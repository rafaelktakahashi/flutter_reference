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

## Folder structure

- **(src)**
  - **view**
    - **UI**
      - **themes**: Theme objects and also the color palette. These can be referenced from any widget.
      - **atoms**: Widgets outside of the UI folder should avoid using atoms directly, but that's not strictly forbidden.
      - **molecules**: Molecules that may be directly referenced in a template/page or used in organisms.
      - **organisms**: Organisms that are typically used in one template/page, but are reusable nonetheless. *Separated into subfolders*.
    - **templates**: Templates for pages that share a visual structure.
    - **pages**: Widgets for one entire screen, optionally using a template. *Separated into subfolders*.
