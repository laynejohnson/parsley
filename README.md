#  Parsley

### iOS todo app with optional Core Data || Realm database setups.

<img src="Parsley/Assets.xcassets/parsley_logo.imageset/parsley_logo.png" alt="Parsley Todo App Icon" width="150" height="150"/>

### **🌱 To Run App :** 
- Run `pod install` inside project directory. (CocoaPods required)
- `open parsley.xcworkspace` in Terminal to open app in XCode.

### **Database Options :**

#### **Realm (Default) :**

- Models: `Models` > `Realm`
- Controllers : `Controllers` > `Realm`

#### **Core Data :**

- Model : `Models` > `Core Data`
- Controllers : `Controllers` > `Core Data`

** For Core Data setup: use Core Data controllers in `Controllers` > `Core Data`. Set `ListViewController.swift` & `TodoViewController.swift` custom classes in `Views` > `Main.storyboard`. Use `Parsley.xcdatamodeld` data model.
