class AppError extends StateError {
  final ErrorType type;

  AppError(this.type) : super(type.toString());
}

enum ErrorType {
  weakPassword,
  emailAlreadyExists,
  wrongCredentials,
  invalidEmail,
  userNotFound,
  wrongPassword,
  createProfile,
  unauthorised,
  accountExistsWithDifferentCredential,
  invalidCredential,
  saveProfile,
  deleteProfile,
  loadPatterns,
  loadPatternDetails,
  loadAbbreviations,
  loadYarns,
  updateYarns,
  syncPdfs,
  downloadPdfs,
  loadPdf,
  generalError,
  newPatternReleaseDate,
  patternStartHint,
  addNeedle,
  editNeedle,
  addHook,
  editHook,
  loadShoppingList,
  addShoppingItem,
  editShoppingItem,
  deleteShoppingItem,
  loadPdfNotes,
  savePdfNotes
}
