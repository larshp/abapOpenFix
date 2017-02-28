interface ZIF_AOF_FIXER
  public .


  methods IS_FIXABLE
    importing
      !IS_RESULT type SCIR_ALVLIST
    returning
      value(RV_FIXABLE) type ABAP_BOOL .
endinterface.
