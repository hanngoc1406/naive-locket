//
//  LocketUploaderApp.swift
//  LocketUploader
//
//  Created by Phan Đức on 21/7/24.
//

import SwiftUI
import FirebaseCore

@main
struct LocketUploaderApp: App {
   
   // 1. Add StateObject authManager.
   @StateObject var authManager = AuthViewModel()
   
   init() {
      // register app delegate for Firebase setup
      initFirebase()
   }
   
   var body: some Scene {
      WindowGroup {
         ContentView()
            .environmentObject(authManager)
      }
   }
}

extension LocketUploaderApp {
   func initFirebase() {
      FirebaseApp.configure()
   }
}
