//
//  AuthService.swift
//  LocketUploader
//
//  Created by Phan Đức on 21/7/24.
//

import UIKit
import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseFunctions

class LocketServices {
   static func login(email: String, password: String, completion: @escaping ((AuthDataResult?) -> ())) {
      Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
         if error != nil {
            print(error?.localizedDescription ?? "")
         } else {
            completion(result)
         }
      }
   }
   
   static func logout(completion: @escaping (() -> ())) {
      do {
         try Auth.auth().signOut()
         completion()
      }
      catch {
         print("already logged out")
      }
   }
   
   static func uploadImage(image: UIImage, userId: String, completion: @escaping(String, Bool) -> Void) {
      guard let imageData = image.jpegData(compressionQuality: 0.7) else {return}
      let uid = NSUUID().uuidString.lowercased()
      let fileName = "\(uid.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)).webp"
      let ref = Storage.storage().reference(withPath: "/users/\(userId)/moments/thumbnails/\(fileName)")
      
      ref.putData(imageData, metadata: nil) { metadata, error in
         if let error = error {
            print("Err: Failed to upload image \(error.localizedDescription)")
            completion("Lỗi!!!", false)
         }
         
         ref.downloadURL { url, error in
            guard let imageURL = url?.absoluteString else {return}
            print(imageURL)
            completion(imageURL, true)
         }
      }
   }
   
   static func uploadVideo(video: URL, thumbnail: UIImage, userId: String, completion: @escaping(String, String, Bool) -> Void) {
      let uid = NSUUID().uuidString.lowercased()
      let fileName = "\(uid.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)).mp4"
      let storage = Storage.storage(url: "gs://locket-video")
      let ref = storage.reference(withPath: "/users/\(userId)/moments/videos/\(fileName)")
      let metaData = StorageMetadata()
      metaData.contentType = "video/mp4"
      
      uploadImage(image: thumbnail, userId: userId) { thumbUrl, succ in
         if succ {
            do {
               let data = try Data(contentsOf: video)
               
               if let uploadData = data as Data? {
                  ref.putData(uploadData, metadata: metaData) { metadata, error in
                     if let error = error {
                        print("Err: Failed to upload image \(error.localizedDescription)")
                        return
                     }
                     
                     ref.downloadURL { url, error in
                        guard let video = url?.absoluteString else {return}
                        completion(video, thumbUrl, succ)
                     }
                  }
               }
            }catch let error {
               print(error.localizedDescription)
            }
         }
      }
   }
   
   static func postImage(_ thumbnailUrl: String, _ caption: String, completion: @escaping((Bool) -> Void)) {
      lazy var functions = Functions.functions()
      let req: [String: Any] = ["thumbnail_url": thumbnailUrl, "caption": caption]
      
      functions.httpsCallable(URL(string: "https://api.locketcamera.com/postMomentV2")!).call(req) { result, error in
         if let error = error as NSError? {
            print(error)
            completion(false)
         }
         
         if let data = result?.data as? [String: Any] {
            print(data)
            completion(true)
         }
      }
   }
   
   static func postVideo(_ videoUrl: String, _ thumbnailUrl: String, _ caption: String, completion: @escaping((Bool) -> Void)) {
      lazy var functions = Functions.functions()
      let req = VideoHelper.videoDataJson(videoUrl: videoUrl, thumbUrl: thumbnailUrl, caption: caption)
      
      functions.httpsCallable(URL(string: "https://api.locketcamera.com/postMomentV2")!).call(req) { result, error in
         if let error = error as NSError? {
            print(error)
            completion(false)
         }
         
         if let data = result?.data as? [String: Any] {
            print(data)
            completion(true)
         }
      }
   }   
   
   static func postVideo2(_ videoUrl: String, _ thumbnailUrl: String, _ caption: String, _ token: String, completion: @escaping((Bool) -> Void)) {
      let json = VideoHelper.videoDataJson(videoUrl: videoUrl, thumbUrl: thumbnailUrl, caption: caption)
      
      let url = URL(string: "https://api.locketcamera.com/postMomentV2")!
      
      var request = URLRequest(url: url)
      request.httpMethod = "POST"
      
      request.httpBody = json
      request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
      
      let task = URLSession.shared.dataTask(with: request) { data, response, error in
         guard let data = data, error == nil else {
            print(error?.localizedDescription ?? "No data")
            return
         }
         let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
         if let responseJSON = responseJSON as? [String: Any] {
            print(responseJSON)
            completion(true)
         } else {
            completion(false)
         }
      }
      
      task.resume()
   }
}

