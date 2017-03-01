class ZCL_AOF_AOC_CHECK_30 definition
  public
  create public .

public section.

  interfaces ZIF_AOF_FIXER .
protected section.
private section.
ENDCLASS.



CLASS ZCL_AOF_AOC_CHECK_30 IMPLEMENTATION.


  METHOD zif_aof_fixer~is_fixable.

    rv_fixable = boolc( is_result-test = 'ZCL_AOC_CHECK_30' ).

  ENDMETHOD.


  METHOD zif_aof_fixer~run.

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

* todo, extra validations that the line in fact only contains "EXPORTING"
      DELETE <ls_change>-code_after INDEX <ls_result>-line.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
