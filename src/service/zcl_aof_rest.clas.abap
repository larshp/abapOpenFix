class ZCL_AOF_REST definition
  public
  create public .

public section.

  interfaces IF_HTTP_EXTENSION .
  interfaces ZIF_SWAG_HANDLER .

  methods LIST_TASKS
    importing
      !IV_WORKLIST type ZAOF_WORKLIST
    returning
      value(RT_LIST) type ZAOF_TASKS_TT .
  methods LIST_WORKLISTS
    returning
      value(RT_LIST) type ZAOF_WORKLISTS_TT .
PROTECTED SECTION.

  CONSTANTS c_base TYPE string VALUE '/sap/zabapopenfix/rest' ##NO_TEXT.
private section.
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

    lo_swag->run( ).

  ENDMETHOD.


  METHOD list_tasks.

    SELECT * FROM zaof_tasks
      INTO TABLE rt_list
      WHERE worklist = iv_worklist.

  ENDMETHOD.


  METHOD list_worklists.

    SELECT * FROM zaof_worklists
      INTO TABLE rt_list.

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

  ENDMETHOD.
ENDCLASS.
