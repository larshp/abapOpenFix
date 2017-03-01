class ZCL_AOF_FIXERS definition
  public
  create public .

public section.

  class-methods FIND_FIXER
    importing
      !IS_RESULT type SCIR_ALVLIST
    returning
      value(RV_CLASS) type SEOCLSNAME .
protected section.

  types:
    BEGIN OF ty_fixer,
           ref  TYPE REF TO zif_aof_fixer,
           name TYPE seoclsname,
         END OF ty_fixer .

  class-data:
    gt_fixers TYPE STANDARD TABLE OF ty_fixer WITH DEFAULT KEY .

  class-methods FIND_FIXER_CLASSES .
private section.
ENDCLASS.



CLASS ZCL_AOF_FIXERS IMPLEMENTATION.


  METHOD find_fixer.

    DATA: ls_fixer   LIKE LINE OF gt_fixers,
          lv_fixable TYPE abap_bool.


    IF lines( gt_fixers ) = 0.
      find_fixer_classes( ).
    ENDIF.

    LOOP AT gt_fixers INTO ls_fixer.
      lv_fixable = ls_fixer-ref->is_fixable( is_result ).
      IF lv_fixable = abap_true.
        rv_class = ls_fixer-name.
* todo, what if something can be fixed by multiple?
        RETURN.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD find_fixer_classes.

    DATA: ls_fixer TYPE ty_fixer,
          ls_key   TYPE seoclskey,
          lt_keys  TYPE seor_implementing_keys.

    FIELD-SYMBOLS: <ls_key> LIKE LINE OF lt_keys.


    CLEAR gt_fixers.

    ls_key-clsname = 'ZIF_AOF_FIXER'.

    CALL FUNCTION 'SEO_INTERFACE_IMPLEM_GET_ALL'
      EXPORTING
        intkey       = ls_key
      IMPORTING
        impkeys      = lt_keys
      EXCEPTIONS
        not_existing = 1
        OTHERS       = 2.
    ASSERT sy-subrc = 0.

    LOOP AT lt_keys ASSIGNING <ls_key>.
      CLEAR ls_fixer.
      CREATE OBJECT ls_fixer-ref TYPE (<ls_key>-clsname).
      ls_fixer-name = <ls_key>-clsname.
      APPEND ls_fixer TO gt_fixers.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
