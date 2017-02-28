class ZCL_AOF_TASK definition
  public
  create public .

public section.

  class-methods RUN
    importing
      !IV_WORKLIST type ZAOF_WORKLIST
      !IV_TASK type ZAOF_TASK
    returning
      value(RS_DATA) type ZAOF_RUN_DATA .
protected section.

  class-methods FILL_DATA
    importing
      !IT_RESULTS type SCIT_ALVLIST
    returning
      value(RS_DATA) type ZAOF_RUN_DATA .
private section.
ENDCLASS.



CLASS ZCL_AOF_TASK IMPLEMENTATION.


  method FILL_DATA.
  endmethod.


  METHOD run.

* todo, refactor?

    DATA: lt_results TYPE scit_alvlist,
          lt_final   TYPE scit_alvlist,
          lv_class   TYPE seoclsname,
          li_fixer   TYPE REF TO zif_aof_fixer,
          ls_task    TYPE zaof_tasks.

    FIELD-SYMBOLS: <ls_result> LIKE LINE OF lt_results.


    SELECT SINGLE * FROM zaof_tasks INTO ls_task
      WHERE worklist = iv_worklist
      AND task = iv_task.
    ASSERT sy-subrc = 0.

    lt_results = zcl_aof_code_inspector=>run_object(
        iv_variant = 'ZHVAM' " todo
        iv_objtype = ls_task-objtype
        iv_objname = ls_task-objname ).

    LOOP AT lt_results ASSIGNING <ls_result>.
      lv_class = zcl_aof_fixers=>find_fixer( <ls_result> ).
      IF lv_class = ls_task-fixer.
        APPEND <ls_result> TO lt_final.
      ENDIF.
    ENDLOOP.
    CLEAR lt_results.

    rs_data = fill_data( lt_final ).

    CREATE OBJECT li_fixer TYPE (ls_task-fixer).
    rs_data = li_fixer->run( rs_data ).

  ENDMETHOD.
ENDCLASS.
