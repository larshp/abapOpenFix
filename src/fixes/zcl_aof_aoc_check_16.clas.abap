class ZCL_AOF_AOC_CHECK_16 definition
  public
  create public .

public section.

  interfaces ZIF_AOF_FIXER .
protected section.
private section.
ENDCLASS.



CLASS ZCL_AOF_AOC_CHECK_16 IMPLEMENTATION.


  METHOD zif_aof_fixer~is_fixable.

    rv_fixable = boolc( is_result-test = 'ZCL_AOC_CHECK_16' ).

  ENDMETHOD.


  METHOD zif_aof_fixer~run.

    DATA: lv_dot    TYPE string,
          lv_before TYPE string.

    FIELD-SYMBOLS: <ls_result> LIKE LINE OF rs_data-results,
                   <ls_change> LIKE LINE OF rs_data-changes.


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

* todo, extra validations
      READ TABLE <ls_change>-code_after INDEX <ls_result>-line - 1
        INTO lv_before.                                   "#EC CI_SUBRC
      READ TABLE <ls_change>-code_after INDEX <ls_result>-line
        INTO lv_dot.
      CONDENSE lv_dot.
      IF lv_dot = '.'.
        CONCATENATE lv_before lv_dot INTO lv_before.
      ELSE.
        CONCATENATE lv_before lv_dot INTO lv_before SEPARATED BY space.
      ENDIF.
      ASSERT sy-subrc = 0.
      DELETE <ls_change>-code_after INDEX <ls_result>-line.
      MODIFY <ls_change>-code_after INDEX <ls_result>-line - 1 FROM lv_before.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
