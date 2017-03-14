CLASS ltcl_test DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    DATA: mi_fixer    TYPE REF TO zif_aof_fixer,
          mt_input    TYPE string_table,
          mt_results  TYPE scit_alvlist,
          mt_expected TYPE string_table.

    METHODS:
      setup,
      test01 FOR TESTING,
      test02 FOR TESTING.

ENDCLASS.       "ltcl_Test

CLASS ltcl_test IMPLEMENTATION.

  METHOD setup.

    CREATE OBJECT mi_fixer TYPE zcl_aof_aoc_check_16.

    CLEAR: mt_input,
           mt_results,
           mt_expected.

  ENDMETHOD.

  METHOD test01.

    APPEND 'CALL FUNCTION ''ZASDF''' TO mt_input.
    APPEND '  EXPORTING'             TO mt_input.
    APPEND '    A_WERKS = p_werks'   TO mt_input.
    APPEND '    .'                   TO mt_input.

    APPEND 'CALL FUNCTION ''ZASDF''' TO mt_expected.
    APPEND '  EXPORTING'             TO mt_expected.
    APPEND '    A_WERKS = p_werks.'  TO mt_expected.

    zcl_aof_fixer_unit_test=>test(
      ii_fixer    = mi_fixer
      it_input    = mt_input
      it_expected = mt_expected
      iv_line     = 4 ).

  ENDMETHOD.

  METHOD test02.

    APPEND 'lo_object->method( p_werks' TO mt_input.
    APPEND '  ).'                       TO mt_input.

    APPEND 'lo_object->method( p_werks ).'  TO mt_expected.

    zcl_aof_fixer_unit_test=>test(
      ii_fixer    = mi_fixer
      it_input    = mt_input
      it_expected = mt_expected
      iv_line     = 2 ).

  ENDMETHOD.

ENDCLASS.
