# Domain

The domain folder isn't a "layer", but rather a part of the application's language and protocols.

In certain architectures, like MVVM, the domain is explicitly part of the business logic. Not so here, where all our domain entities are strictly data classes. This is very common in this sort of reactive architecture that incorporates elements of functional programming, as opposed to more traditional object-oriented approaches where the classes contain behavior.

The domain layer is unique in that it's accessible from anywhere in the application.

## Entities

Entities represent concepts in the business domain. Unlike in Java (but like in Python and Kotlin, and who knows in C#), it is acceptable and actually an encouraged practice to place multiple classes in one file, as long as they are logically related.

Avoid making a class that mirrors the domain of some API; it should primarily correspond to what the app needs, and should not include technical limitations from other systems. Possible mappings between the app's domain and other APIs can be handled in the clients using DTOs.

## Error

This reference architecture recommends a superclass for all errors throwable in the application. Its purpose is to minimize unknown errors, and encourage everything to always be handled. Note that regardless of having such a superclass or not, the bloc must always handle any errors in everything it does, such that errors are never exposed to the UI through exceptions, but through the state.

## Freezed

It is recommended to use the freezed package in all domain entities, to automatically obtain utility methods such as `copyWith(...)`. The serialization methods are especially useful for when native interop through the bridge is required.

## Folder structure

- **(src)**
  - **domain**:
    - **domain/entity**
    - **domain/error**
    - **domain/constant**: Directory for any constants in the app, such as urls (but don't include API secrets in your app); may include message strings for apps with internationalization.
