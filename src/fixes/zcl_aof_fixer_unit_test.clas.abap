CLASS zcl_aof_fixer_unit_test DEFINITION
  PUBLIC
  CREATE PUBLIC
  FOR TESTING .

  PUBLIC SECTION.

    CLASS-METHODS test
      IMPORTING
        !ii_fixer    TYPE REF TO zif_aof_fixer
        !it_input    TYPE string_table
        !it_expected TYPE string_table
        !it_results  TYPE scit_alvlist .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_AOF_FIXER_UNIT_TEST IMPLEMENTATION.


  METHOD test.

    DATA: ls_result TYPE zaof_run_data,
          ls_data   TYPE zaof_run_data.

    FIELD-SYMBOLS: <ls_change> LIKE LINE OF ls_data-changes.


    ls_data-results = it_results.

    APPEND INITIAL LINE TO ls_data-changes ASSIGNING <ls_change>.
    <ls_change>-code_before = it_input.
    <ls_change>-code_after = it_input.

    ls_result = ii_fixer->run( ls_data ).

    READ TABLE ls_result-changes INDEX 1 ASSIGNING <ls_change>.
    cl_abap_unit_assert=>assert_subrc( ).

    cl_abap_unit_assert=>assert_equals(
      act = <ls_change>-code_after
      exp = it_expected ).

  ENDMETHOD.
ENDCLASS.
