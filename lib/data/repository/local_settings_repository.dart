/// Repository for local settings.
///
/// I recommend putting logic for local and remote settings in different blocs,
/// because they work in different ways.
/// Local settings are expected to change instantly without much risk of error,
/// while remote settings should be changed using a form making a request.
class LocalSettingsRepository {
  // Note that this repository doesn't need to extend from InteropRepository
  // because it doesn't make calls to native code.
  //
  // We're not using interfaces for repositories because at this time, we don't
  // have a structure for injecting mocks.
}
