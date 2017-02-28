class ZCL_AOF_CODE_INSPECTOR definition
  public
  create public .

public section.

  class-methods RUN
    importing
      !IV_VARIANT type SCI_CHKV
      !IV_OBJECT_SET type SCI_OBJS
    returning
      value(RT_RESULTS) type SCIT_ALVLIST .
protected section.

  class-methods GET_VARIANT
    importing
      !IV_VARIANT type SCI_CHKV
    returning
      value(RO_VARIANT) type ref to CL_CI_CHECKVARIANT .
  class-methods GET_OBJECT_SET
    importing
      !IV_OBJECTSET type SCI_OBJS
    returning
      value(RO_OBJECTSET) type ref to CL_CI_OBJECTSET .
private section.
ENDCLASS.



CLASS ZCL_AOF_CODE_INSPECTOR IMPLEMENTATION.


  METHOD GET_OBJECT_SET.

    cl_ci_objectset=>get_ref(
      EXPORTING
        p_objsnam                 = iv_objectset
      RECEIVING
        p_ref                     = ro_objectset
      EXCEPTIONS
        missing_parameter         = 1
        objs_not_exists           = 2
        invalid_request           = 3
        object_not_exists         = 4
        object_may_not_be_checked = 5
        no_main_program           = 6
        OTHERS                    = 7 ).                  "#EC CI_SUBRC
    ASSERT sy-subrc = 0.

  ENDMETHOD.


  METHOD get_variant.

* variant must be global
    cl_ci_checkvariant=>get_ref(
      EXPORTING
        p_user            = ''
        p_name            = iv_variant
      RECEIVING
        p_ref             = ro_variant
      EXCEPTIONS
        chkv_not_exists   = 1
        missing_parameter = 2
        OTHERS            = 3 ).                          "#EC CI_SUBRC
    ASSERT sy-subrc = 0.

  ENDMETHOD.


  METHOD run.

    DATA: lo_variant    TYPE REF TO cl_ci_checkvariant,
          lo_ci         TYPE REF TO cl_ci_inspection,
          lv_date       TYPE datum,
          lv_text       TYPE sci_text,
          lo_object_set TYPE REF TO cl_ci_objectset.


    lo_variant = get_variant( iv_variant ).
    lo_object_set = get_object_set( iv_object_set ).

    cl_ci_inspection=>create(
      EXPORTING
        p_user           = ''
        p_name           = 'ABAPOPENFIX'
      RECEIVING
        p_ref            = lo_ci
      EXCEPTIONS
        locked           = 1
        error_in_enqueue = 2
        not_authorized   = 3
        OTHERS           = 4 ).                           "#EC CI_SUBRC
    ASSERT sy-subrc = 0.

    lo_ci->set(
      p_chkv = lo_variant
      p_objs = lo_object_set ).

    lo_ci->run(
      EXPORTING
        p_howtorun            = 'L' " parallel local server
      EXCEPTIONS
        invalid_check_version = 1
        OTHERS                = 2 ).                      "#EC CI_SUBRC
    ASSERT sy-subrc = 0.

* make sure SAP note 2043027 is installed
    lo_ci->plain_list(
      IMPORTING
        p_list = rt_results ).
    DELETE rt_results WHERE objtype = 'STAT'.

  ENDMETHOD.
ENDCLASS.
