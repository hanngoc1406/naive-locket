//
//  HomeView.swift
//  LocketUploader
//
//  Created by Phan Đức on 21/7/24.
//

import SwiftUI
import Kingfisher
import UniformTypeIdentifiers
import AVFoundation
import _AVKit_SwiftUI

struct HomeView: View {
   
   @EnvironmentObject var authManager: AuthViewModel
   @FocusState var isInputActive: Bool
   @Environment(\.colorScheme) var colorScheme
   
   @State var showingImagePicker: Bool = false
   @State var showingLoading: Bool = false
   @State private var selectedImage: UIImage?
   @State private var selectedVideo: URL?
   @State private var mediaType: String?
   @State var caption: String = ""
   @State private var alertItem: AlertItem?
   
   var body: some View {
      ZStack {
         VStack {
            
            HStack {
               HStack {
                  KFImage.url(authManager.user?.photoURL)
                     .resizable()
                     .placeholder({
                        Image("no_avatar")
                           .resizable()
                           .frame(width: 50, height: 50)
                           .scaledToFit()
                           .clipShape(Circle())
                     })
                     .frame(width: 50, height: 50)
                     .scaledToFit()
                     .clipShape(Circle())
                  
                  Text(authManager.user?.displayName ?? "")
                     .foregroundColor(colorScheme == .dark ? .white : .black)
               }
               
               Spacer()
               
               Button {
                  self.alertItem = AlertItem(title: Text("Thông báo"), message: Text("Bạn có chắc chắn muốn đăng xuất"), primaryButton: .destructive(Text("Đăng xuất"), action: {
                     authManager.logoutLocket()
                  }), secondaryButton: .cancel())
               } label: {
                  Image("logout")
                     .resizable()
                     .frame(width: 25, height: 25)
               }
               .padding(.trailing, 16)
            }
            .padding(.top, 32)
            
            Spacer()
            
            HStack {
               Text("Đăng ảnh lên Locket với caption dài hơn:")
                  .foregroundColor(colorScheme == .dark ? .white : .black)
               Spacer()
            }
            
            HStack {
               TextEditor(text: $caption)
                  .foregroundColor(colorScheme == .dark ? .white : .black)
                  .padding([.all], 8)
                  .multilineTextAlignment(.leading)
                  .lineLimit(100)
                  .submitLabel(.return)
                  .frame(height: 250)
                  .focused($isInputActive)
                  .toolbar {
                     ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        
                        Button("Done") {
                           isInputActive = false
                        }
                     }
                  }
            }
            .overlay(
               RoundedRectangle(cornerRadius: 10)
                  .stroke(colorScheme == .dark ? .white : .black, lineWidth: 0.5)
            )
            
            Button(action: {
               showingImagePicker.toggle()
            }, label: {
               HStack {
                  if let mediaType = mediaType {
                     if mediaType == UTType.movie.identifier {
                        if let selectedVideos = selectedVideo {
                           VideoPlayer(player: AVPlayer(url: selectedVideos))
                              .frame(width: 80, height: 80)
                              .cornerRadius(10)
                              .onAppear() {
                                 AVPlayer().play()
                              }
                              .overlay(
                                 Button(action: {
                                    selectedVideo = nil
                                 }, label: {
                                    Image("remove_image")
                                       .resizable()
                                       .frame(width: 20, height: 20)
                                 }).padding([.top, .trailing], -7)
                                 , alignment: .topTrailing
                              )
                        }
                     } else {
                        if let selectedImages = selectedImage {
                           Image(uiImage: selectedImages)
                              .resizable()
                              .aspectRatio(contentMode: .fill)
                              .frame(width: 80, height: 80)
                              .cornerRadius(10)
                              .overlay(
                                 Button(action: {
                                    selectedImage = nil
                                 }, label: {
                                    Image("remove_image")
                                       .resizable()
                                       .frame(width: 20, height: 20)
                                 }).padding([.top, .trailing], -7)
                                 , alignment: .topTrailing
                              )
                        }
                     }
                  } else {
                     Image("add_image")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                  }
                  
                  Text("Chọn ảnh hoặc video từ thư viện")
                     .foregroundColor(colorScheme == .dark ? .white : .black)
                  
                  Spacer()
               }
            })
            .padding([.top, .bottom], 16)
            
            Button(action: {
               if let mediaType = mediaType {
                  showingLoading = true
                  
                  if mediaType == UTType.movie.identifier {
                     authManager.uploadVideo(selectedVideo!, authManager.user?.uid ?? "", cap: caption) {
                        showingLoading = false
                        self.alertItem = AlertItem(message: Text("Upload video thành công! Hãy mở locket để xem ảnh."), secondaryButton: .default(Text("Oke"), action: {
                           selectedVideo = nil
                           self.mediaType = nil
                           caption = ""
                        }))
                     }
                  } else {
                     authManager.uploadImage(selectedImage!, authManager.user?.uid ?? "", cap: caption, completion: {
                        showingLoading = false
                        self.alertItem = AlertItem(message: Text("Upload ảnh thành công! Hãy mở locket để xem ảnh."), secondaryButton: .default(Text("Oke"), action: {
                           selectedImage = nil
                           self.mediaType = nil
                           caption = ""
                        }))
                     })
                  }
               } else {
                  self.alertItem = AlertItem(message: Text("Vui lòng chọn ảnh hoặc video muốn upload!"))
               }
            }, label: {
               HStack {
                  Spacer()
                  Text("Đăng ảnh lên Locket!")
                     .foregroundColor(.white)
                     .padding([.bottom, .top], 16)
                  Spacer()
               }
               .background(.blue)
               .cornerRadius(10)
            })
            
            Text("©2024 Anh em hội bia 6789 🍻")
               .foregroundColor(colorScheme == .dark ? .white : .black)
               .padding(.top, 16)
            
            Spacer()
         }
         .padding(.leading, 16)
         .padding(.trailing, 16)
         .sheet(isPresented: $showingImagePicker) {
            PhotoPicker(selectedImage: $selectedImage, selectedVideo: $selectedVideo, mediaType: $mediaType)
         }
         .alert(item: $alertItem) { item in
            if let primaryButton = item.primaryButton {
               Alert(title: item.title, message: item.message, primaryButton: primaryButton, secondaryButton: item.secondaryButton)
            } else {
               Alert(title: item.title, message: item.message, dismissButton: item.secondaryButton)
            }
         }
         .allowsHitTesting(showingLoading ? false : true)
         
         if showingLoading {
            ActivityIndicator()
               .frame(width: 50, height: 50)
               .foregroundColor(colorScheme == .dark ? .white : .black)
         }
      }
   }
}

#Preview {
   HomeView()
}
