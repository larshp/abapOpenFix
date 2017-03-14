class ZCL_AOF_SOURCE_CODE definition
  public
  create public .

public section.

  class-methods UPDATE
    importing
      !IV_NAME type PROGNAME
      !IT_SOURCE type STRING_TABLE
    returning
      value(RT_ERRORS) type ZAOF_ERRORS_TT .
protected section.
private section.
ENDCLASS.



CLASS ZCL_AOF_SOURCE_CODE IMPLEMENTATION.


  METHOD update.

    DATA: ls_trdir TYPE trdir,
          lv_mess  TYPE string,
          lv_line  TYPE i,
          lv_word  TYPE string.

    FIELD-SYMBOLS: <ls_error> LIKE LINE OF rt_errors.


    SELECT SINGLE * FROM trdir
      INTO CORRESPONDING FIELDS OF ls_trdir
      WHERE name = iv_name.
    ASSERT sy-subrc = 0.

    SYNTAX-CHECK FOR it_source
      MESSAGE lv_mess LINE lv_line WORD lv_word
      PROGRAM iv_name
      DIRECTORY ENTRY ls_trdir.
    IF sy-subrc <> 0.
      APPEND INITIAL LINE TO rt_errors ASSIGNING <ls_error>.
      <ls_error>-program = iv_name.
      <ls_error>-message = lv_mess.
      <ls_error>-line    = lv_line.
      RETURN.
    ENDIF.

* todo, locking?

* todo, insert in transport
*    CALL FUNCTION 'RS_CORR_INSERT'
*      EXPORTING
*        object              = is_progdir-name
*        object_class        = 'ABAP'
*        devclass            = iv_package
*        mode                = 'INSERT'
*      EXCEPTIONS
*        cancelled           = 1
*        permission_failure  = 2
*        unknown_objectclass = 3
*        OTHERS              = 4.

    INSERT REPORT iv_name FROM it_source.

  ENDMETHOD.
ENDCLASS.
