# View Layer

The main principle behind the view layer presented in this reference is the Atomic Design methodology; however, as is true for everything in this architecture, it is provided as a possible way of organizing code and should be adapted to your needs.

Under this methodology, every widget must be categorized under **one** of the following types:

- **atom**: The simplest component that cannot be decomposed, such as a button, a field or a label. These widgets are universal (they don't make references to domain entities), usable anywhere in the app, and not made for a specific purpose. Pages will rarely use atoms directly, but they may be present as components of other widgets very frequently. Atoms are thusly very flexible and should ideally adapt to any style and render under any constraints.

  > **Example**: An icon is an atom because it's not made of any other widgets. Often, atoms come from a separate library and we don't need to code our own. If a component from a library is used in the app, it's recommended to wrap it in an atom (or a molecule if appropriate).

- **molecule**: A component that groups atoms together with a certain objective, but not specifically for one use case. Molecules are independent of business, and therefore they must never be molded around a specific bloc. Unlike atoms, molecules are allowed to know about the domain, but that data must be received without being tied directly to a bloc. This makes a molecule reusable, even if its first implementation only appears in one place in the app. A molecule may be a fixed configuration of finitely many atoms, or it may be an unbounded list or table.

  > **Example**: A search bar with text input, buttons and a watermark is a molecule, because it groups atoms and gives them a purpose. (The analogy is not quite precise, because real-life molecules obviously don't have a "purpose", but ours do.) This search bar wouldn't be specifically made for one screen (because anything specific to the screen would be configurable), and in that way it can appear anywhere in the app, containing its own reusable logic.  
  > **Note**: Molecules are useful for reusing bits of logic, like validating a specific type of input. When that logic is reused this way, it stays "hidden" in a molecule. If you want to reuse logic from a molecule into another, consider making that logic itself a widget.

- **organism**: A higher-complexity widget that groups atoms and/or molecules together to fulfill a specific funcionality in the app's domain; that may be an entire "group" of components that are logically connected and work together on the screen, like a form. Organisms determine the layout of these groups, and will often be tailor-made for a specific functionality but must nonetheless be open for reuse in other places that want the same functionality.  
  The main difference between the "purpose" of a molecule and the "purpose" of an organism, is that the organism is aware of the app's business and explicitly provides a certain funcionality. _Organisms can connect to blocs_, and in that way they are one of the two connection points between the data layer and the business layer (the other one being the pages). Note that even though any business operations (events) are an organism's responsibility, anything related to routing and navigation should preferentially belong to the page.  
  Organisms are separated into subfolders, but that does not need to line up with the blocs or with the pages. Any organism can reference any bloc and appear in any page.

  > **Example**: A graph with buttons and inputs for changing its parameters is an organism; this organism would proably be made for one specific page, but it's conceivable that it could appear somewhere else. It provides a reasonably complete functionality by itself.

- **template**: The layout of a whole page, but independent of content. Typically used for abstracting the layout of a large number of pages that share the same layout.  
  It is possible for templates to be nested; for example, you may define a template for "a page with a header and a side menu", and inside that, another template could define the layout of "a column with content with a sidebar and a footer". Templates define all layout, while pages define content (content includes the organisms). However, keep in mind that a template never knows about navigation; that is the page's resposibility, and makes it so that a template can be freely reused in any page that needs the same layout.

  > **Example**: Popups and error pages are great candidates for being templates, since a large number of near-identical pages would be required otherwise. However, even something as simple as "two pieces of content side-by-side" can be a template. The template defines all layout and responsiveness.

- **page**: The page itself, which can be considered an instance of a template. Pages are closely related to routes: each route gets one page, and if many pages are very similar, then they should share a template. Pages create the _content_ (including organisms and sometimes molecules and even atoms) and pass them to a template, which organizes that content. Because pages create the content, they may need to have state and connect to the blocs.  
  Pages are separated into subfolders, because multiple pages may be part of one logical sequence in a use case. That organization is purely organizational, and any page can use any organism and any bloc.

> Warning: You should not write blocs that are specifically made for a page. More about this in other pages, but in principle any page and any organism can connect to any bloc.

![View layer](img/arq-app-flutter-hybrid-architecture-View%20Layer.drawio.png)

A few additional things to keep in mind:

- Atomic design purposefully leaves many implementation details open; as such, the principles and rules I've outlined in this section are my own interpretation, which you can adjust as you see fit. I hope that this can serve as a better starting point than just reading about the basics online.
- The router and the themes are additions of my own, but keeping the layout (in the templates) separate from styling (in the themes) is a practice that aligns well with Flutter's principles and that I recommend adopting even if you decide to follow a different methodology.

## Navigation

This example project uses go_router for navigation. Among other things, go_router lets us navigate using urls, which is convenient for interoperability, since native pages only need to send a url to the Flutter code (see the interop navigator). However, keep in mind that many of the principles laid down here are valid regardless of which navigation framework a project uses.

### Parameters

Generally speaking, passing parameters between pages should be avoided because it adds coupling between components of the same type. This principle also applies to other components: blocs shouldn't depend on other blocs, repositories shouldn't depend on other repositories and so on. There are very few components that can depend on others of the same type (molecules are one of those, but even then you should be careful to avoid too many nested widgets).

However, this principle is only a general guideline. One very common use case for passing parameters is when a page renders details about an item, specified by id. For example, a url for accessing an item's details may look like `/something/details/50`. In this case, the details page simply shows some data from the bloc.

The rule of thumb is that information about the business should not be passed between pages, but information that only affects view logic is fine.

> **Bad examples**:
>
> - Sending information about the current user to a page is bad, because it adds coupling in the form of an obligation to always send that information when we need to reach that specific page. The page should get that information from a bloc instead.
> - Suppose a modal page shows different content depending on the user, based on certain rules. Computing that in the previous page and rendering the modal page with a parameter is bad, because now you have business logic happening in the view layer. The rule should be computed in a bloc and exposed through a bloc state, which the modal page reads and interpret in order to show the correct content.
> - In a multi-page form, one page sending its data to the next is bad. A multi-page login process where one page sends its data to the next is also bad. In these cases, the pages are so tightly coupled that they behave like one page. It is better to keep the state of those multiple pages in a single bloc. Consider also building a single page that displays different children at different stages of a form.

> **Good examples**:
>
> - A page that receives a parameter to know which of a list of items to show details for; this page should read the list from a bloc, and the manner in which it displays information is view logic.
> - Sending redirect parameters (for example, to a login page that needs to direct the user to a certain page after a successful login) is fine, because routing and navigation is view logic. Be careful about the separate logic of which pages the user is allowed to see based on bloc states.

### Initialization

In many frameworks, it's common to run initialization logic in the page itself. Android activities, React Native components and others all have a lifecycle that lets you define what happens when the component is created, or when it's loaded.

However, Flutter widgets generally do not have a lifecycle; StatelessWidgets work as if they were functions that don't do anything special the first time they run, and StatefulWidgets only have a lifecycle in their State. Even though it's possible to put initialization logic in the State's constructor, it may not be worth it to make a widget stateful just for initialization logic, and that adds unpredictability when testing the widgets. The practice is not forbidden, but it should be avoided because there are more idiomatic ways to implement initialization. (Note that certain initialization logic really does belong in a state, but only when it's purely related to view logic, such as the open/closed state of cards.)

The initialiation logic of pages should be written in a bloc when it consists of business logic. The initialization logic in a bloc should not be triggered by the bloc itself, but rather it should run in response to events. A good place to emit initialiation events is in the page's route. An example is provided in this project, when navigating to any page containing a list.

1. Navigating to a url is done without any additional logic. For example, simply call `push('/destination');`.
2. The router emits any necessary events to the relevant bloc, for example emitting an event that starts a request.
3. The destination page assumes that the necessary events have already been sent, and simply reflects the bloc's state.

> Note: This means that the router's logic will run every time the page is called. You can and should implement logic for avoiding redundant requests in your bloc. See the product list bloc for an example of this, where a flag named `skipIfAlreadyLoaded` is included in the event.

It is also possible (although less recommended) to place initialization logic in the page that does the navigation.

1. When navigating to a url, you also send all the necessary events, for example emitting an event that starts a request. In this case, it's generally recommended to send the events _first_, then navigate.
2. The destination page assumes that the necessary events have already been sent, and simply reflects the bloc's state.

This is less recommended because each page that navigates to a certain page has to know how to initialize it using the correct events sent to the correct bloc. Sometimes you may want exactly this, the ability to run different logic before navigating, but usually that's not the case and it's better to emit the events in the router.

Note that in both options, the destination page assumes that all events have already been sent and that the bloc is already doing the necessary work. This means the widgets can be StatelessWidgets, and there's no necessity to use States just for initialization.  
Each page should simply reflect the bloc's state, sometimes receiving parameters in its constructor.

In rare cases, a bloc needs to be initialized at the start of the application. See the `settings_bloc.dart` for an example. In these cases, the initialization also happens through an event, but the event is emitted once during the app's setup.

### Interop

Interoperability between native pages and Flutter pages is possible. The interop navigator in this project offers an example, and can be found in `interop_navigator.dart`, `InteropNavigator.swift` and `InteropNavigator.kt`. They use the bridge to send the required information to the other side of the bridge.

In our interop navigator, the advantages of using url-based navigation become apparent, as the information that's necessary to be sent through the bridge is very simple.

The native classes (in Android and iOS) that let you interact with the Flutter engine also provide some methods to set routes, but those are less powerful than our interop navigator. Specifically, one valuable capacity of the interop navigator is being able to navigate with any method, including with named replaces that properly respect page transitions.

### Redirection

Redirection is logic for changing the destination page based on some rule. For example, when `push('/map')` is called, there may exist some rule to show the page at `'/map/tutorial'` the first time that route is used. You may also want to show a certain modal page on top of the original destination. In any case, this project demonstrates three possible ways to implement redirection, each with its own advantages and disadvantages.

1. Put all logic in the widget that's calling the navigation.  
   The widget that calls the navigation can also run extra logic to decide where to send the user, or if an extra page needs to be pushed, an so on. It is the easiest way to implement redirection logic, but also the least reusable, because the code needs to be replicated in all the places that use that route.  
   It's true that you can extract the code to a separate function to reuse it, but navigating to that route from native code is still difficult.  
   Still, if that specific navigation doesn't need to be reusable, this option is very easy to implement and gives you a lot of freedom for which pages to push. Notably, it's possible to push multiple pages at once.
2. Use a router redirect.  
   The router can have its own redirection logic to replace a certain route with a different one based on your own custom logic. One major weakness of this approach is that it can't push multiple pages at once, but otherwise it's a good option to reuse code. Native pages can navigate to a certain url without also implementing the necessary redirection logic.
3. Use navigation cases.  
   This project presents its own solution for redirection and other kinds of complicated routing that depends on rules and bloc states. Navigation cases are functions registered using a provider, that can be referenced by name and can use the build context to push, pop, reset and do other navigation operations. This option is independent of the navigation framework that the project uses. Its main disadvantage is that it requires more code and doesn't handle url parameters if you don't implement them by hand.

For all these options, check the `redirect_pages.dart` file for more details.

## Themes

Developers used to other frameworks may expect to write styling and layout in the same place, as is often the case with CSS and styling frameworks based on CSS. However, in Flutter we always keep styling separate from layout.

Styles (for example colors, transparency, borders and fonts) are determined by the currently applied theme data. The `theme_data.dart` file has an example of how you can set up different styles to be used in different pages, for example in the map at `map_page.dart`.

On the other hand, layout (such as padding, borders and all placement and positioning of visual components) is done with widgets. Though a web developer may be used to applying padding together with colors using css, in Flutter we use a Padding widget. Layout logic is contained in the molecules, organisms and templates.

Note that at the top level of the atomic structure, pages provide style and templates provide layout. Organism and smaller components are allowed to contain their own layout logic that is internal to them, and even styles when they're independent of the app's style, but generally they should be as open as possible to configuration:

- Whenever possible, an organism or smaller component should properly react to changes in the current style. This means they should take their colors, fonts, etc. from the current theme instead of ever hardcoding them. Atoms and molecules can also accept style properties to delegate styling to the parent widget.
- Whenever possible, an organism or smaller component should not make assumptions about the parent widget's layout, and should work well as a child of a scrollview, column, aligned, and any other layout widget. Widgets do not make decisions about the constraints imposed on them.

## Folder structure

- **(src)**
  - **view**
    - **UI**
      - **themes**: Theme objects and also the color palette. Only pages can make references to themes.
      - **atoms**: Atoms should avoid referencing other widgets. If necessary, references should be limited to other atoms. Any widget can use atoms directly, but big jumps (ex.: pages using atoms) should be avoided.
      - **molecules**: Molecules that may be directly referenced in a template/page or used in organisms. Molecules can make references to domain entities.
      - **organisms**: Organisms that are typically used in one template/page, but are reusable nonetheless. _Separated into subfolders_. Organisms can make references to domain entities and to blocs.
    - **templates**: Templates for pages that share a visual structure. Templates can only reference other templates and widgets in the UI folder.
    - **pages**: Widgets for one entire screen, optionally using a template. _Separated into subfolders_. Pages are responsible for providing content (widgets) to templates, handling navigation logic and setting the theme.
