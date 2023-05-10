# View Layer

The main principle behind the view layer presented in this reference is the Atomic Design methodology; however, as is true for everything in this architecture, it is provided as a possible way of organizing code and should be adapted to your needs.

Under this methodology, every widget must be categorized under **one** of the following types:

- **atom**: The simplest component that cannot be decomposed, such as a button, a field or a label. These widgets are universal, usable anywhere in the app, and not made for a specific purpose. Pages will rarely use atoms directly, but they may be present as components of other widgets very frequently.

  > **Example**: An icon is an atom because it's not made of any other widgets. Often, atoms from a separate library and we don't need to code our own. If a component from a library is used in the app, it's recommended to wrap it in an atom (or a molecule if appropriate).

- **molecule**: A component that groups atoms together with a certain objective, but not specifically for one use case. Molecules are independent of business, and thusly they must never be molded around a specific bloc. It is allowed for a molecule to _know about the domain_, but that data must be received without being tied directly to a bloc. This makes a molecule reusable, even if its first implementation only appears in one place in the app. A molecule may be a fixed configuration of finitely many atoms, or it may be an unbounded list or table.

  > **Example**: A search bar with text input, buttons and a watermark is a molecule, because it groups atoms and gives them a purpose. (The analogy is not quite precise, because real-life molecules obviously don't have a "purpose", but ours do.) This search bar wouldn't be specifically made for one screen (because anything specific to the screen would be configurable), and in that way it can appear anywhere in the app.

- **organism**: A higher-complexity widget that groups atoms and/or molecules together to fulfill a specific funcionality in the app's domain; that may be an entire "group" of components that are logically connected and work together on the screen, like a form. Organisms determine the layout of these groups, and will often be tailor-made for a specific functionality but must nonetheless be open for reuse in other places that want the same functionality.  
  The main difference between the "purpose" of a molecule and the "purpose" of an organism, is that the organism is aware of the app's business and explicitly provides a certain funcionality. _Organisms can connect to blocs_, and in that way they are one of the two connection points between the data layer and the business layer (the other one being the pages). Note that even though any business operations (events) are an organism's responsibility, anything related to routing and navigation should belong to the page.  
  Organisms are separated into subfolders, but that does not need to line up with the blocs or with the pages. Any organism can reference any bloc and appear in any page.

  > **Example**: A graph with buttons and inputs for changing its parameters is an organism; this organism would proably be made for one specific page, but it's conceivable that it could appear somewhere else. It provides a reasonably complete functionality by itself.

- **template**: The layout of a whole page, but still independent of data iself. Typically used for abstracting the layout of a large number of pages that share the same layout.  
  It is possible for templates to be nested; for example, you may define a template for "a page with a header and a side menu", and inside that, another template could define the layout of "a column with content with a sidebar and a footer". Templates define all layout, while pages define content (content includes the organisms). However, keep in mind tha a template never knows about navigation; that is the page's resposibility.

  > **Example**: Popups and error pages are great candidates for being templates, since a large number of near-identical pages would be required otherwise. However, even something as simple as "two pieces of content side-by-side" can be a template. The template defines all layout and responsiveness.

- **page**: The page itself, which can be considered an instance of a template. Pages are closely related to routes: each route gets one page, and if many pages are very similar, then they should share a template. Pages create the _content_ (including organisms and sometimes molecules and even atoms) and pass them to a template, which organizes that content. Because pages create the content, they may need to have state and connect to the blocs.  
  Pages are separated into subfolders, because multiple pages may be part of one logical sequence in a use case. That organization is purely organizational, and any page can use any organism and any bloc.

> Warning: You should not write blocs that are specifically made for a page or another. More about this in other pages, but in principle any page and any organism can connect to any bloc.

## Navigation

This example project uses go_router for navigation. Among other things, go_router lets us navigate using urls, which is convenient for interoperability, since native pages only need to send a url to the Flutter code (see the interop navigator). However, keep in mind that many of the principles laid down here are valid regardless of which navigation framework a project uses.

### Parameters

Generally speaking, passing parameters between pages should be avoided because it adds coupling between components of the same type. This principle also applies to other components: blocs shouldn't depend on other blocs, repositories shouldn't depend on other repositories and so on. There are very few components that can depend on others of the same type (molecules are one of those, but even then you should be careful to avoid too many nested widgets).

However, this principle is only a general guideline. One very common use case for passing parameters is when a page renders details about an item, specified by id. For example, a url for accessing an item's details may look like `/something/details/50`. In this case, the details page simply shows some data from the bloc.

### Initialization

In many frameworks, it's common to run initialization logic in the page itself. Android activities, React Native components and others all have a lifecycle that lets you define what happens when the component is created, or when it's loaded.

However, Flutter widgets generally do not have a lifecycle; StatelessWidgets work as if they were functions that don't do anything special the first time they run, and StatefulWidgets only have a lifecycle in their State. Even though it's possible to put initialization logic in the State's constructor, it may not be worth it to make a widget stateful just for initialization logic, and that adds unpredictability when testing the widgets. The practice is not forbidden, but it should be avoided because there are more idiomatic ways to implement initialization.

The most recommended option is to run initialization logic in the bloc, triggered by an event sent in the route. An example is provided in this project, when navigating to any page containing a list.

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

### Interop

Interoperability between native pages and Flutter pages is possible. The interop navigator in this project offers an example, and can be found in `interop_navigator.dart`, `InteropNavigator.swift` and `InteropNavigator.kt`. They use the bridge to send the required information to the other side of the bridge.

In our interop navigator, the advantages of using url-based navigation become apparent, as the information that's necessary to be sent through the bridge is very simple.

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

## Folder structure

- **(src)**
  - **view**
    - **UI**
      - **themes**: Theme objects and also the color palette. These can be referenced from any widget.
      - **atoms**: Widgets outside of the UI folder should avoid using atoms directly, but that's not strictly forbidden.
      - **molecules**: Molecules that may be directly referenced in a template/page or used in organisms.
      - **organisms**: Organisms that are typically used in one template/page, but are reusable nonetheless. _Separated into subfolders_.
    - **templates**: Templates for pages that share a visual structure.
    - **pages**: Widgets for one entire screen, optionally using a template. _Separated into subfolders_.
