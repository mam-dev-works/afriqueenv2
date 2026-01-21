About this project: 
Instruction that needs to be followed while doing this project. 

BLoC Usage
76 files with flutter_bloc imports
18 bloc files

GetX State Management
0 lines with GetX state management
0 files with GetxController

GetX Navigation
169 lines with GetX navigation

setState Usage
262 lines with setState => Reduce setState: When refactoring, move widget state to BLoC

In this project: 
BLoC is Primary used for state management for business logic and complex state
GetX is used Only for navigation (NOT for state management)
setState is used in Local widget state (way too much, should be reduced)

For new features: Always use BLoC

If a feature uses BLoC, don't add setState to it