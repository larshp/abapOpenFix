class ZCL_AOF_FIXER_UNIT_TEST definition
  public
  create public
  for testing .

public section.

  class-methods TEST
    importing
      !II_FIXER type ref to ZIF_AOF_FIXER
      !IT_INPUT type STRING_TABLE
      !IT_EXPECTED type STRING_TABLE
      !IV_LINE type SCI_LINE
      !IV_PARAM1 type SYCHAR80 optional .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_AOF_FIXER_UNIT_TEST IMPLEMENTATION.


  METHOD test.

    DATA: ls_result TYPE zaof_run_data,
          ls_data   TYPE zaof_run_data.

    FIELD-SYMBOLS: <ls_result> LIKE LINE OF ls_data-results,
                   <ls_change> LIKE LINE OF ls_data-changes.


    APPEND INITIAL LINE TO ls_data-results ASSIGNING <ls_result>.
    <ls_result>-line   = iv_line.
    <ls_result>-param1 = iv_param1.

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
