CLASS lhc_ZI_BOOKINGRAJ_M DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_bookingraj_m RESULT result.

    METHODS earlynumbering_cba_Bookingsupp FOR NUMBERING
      IMPORTING entities FOR CREATE zi_bookingraj_m\_Bookingsuppl.

ENDCLASS.

CLASS lhc_ZI_BOOKINGRAJ_M IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD earlynumbering_cba_Bookingsupp.

   DATA: max_booking_suppl_id TYPE /dmo/booking_supplement_id .

   READ ENTITIES OF zi_travelraj_m IN LOCAL MODE
   ENTITY zi_bookingraj_m BY \_bookingsuppl FROM CORRESPONDING #( entities ) LINK data(booking_supple).


   loop at entities ASSIGNING FIELD-SYMBOL(<booking_group>) GROUP BY <booking_group>-%tky.

   " Get highest bookingsupplement_id from bookings belonging to booking

   max_booking_suppl_id = REDUCE #( init max = conv /dmo/booking_supplement_id( '0' )
                                   for booksupl in booking_supple WHERE ( source-TravelId = <booking_group>-TravelId and
                                                                          source-BookingId = <booking_group>-BookingId )

                                           NEXT max = COND /dmo/booking_supplement_id( when booksupl-target-BookingSupplementId > max
                                                                                       THEN booksupl-target-BookingSupplementId
                                                                                       ELSE max ) ).

                   " Get highest assigned bookingsupplement_id from incoming entities
   max_booking_suppl_id = REDUCE #( init max = max_booking_suppl_id
                                    for entity in entities WHERE ( TravelId = <booking_group>-TravelId
                                                                   and BookingId = <booking_group>-BookingId )
                                      for target in entity-%target
                                      NEXT max = COND  /dmo/booking_supplement_id( when target-BookingSupplementId > max
                                                                                   THEN target-BookingSupplementId
                                                                                   ELSE max ) )   .
                  " Loop over all entries in entities with the same TravelID and BookingID
      LOOP AT entities ASSIGNING FIELD-SYMBOL(<booking>) USING KEY entity WHERE TravelId  = <booking_group>-TravelId
                                                                            AND BookingId = <booking_group>-BookingId.

     loop at <booking>-%target ASSIGNING FIELD-SYMBOL(<booking_wo_no>).

     APPEND CORRESPONDING #( <booking_wo_no> ) to mapped-zi_book_suppraj_m ASSIGNING FIELD-SYMBOL(<mapped_suppl>).

       IF <booking_wo_no>-BookingSupplementId IS INITIAL.
            max_booking_suppl_id += 1 .
            <mapped_suppl>-BookingSupplementId = max_booking_suppl_id .
          ENDIF.

          ENDLOOP.

       ENDLOOP.




   ENDLOOP.

  ENDMETHOD.

ENDCLASS.
