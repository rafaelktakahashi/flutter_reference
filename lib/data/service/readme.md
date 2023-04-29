## Services

These are the data layer's services.

The main purpose of services is to encapsulate operations related to the System API. That's different from repositories, which encapsulate operations related to external APIs.

In many other architectures, there's no difference between these two types of components; you'll often see only one type of repository, which may get its data from a database, or a remote API, or local memory, or a local computation, or any combination of those.

However, in mobile development, the System API has a more important status than in backend applications because it interacts with the physical device in the user's hands. Things like persistent memory, network, screen information (size, dpi, etc), biometric authentication, etc, deserve a higher status than just being a certain kind of repository because specific system funcionality is often part of the app's business rules.

For this reason, blocs can access these services directly in order to execute operations related to the physical device.

Mobile development is somewhat unique in that most of the code is aware that it's running on a particular operating system, and needs to take advantage of that fact. For that reason, in some cases widgets are also allowed to access a service directly, skipping the business layer. _However_, you should be aware that in almost all cases where you want to access a service from a widget, there's a better way of doing that through a bloc instead, or through a Widget that is aware of the System API (ex.: The SafeArea widget), and both those options are preferrable.

In some cases, a service may not need to access any API at all, for example a service that provides ids or other data according to some rule. It is permissible to create services for logic that is complicated enough to deserve its own file, but not related to business rules.

> A further note on terminology: A "service" denotes a different kind of component altogether in certain other architectures, but in mobile and frontend development, a "service" is typically a data layer component very similar to a repository (we don't often have both in the same project). In this sense, "services" and "repositories" wrap data providers and also include additional logic for processing the data.
