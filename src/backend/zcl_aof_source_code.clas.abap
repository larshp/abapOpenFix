class ZCL_AOF_SOURCE_CODE definition
  public
  create public .

public section.

  class-methods UPDATE
    importing
      !IV_NAME type PROGNAME
      !IT_SOURCE type STRING_TABLE .
protected section.
private section.
ENDCLASS.



CLASS ZCL_AOF_SOURCE_CODE IMPLEMENTATION.


  METHOD update.

* todo
    BREAK-POINT.

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

    INSERT REPORT iv_name FROM it_source STATE 'I'.

* perform basic syntax check before activating?

  ENDMETHOD.
ENDCLASS.
