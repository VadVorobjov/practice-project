**Hello there! ☕️☀️**

<br>
  
**Application's idea in short**: provide to user a possibility to create for a fulfillment **one** task(`Command`) per 24h 🕣  
- Whys and Hows it creates and provides value is a topic for a long discussion 🍻

<br>

**Project's & Code's Highlights**:
- 📦`Thrive` - is a separate module:
    - It contains business logic that is platform independent(can be used on iOS, iPadOS, MacOS, WatchOS);
    - It runs on Mac instead of Simulator - faster build & test runs;
    - Business logic behaviour is tested
        - In `Thrive > ThriveTests` you can find tests
          - **Unit Tests**
          - **Integration Tests** 
    - **LSP** applied - `CommandStore` can have multiple implementations without **breaking/changing** any other classes.
    - **ISP** applied:
       - `TaskStoreSpecs.swift` not all tests might need _Failable_ scenarios (such as in-memory implementation)
       - `CommandLoader`, `CommandSave`, `CommandDelete`:
         - Some implementations will use all the interfaces(ex. `LocalCommandLoaderDecorator`).  
         - Some only one(ex. in a case when on a pirtuclar _View_, we only need to load _history_ of created tasks(`Command`).

<br>

- 📱`ThriveApp` - is iOS implementation
    - **DI** - `SceneDelegate` acts as a _Composition Root_ and all the injections happening here
    - **SwiftUI** - by creating `View` a principle of a smaller components being applied(though refactoring of some `View` should be considered) for a better maintanability, readability and reusability.
    - **Navigation** - being extracted as separate and is not coupled with the the `View`.
<br>


**P.S.** these are few highlights, that, hopefully, bring some light 🙃

<br>

**Have a good day!** 👋
