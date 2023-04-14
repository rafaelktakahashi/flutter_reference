# Data Layer

The data layer contains all logic for _services_ that interfact with APIs that are external to our code, which includes external remote APIs, system APIs and possibly some utility libraries.

## Structure

The main structure of this reference architecture's data layer is the separation of its classes in three types of services:

1. **Repositories**, which expose low-level data and functionality for a feature. Each repository uses one or more data sources and APIs, providing a class that the bloc can use without concern for which low-level operations are required.
2. **Clients**, which interact with remote APIs. When an app uses multiple remote APIs, each one has its own client.  
   Blocs don't use client directly; they only do so through the repositories. Each repository decides how to carry out an operation, and that may be through a client.  
   Each client should be as self-contained as possible, not requiring extensive knowledge to use it. Any initialization logic for each client should also be as self-contained as possible.
   ![Data layer](img/arq-app-flutter-hybrid-architecture-Data%20Layer.drawio.png)

An example is provided in this reference architecture for a repository that needs to reference another that exists in native code. By using the bridge, repositories in native code and in Flutter can obtain data from one another, and while it's generally unadvisable to add coupling between repositories, in this case we allow a repository's implementation to be backed by another on the other side of the bridge.
![Repository call stack](img/arq-app-flutter-hybrid-architecture-Repository%20Call%20Stack.drawio.png)

## Method signatures

This reference architecture uses `Either`s for the return types, and that's advisable for all repositories. This means that every operation does not return a `Future<Entity>`, but a `Future<Either<Error, Entity>>`. When a return does not exist (when the method would normally return void), use a `Unit`. Both `Either` and `Unit` and from the [dartz](https://pub.dev/packages/dartz) library.

It is not required to enforce specific method signatures. One may imagine that a generic repository interface could enforce add(), update(), delete() methods and so on with their own predefined inputs and outputs, but that ceases to be useful once we need any other kind of operation.  
It is for that reason that we don't enforce interfaces for repositories. A repository may require any parameters and return any entity, as long as its methods make sense on their own (a repository should be a sensible piece of code on its own).

## Folder structure

- **(src)**
  - **data**:
    - **data/repository**: Repositories, which can be referenced by any bloc. Classes in this folder can reference anything else in the data layer, but should not access APIs directly, be them remote or OS APIs.
    - **data/client**: Clients that reach remote services; blocs should not reference these classes directly (use repositories instead), and these classes can only reference ones in the service folder.
    - **data/service**: Classes that provide either (1) OS funcionality or (2) utility functions such as calculations that are not part of the business.
