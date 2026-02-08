CLASS lsc_zi_travelraj_m DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zi_travelraj_m IMPLEMENTATION.

  METHOD save_modified.

    DATA : lt_log TYPE STANDARD TABLE OF zlog_travelraj_m.
    DATA : lt_travel_log_c TYPE STANDARD TABLE OF zlog_travelraj_m.
    DATA : lt_travel_log_u TYPE STANDARD TABLE OF zlog_travelraj_m.
    "create
    IF create-zi_travelraj_m IS NOT INITIAL.
      lt_log = CORRESPONDING #( create-zi_travelraj_m  ).

      LOOP AT lt_log ASSIGNING FIELD-SYMBOL(<ls_travel_log>).

        <ls_travel_log>-changing_operation = 'CREATE'.
        GET TIME STAMP FIELD <ls_travel_log>-created_at.

        READ TABLE create-zi_travelraj_m ASSIGNING FIELD-SYMBOL(<ls_travel>)
                    WITH TABLE KEY entity COMPONENTS TravelId = <ls_travel_log>-travelid.
        IF sy-subrc IS INITIAL.

          IF <ls_travel>-%control-BookingFee = cl_abap_behv=>flag_changed.
            <ls_travel_log>-changed_field_name = 'Booking Fee'.
            <ls_travel_log>-changed_value = <ls_travel>-BookingFee.
            TRY.
                <ls_travel_log>-change_id = cl_system_uuid=>create_uuid_x16_static(  ).
              CATCH cx_uuid_error.
                "handle exception
            ENDTRY.

            APPEND <ls_travel_log> TO lt_travel_log_c.
          ENDIF.


          IF <ls_travel>-%control-OverallStatus = cl_abap_behv=>flag_changed.
            <ls_travel_log>-changed_field_name = 'Overall Status'.
            <ls_travel_log>-changed_value = <ls_travel>-OverallStatus.
            TRY.
                <ls_travel_log>-change_id = cl_system_uuid=>create_uuid_x16_static(  ).
              CATCH cx_uuid_error.
                "handle exception
            ENDTRY.

            APPEND <ls_travel_log> TO lt_travel_log_c.
          ENDIF.

        ENDIF.

      ENDLOOP.
      INSERT zlog_travelraj_m  FROM TABLE @lt_travel_log_c .
    ENDIF.

    "update
    IF update-zi_travelraj_m IS NOT INITIAL.




      lt_log = CORRESPONDING #( update-zi_travelraj_m  ).

      LOOP AT update-zi_travelraj_m ASSIGNING FIELD-SYMBOL(<ls_log_UPDATE>).

        ASSIGN lt_log[ travelid = <ls_log_update>-TravelId ] TO FIELD-SYMBOL(<ls_log_u>).

        <ls_log_u>-changing_operation = 'UPDATE'.
        GET TIME STAMP FIELD <ls_log_u>-created_at.

        "READ TABLE update-zi_travelraj_m ASSIGNING FIELD-SYMBOL(<ls_travel>)
        "        WITH TABLE KEY entity COMPONENTS TravelId = <ls_travel_log>-travelid.
        " IF sy-subrc IS INITIAL.

        IF <ls_log_update>-%control-CustomerId = cl_abap_behv=>flag_changed.
          <ls_log_u>-changed_field_name = 'Customer id'.
          <ls_log_u>-changed_value = <ls_log_update>-CustomerId.
          TRY.
              <ls_log_u>-change_id = cl_system_uuid=>create_uuid_x16_static(  ).
            CATCH cx_uuid_error.
              "handle exception
          ENDTRY.

          APPEND <ls_log_u> TO lt_travel_log_u.
        ENDIF.


        IF <ls_log_update>-%control-Description = cl_abap_behv=>flag_changed.
          <ls_log_u>-changed_field_name = 'Discription'.
          <ls_log_u>-changed_value = <ls_log_update>-Description.
          TRY.
              <ls_log_u>-change_id = cl_system_uuid=>create_uuid_x16_static(  ).
            CATCH cx_uuid_error.
              "handle exception
          ENDTRY.

          APPEND <ls_log_u> TO lt_travel_log_u.
        ENDIF.

        "ENDIF.

      ENDLOOP.
      INSERT zlog_travelraj_m  FROM TABLE @lt_travel_log_u .


    ENDIF.

    "delete
    IF delete-zi_travelraj_m IS NOT INITIAL.

      lt_log = CORRESPONDING #( delete-zi_travelraj_m  ).

      LOOP AT lt_log ASSIGNING FIELD-SYMBOL(<ls_log_del>).

        <ls_log_del>-changing_operation = 'Delete'.
        GET TIME STAMP FIELD <ls_log_del>-created_at.
        TRY.
            <ls_log_del>-change_id = cl_system_uuid=>create_uuid_x16_static(  ).
          CATCH cx_uuid_error.
            "handle exception
        ENDTRY.


      ENDLOOP.

      INSERT zlog_travelraj_m  FROM TABLE @lt_log .

    ENDIF.




    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    DATA : lt_book_suppl TYPE TABLE OF zbooksuppraj_m.
    IF create-zi_book_suppraj_m IS NOT INITIAL.
      lt_book_suppl = VALUE #( for ls_book in create-zi_book_suppraj_m
                                    ( travel_id = ls_book-TravelId
                                    booking_id = ls_book-BookingId
                                    booking_supplement_id = ls_book-BookingSupplementId
                                    supplement_id = ls_book-SupplementId
                                    price = ls_book-Price
                                    currency_code = ls_book-CurrencyCode
                                    last_changed_at = ls_book-LastChangedAt ) ).

      INSERT zbooksuppraj_m FROM TABLE @lt_book_suppl.
    ENDIF.

    IF update-zi_book_suppraj_m IS NOT INITIAL.
      lt_book_suppl = VALUE #( for ls_book in update-zi_book_suppraj_m
                                    ( travel_id = ls_book-TravelId
                                    booking_id = ls_book-BookingId
                                    booking_supplement_id = ls_book-BookingSupplementId
                                    supplement_id = ls_book-SupplementId
                                    price = ls_book-Price
                                    currency_code = ls_book-CurrencyCode
                                    last_changed_at = ls_book-LastChangedAt ) ).
      UPDATE zbooksuppraj_m FROM TABLE @lt_book_suppl.
    ENDIF.

    IF delete-zi_book_suppraj_m IS NOT INITIAL.
      lt_book_suppl =
