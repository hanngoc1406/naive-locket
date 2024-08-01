//
//  PhotoPicker.swift
//  LocketUploader
//
//  Created by Phan Đức on 30/7/24.
//

import UIKit
import SwiftUI
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
   
   @Environment(\.presentationMode) private var presentationMode
   var sourceType: UIImagePickerController.SourceType = .photoLibrary
   @Binding var selectedImage: UIImage?
   @Binding var selectedVideo: URL?
   @Binding var mediaType: String?
   
   func makeUIViewController(context: Context) -> UIImagePickerController {
      let photoPicker = UIImagePickerController()
      photoPicker.allowsEditing = false
      photoPicker.sourceType = sourceType
      photoPicker.allowsEditing = true
      photoPicker.mediaTypes = ["public.image", "public.movie"]
      photoPicker.delegate = context.coordinator
      
      return photoPicker
   }
   
   func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
      
   }
   
   func makeCoordinator() -> Coordinator {
      Coordinator(self)
   }
   
   final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
      
      var parent: PhotoPicker
      
      init(_ parent: PhotoPicker) {
         self.parent = parent
      }
      
      func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         
         if let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String {
            parent.mediaType = mediaType
            
            if mediaType == UTType.movie.identifier {
               parent.selectedVideo = info[UIImagePickerController.InfoKey.mediaURL] as? URL
            } else {
               if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                  parent.selectedImage = image
               }
            }
         }
         
         parent.presentationMode.wrappedValue.dismiss()
      }
      
   }
}
