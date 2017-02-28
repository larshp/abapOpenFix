class ZCL_AOF_SICF definition
  public
  create public .

public section.

  interfaces IF_HTTP_EXTENSION .
protected section.
private section.
ENDCLASS.



CLASS ZCL_AOF_SICF IMPLEMENTATION.


  METHOD if_http_extension~handle_request.

    DATA: lv_path TYPE string,
          li_http TYPE REF TO if_http_extension.


    lv_path = server->request->get_header_field( '~path' ).

    IF lv_path CP '/sap/zabapopenfix/rest/*'.
      CREATE OBJECT li_http TYPE zcl_aof_rest.
    ELSE.
      CREATE OBJECT li_http TYPE zcl_aof_static.
    ENDIF.

    li_http->handle_request( server ).

  ENDMETHOD.
ENDCLASS.
