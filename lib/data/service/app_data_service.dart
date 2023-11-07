import 'package:flutter_reference/domain/entity/user.dart';

/// Represents information that is globally relevant during runtime and that
/// should be available app-wide.
///
/// Be very careful with what is added here. Generally, very little data is
/// relevant app-wide, and anything added here becomes available to every bloc,
/// service and repository. If some information is only relevant to a few blocs,
/// then consider sharing that information by emitting multiple events or using
/// listeners in the widget tree.
///
/// Importantly, when adding a new property to `AppData`, make sure to comment
/// and explain the following:
/// - Why this data is relevant to the entire app and must be globally available;
///   - If it doesn't have to be globally available, then it should only exist
///     in a bloc and be shared through streams or listeners in the widget tree.
/// - Where this data comes from and where it's duplicated;
///   - The data here likely also exists somewhere else, and that creates the
///     possibility of inconsistencies in case of bugs.
/// - What the consequences are in case of inconsistencies with duplicated data;
///   - Explain what happens when the data here becomes out-of-sync with where
///     it came from. This is not expected during normal operation, but the
///     comment must clarify what effects a bug may have.
///
/// Remember that all information in `AppData` is likely duplicated from a bloc,
/// and therefore runs the risk of being out of sync in case of a bug. Avoid
/// relying on `AppData` if you can, and if you must use globally available
/// information, be sure to properly unit test the places where you read and
/// write global information.
///
/// Each field should also have default values which will be used when the app
/// initializes.
class AppData {
  /// The user who is currently logged in. This is globally available because
  /// the business logic contained in many blocs may be affected by the current
  /// user's information, for example their role (admin or not). Business rules
  /// are frequently based on the user who is doing a certain operation. Any
  /// new business rule may depend on this information (for example, we may want
  /// to limit a certain operation depending on the user's address).
  ///
  /// If this field is null, it means there is no user currently logged in.
  ///
  /// This information also exists in the login bloc. Therefore, any time that
  /// the login bloc updates its state, it should also update the current user
  /// here. If that does not happen, then other blocs could inadvertedly apply
  /// a business rule incorrectly due to not having correct data about the
  /// current user.
  User? currentUser;

  // Examples of information that can be in AppData:
  // - The user's current location, in an app where business logic depends on
  //   the user's location/velocity/other gps info.
  // - Information about a connected external device in an app that can control
  //   and interact with that device.
  // Examples of information that doesn't need to be global:
  // - Access tokens and refresh tokens are already available in local storage,
  //   where they should be because it's persistent information. Retrieving
  //   information from local storage is quick enough that keeping it in memory
  //   here is not justified for performance.
  // - A step indicator for some operation, such as the user's current step in
  //   onboarding. This should stay in a bloc, available to widgets through a
  //   provider. If this affects any bloc logic, the information can be sent
  //   inside events.
}

/// Service that makes information globally available to all blocs and services
/// in the application.
///
/// This is as dangerous as it sounds. Don't add information to AppData just
/// because you need it somewhere else; this is intended for cases where a
/// bloc or service's logic depends on information that is stored somewhere
/// else, and that information is relevant to the entire app.
class AppDataService {
  // The data object is mutable.
  final AppData _data = AppData();

  void writeCurrentUser(User user) {
    _data.currentUser = user;
  }

  void clearCurrentUser() {
    _data.currentUser = null;
  }

  User? readCurrentUser() => _data.currentUser;
}
