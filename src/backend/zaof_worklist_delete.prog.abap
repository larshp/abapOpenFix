REPORT zaof_worklist_delete.

PARAMETERS: p_work TYPE zaof_worklists-worklist OBLIGATORY.

START-OF-SELECTION.
  PERFORM run.

FORM run.

  zcl_aof_worklist=>delete( p_work ).

  WRITE: / 'Done'(001).

ENDFORM.
