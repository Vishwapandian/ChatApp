//
//  CreateNewMessageView.swift
//  ChatApp
//
//  Created by Vishwa Pandian on 12/29/21.
//

import SwiftUI
import SDWebImageSwiftUI

class CreateNewMessageViewModel: ObservableObject {
    
    @Published var users = [ChatUser]()
    @Published var errorMessage = ""
    
    init() {
        fetchAllUsers()
    }
    
    private func fetchAllUsers() {
        FirebaseManager.shared.firestore.collection("users")
            .getDocuments { documentsSnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to fetch users: \(error)"
                    print("Failed to fetch users: \(error)")
                    return
                }
                
                documentsSnapshot?.documents.forEach({ snapshot in
                    let data = snapshot.data()
                    let user = ChatUser(data: data)
                    if user.uid != FirebaseManager.shared.auth.currentUser?.uid {
                        self.users.append(.init(data: data))
                    }
                    
                })
            }
    }
}

extension View {
    /// Sets the text color for a navigation bar title.
    /// - Parameter color: Color the title should be
    ///
    /// Supports both regular and large titles.
    @available(iOS 14, *)
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        let uiColor = UIColor(color)
    
        // Set appearance for both normal and large sizes.
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor ]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor ]
    
        return self
    }
}


struct CreateNewMessageView: View {
    
    
    let didSelectNewUser: (ChatUser) -> ()
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var vm = CreateNewMessageViewModel()
    
    
    var body: some View {
        ZStack {
        NavigationView {
            ScrollView {
                Text(vm.errorMessage)
                
                ForEach(vm.users) { user in
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        didSelectNewUser(user)
                    } label: {
                        
                        ZStack {
                            
                            /*
                            RoundedRectangle(cornerRadius: 25)
                                .frame(height: 75)
                                .foregroundColor(Color(red: 72 / 255, green: 50 / 255, blue: 168 / 255))
                                .opacity(0.3)
                                .offset(y: 1.5)
                             */

                            
                            RoundedRectangle(cornerRadius: 25)
                                .frame(height: 75)
                                .foregroundColor(Color(red: 230 / 255, green: 230 / 255, blue: 255 / 255))
                                .shadow(radius: 3)
                                .opacity(0.5)
                            
                            HStack(spacing: 16) {
                                WebImage(url: URL(string: user.profileImageUrl))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 54, height: 54)
                                    .clipped()
                                    .cornerRadius(50)
                                    .shadow(radius: 3)
                                    
                                    
                                Text(user.email.replacingOccurrences(of: "@gmail.com", with: "") ?? "")
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(red: 60 / 255, green: 110 / 255, blue: 104 / 255))
                                    
                                Spacer()
                            }.padding(.horizontal, 10)
                        }
                        .padding(.horizontal)
                      
                        
                        
                        
                    }
                        .padding(.vertical, 8)
                }
            }.navigationBarTitle("New Message")
                .navigationBarTitleTextColor(Color(red: 60 / 255, green: 110 / 255, blue: 104 / 255))
                .shadow(radius: 3)
            
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "chevron.down")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(Color(red: 60 / 255, green: 110 / 255, blue: 104 / 255))
                        }
                    }
                }
                .background(
                        LinearGradient(gradient: Gradient(colors: [Color(red: 229 / 255, green: 212 / 255, blue: 207 / 255), Color(red: 178 / 255, green: 191 / 255, blue: 199 / 255)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                
        }
    }
    }
}

struct CreateNewMessageView_Previews: PreviewProvider {
    static var previews: some View {
        //CreateNewMessageView()
        MainMessagesView()
    }
}
