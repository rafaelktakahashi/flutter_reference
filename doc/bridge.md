# The Method Channel Bridge

One of the main things that this reference architecture showcases is the interop between native and Flutter code, mainly for using Flutter blocs in native code.

**Problem**: If you only ever follow ready-made Flutter tutorials for opening method channels, you may end up with a situation where too many method channels are open all the time, making them difficult to track and very hard to maintain, not to mention that code for using the method channel would be scattered in the application, in places where that kind of logic does not belong.

![Bridge, image 1 of 3](<img/arq-app-flutter-hybrid-architecture-Shared%20Channel%20(1%20of%203).drawio.png>)

One clear improvement would be to add one class on each side of the bridge (in native code and in Flutter) to encapsulate the logic of creating the method channels and sending/receiving messages. We can use these classes as an opportunity to share a single method channel.

![Bridge, image 2 of 3](<img/arq-app-flutter-hybrid-architecture-Shared%20Channel%20(2%20of%203).drawio.png>)

This is also an improvement in a different way, in that we're free to declare different method signatures that are more convenient to use than the ones provided by Flutter.

This added structure (which is still just one class in each platform) is what we call the bridge. It simplifies many steps in using the method channel:

- Initializing the bridge is only necessary once, at the start of the application. Compare this to using multiple method channels and having to provide the binary message to all of them.
- The method channel only allows for one single handler to be registered, but the bridge allows multiple handlers, each one registered by name. This is because the bridge registers its own handler, routing incoming calls to the handlers that were registered in the bridge.
- It is possible to register handlers in the bridge before it has been initialized. (Note, however, that the bridge will only be able to send and receive messages once it's initialized.)
- The API that the bridge exposes is more convenient to use, and can be changed according to our needs.

```dart
// InteropBloc.dart, initialization logic
// Our bridge exposes a simpler API than using the method channel directly.
bridge.registerHandler("sendEvent", _receiveMessage);
bridge.registerHandler("getCurrentState", (_) => stateToMessage(state));
...

void _receiveMessage(dynamic message) {
  ...
  // This method can return something that'll be sent to the other side of the bridge.
}
// etc
```

However, there's still something that we can improve. It's not good that every bloc and bloc adapter and repository and any other class that wants to use the bridge calls it directly. That's because any modifications in the bridge will result in an unbounded number of required changes in the code. Furthermore, we haven't solved the problem that each of these classes needs to repeat a similar logic for using the bridge.

> It is known that there are only three quantities: **0** (none), **1** (one) and **N** (many). If you're writing the same logic N times, that's a sign that something's wrong.

To avoid every new class from having to write its own code to use the bridge, we encapsulate that logic in superclasses. Those superclasses know how to use the bridge to expose functionalities to the other side. With that change, we reach the final structure of the method channel bridge.

![Bridge, image 3 of 3](<img/arq-app-flutter-hybrid-architecture-Shared%20Channel%20(3%20of%203).drawio.png>)

The `InteropBloc` class is the superclass of all blocs that want to be usable in native code; it encapsulates all interaction with the bridge, and each concrete bloc simply needs to extend from the InteropBloc and implement its abstract methods. There's an `InteropRepository` with the same purpose, and other superclasses can be added if necessary. What matters is that any change in the bridge only requires changes in these classes, not in all of the concrete implementations of blocs and repositories.

Another difference is that now we require each consumer of the bridge to open a port; this is a similar idea as in the method channel, and it means that the classes that use the bridge don't need to worry about method name collisions.

> A note about async code: Currently, only the Dart side of the bridge fully supports asynchronous methods. The Android side accepts Kotlin coroutines in handlers but not in the calls (simply because I couldn't get it to work), and the iOS side only supports async code in iOS13+.

The bridge itself lives in the files named "ChannelBridge" (or "channel_bridge" in Dart). The bridge eases the overhead of configuring method channels and exposes a simpler API.

![The bridge, completed](<img/arq-app-flutter-hybrid-architecture-Shared%20Channel%20(epilogue).drawio.png>)

Usage:

**In Dart**:

```dart
import "..." as bridge;
...
// Open a port
final weatherPort = bridge.openMethodChannelPort("WeatherRepository");

// Then use the port to send a call to native code
final forecast = await weatherPort.call("fetchWeatherForecast", args);
// Or register a handler to receive a call from native code
weatherPort.registerHandler("fetchWeatherForecast", () async {...});
```

**In Kotlin**:

```Kotlin
// Open a port
val weatherPort = MethodChannelBridge.openPort("WeatherRepository");

// Then use the port to send a call to Flutter
weatherPort.call(
  "fetchWeatherForecast", // name of the Flutter handler
  args, // arguments (Nullable)
  { logError(it) }, // error callback
  { handleResponse(it) } // success callback
)
// Or register a handler to receive a call from Flutter
weatherPort.registerHandler("fetchWeatherForecast") { handleCall(it) }
```

**In Swift**:

```swift
// Open a port
let weatherPort = MethodChannelBridge.openPort("WeatherRepository")

// Then use the port to send a call to Flutter
weatherPort.call(
  "fetchWeatherForecast",
  withArguments: args,
  onError: { exception in logError(exception) },
  onSuccess: { params in ... }
)
// Or register a handler to receive a call from Flutter
weatherPort.registerHandler("fetchWeatherForecast") { [weak self] params in ... }
```

The `call()` function's success callback is defined last in its parameters to allow using the trailing lambda (Kotlin) or trailing closure (Swift) syntax, where the callback is written after closing the brackets. A second reason is to encourage handling the error cases.

Note that when obtaining a port, it's not necessary to inform a binary messenger, because that'll have been done during initialization of the bridge.

## InteropBloc

The Flutter side of this reference architecture uses a typical structure with blocs, but it also demonstrates how a bloc can be used from native code.

The concrete blocs work like any normal bloc, thanks to all the bridge logic being centralized in the InteropBloc superclass. Technically it doesn't need the bridge (it would work just fine by directly opening method channels), but hopefully this architecture is sufficiently convincing of the advantages of having a bridge.

The following class diagram demonstrates everything you need to implement the InteropBloc in your own project, and of course you can find these classes in this repository:

![Interop bloc](img/arq-app-flutter-hybrid-architecture-Interop%20BLoCs.drawio.png)

There are two main principles in this structure:

1. Each Flutter bloc needs a corresponding Android adapter and an iOS adapter. Only blocs that wish to expose their functionlity to native code need to extend from `InteropBloc`, but all such blocs need a bloc adapter in native code.
2. Blocs (in Flutter) and adapters (in native code) don't even know about the bridge; all the bridge logic is encapsulated in the superclasses, which avoids changes in the bridge from spreading too far and requiring too much rework. This way, no matter how many blocs exist in the app, any change related to the bridge only needs to be made in three classes at most.

Again, not every bloc needs to extend from `InteropBloc`. That's only for blocs that need to expose their functionality to native code. One consequence of using the bridge is that an instance of the bloc and an instance of its adapter need to exist since initialization; that's solvable with a dependency injection library, but limits on-demand instantiation with factories.
