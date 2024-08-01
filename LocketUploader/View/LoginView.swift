//
//  LoginView.swift
//  LocketUploader
//
//  Created by Phan Đức on 21/7/24.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
   
   @State var email: String = ""
   @State var passowrd: String = ""
   
   var vm = AuthViewModel()
   
   var body: some View {
      ZStack {
         VStack {
            
            Text("Hãy đăng nhập bằng tài khoản và mật khẩu Locket của bạn")
               .padding(.bottom, 30)
            
            HStack {
               TextField("Email", text: $email)
                  .padding(.leading, 16)
                  .padding(.trailing, 16)
                  .padding(.bottom, 16)
                  .padding(.top, 16)
            }
            .overlay(
               RoundedRectangle(cornerRadius: 10)
                  .stroke(.black, lineWidth: 0.2)
            )
            
            HStack {
               SecureField("Password", text: $passowrd)
                  .padding(.leading, 16)
                  .padding(.trailing, 16)
                  .padding(.bottom, 16)
                  .padding(.top, 16)
            }
            .overlay(
               RoundedRectangle(cornerRadius: 10)
                  .stroke(.black, lineWidth: 0.2)
            )
            
            Button(action: {
               vm.loginToLocket(email, passowrd)
            }, label: {
               HStack {
                  Spacer()
                  Text("Đăng nhập")
                     .foregroundColor(.white)
                     .padding([.bottom, .top], 16)
                  Spacer()
               }
               .background(.blue)
               .cornerRadius(10)
            })
         }
         .padding(.leading, 16)
         .padding(.trailing, 16)
      }
   }
}

#Preview {
   LoginView()
}
