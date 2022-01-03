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
  addAdvert,
  generalError,
}
