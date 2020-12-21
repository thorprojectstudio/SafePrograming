extern __imp_ChooseColorA:qword 
ChooseColor TEXTEQU <__imp_ChooseColorA> 
extern __imp_ChooseColorW:qword 
ChooseColorW TEXTEQU <__imp_ChooseColorW> 
extern __imp_ChooseFontA:qword 
ChooseFont TEXTEQU <__imp_ChooseFontA> 
extern __imp_ChooseFontW:qword 
ChooseFontW TEXTEQU <__imp_ChooseFontW> 
extern __imp_CommDlgExtendedError:qword 
CommDlgExtendedError TEXTEQU <__imp_CommDlgExtendedError> 
extern __imp_DllCanUnloadNow:qword 
DllCanUnloadNow TEXTEQU <__imp_DllCanUnloadNow> 
extern __imp_DllGetClassObject:qword 
DllGetClassObject TEXTEQU <__imp_DllGetClassObject> 
extern __imp_FindTextA:qword 
FindText TEXTEQU <__imp_FindTextA> 
extern __imp_FindTextW:qword 
FindTextW TEXTEQU <__imp_FindTextW> 
extern __imp_GetFileTitleA:qword 
GetFileTitle TEXTEQU <__imp_GetFileTitleA> 
extern __imp_GetFileTitleW:qword 
GetFileTitleW TEXTEQU <__imp_GetFileTitleW> 
extern __imp_GetOpenFileNameA:qword 
GetOpenFileName TEXTEQU <__imp_GetOpenFileNameA> 
extern __imp_GetOpenFileNameW:qword 
GetOpenFileNameW TEXTEQU <__imp_GetOpenFileNameW> 
extern __imp_GetSaveFileNameA:qword 
GetSaveFileName TEXTEQU <__imp_GetSaveFileNameA> 
extern __imp_GetSaveFileNameW:qword 
GetSaveFileNameW TEXTEQU <__imp_GetSaveFileNameW> 
extern __imp_LoadAlterBitmap:qword 
LoadAlterBitmap TEXTEQU <__imp_LoadAlterBitmap> 
extern __imp_PageSetupDlgA:qword 
PageSetupDlg TEXTEQU <__imp_PageSetupDlgA> 
extern __imp_PageSetupDlgW:qword 
PageSetupDlgW TEXTEQU <__imp_PageSetupDlgW> 
extern __imp_PrintDlgA:qword 
PrintDlg TEXTEQU <__imp_PrintDlgA> 
extern __imp_PrintDlgExA:qword 
PrintDlgEx TEXTEQU <__imp_PrintDlgExA> 
extern __imp_PrintDlgExW:qword 
PrintDlgExW TEXTEQU <__imp_PrintDlgExW> 
extern __imp_PrintDlgW:qword 
PrintDlgW TEXTEQU <__imp_PrintDlgW> 
extern __imp_ReplaceTextA:qword 
ReplaceText TEXTEQU <__imp_ReplaceTextA> 
extern __imp_ReplaceTextW:qword 
ReplaceTextW TEXTEQU <__imp_ReplaceTextW> 
extern __imp_Ssync_ANSI_UNICODE_Struct_For_WOW:qword 
Ssync_ANSI_UNICODE_Struct_For_WOW TEXTEQU <__imp_Ssync_ANSI_UNICODE_Struct_For_WOW> 
extern __imp_WantArrows:qword 
WantArrows TEXTEQU <__imp_WantArrows> 
extern __imp_dwLBSubclass:qword 
dwLBSubclass TEXTEQU <__imp_dwLBSubclass> 
extern __imp_dwOKSubclass:qword 
dwOKSubclass TEXTEQU <__imp_dwOKSubclass> 
extern __imp_comdlg32_ordinal100:qword 
comdlg32_ordinal100 TEXTEQU <__imp_comdlg32_ordinal100> 
extern __imp_comdlg32_ordinal101:qword 
comdlg32_ordinal101 TEXTEQU <__imp_comdlg32_ordinal101> 
;----------------------------
FINDREPLACE STRUCT
  lStructSize       DWORD      ?,?
  hwndOwner         QWORD      ?
  hInstance         QWORD      ?
  Flags             DWORD      ?,?
  lpstrFindWhat     QWORD      ?
  lpstrReplaceWith  QWORD      ?
  wFindWhatLen       WORD      ?
  wReplaceWithLen    WORD      ?
  lCustData         DWORD      ?
  lpfnHook          QWORD      ?
  lpTemplateName    QWORD      ?,?
FINDREPLACE ENDS