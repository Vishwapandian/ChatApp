//
//  ProfileView.swift
//  ChatApp
//
//  Created by Vishwa Pandian on 12/31/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var shouldShowLogOutOptions = false
    
    @State var shouldNavigateToChatLogView = false
    
    @ObservedObject private var vm = MainMessagesViewModel()
    
    var body: some View {
        ZStack {
        VStack {
            HStack {
                Spacer()
                
                Button {
                    shouldShowLogOutOptions.toggle()
                } label: {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 24, weight: .bold))
                        //.foregroundColor(Color(red: 60 / 255, green: 100 / 255, blue: 104 / 255))
                        .foregroundColor(Color.black)
                }
                
            }
            .padding(.horizontal)
            
            
            VStack {
        HStack(spacing: 16) {
            
            
            WebImage(url: URL(string: vm.chatUser?.profileImageUrl ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 150)
                .clipped()
                .cornerRadius(500)
                .shadow(radius: 5)
            
            
            VStack(alignment: .leading, spacing: 4) {
                let firstName = vm.chatUser?.firstName ?? ""
                let lastName = vm.chatUser?.lastName ?? ""
                let email = vm.chatUser?.email.replacingOccurrences(of: "@gmail.com", with: "") ?? ""
                HStack {
                    
                    let name = firstName + " " + lastName
                    Text(name)
                }
                .font(.system(size: 24, weight: .bold))
                
                Text("@" + email)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color.gray)
                
                
            }
            
            Spacer()
            
            }
                let Bio = vm.chatUser?.bio ?? ""
                HStack {
                    VStack {
                        Text("Bio")
                            .foregroundColor(Color.gray)
                        Text(Bio)
                        
                    }
                    Spacer()
                }
                .padding()
                Spacer()
            }
            
        .padding()
        .actionSheet(isPresented: $shouldShowLogOutOptions) {
            .init(title: Text("Settings"), message: Text("What do you want to do?"), buttons: [
                .destructive(Text("Sign Out"), action: {
                    print("handle sign out")
                    vm.handleSignOut()
                }),
                    .cancel()
            ])
        }
        
        .fullScreenCover(isPresented: $vm.isUserCurrentlyLoggedOut, onDismiss: nil) {
            LoginView(didCompleteLoginProcess: {
                self.vm.isUserCurrentlyLoggedOut = false
                self.vm.fetchCurrentUser()
            })
        }
    }
      //here
            //CustomNavBar()
            
        }
        .background(
                LinearGradient(gradient: Gradient(colors: [Color(red: 229 / 255, green: 212 / 255, blue: 207 / 255), Color(red: 178 / 255, green: 191 / 255, blue: 199 / 255)]), startPoint: .topLeading, endPoint: .bottomTrailing)
            )
        
}
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
