class ZCL_AOF_TASK definition
  public
  create public .

public section.

  methods RUN
    returning
      value(RS_DATA) type ZAOF_RUN_DATA
    raising
      ZCX_AOF_ERROR .
  methods SAVE
    importing
      !IS_DATA type ZAOF_RUN_DATA
    returning
      value(RS_DATA) type ZAOF_SAVE_DATA .
  methods CONSTRUCTOR
    importing
      !IV_WORKLIST type ZAOF_WORKLIST
      !IV_TASK type ZAOF_TASK .
protected section.

  class-methods FILL_DATA
    importing
      !IT_RESULTS type SCIT_ALVLIST
      !IS_TASK type ZAOF_TASKS
    returning
      value(RS_DATA) type ZAOF_RUN_DATA .
  class-methods READ_SOURCE
    importing
      !IV_SOBJTYPE type SCI_TYPID
      !IV_SOBJNAME type SOBJ_NAME
    returning
      value(RT_SOURCE) type STRING_TABLE .
private section.

  data MV_WORKLIST type ZAOF_WORKLIST .
  data MV_TASK type ZAOF_TASK .
ENDCLASS.



CLASS ZCL_AOF_TASK IMPLEMENTATION.


  METHOD constructor.

    mv_worklist = iv_worklist.
    mv_task     = iv_task.

  ENDMETHOD.


  METHOD fill_data.

    FIELD-SYMBOLS: <ls_result> LIKE LINE OF it_results,
                   <ls_change> LIKE LINE OF rs_data-changes.


    rs_data-worklist  = is_task-worklist.
    rs_data-task      = is_task-task.
    rs_data-objtype   = is_task-objtype.
    rs_data-objname   = is_task-objname.
    rs_data-results   = it_results.

    rs_data-next_task = is_task-task + 1.
    SELECT SINGLE task FROM zaof_tasks
      INTO rs_data-next_task
      WHERE worklist = is_task-worklist
      AND task = rs_data-next_task.
    IF sy-subrc <> 0.
      CLEAR rs_data-next_task.
    ENDIF.

    LOOP AT it_results ASSIGNING <ls_result>.
      rs_data-description = <ls_result>-description.

      READ TABLE rs_data-changes WITH KEY
        sobjtype = <ls_result>-sobjtype
        sobjname = <ls_result>-sobjname
        TRANSPORTING NO FIELDS.
      IF sy-subrc <> 0.
        APPEND INITIAL LINE TO rs_data-changes ASSIGNING <ls_change>.
        <ls_change>-sobjtype = <ls_result>-sobjtype.
        <ls_change>-sobjname = <ls_result>-sobjname.

        <ls_change>-code_before = read_source(
          iv_sobjtype = <ls_change>-sobjtype
          iv_sobjname = <ls_change>-sobjname ).

        <ls_change>-code_after = <ls_change>-code_before.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD read_source.

    DATA: lt_source TYPE abaptxt255_tab.


    CASE iv_sobjtype.
      WHEN 'PROG'.
        CALL FUNCTION 'RPY_PROGRAM_READ'
          EXPORTING
            program_name     = iv_sobjname
            with_lowercase   = abap_true
          TABLES
            source_extended  = lt_source
          EXCEPTIONS
            cancelled        = 1
            not_found        = 2
            permission_error = 3
            OTHERS           = 4.
        ASSERT sy-subrc = 0.
      WHEN OTHERS.
        ASSERT 0 = 1.
    ENDCASE.

    rt_source = lt_source.

  ENDMETHOD.


  METHOD run.

* todo, refactor?

    DATA: lt_results  TYPE scit_alvlist,
          lt_final    TYPE scit_alvlist,
          lv_class    TYPE seoclsname,
          li_fixer    TYPE REF TO zif_aof_fixer,
          ls_task     TYPE zaof_tasks,
          ls_worklist TYPE zaof_worklists.

    FIELD-SYMBOLS: <ls_result> LIKE LINE OF lt_results.


    SELECT SINGLE * FROM zaof_worklists INTO ls_worklist
      WHERE worklist = mv_worklist.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_aof_not_found.
    ENDIF.

    SELECT SINGLE * FROM zaof_tasks INTO ls_task
      WHERE worklist = mv_worklist
      AND task = mv_task.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_aof_not_found.
    ENDIF.

    lt_results = zcl_aof_code_inspector=>run_object(
      iv_variant = ls_worklist-check_variant
      iv_test    = ls_task-test
      iv_objtype = ls_task-objtype
      iv_objname = ls_task-objname ).

    LOOP AT lt_results ASSIGNING <ls_result> WHERE test = ls_task-test.
      lv_class = zcl_aof_fixers=>find_fixer( <ls_result> ).
      IF lv_class = ls_task-fixer.
        APPEND <ls_result> TO lt_final.
      ENDIF.
    ENDLOOP.
    CLEAR lt_results.

    rs_data = fill_data(
      is_task    = ls_task
      it_results = lt_final ).

    CREATE OBJECT li_fixer TYPE (ls_task-fixer).
    rs_data = li_fixer->run( rs_data ).

  ENDMETHOD.


  METHOD save.

    FIELD-SYMBOLS: <ls_change> LIKE LINE OF is_data-changes.


    LOOP AT is_data-changes ASSIGNING <ls_change>.
      ASSERT <ls_change>-sobjtype = 'PROG'.

      IF <ls_change>-code_before <> <ls_change>-code_after.
        APPEND LINES OF
          zcl_aof_source_code=>update(
            iv_name   = <ls_change>-sobjname
            it_source = <ls_change>-code_after )
          TO rs_data-errors.
      ENDIF.
    ENDLOOP.

* todo, return result
    rs_data-todo = 666.

  ENDMETHOD.
ENDCLASS.
