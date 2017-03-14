CLASS ltcl_test DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    DATA: mi_fixer TYPE REF TO zif_aof_fixer.

    METHODS:
      setup,
      test01 FOR TESTING.

ENDCLASS.       "ltcl_Test

CLASS ltcl_test IMPLEMENTATION.

  METHOD setup.

    CREATE OBJECT mi_fixer TYPE zcl_aof_aoc_check_30.

  ENDMETHOD.

  METHOD test01.

    DATA: lt_input    TYPE string_table,
          lt_results  TYPE scit_alvlist,
          lt_expected TYPE string_table.

    FIELD-SYMBOLS: <ls_result> LIKE LINE OF lt_results.


    APPEND INITIAL LINE TO lt_results ASSIGNING <ls_result>.
    <ls_result>-line = 2.

    APPEND 'lx_error->to_fpm_error('          TO lt_input.
    APPEND '  EXPORTING'                      TO lt_input.
    APPEND '    iv_ref_name  = lv_field_name' TO lt_input.
    APPEND '    iv_ref_index = lv_row ).'     TO lt_input.

    APPEND 'lx_error->to_fpm_error('          TO lt_expected.
    APPEND '    iv_ref_name  = lv_field_name' TO lt_expected.
    APPEND '    iv_ref_index = lv_row ).'     TO lt_expected.

    zcl_aof_fixer_unit_test=>test(
      ii_fixer    = mi_fixer
      it_input    = lt_input
      it_expected = lt_expected
      it_results  = lt_results ).

  ENDMETHOD.

ENDCLASS.
