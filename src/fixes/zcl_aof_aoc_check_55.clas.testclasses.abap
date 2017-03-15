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
*      test04 FOR TESTING.

ENDCLASS.       "ltcl_Test

CLASS ltcl_test IMPLEMENTATION.

  METHOD setup.

    CREATE OBJECT mi_fixer TYPE zcl_aof_aoc_check_55.

    CLEAR mt_input.
    CLEAR mt_expected.

  ENDMETHOD.

  METHOD test01.

    APPEND 'DATA: foo type c.' TO mt_input.
    APPEND 'DATA: bar type c.' TO mt_input.

    APPEND 'DATA: foo type c,' TO mt_expected.
    APPEND '      bar type c.' TO mt_expected.

    zcl_aof_fixer_unit_test=>test(
      ii_fixer    = mi_fixer
      it_input    = mt_input
      it_expected = mt_expected
      iv_line     = 2 ).

  ENDMETHOD.

  METHOD test02.

    APPEND 'DATA foo type c.' TO mt_input.
    APPEND 'DATA bar type c.' TO mt_input.

    APPEND 'DATA: foo type c,' TO mt_expected.
    APPEND '      bar type c.' TO mt_expected.

    zcl_aof_fixer_unit_test=>test(
      ii_fixer    = mi_fixer
      it_input    = mt_input
      it_expected = mt_expected
      iv_line     = 2 ).

  ENDMETHOD.

  METHOD test03.

    APPEND 'DATA foo type c.' TO mt_input.
    APPEND ''                 TO mt_input.
    APPEND 'DATA bar type c.' TO mt_input.

    APPEND 'DATA: foo type c,' TO mt_expected.
    APPEND '      bar type c.' TO mt_expected.

    zcl_aof_fixer_unit_test=>test(
      ii_fixer    = mi_fixer
      it_input    = mt_input
      it_expected = mt_expected
      iv_line     = 3 ).

  ENDMETHOD.

* todo
*  METHOD test04.
*
*    APPEND 'DATA foo type c.' TO mt_input.
*    APPEND 'DATA bar type c.' TO mt_input.
*    APPEND 'DATA moo type c.' TO mt_input.
*
*    APPEND 'DATA: foo type c,' TO mt_expected.
*    APPEND '      bar type c,' TO mt_expected.
*    APPEND '      moo type c.' TO mt_expected.
*
*    zcl_aof_fixer_unit_test=>test(
*      ii_fixer    = mi_fixer
*      it_input    = mt_input
*      it_expected = mt_expected
*      iv_line     = 2 ).
*
*  ENDMETHOD.

ENDCLASS.
