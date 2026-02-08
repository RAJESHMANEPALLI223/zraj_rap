CLASS lhc_zi_book_suppraj_m DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS validatecurrencycode FOR VALIDATE ON SAVE
      IMPORTING keys FOR ZI_BOOK_SUPPRAJ_M~validatecurrencycode.

    METHODS validateprice FOR VALIDATE ON SAVE
      IMPORTING keys FOR ZI_BOOK_SUPPRAJ_M~validateprice.

    METHODS validatesupplement FOR VALIDATE ON SAVE
      IMPORTING keys FOR ZI_BOOK_SUPPRAJ_M~validatesupplement.
    METHODS calculateTotalprice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR ZI_BOOK_SUPPRAJ_M~calculateTotalprice.

ENDCLASS.

CLASS lhc_zi_book_suppraj_m IMPLEMENTATION.

  METHOD validatecurrencycode.
  ENDMETHOD.

  METHOD validateprice.
  ENDMETHOD.

  METHOD validatesupplement.
  ENDMETHOD.

  METHOD calculateTotalprice.


   data : lt_travel type STANDARD TABLE OF zi_travelraj_m with UNIQUE HASHED KEY key COMPONENTS TravelId.

  lt_travel = CORRESPONDING #(  keys DISCARDING DUPLICATES MAPPING TravelId = TravelId ).

  MODIFY ENTITIES OF zi_travelraj_m IN LOCAL MODE
  ENTITY zi_travelraj_m EXECUTE recalctotprice FROM CORRESPONDING #( keys ).

  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
