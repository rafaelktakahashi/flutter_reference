# Business Layer

Our business layer is primarily populated by Flutter blocs (see the [flutter_bloc](https://pub.dev/packages/flutter_bloc) package). Because other pages in this documentation and elsewhere already expand on this topic sufficiently, this page is meant primarily for explaining the business layer structuraly.

## Simple Blocs

When a bloc is relatively simple and comfortably fits in a single file, it's expected that all business logic related to that bloc can be found in the bloc's class. In this case it's sufficient to write the bloc just like in the simplest examples found in tutorials.

### What belongs in each layer

A very common concern is deciding where each piece of information belongs; The main guiding principle is that _business rules (and thus the blocs) are independent of view logic, and should continue working the same regardless of any changes in the view layer_.

In other words, each bloc merely exposes its functionality through events and streams, but it does not care how the data in those streams is used or who emits events, much less about the visual likeness of the widgets.

---

**Let's make a thought experiment**. Imagine an app with dozens of different features but everything is placed in a single enormous page; every label, button, input field and list exists in a single page all at the same time. Putting aside the clear absurdity of this hypothetic app, I invite you to imagine how this page would connect to the blocs.

The key realization is that the blocs themselves would be built exactly the same as in a more reasonable app, with each part of the UI connecting to the relevant bloc.

The same would be true if the UI was a simple text-based terminal, or if the user interacted with the blocs using chatbots. A more realistic example would be imagining a different navigation structure in your app, which shouldn't require reworking your blocs.

From this though experiment, we can deduce a few key principles:

- Information regarding the currently displayed page or the currently displayed state on the screen (such as the current step of a multi-step form) does not belong in the bloc, because it's part of the UI's efforts to present information in a friendly manner. Generally, all navigation is either manual (initiated by the user doing a certain action to go to a page), or automatic (fired by a bloc listener in the UI in response to a specific state change).
- Avoid as much as possible sending parameters directly to another page. Navigation parameters are exclusively for UI logic.
  > **Example**: When a page is displaying a list, and pressing on an item leads the user to another page showing details, it's permissible to send the id of the item that was pressed. This is because the item that's being shown is presentation logic (remember our throught experiment, where the list and the details could very well have been implemented in one page without changing the way the bloc works). However, it would not be acceptable to send information to the details page that is not present in the bloc.
- Events represent things that happen in the app in an abstract way; they don't say that a certain button was pressed, but rather that a certain use case has begun. In the same way, the state never contains information for specific widgets (like a "message for a modal"), but rather abstract data that the UI decides how to display to the user (e.g. an "error message" that the UI decides to display in a modal).

## Folder structure

- **(src)**
  - **business**
    - **business/infra**: Directory for all infrastructure, like the InteropBloc.
    - **business/{feature}**: Directory for a specific feature, containing blocs and any helper classes.
      - **business/{feature}/{feature}\_bloc.dart**: File for the bloc itself, its events and the state.
      - **business/{feature}/{usecases}.dart**: Any number of files with any number of functions for containing business rules that are too complex to comfortably fit in the main bloc's file. What exactly is contained in these files is left to the programmer's discretion; this reference architecture does not provide a standardized way of executing large amounts of business rules, as that is typically not required in an app.
