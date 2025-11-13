
class UpdateProfileException implements Exception {
  final String? message;
  final Map<String, String>? fieldErrors;

  UpdateProfileException({this.message, this.fieldErrors});
}
