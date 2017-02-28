REPORT zaof_build_worklist.

PARAMETERS: p_des TYPE zaof_worklists-description OBLIGATORY,
            p_set TYPE zaof_worklists-object_set OBLIGATORY,
            p_chk TYPE zaof_worklists-check_variant OBLIGATORY.

START-OF-SELECTION.
  PERFORM run.

FORM run.

  DATA: ls_data TYPE zaof_worklists_data.


  ls_data-description   = p_des.
  ls_data-object_set    = p_set.
  ls_data-check_variant = p_chk.

  zcl_aof_worklist=>create( ls_data ).

  WRITE: / 'Done'(001).

ENDFORM.
