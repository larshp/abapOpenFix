CLASS zcl_aof_rest DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_http_extension .
    INTERFACES zif_swag_handler .

    METHODS list_tasks
      IMPORTING
        !iv_worklist   TYPE zaof_worklist
      RETURNING
        VALUE(rt_list) TYPE zaof_tasks_tt
      RAISING
        zcx_aof_error .
    METHODS list_worklists
      RETURNING
        VALUE(rt_list) TYPE zaof_worklists_tt .
    METHODS save_task
      IMPORTING
        !iv_worklist   TYPE zaof_worklist
        !iv_task       TYPE zaof_task
        !is_data       TYPE zaof_run_data
      RETURNING
        VALUE(rs_data) TYPE zaof_save_data .
    METHODS run_task
      IMPORTING
        !iv_worklist   TYPE zaof_worklist
        !iv_task       TYPE zaof_task
      RETURNING
        VALUE(rs_data) TYPE zaof_run_data
      RAISING
        zcx_aof_error .
  PROTECTED SECTION.

    CONSTANTS c_base TYPE string VALUE '/sap/zabapopenfix/rest' ##NO_TEXT.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_AOF_REST IMPLEMENTATION.


  METHOD if_http_extension~handle_request.

    DATA: lo_swag TYPE REF TO zcl_swag.


    CREATE OBJECT lo_swag
      EXPORTING
        ii_server = server
        iv_base   = c_base
        iv_title  = 'abapOpenFix'.
    lo_swag->register( me ).

    TRY.
        lo_swag->run( ).
      CATCH zcx_aof_not_found.
        server->response->set_cdata( '404, NOT FOUND' ).
        server->response->set_status( code   = 404
                                      reason = 'NOT FOUND' ).
    ENDTRY.

  ENDMETHOD.


  METHOD list_tasks.

    DATA: lv_worklist TYPE zaof_worklists-worklist.


    SELECT SINGLE worklist FROM zaof_worklists
      INTO lv_worklist
      WHERE worklist = iv_worklist.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_aof_not_found.
    ENDIF.

    SELECT * FROM zaof_tasks
      INTO TABLE rt_list
      WHERE worklist = iv_worklist.

  ENDMETHOD.


  METHOD list_worklists.

    SELECT * FROM zaof_worklists
      INTO TABLE rt_list.

  ENDMETHOD.


  METHOD run_task.

    DATA: lo_task TYPE REF TO zcl_aof_task.

    CREATE OBJECT lo_task
      EXPORTING
        iv_worklist = iv_worklist
        iv_task     = iv_task.

    rs_data = lo_task->run( ).

  ENDMETHOD.


  METHOD save_task.

    DATA: lo_task TYPE REF TO zcl_aof_task.

    CREATE OBJECT lo_task
      EXPORTING
        iv_worklist = iv_worklist
        iv_task     = iv_task.

    rs_data = lo_task->save( is_data ).

  ENDMETHOD.


  METHOD zif_swag_handler~meta.

    FIELD-SYMBOLS: <ls_meta> LIKE LINE OF rt_meta.


    APPEND INITIAL LINE TO rt_meta ASSIGNING <ls_meta>.
    <ls_meta>-summary   = 'List Worklists'(001).
    <ls_meta>-url-regex = '/worklists$'.
    <ls_meta>-method    = zcl_swag=>c_method-get.
    <ls_meta>-handler   = 'LIST_WORKLISTS'.

    APPEND INITIAL LINE TO rt_meta ASSIGNING <ls_meta>.
    <ls_meta>-summary   = 'List Tasks'(002).
    <ls_meta>-url-regex = '/tasks/(\w+)$'.
    APPEND 'IV_WORKLIST' TO <ls_meta>-url-group_names.
    <ls_meta>-method    = zcl_swag=>c_method-get.
    <ls_meta>-handler   = 'LIST_TASKS'.

    APPEND INITIAL LINE TO rt_meta ASSIGNING <ls_meta>.
    <ls_meta>-summary   = 'Run Task'(003).
    <ls_meta>-url-regex = '/tasks/(\w+)/(\w+)$'.
    APPEND 'IV_WORKLIST' TO <ls_meta>-url-group_names.
    APPEND 'IV_TASK' TO <ls_meta>-url-group_names.
    <ls_meta>-method    = zcl_swag=>c_method-get.
    <ls_meta>-handler   = 'RUN_TASK'.

    APPEND INITIAL LINE TO rt_meta ASSIGNING <ls_meta>.
    <ls_meta>-summary   = 'Save Task'(004).
    <ls_meta>-url-regex = '/tasks/(\w+)/(\w+)$'.
    APPEND 'IV_WORKLIST' TO <ls_meta>-url-group_names.
    APPEND 'IV_TASK' TO <ls_meta>-url-group_names.
    <ls_meta>-method    = zcl_swag=>c_method-post.
    <ls_meta>-handler   = 'SAVE_TASK'.

  ENDMETHOD.
ENDCLASS.
