//
//  SwiftUI_CMS_with_relation_bundle_dataApp.swift
//  SwiftUI-CMS-with-relation-bundle-data
//
//  Created by Waleerat Gottlieb on 2021-10-12.
//

import SwiftUI
import Firebase

@main
struct SwiftUI_CMS_with_relation_bundle_dataApp: App {
    init() {
       setupFirebaseApp()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    } 
   
    private func setupFirebaseApp() {
        let kGoogleServiceInfoFileName = "GoogleService-Info"
        
       guard let plistPath = Bundle.main.path(
        forResource: kGoogleServiceInfoFileName, ofType: "plist"),
             let options =  FirebaseOptions(contentsOfFile: plistPath)
                      else { return }
        
          if FirebaseApp.app() == nil{
              FirebaseApp.configure(options: options)
          }
    }
}
