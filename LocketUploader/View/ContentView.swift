//
//  ContentView.swift
//  LocketUploader
//
//  Created by Phan Đức on 21/7/24.
//

import SwiftUI

struct ContentView: View {
   
   @EnvironmentObject var authManager: AuthViewModel
   
    var body: some View {
       if authManager.state != .signedOut {
          HomeView()
       } else {
          LoginView()
       }
    }
}

#Preview {
    ContentView()
}
