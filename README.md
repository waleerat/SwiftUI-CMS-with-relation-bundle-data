# SwiftUI-CMS-with-relation-bundle-data

 
### Xcode Version 13.0
###### SwiftUI, Firebase, Relation collection
 
The sample CMS for profile with multiple skills. 

## Screenshots
<img src="https://raw.githubusercontent.com/waleerat/GitHub-Photos-Shared/main/SwiftUI-CMS-with-relation-bundle-data/01.png" width="20%" height="20%"> |
<img src="https://raw.githubusercontent.com/waleerat/GitHub-Photos-Shared/main/SwiftUI-CMS-with-relation-bundle-data/02.png"  width="20%" height="20%"> |
<img src="https://raw.githubusercontent.com/waleerat/GitHub-Photos-Shared/main/SwiftUI-CMS-with-relation-bundle-data/03.png"  width="20%" height="20%"> 



## How to setup project
1. Clone project to your Mac
2. Setup firebase  [See](https://firebase.google.com/docs/ios/setup)
3. Enable Firebase and Firestore [See](https://console.firebase.google.com/)
4. import your own GoogleService-Info.plist to the project
5. run pod install in Terminal

```sh
 run pod install
```
5.  Close project and open again
 <img src="https://raw.githubusercontent.com/waleerat/GitHub-Photos-Shared/main/SwiftUI-CMS-with-relation-bundle-data/04.png"  width="50%" height="50%">




# Models

```sh
struct SkillModel: Identifiable, Hashable {
    var id: String
    var name: String
}

struct ProfileModel: Identifiable, Hashable {
    var id: String
    var name: String
    var imageURL: String
}

struct ProfileBundleModel: Identifiable {
    var id: String
    var profileId: String
    var skillId: String
}

struct ProfileViewModel: Identifiable, Hashable {
    var id: String
    var name: String
    var imageURL: String
    var skills: [SkillModel]
}

```

## Check these files

#### SwiftUI_CMS_with_relation_bundle_dataApp.swift

if you want to separate to difference Firebase for development and production so you can use this code otherwise you can just use `FirebaseApp.configure()`

```sh
    private func setupFirebaseApp() {
        
       guard let plistPath = Bundle.main.path(
        forResource: "GoogleService-Info", ofType: "plist"),
             let options =  FirebaseOptions(contentsOfFile: plistPath)
                      else { return }
        
          if FirebaseApp.app() == nil{
              FirebaseApp.configure(options: options)
          }
    }
```

Example for Config 2 difference Firebase.


```sh
     private func setupFirebaseApp() {
        #if DEBUG
            let kGoogleServiceInfoFileName = "DEVELOPMENT-GoogleService-Info"
        #else
            let kGoogleServiceInfoFileName = "GoogleService-Info"
        #endif
        
       guard let plistPath = Bundle.main.path(
        forResource: kGoogleServiceInfoFileName, ofType: "plist"),
             let options =  FirebaseOptions(contentsOfFile: plistPath)
                      else { return }
        
          if FirebaseApp.app() == nil{
              FirebaseApp.configure(options: options)
          }
    }
```

#### Constants.swift 

The constants values for foreground and background color. 

 ```sh
 public let kForeground: String = "foreground"
 public let kBackground: String = "background"
 ```
  
#### FCollectionReference.swift
Collections for firebase

```sh
enum FCollectionReference: String {
    case Skill = "pia_skill"
    case SkillBundle = "pia_skillBundle"
    case Profile = "pia_profile" 
} 


func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    
    return Firestore.firestore().collection(collectionReference.rawValue)
} 
```
  
How to use :


```sh
FirebaseReference(.Profile).document(objectId).delete() { error in }
```


#### If you can't run project

> Note: `The project at ‘/Users/lia/Documents/MVVM-and-Design-Pattern/MVVM-and-Design-Pattern.xcodeproj’ cannot be opened because it is in a future Xcode project file format. Adjust the project format using a compatible version of Xcode to allow it to be opened by this version of Xcode.` 
