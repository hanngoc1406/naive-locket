//
//  LoginViewModel.swift
//  LocketUploader
//
//  Created by Phan Đức on 21/7/24.
//

import UIKit
import SwiftUI
import Foundation
import AVFoundation
import FirebaseAuth
import FirebaseStorage
import UniformTypeIdentifiers

struct AlertItem: Identifiable {
   var id = UUID()
   var title: Text = Text("Thông báo")
   var message: Text?
   var primaryButton: Alert.Button?
   var secondaryButton: Alert.Button = .cancel()
}

class AuthViewModel: ObservableObject {
   
   enum SignInState {
      case signedIn
      case signedOut
   }
   
   @Published var state: SignInState = .signedOut
   @Published var user: User?
   @Published var url: String = ""
   @Published var idToken: String = ""
   
   init() {
      Auth.auth().addStateDidChangeListener() { auth, user in
         if user != nil {
            self.state = .signedIn
            self.user = user
            
            user?.getIDToken(completion: { token, error in
               if let token = token {
                  self.idToken = token
               }
            })
         } else {
            self.state = .signedOut
            print("Auth state changed, is signed out")
         }
      }
   }
   
   func loginToLocket(_ email: String, _ password: String) {
      LocketServices.login(email: email, password: password) { result in
         self.user = result?.user
         self.state = .signedIn
      }
   }
   
   func logoutLocket() {
      LocketServices.logout {
         self.state = .signedOut
      }
   }
   
   func uploadImage(_ img: UIImage, _ userId: String, cap: String, completion: @escaping(() -> Void)) {
      LocketServices.uploadImage(image: img, userId: userId) { urlString, success in
         if success {
            LocketServices.postImage(urlString, cap, completion: { succ in
               if succ {
                  completion()
               } else {
                  print("Lỗi!!!")
               }
            })
            
         }
      }
   }
   
   func uploadVideo(_ video: URL, _ userId: String, cap: String, completion: @escaping(() -> Void)) {
      let thumbnail = VideoHelper.generateThumbnail(path: video)
      
      LocketServices.uploadVideo(video: video, thumbnail: thumbnail!, userId: userId) { urlString, thumbnail, succ  in
         print(urlString)
         if succ {
            LocketServices.postVideo2(urlString, thumbnail, cap, self.idToken, completion: { succ in
               if succ {
                  completion()
               } else {
                  print("Lỗi!!!")
               }
            })
         }
      }
   }
}
