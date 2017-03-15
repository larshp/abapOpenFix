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
    CREATE OBJECT mi_fixer TYPE zcl_aof_aoc_check_43.

    CLEAR: mt_input,
           mt_expected.
  ENDMETHOD.

  METHOD test01.

    APPEND 'mo_log->set_probclass( i_probclass = ''1'' ).' TO mt_input.

    APPEND 'mo_log->set_probclass( ''1'' ).' TO mt_expected.

    zcl_aof_fixer_unit_test=>test(
      ii_fixer    = mi_fixer
      it_input    = mt_input
      it_expected = mt_expected
      iv_line     = 1
      iv_param1   = 'I_PROBCLASS' ).

  ENDMETHOD.

ENDCLASS.
