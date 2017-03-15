CLASS ltcl_test DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    DATA: mi_fixer    TYPE REF TO zif_aof_fixer,
          mt_input    TYPE string_table,
          mt_expected TYPE string_table.

    METHODS:
      setup,
      test01 FOR TESTING,
      test02 FOR TESTING,
      test03 FOR TESTING.

ENDCLASS.       "ltcl_Test

CLASS ltcl_test IMPLEMENTATION.

  METHOD setup.

    CREATE OBJECT mi_fixer TYPE zcl_aof_aoc_check_30.

    CLEAR: mt_input,
           mt_expected.

  ENDMETHOD.

  METHOD test01.

    APPEND 'lx_error->to_fpm_error('          TO mt_input.
    APPEND '  EXPORTING'                      TO mt_input.
    APPEND '    iv_ref_name  = lv_field_name' TO mt_input.
    APPEND '    iv_ref_index = lv_row ).'     TO mt_input.

    APPEND 'lx_error->to_fpm_error('          TO mt_expected.
    APPEND '    iv_ref_name  = lv_field_name' TO mt_expected.
    APPEND '    iv_ref_index = lv_row ).'     TO mt_expected.

    zcl_aof_fixer_unit_test=>test(
      ii_fixer    = mi_fixer
      it_input    = mt_input
      it_expected = mt_expected
      iv_line     = 2 ).

  ENDMETHOD.

  METHOD test02.

    APPEND 'go_luc->assign( EXPORTING i_ver = p_ver ).' TO mt_input.

    APPEND 'go_luc->assign( i_ver = p_ver ).' TO mt_expected.

    zcl_aof_fixer_unit_test=>test(
      ii_fixer    = mi_fixer
      it_input    = mt_input
      it_expected = mt_expected
      iv_line     = 1 ).

  ENDMETHOD.

  METHOD test03.

    APPEND 'go_luc->assign( exporting i_ver = p_ver ).' TO mt_input.

    APPEND 'go_luc->assign( i_ver = p_ver ).' TO mt_expected.

    zcl_aof_fixer_unit_test=>test(
      ii_fixer    = mi_fixer
      it_input    = mt_input
      it_expected = mt_expected
      iv_line     = 1 ).

  ENDMETHOD.

ENDCLASS.
