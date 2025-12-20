CLASS zcl_data_generate_m DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES :
  if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_data_generate_m IMPLEMENTATION.

METHOD if_oo_adt_classrun~main.
 " delete existing entries in the database table
    DELETE FROM ztravelraj_m.
    DELETE FROM ZBOOKINGRAJ_M.
    DELETE FROM ZBOOKSUPPRAJ_M.
    COMMIT WORK.
    " insert travel demo data
    INSERT ztravelraj_m FROM (
        SELECT *
          FROM /dmo/travel_m
      ).
    COMMIT WORK.

    " insert booking demo data
    INSERT ZBOOKINGRAJ_M FROM (
        SELECT *
          FROM   /dmo/booking_m
*            JOIN ytravel_tech_m AS y
*            ON   booking~travel_id = y~travel_id

      ).
    COMMIT WORK.
    INSERT ZBOOKSUPPRAJ_M FROM (
        SELECT *
          FROM   /dmo/booksuppl_m
*            JOIN ytravel_tech_m AS y
*            ON   booking~travel_id = y~travel_id

      ).
    COMMIT WORK.

    out->write( 'Travel and booking demo data inserted.').

ENDMETHOD.
ENDCLASS.
