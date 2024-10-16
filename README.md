# newsapp
by Edward Chan

## Getting Started

To install the app, clone the repository onto your computer and launch the file in VSCode or an IDE of your choice.
Launch the IOS simulator on your device and connect your IDE to the simulator.

In the terminal, type these commands:
  flutter clean
  flutter pub get
  flutter run

********
On my computer, I ran into an issue where a file called StorageError.swift had a syntax issue and prevented me from running the app.
This file is automatically loaded when you run "flutter run." If you run into this issue, you can launch the app by going to 
the folder location (ios -> Pods -> FirebaseStorage -> FirebaseStorage -> Sources -> StorageError.swift) and replacing it with
the StorageError.swift file that I provided in the repository. Then re-run "flutter run" and the app should launch.
********

Upon entering the app, users are presented with a login page. They can click "Register Here" to register their account. After a use is logged in/registered,
they're taken to a homepage where they can see recent posts. The posts are displayed by recency, so the latest posts are at the top. Users can open a sidebar
where they can view their profile and edit their bio.

Currently, users are able to delete posts that aren't their own, but this is something I plan to fix. Users are able to like and unlike posts by clicking on
the like button for each post. The like count is stored locally and persists even after refreshing the app in the simulator. However, if you restart the simulator
session from your IDE (by running "flutter run"), the likes for each post will be lost.

For my state management, I chose to use the Bloc library, which is a design pattern that separates the business logic from the user interface (UI) 
by using streams to manage state. BLoC lets you build applications while ensuring that UI components don't directly depend on business logic and vice versa.

  How BLoC Works:
  Event: Represents an action triggered by the user (e.g., button press, API call).
  State: Represents the current state of the application (e.g., loading, success, or error).
  BLoC: Acts as a middleman that receives events and maps them to states.

I used Bloc to handle my authentication and for almost every feature in my app.

