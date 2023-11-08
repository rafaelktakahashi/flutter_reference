import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reference/business/settings/settings_bloc.dart';
import 'package:flutter_reference/view/UI/organisms/settings/settings_controls.dart';
import 'package:flutter_reference/view/templates/simple_template.dart';

int counter = 0;

/// Example of a settings page.
///
/// The settings that the user can control in this page don't actually affect
/// much of the app's behavior, but they're saved in local storage.
///
/// This is meant as a demonstration of accessing local storage using blocs.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // In this example project, we have a SimpleTemplate that isn't scrollable,
    // and a ScrollableTemplate that accepts a list of widgets and is scrollable.
    //
    // Even in situations when the main content of the page is a list, it makes
    // more sense to use the simple template because the "list" is one organism.
    // The home page is an example of a page that uses the scrollable template.
    return SimpleTemplate(
      title: "Settings",
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (a, b) {
          return const SettingsControls();
        },
      ),
    );
  }
}
