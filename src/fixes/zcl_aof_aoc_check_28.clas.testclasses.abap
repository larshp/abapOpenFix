CLASS ltcl_test DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    DATA: mi_fixer    TYPE REF TO zif_aof_fixer,
          mt_input    TYPE string_table,
          mt_expected TYPE string_table.

    METHODS:
      setup,
      test01 FOR TESTING.

ENDCLASS.       "ltcl_Test

CLASS ltcl_test IMPLEMENTATION.

  METHOD setup.
    CREATE OBJECT mi_fixer TYPE zcl_aof_aoc_check_28.
  ENDMETHOD.

  METHOD test01.

    APPEND 'MESSAGE ID ''00'' TYPE ''E'' NUMBER 55 .' TO mt_input.

    APPEND 'MESSAGE ID ''00'' TYPE ''E'' NUMBER 55.' TO mt_expected.

    zcl_aof_fixer_unit_test=>test(
      ii_fixer    = mi_fixer
      it_input    = mt_input
      it_expected = mt_expected
      iv_line     = 1 ).

  ENDMETHOD.

ENDCLASS.
