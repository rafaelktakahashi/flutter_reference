/// Superclass for all errors that can be returned from operations (especially
/// in the data layer) in this project.
abstract class MegastoreError {
  const MegastoreError();

  String errorMessage();

  String errorCode();
}
