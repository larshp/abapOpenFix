CLASS zcl_aof_worklist DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS create
      IMPORTING
        !is_data TYPE zaof_worklists_data .
protected section.
private section.
ENDCLASS.



CLASS ZCL_AOF_WORKLIST IMPLEMENTATION.


  METHOD create.

    DATA: lt_results  TYPE scit_alvlist,
          lt_tasks    TYPE STANDARD TABLE OF zaof_tasks WITH DEFAULT KEY,
          ls_worklist TYPE zaof_worklists,
          lv_class    TYPE seoclsname.

    FIELD-SYMBOLS: <ls_task>   LIKE LINE OF lt_tasks,
                   <ls_result> LIKE LINE OF lt_results.


    ls_worklist-worklist = cl_system_uuid=>if_system_uuid_static~create_uuid_c22( ).
    ls_worklist-description = is_data-description.
    ls_worklist-object_set = is_data-object_set.
    ls_worklist-check_variant = is_data-check_variant.

* todo, status and spawn background job? so this can be executed via REST?
    lt_results = zcl_aof_code_inspector=>run(
      iv_variant    = is_data-check_variant
      iv_object_set = is_data-object_set ).

    LOOP AT lt_results ASSIGNING <ls_result>.
      lv_class = zcl_aof_fixers=>find_fixer( <ls_result> ).
      IF NOT lv_class IS INITIAL.

        READ TABLE lt_tasks ASSIGNING <ls_task> WITH KEY
          objtype = <ls_result>-objtype
          objname = <ls_result>-objname
          description = <ls_result>-description
          test = <ls_result>-test
          fixer = lv_class.
        IF sy-subrc <> 0.
          APPEND INITIAL LINE TO lt_tasks ASSIGNING <ls_task>.
          <ls_task>-worklist = ls_worklist-worklist.
          <ls_task>-task = lines( lt_tasks ).
          <ls_task>-objtype = <ls_result>-objtype.
          <ls_task>-objname = <ls_result>-objname.
          <ls_task>-description = <ls_result>-description.
          <ls_task>-test = <ls_result>-test.
          <ls_task>-fixer = lv_class.
        ENDIF.
        <ls_task>-counter = <ls_task>-counter + 1.
      ENDIF.
    ENDLOOP.

    INSERT zaof_worklists FROM ls_worklist.
    ASSERT sy-subrc = 0.
    INSERT zaof_tasks FROM TABLE lt_tasks.
    ASSERT sy-subrc = 0.

  ENDMETHOD.
ENDCLASS.
