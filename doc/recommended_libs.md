# Recommended Libraries

This file is meant as a recommendation of libraries, but in any case it's recommended that you keep a file like this one in your project's documentation to enumerate and justify all libraries that are used, and also any libraries to avoid.

## Business logic and state management: [flutter_bloc](https://pub.dev/packages/flutter_bloc)

Blocs are the main library for business logic and state management in Flutter, but it's also important to note that there are others that may make more sense depending on the project and depending on the team's familiarity with the different options.

In this project, blocs are a central part of the native interop capabilities of this architecture. If you choose to use another library for this purpose (e.g. Redux), you'll have to reimplement the interop bloc in order to keep the native interop functionality.

## Dependency injection: [get_it](https://pub.dev/packages/get_it)

Generally, it is good practice to use dependency injection to reduce coupling between classes; however, keep in mind that generally speaking, mobile applications don't benefit that much from the overabundance of interfaces one may find in a Java backend application. For one, there's no such thing as modularized deploys, since every version of the app is a whole new package. There's also never a need to swap a class' implementation in runtime.

More specifically to this project, we use dependency injection to ensure that an interop bloc and its native adapter only ever have exactly one instance from the start of the application. The code in this repository showcases a simple example of how these instances can be safely created.

## Code Generator: [freezed](https://pub.dev/packages/freezed)

Code generator that's mainly for convenience and quality of life; with it, it's not necessary to manually write functions for copying data classes or for serialization/deserialization. There's a certain learning curve, but it's very likely to save work and time in the long run.

Because freezed classes use code generation, it's necessary to run `flutter pub run build_runner build` in the terminal whenever you write or change a freezed class. Those generated files should be committed to the repository (don't treat them as build artifacts, but rather as actual source files).

# Not recommended

## Bloc persistence: [hydrated_bloc](https://pub.dev/packages/hydrated_bloc)

Hydrated bloc is a quite tricky library to use correctly, and it has a more limited set of use cases and it appears. Generally speaking, you shouldn't think of bloc states as "persistable" to begin with. States are ephemeral and represent the immediate, present state of the application. Things like loading states and error messages shouldn't be persisted, and persisting them comes at the cost of having to manage what happens when the state object changes between app versions.

Always consider persisting information manually whenever possible. In almost all situations, adding bloc persistence (or some other kind of persistence for other state-management libraries) is going to increase complexity, add unneeded rules that you have to think about, and introduce new ways for the app to fail.
