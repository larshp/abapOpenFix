class ZCL_AOF_AOC_CHECK_55 definition
  public
  create public .

public section.

  interfaces ZIF_AOF_FIXER .
  PROTECTED SECTION.

    METHODS previous_to_comma
      IMPORTING
        !iv_line TYPE sci_line
      CHANGING
        !ct_code TYPE string_table .
    METHODS remove_preceding_empty_lines
      CHANGING
        !cv_line TYPE sci_line
        !ct_code TYPE string_table .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_AOF_AOC_CHECK_55 IMPLEMENTATION.


  METHOD previous_to_comma.

    DATA: lv_line   TYPE sci_line,
          lv_length TYPE i.

    FIELD-SYMBOLS: <lv_code> LIKE LINE OF ct_code.


    lv_line = iv_line - 1.

    READ TABLE ct_code INDEX lv_line ASSIGNING <lv_code>.
    ASSERT sy-subrc = 0.

    IF <lv_code> CP '*.'.
      lv_length = strlen( <lv_code> ) - 1.

      <lv_code> = replace( val  = <lv_code>
                           off  = lv_length
                           len  = 1
                           with = ',' ).
    ENDIF.

    IF <lv_code> NP '*DATA:*'.
      REPLACE FIRST OCCURRENCE OF 'DATA' IN <lv_code> WITH 'DATA:'.
    ENDIF.

  ENDMETHOD.


  METHOD remove_preceding_empty_lines.

    DATA: lv_line TYPE sci_line.

    FIELD-SYMBOLS: <lv_code> LIKE LINE OF ct_code.


    lv_line = cv_line - 1.

    DO.
      READ TABLE ct_code INDEX lv_line ASSIGNING <lv_code>.
      ASSERT sy-subrc = 0.
      IF <lv_code> <> ''.
        EXIT.
      ENDIF.
      DELETE ct_code INDEX lv_line.
      lv_line = lv_line - 1.
      cv_line = cv_line - 1.
    ENDDO.

  ENDMETHOD.


  METHOD zif_aof_fixer~is_fixable.

    rv_fixable = boolc( is_result-test = 'ZCL_AOC_CHECK_55' ).

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

      remove_preceding_empty_lines(
        CHANGING
          cv_line = <ls_result>-line
          ct_code = <ls_change>-code_after ).

      READ TABLE <ls_change>-code_after ASSIGNING <lv_line> INDEX <ls_result>-line.
      ASSERT sy-subrc = 0.

      REPLACE FIRST OCCURRENCE OF 'DATA:' IN <lv_line> WITH `     `.
      IF sy-subrc <> 0.
        REPLACE FIRST OCCURRENCE OF 'DATA' IN <lv_line> WITH `     `.
      ENDIF.
      IF sy-subrc = 0.
        previous_to_comma( EXPORTING iv_line = <ls_result>-line
                           CHANGING ct_code = <ls_change>-code_after ).
      ENDIF.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
