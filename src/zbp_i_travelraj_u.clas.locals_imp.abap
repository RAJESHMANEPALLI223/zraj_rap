CLASS lsc_ZI_TRAVELRAJ_U DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS adjust_numbers REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZI_TRAVELRAJ_U IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD adjust_numbers.
    DATA: lt_travel_mapping TYPE /dmo/if_flight_legacy=>tt_ln_travel_mapping,
          lt_booking_mapping TYPE /dmo/if_flight_legacy=>tt_ln_booking_mapping,
          lt_bookingsuppl_mapping TYPE /dmo/if_flight_legacy=>tt_ln_bookingsuppl_mapping.

   CALL FUNCTION '/DMO/FLIGHT_TRAVEL_ADJ_NUMBERS'
     IMPORTING
       et_travel_mapping       = lt_travel_mapping
       et_booking_mapping      = lt_booking_mapping
       et_bookingsuppl_mapping = lt_bookingsuppl_mapping
     .
     mapped-travel = VALUE #( for ls_travel in lt_travel_mapping ( %tmp = VALUE #( TravelId = ls_travel-preliminary-travel_id )
                                                                    TravelId = ls_travel-final-travel_id ) ).


      mapped-booking = VALUE #( for ls_booking in lt_booking_mapping ( %tmp = VALUE #( TravelId = ls_booking-preliminary-travel_id
                                                                                       BookingId = ls_booking-preliminary-booking_id )
                                                                    TravelId = ls_booking-final-travel_id
                                                                     BookingId = ls_booking-final-booking_id ) ).
  ENDMETHOD.

  METHOD save.
   CALL FUNCTION '/DMO/FLIGHT_TRAVEL_SAVE'.
  ENDMETHOD.

  METHOD cleanup.
  CALL FUNCTION '/DMO/FLIGHT_TRAVEL_INITIALIZE'.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
