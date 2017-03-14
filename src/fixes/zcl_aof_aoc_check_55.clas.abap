CLASS zcl_aof_aoc_check_55 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_aof_fixer .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_AOF_AOC_CHECK_55 IMPLEMENTATION.


  METHOD zif_aof_fixer~is_fixable.

* todo
    rv_fixable = abap_false.
*    rv_fixable = boolc( is_result-test = 'ZCL_AOC_CHECK_55' ).

  ENDMETHOD.


  METHOD zif_aof_fixer~run.

    FIELD-SYMBOLS: <ls_result> LIKE LINE OF rs_data-results,
                   <ls_change> LIKE LINE OF rs_data-changes,
                   <lv_line>   LIKE LINE OF <ls_change>-code_after.


    rs_data = is_data.

    SORT rs_data-results BY
      sobjtype ASCENDING
      sobjname ASCENDING
      line DESCENDING.

    LOOP AT rs_data-results ASSIGNING <ls_result>.
      READ TABLE rs_data-changes ASSIGNING <ls_change>
        WITH KEY sobjtype = <ls_result>-sobjtype
                 sobjname = <ls_result>-sobjname.
      ASSERT sy-subrc = 0.

      READ TABLE <ls_change>-code_after ASSIGNING <lv_line> INDEX <ls_result>-line.
      ASSERT sy-subrc = 0.

      REPLACE FIRST OCCURRENCE OF 'DATA:' IN <lv_line> WITH `     `.

* todo

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