VALUE #( for ls_book1 in delete-zi_book_suppraj_m
                                    ( travel_id = ls_book1-TravelId
                                    booking_id = ls_book1-BookingId
                                    booking_supplement_id = ls_book1-BookingSupplementId
                                    ) ).
DELETE zbooksuppraj_m FROM TABLE @lt_book_suppl.
    ENDIF.


  ENDMETHOD.

ENDCLASS.

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
    METHODS validatecustomer FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_travelraj_m~validatecustomer.
    METHODS validatebookingfee FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_travelraj_m~validatebookingfee.

    METHODS validatecurrencycode FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_travelraj_m~validatecurrencycode.

    METHODS validatedates FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_travelraj_m~validatedates.

    METHODS validatestatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_travelraj_m~validatestatus.
    METHODS calculatetotalprice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_travelraj_m~calculatetotalprice.
    METHODS recalctotprice FOR MODIFY
      IMPORTING keys FOR ACTION zi_travelraj_m~recalctotprice.

    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE zi_travelraj_m.

    METHODS earlynumbering_cba_Booking FOR NUMBERING
      IMPORTING entities FOR CREATE zi_travelraj_m\_Booking.

ENDCLASS.

CLASS lhc_ZI_TRAVELRAJ_M IMPLEMENTATION.

  METHOD get_instance_features.

    READ ENTITIES OF zi_travelraj_m IN LOCAL MODE
    ENTITY zi_travelraj_m  FIELDS ( TravelId OverallStatus  )
    WITH CORRESPONDING #( keys ) RESULT DATA(lt_travel).

    result = VALUE #( FOR ls_travel IN lt_travel
                     ( %tky = ls_travel-%tky
                       %features-%action-acceptTravel = COND #( WHEN ls_travel-OverallStatus = 'A'
                                                                THEN if_abap_behv=>fc-o-disabled
                                                                ELSE if_abap_behv=>fc-o-enabled )

                        %features-%action-rejectTravel = COND #( WHEN ls_travel-OverallStatus = 'X'
                                                                THEN if_abap_behv=>fc-o-disabled
                                                                ELSE if_abap_behv=>fc-o-enabled )

                          %features-%assoc-_booking = COND #( WHEN ls_travel-OverallStatus = 'X'
                                                                THEN if_abap_behv=>fc-o-disabled
                                                                ELSE if_abap_behv=>fc-o-enabled )
                                                                 )


                                                                  ).

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

        LOOP AT lt_entities INTO DATA(ls_entities).
          APPEND VALUE #( %cid = ls_entities-%cid
                          %key = ls_entities-%key ) TO failed-zi_travelraj_m.
          APPEND VALUE #( %cid = ls_entities-%cid
                        %key = ls_entities-%key
                        %msg = lo_error  ) TO reported-zi_travelraj_m.
        ENDLOOP.
        EXIT.
    ENDTRY.

    ASSERT lv_qty = lines( lt_entities ).
    DATA(lv_cur_no) = lv_latest_num - lv_qty.

    LOOP AT lt_entities INTO ls_entities.
      lv_cur_no = lv_cur_no + 1.
      APPEND VALUE #( %cid = ls_entities-%cid
                      TravelId = lv_cur_no ) TO mapped-zi_travelraj_m.
    ENDLOOP.

  ENDMETHOD.

  METHOD earlynumbering_cba_Booking.

    DATA : lv_max_booking TYPE /dmo/booking_id.

    READ ENTITIES OF zi_travelraj_m  IN LOCAL MODE
    ENTITY zi_travelraj_m BY \_booking FROM CORRESPONDING #( entities ) LINK DATA(lt_link_data).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_group>)
    GROUP BY <ls_group>-TravelId.

      lv_max_booking = REDUCE #( INIT lv_max = CONV /dmo/booking_id( '0' )
                                  FOR ls_link IN lt_link_data WHERE ( source-TravelId = <ls_group>-TravelId )
                                  NEXT lv_max = COND /dmo/booking_id( WHEN lv_max < ls_link-target-BookingId
                                                                      THEN ls_link-target-BookingId
                                                                      ELSE lv_max ) ).


      lv_max_booking = REDUCE #(  INIT lv_max = lv_max_booking
                                  FOR ls_entity IN entities WHERE ( TravelId = <ls_group>-TravelId )
                                  FOR ls_book IN ls_entity-%target
                                  NEXT lv_max = COND /dmo/booking_id( WHEN lv_max < ls_book-BookingId
                                                                      THEN ls_book-BookingId
                                                                      ELSE lv_max ) ).


      LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_entities>) USING KEY entity
                                         WHERE TravelId = <ls_group>-TravelId.



        LOOP AT <ls_entities>-%target  ASSIGNING FIELD-SYMBOL(<ls_booking>).

          APPEND CORRESPONDING #( <ls_booking> ) TO mapped-zi_bookingraj_m

          ASSIGNING FIELD-SYMBOL(<ls_book_new>).
          IF <ls_booking>-BookingId IS INITIAL.

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
    VALUE #( FOR ls_keys IN keys ( %tky = ls_keys-%tky
                                   OverallStatus = 'A' ) )  ."REPORTED DATA(LT_TRAVEL).

    READ ENTITIES OF zi_travelraj_m IN LOCAL MODE
    ENTITY zi_travelraj_m ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).

    result = VALUE #( FOR ls_result IN lt_result (  %tky = ls_result-%tky
                                                    %param = ls_result ) ).

  ENDMETHOD.

  METHOD copyTravel.

    """""""declaration for the create the line items,
    DATA : it_travel       TYPE TABLE FOR CREATE zi_travelraj_m,
           it_booking_cba  TYPE TABLE FOR CREATE zi_travelraj_m\_booking,
           it_booksupp_cba TYPE TABLE FOR CREATE zi_bookingraj_m\_bookingsuppl.

    """""""""" read the the structure keys """""""""""""""
    READ TABLE keys ASSIGNING FIELD-SYMBOL(<ls_without_cid>) WITH KEY %cid = ' '.
    ASSERT <ls_without_cid> IS NOT ASSIGNED.

    READ ENTITIES OF zi_travelraj_m IN LOCAL MODE
    ENTITY zi_travelraj_m ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel_r)
    FAILED DATA(lt_failed).

    READ ENTITIES OF zi_travelraj_m IN LOCAL MODE
    ENTITY zi_travelraj_m BY \_booking
    ALL FIELDS WITH CORRESPONDING #( lt_travel_r )
    RESULT DATA(lt_booking_r).

    READ ENTITIES OF zi_travelraj_m IN LOCAL MODE
    ENTITY zi_bookingraj_m BY \_bookingsuppl
    ALL FIELDS WITH CORRESPONDING #( lt_booking_r )
    RESULT DATA(lt_booksupp_r).


    LOOP AT lt_travel_r ASSIGNING FIELD-SYMBOL(<ls_travel_r>).


      APPEND VALUE #( %cid = keys[ KEY entity TravelId = <ls_travel_r>-TravelId ]-%cid
                      %data = CORRESPONDING #( <ls_travel_r> EXCEPT Travelid ) ) TO it_travel
                      ASSIGNING FIELD-SYMBOL(<ls_travel>).
      <ls_travel>-BeginDate = cl_abap_context_info=>get_system_date(  ).
      <ls_travel>-EndDate = cl_abap_context_info=>get_system_date(  ) + 30.
      <ls_travel>-OverallStatus = 'O'.

      """""""""""""""""""""BOOKING """""""""""""""""""""""

      APPEND VALUE #( %cid_ref = <ls_travel>-%cid ) TO it_booking_cba ASSIGNING FIELD-SYMBOL(<it_booking>).
      LOOP AT lt_booking_r ASSIGNING FIELD-SYMBOL(<ls_booking_r>) USING KEY entity WHERE TravelId = <ls_travel_r>-TravelId.

        APPEND VALUE #( %cid = <ls_travel>-%cid && <ls_booking_r>-BookingId
                       %data = CORRESPONDING #( <ls_booking_r> EXCEPT travelid )  )
                       TO <it_booking>-%target  ASSIGNING FIELD-SYMBOL(<ls_booking>).

        <ls_booking>-BookingStatus = 'N'.

        """"""""""""""BOOKING SUPPLEMENT """"""""

        APPEND VALUE #( %cid_ref = <ls_booking>-%cid ) TO it_booksupp_cba ASSIGNING FIELD-SYMBOL(<it_booking_supp>).

        LOOP AT lt_booksupp_r ASSIGNING FIELD-SYMBOL(<ls_booksupp_r>) USING KEY entity WHERE TravelId = <ls_travel_r>-TravelId
                                                                                              AND BookingId = <ls_booking_r>-BookingId.

          APPEND VALUE #( %cid = <ls_travel>-%cid && <ls_booking_r>-BookingId && <ls_booksupp_r>-BookingSupplementId
                          %data = CORRESPONDING #( <ls_booksupp_r> EXCEPT travelid bookingid ) )
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
    VALUE #( FOR ls_keys IN keys ( %tky = ls_keys-%tky
                                   OverallStatus = 'X' ) )  ."REPORTED DATA(LT_TRAVEL).

    READ ENTITIES OF zi_travelraj_m IN LOCAL MODE
    ENTITY zi_travelraj_m ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).

    result = VALUE #( FOR ls_result IN lt_result (  %tky = ls_result-%tky
                                                    %param = ls_result ) ).

  ENDMETHOD.

  METHOD validatecustomer.

    READ ENTITY IN LOCAL MODE zi_travelraj_m
    FIELDS ( CustomerId ) WITH CORRESPONDING #( keys  ) RESULT DATA(lt_travel).

    DATA : lt_cust TYPE SORTED TABLE OF /dmo/customer WITH UNIQUE KEY customer_id.

    lt_cust = CORRESPONDING #( lt_travel DISCARDING DUPLICATES MAPPING customer_id = CustomerId ).

    DELETE lt_cust WHERE customer_id IS INITIAL.

    SELECT FROM /dmo/customer FIELDS customer_id FOR ALL ENTRIES IN @lt_cust
    WHERE customer_id = @lt_cust-customer_id INTO TABLE @DATA(lt_cust_db).

    IF sy-subrc IS INITIAL.


    ENDIF.


    LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).
      IF <ls_travel>-CustomerId IS INITIAL
      OR NOT line_exists( lt_cust_db[ customer_id = <ls_travel>-CustomerId  ] ).
        APPEND VALUE #( %tky = <ls_travel>-%tky ) TO failed-zi_travelraj_m.
        APPEND VALUE #( %tky = <ls_travel>-%tky
                        %msg = NEW /dmo/cm_flight_messages(
                         textid                =   /dmo/cm_flight_messages=>customer_unkown

                         customer_id           =  <ls_travel>-CustomerId

                         severity              =  if_abap_behv_message=>severity-error

        ) %element-CustomerId = if_abap_behv=>mk-on ) TO reported-zi_travelraj_m.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validatebookingfee.
  ENDMETHOD.

  METHOD validatecurrencycode.
  ENDMETHOD.

  METHOD validatedates.

    READ ENTITIES OF zi_travelraj_m IN LOCAL MODE
    ENTITY zi_travelraj_m FIELDS ( BeginDate EndDate )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travels).

    LOOP AT lt_travels INTO DATA(travel).

      IF travel-BeginDate < travel-EndDate .

        APPEND VALUE #( %tky = travel-%tky
                         ) TO failed-zi_travelraj_m.

        APPEND VALUE #( %tky = travel-%tky
                        %msg = NEW /dmo/cm_flight_messages(
                                   textid     = /dmo/cm_flight_messages=>begin_date_bef_end_date
                                   severity   = if_abap_behv_message=>severity-error
                                   begin_date = travel-BeginDate
                                   end_date   = travel-EndDate
                                   travel_id  = travel-TravelId )
                        %element-BeginDate   = if_abap_behv=>mk-on
                        %element-EndDate     = if_abap_behv=>mk-on
                     ) TO reported-zi_travelraj_m.
      ELSEIF travel-BeginDate < cl_abap_context_info=>get_system_date(  ).

        APPEND VALUE #( %tky = travel-%tky
                                ) TO failed-zi_travelraj_m.

        APPEND VALUE #( %tky = travel-%tky
                           %msg = NEW /dmo/cm_flight_messages(
                                       textid   = /dmo/cm_flight_messages=>begin_date_on_or_bef_sysdate
                                       severity = if_abap_behv_message=>severity-error )
                           %element-BeginDate  = if_abap_behv=>mk-on
                           %element-EndDate    = if_abap_behv=>mk-on
                         ) TO reported-zi_travelraj_m.



      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD validatestatus.

    READ ENTITIES OF zi_travelraj_m IN LOCAL MODE
    ENTITY zi_travelraj_m FIELDS ( OverallStatus )
    WITH CORRESPONDING #( keys ) RESULT DATA(lt_travel).

    LOOP AT lt_travel INTO DATA(ls_travel).
      CASE ls_travel-OverallStatus.
        WHEN 'O' .
        WHEN 'X'.
        WHEN 'A'.
        WHEN OTHERS.
          APPEND VALUE #( %tky = ls_travel-%tky ) TO failed-zi_travelraj_m.
          APPEND VALUE #( %tky = ls_travel-%tky
                            %msg = NEW /dmo/cm_flight_messages(
                                           textid = /dmo/cm_flight_messages=>status_invalid
                                           severity = if_abap_behv_message=>severity-error
                                           status = ls_travel-OverallStatus )
                                %element-OverallStatus = if_abap_behv=>mk-on
                              ) TO reported-zi_travelraj_m.

      ENDCASE.

    ENDLOOP.
  ENDMETHOD.

  METHOD calculateTotalprice.

    MODIFY ENTITIES OF zi_travelraj_m IN LOCAL MODE
    ENTITY zi_travelraj_m EXECUTE recalctotprice FROM CORRESPONDING #( keys ).

  ENDMETHOD.

  METHOD recalctotprice.

    TYPES : BEGIN OF ty_total,
              price TYPE /dmo/total_price,
              curr  TYPE /dmo/currency_code,
            END OF ty_total .
    DATA: lt_total      TYPE TABLE OF ty_total,
          lv_conv_price TYPE ty_total-price.

    READ ENTITIES OF zi_travelraj_m IN LOCAL MODE
    ENTITY zi_travelraj_m FIELDS ( BookingFee CurrencyCode ) WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel).

    DELETE lt_travel WHERE CurrencyCode IS INITIAL.


    READ ENTITIES OF zi_travelraj_m IN LOCAL MODE
    ENTITY zi_travelraj_m BY \_booking FIELDS ( FlightPrice CurrencyCode ) WITH CORRESPONDING #( lt_travel )
    RESULT DATA(lt_ba_booking).

    READ ENTITIES OF zi_travelraj_m IN LOCAL MODE
    ENTITY zi_bookingraj_m BY \_bookingsuppl FIELDS ( Price CurrencyCode ) WITH CORRESPONDING #( lt_ba_booking )
    RESULT DATA(lt_ba_booksuppl).

    LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).

      APPEND VALUE #( price = <ls_travel>-BookingFee curr = <ls_travel>-CurrencyCode  ) TO lt_total.

      LOOP AT lt_ba_booking ASSIGNING FIELD-SYMBOL(<Ls_booking>) USING KEY entity
                                                               WHERE TravelId = <ls_travel>-TravelId
                                                               AND CurrencyCode IS NOT INITIAL.


        APPEND VALUE #( price = <ls_booking>-FlightPrice curr = <ls_booking>-CurrencyCode  ) TO lt_total.

        LOOP AT lt_ba_booksuppl ASSIGNING FIELD-SYMBOL(<ls_bookssuppl>) USING KEY entity WHERE TravelId = <ls_booking>-TravelId AND BookingId = <ls_booking>-BookingId
                                                                                   AND CurrencyCode IS NOT INITIAL.

          APPEND VALUE #( price = <ls_bookssuppl>-Price curr = <ls_bookssuppl>-CurrencyCode  ) TO lt_total.

        ENDLOOP.

      ENDLOOP.



      LOOP AT lt_total ASSIGNING FIELD-SYMBOL(<ls_total>).

        IF <ls_total>-curr = <ls_travel>-CurrencyCode.
          lv_conv_price = <ls_total>-price.
        ELSE.

          /dmo/cl_flight_amdp=>convert_currency(
            EXPORTING
              iv_amount               = <ls_total>-price
              iv_currency_code_source = <ls_total>-curr
              iv_currency_code_target = <ls_travel>-CurrencyCode
              iv_exchange_rate_date   =  cl_abap_context_info=>get_system_date( )
            IMPORTING
              ev_amount               = lv_conv_price
          ).

        ENDIF.

        <ls_travel>-TotalPrice =  <ls_travel>-TotalPrice + lv_conv_price.
      ENDLOOP.

    ENDLOOP.


    MODIFY ENTITIES OF zi_travelraj_m IN LOCAL MODE
    ENTITY zi_travelraj_m  UPDATE FIELDS ( TotalPrice ) WITH CORRESPONDING #( lt_travel ).

  ENDMETHOD.

ENDCLASS.
