//
//  AuthenState.swift
//  LocketUploader
//
//  Created by Phan Đức on 21/7/24.
//

import Foundation
import AuthenticationServices
import FirebaseAuth
import FirebaseCore

enum AuthState {
   case authenticated // Anonymously authenticated in Firebase.
   case signedIn // Authenticated in Firebase using one of service providers, and not anonymous.
   case signedOut // Not authenticated in Firebase.
}

@MainActor
class AuthManager: ObservableObject {
   @Published var user: User?
   @Published var authState = AuthState.signedOut
   
   /// 1.
   private var authStateHandle: AuthStateDidChangeListenerHandle!
   
   init() {
      // 3.
      configureAuthStateChanges()
   }
   
   // 2.
   func configureAuthStateChanges() {
      authStateHandle = Auth.auth().addStateDidChangeListener { auth, user in
         print("Auth changed: \(user != nil)")
         self.updateState(user: user)
      }
   }
   
   // 2.
   func removeAuthStateListener() {
      Auth.auth().removeStateDidChangeListener(authStateHandle)
   }
   
   // 4.
   func updateState(user: User?) {
      self.user = user
      let isAuthenticatedUser = user != nil
      let isAnonymous = user?.isAnonymous ?? false
      
      if isAuthenticatedUser {
         self.authState = isAnonymous ? .authenticated : .signedIn
      } else {
         self.authState = .signedOut
      }
   }
}
