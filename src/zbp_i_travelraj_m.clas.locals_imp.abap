CLASS lhc_ZI_TRAVELRAJ_M DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_travelraj_m RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_travelraj_m RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zi_travelraj_m RESULT result.
    METHODS accepttravel FOR MODIFY
      IMPORTING keys FOR ACTION zi_travelraj_m~accepttravel RESULT result.

    METHODS copytravel FOR MODIFY
      IMPORTING keys FOR ACTION zi_travelraj_m~copytravel.

    METHODS rejecttravel FOR MODIFY
      IMPORTING keys FOR ACTION zi_travelraj_m~rejecttravel RESULT result.

    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE zi_travelraj_m.

    METHODS earlynumbering_cba_Booking FOR NUMBERING
      IMPORTING entities FOR CREATE zi_travelraj_m\_Booking.

ENDCLASS.

CLASS lhc_ZI_TRAVELRAJ_M IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.
  "" send the entity data into local internal table
   DATA(lt_entities) = entities.

"" delete the line if the travel id was already generate
  DELETE lt_entities WHERE TravelId IS NOT INITIAL.
  """""generate the travelid
  TRY.
      cl_numberrange_runtime=>number_get(
        EXPORTING
          nr_range_nr       = '01'
          object            = '/DMO/TRV_M'
          quantity          = CONV #( lines( lt_entities ) )
        IMPORTING
          number            =  DATA(lv_latest_num)
          returncode        =  DATA(lv_code)
          returned_quantity =  DATA(lv_qty)
      ).
    CATCH cx_nr_object_not_found.
    CATCH cx_number_ranges INTO DATA(lo_error).

    loop at lt_entities into data(ls_entities).
    APPEND VALUE #( %cid = ls_entities-%cid
                    %key = ls_entities-%key ) to failed-zi_travelraj_m.
      APPEND VALUE #( %cid = ls_entities-%cid
                    %key = ls_entities-%key
                    %msg = lo_error  ) to reported-zi_travelraj_m.
    ENDLOOP.
    EXIT.
    ENDTRY.

    ASSERT lv_qty = lines( lt_entities ).
    data(lv_cur_no) = lv_latest_num - lv_qty.

    loop at lt_entities into ls_entities.
    lv_cur_no = lv_cur_no + 1.
    APPEND VALUE #( %cid = ls_entities-%cid
                    TravelId = lv_cur_no ) to mapped-zi_travelraj_m.
    ENDLOOP.

  ENDMETHOD.

  METHOD earlynumbering_cba_Booking.

  DATA : lv_max_booking TYPE /dmo/booking_id.

  READ ENTITIES OF zi_travelraj_m  IN LOCAL MODE
  ENTITY zi_travelraj_m BY \_booking FROM CORRESPONDING #( entities ) LINK DATA(lt_link_data).

  loop at entities ASSIGNING FIELD-SYMBOL(<ls_group>)
  GROUP BY <ls_group>-TravelId.

  lv_max_booking = REDUCE #( INIT lv_max = conv /dmo/booking_id( '0' )
                              for ls_link in lt_link_data WHERE ( source-TravelId = <ls_group>-TravelId )
                              NEXT lv_max = COND /dmo/booking_id( WHEN lv_max < ls_link-target-BookingId
                                                                  THEN ls_link-target-BookingId
                                                                  ELSE lv_max ) ).


   lv_max_booking = REDUCE #(  INIT lv_max = lv_max_booking
                               for ls_entity in entities WHERE ( TravelId = <ls_group>-TravelId )
                               FOR ls_book in ls_entity-%target
                               NEXT lv_max = COND /dmo/booking_id( WHEN lv_max < ls_book-BookingId
                                                                   THEN ls_book-BookingId
                                                                   ELSE lv_max ) ).


   loop at entities ASSIGNING FIELD-SYMBOL(<ls_entities>) USING KEY entity
                                      WHERE TravelId = <ls_group>-TravelId.



            loop at <ls_entities>-%target  ASSIGNING FIELD-SYMBOL(<ls_booking>).

            APPEND CORRESPONDING #( <ls_booking> ) to mapped-zi_bookingraj_m

            ASSIGNING FIELD-SYMBOL(<ls_book_new>).
            if <ls_booking>-BookingId is INITIAL.

            lv_max_booking += 10.

            <ls_book_new>-BookingId = lv_max_booking.
            ENDIF.


            ENDLOOP.


                                      ENDLOOP.

  ENDLOOP.

  ENDMETHOD.

  METHOD acceptTravel.

  """"""""""""""""""""""""""""" BASED ON THE ACTION WE NEED TO CHANGE THE STATUS """""""""""""""""""""""""""""""

  MODIFY ENTITIES OF zi_travelraj_m IN LOCAL MODE
  ENTITY zi_travelraj_m UPDATE FIELDS ( OverallStatus ) WITH
  VALUE #( FOR LS_KEYS IN keys ( %tky = ls_keys-%tky
                                 OverallStatus = 'A' ) )  ."REPORTED DATA(LT_TRAVEL).

  READ ENTITIES OF zi_travelraj_m IN LOCAL MODE
  ENTITY zi_travelraj_m ALL FIELDS WITH CORRESPONDING #( keys )
  RESULT DATA(LT_RESULT).

  result = VALUE #( FOR LS_RESULT IN lt_result (  %tky = ls_result-%tky
                                                  %param = ls_result ) ).

  ENDMETHOD.

  METHOD copyTravel.

  """""""declaration for the create the line items,
  data : it_travel type TABLE FOR CREATE zi_travelraj_m,
         it_booking_cba type TABLE FOR CREATE zi_travelraj_m\_booking,
         it_booksupp_cba type TABLE FOR CREATE zi_bookingraj_m\_bookingsuppl.

     """""""""" read the the structure keys """""""""""""""
     READ TABLE keys ASSIGNING FIELD-SYMBOL(<ls_without_cid>) WITH KEY %cid = ' '.
     ASSERT <ls_without_cid> is not ASSIGNED.

  READ ENTITIES OF zi_travelraj_m IN LOCAL MODE
  ENTITY zi_travelraj_m ALL FIELDS WITH CORRESPONDING #( keys )
  RESULT DATA(lt_travel_r)
  FAILED DATA(lt_failed).

  READ ENTITIES OF zi_travelraj_m IN LOCAL MODE
  ENTITY zi_travelraj_m BY \_booking
  ALL FIELDS WITH CORRESPONDING #( lt_travel_r )
  RESULT data(lt_booking_r).

  READ ENTITIES OF zi_travelraj_m IN LOCAL MODE
  ENTITY zi_bookingraj_m BY \_bookingsuppl
  ALL FIELDS WITH CORRESPONDING #( lt_booking_r )
  RESULT DATA(lt_booksupp_r).


  loop at lt_travel_r ASSIGNING FIELD-SYMBOL(<ls_travel_r>).


  APPEND VALUE #( %cid = keys[ KEY entity TravelId = <ls_travel_r>-TravelId ]-%cid
                  %data = CORRESPONDING #( <ls_travel_r> EXCEPT Travelid ) ) to it_travel
                  ASSIGNING FIELD-SYMBOL(<ls_travel>).
    <ls_travel>-BeginDate = cl_abap_context_info=>get_system_date(  ).
    <ls_travel>-EndDate = cl_abap_context_info=>get_system_date(  ) + 30.
    <ls_travel>-OverallStatus = 'O'.

    """""""""""""""""""""BOOKING """""""""""""""""""""""

    APPEND VALUE #( %CID_REF = <ls_travel>-%cid ) TO it_booking_cba ASSIGNING FIELD-SYMBOL(<IT_BOOKING>).
