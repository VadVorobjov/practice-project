
# Welcome :wave:

This is my personal practise project, that can ==highlighting== some of my knowledge in TDD, Design Patterns/SOLID, Swift.

:warning: This project still has development iterations, that are focused to do changes in:
 - logic;
 - approach;
 - refactor.
 
Client part(ThriveApp: iOS, SwiftUI) is the rawest one.
Please, don't be suprised to see in some occasions something "unpolished".

## Walkthrough :paw_prints:

`Thrive` module was created as an independent framework target for the purpose to share(and not to couple) _Busines logic_, _Implementation_ and  _Infrastructure_ details across multiple platforms/clients: MacOS, iOS, WatchOS and etc.
Also, as `Thrive` framework runs on MacOS, tests run faster(no need for _Simulator_ being launched).

---
**Modular Design**
By fulfilling **DI - SOLID** principle our high-level modules don't depend on low-level modules(for ex. on SwiftUI).  More clearly visible on the diagram. [^Diagram]
- Command Feature Module
- Command API Module
- Command Store Module
- Command Presentation Module
- Command SwiftUI
---
**LSP** & **ISP** 
_CommandLoad, CommandSave, CommandDelete_ Interfaces are being segregated(and aggregated in _CommandSerialization_ for sake of need), to accomodate with **SOLID** principles.
**~example:~** `RemoteCommandLoader` implements only _CommandLoad_ interface.
**~example:~** `LocalCommandLoader` implements _CommandSerialization_ aggregation of interfaces.

---

**Command Store Module** has its own model of `Command` - `LocalCommand`. That provides:
- Emphasizes Module separation
- In case of a `Model` change in one of the Modules, we have a _"bridge"_  - a place where we can align with the changes even, in some cases, without modifying the second `Model`.

---

**Decorator** design pattern used in `LocalComandLoaderDecorator` to run completion blocks of _async_ operations on the main thread. (**Open/Close** SOLID principle being fullfilled).

[^Diagram]: Application's architecture.
![Fulfil-Page-4 drawio-3](https://github.com/VadVorobjov/practice-project/assets/13715822/7c691000-dcf4-4ee5-8903-2515246a73d0)
