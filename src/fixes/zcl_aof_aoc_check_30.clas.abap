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
ENDCLASS.