LOOP AT lt_booking_r ASSIGNING FIELD-SYMBOL(<LS_BOOKING_R>) USING KEY entity WHERE TravelId = <ls_travel_r>-TravelId.

APPEND VALUE #( %CID = <ls_travel>-%cid && <ls_booking_r>-BookingId
               %DATA = CORRESPONDING #( <ls_booking_r> EXCEPT TRAVELID )  )
               TO <it_booking>-%target  ASSIGNING FIELD-SYMBOL(<LS_BOOKING>).

               <ls_booking>-BookingStatus = 'N'.

     """"""""""""""BOOKING SUPPLEMENT """"""""

     APPEND VALUE #( %CID_REF = <ls_booking>-%cid ) TO it_booksupp_cba ASSIGNING FIELD-SYMBOL(<IT_BOOKING_SUPP>).

     LOOP AT lt_booksupp_r ASSIGNING FIELD-SYMBOL(<LS_BOOKSUPP_R>) USING KEY entity WHERE TravelId = <ls_travel_r>-TravelId
                                                                                           AND BookingId = <ls_booking_r>-BookingId.

APPEND VALUE #( %CID = <ls_travel>-%cid && <ls_booking_r>-BookingId && <ls_booksupp_r>-BookingSupplementId
                %DATA = CORRESPONDING #( <ls_booksupp_r> EXCEPT TRAVELID BOOKINGID ) )
                TO <it_booking_supp>-%target.

ENDLOOP.
ENDLOOP.

  ENDLOOP.



"""""""""""""""""""""""" MODIFY THE DATA """""""""""""""""""""""""""""

  MODIFY ENTITIES OF zi_travelraj_m IN LOCAL MODE
    ENTITY zi_travelraj_m
    CREATE FIELDS ( AgencyId CustomerId BeginDate EndDate BookingFee TotalPrice CurrencyCode OverallStatus Description )
    WITH it_travel
    ENTITY zi_travelraj_m
     CREATE BY \_Booking
     FIELDS ( BookingId BookingDate CustomerId CarrierId ConnectionId FlightDate FlightPrice CurrencyCode BookingStatus )
     WITH it_booking_cba
    ENTITY zi_bookingraj_m
     CREATE BY \_Bookingsuppl
     FIELDS ( BookingSupplementId SupplementId Price CurrencyCode )
     WITH it_booksupp_cba
     MAPPED DATA(it_mapped).


  mapped-zi_travelraj_m = it_mapped-zi_travelraj_m.

  ENDMETHOD.

  METHOD rejectTravel.
  """"""""""""""""""""""""""""" BASED ON THE ACTION WE NEED TO CHANGE THE STATUS """""""""""""""""""""""""""""""

  MODIFY ENTITIES OF zi_travelraj_m IN LOCAL MODE
  ENTITY zi_travelraj_m UPDATE FIELDS ( OverallStatus ) WITH
  VALUE #( FOR LS_KEYS IN keys ( %tky = ls_keys-%tky
                                 OverallStatus = 'X' ) )  ."REPORTED DATA(LT_TRAVEL).

  READ ENTITIES OF zi_travelraj_m IN LOCAL MODE
  ENTITY zi_travelraj_m ALL FIELDS WITH CORRESPONDING #( keys )
  RESULT DATA(LT_RESULT).

  result = VALUE #( FOR LS_RESULT IN lt_result (  %tky = ls_result-%tky
                                                  %param = ls_result ) ).

  ENDMETHOD.

ENDCLASS.
