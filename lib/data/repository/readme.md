## Repositories

Repositories encapsulate data. Reading data, writing data, updating data, and so on.

In mobile development, repositories aren't everything in the data layer. There are also services that expose functionality, especially through the System API. Repositories are reserved for data.

Repositories "hide" the source of data, so that the blocs don't have to be aware of the source. The source may even be in native code (accessible through the InteropRepository).

### A note on interfaces

It is generally considered good practice to use interfaces [citation needed]. Interfaces decouple dependencies and allow for easily switching the implementation of components.

However, modern mobile frameworks tend to use interfaces to a lesser extent, since many of the advantages that one would get in a traditional backend application simply don't apply.
- Switching implementations on the fly (e.g. by replacing .jar files) is not a thing in apps, since the whole code must be compiled into a binary and shipped to the store.
- Writing interfaces to enable the construction of mocks is not necessary, since any Dart class can already be used as if it were an interface. This also means that dependency injection does not necessarily require interfaces, and any class can be converted into an interface without changing its usage.

In short, this means that writing interfaces is not required and blocs can refer to repositories directly. However, it is still recommended to use a dependency-injection library to obtain the instances, or receive them in the class' constructor.
