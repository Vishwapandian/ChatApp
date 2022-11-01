//
//  MainMessagesView.swift
//  ChatApp
//
//  Created by Vishwa Pandian on 12/28/21.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
//import Firebase FirestoreSwift


struct RecentMessage: Identifiable {

    var id: String { documentId }

    let documentId: String
    let text, email: String
    let fromId, toId: String
    let profileImageUrl: String
    let timestamp: Timestamp

    init(documentId: String, data: [String: Any]) {
        
        //check this if error
        self.documentId = documentId
        self.text = data["text"] as? String ?? ""
        self.fromId = data["fromId"] as? String ?? ""
        self.toId = data["toId"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.timestamp = data["timestamp"] as? Timestamp ?? Timestamp(date: Date())
    }
}


class MainMessagesViewModel: ObservableObject {
    
    @Published var errorMessage = ""
    @Published var chatUser: ChatUser?
    
    init() {
        
        DispatchQueue.main.async {
            self.isUserCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
        }
        
        fetchCurrentUser()
        
        fetchRecentMessages()
        
    }
    
    @Published var recentMessages = [RecentMessage]()
    
    private func fetchRecentMessages() {
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        FirebaseManager.shared.firestore.collection("recent_messages").document(uid).collection("messages").order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                
                if let error = error {
                    
                    self.errorMessage = "failed to listen for recent messages \(error)"
                    return
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    
                    let docId = change.document.documentID
                    
                    if let index = self.recentMessages.firstIndex(where: { rm in
                        return rm.documentId == docId
                    }) {
                        
                        self.recentMessages.remove(at: index)
                        
                    }
                    
                    self.recentMessages.insert(.init(documentId: docId, data: change.document.data()), at: 0)

                    
                })
                
            }
        
    }
    
     func fetchCurrentUser() {
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "Could not find firebase uid"
            return
        }
        
        
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch current user: \(error)"
                print("Failed to fetch current user:", error)
                return
            }
            
//            self.errorMessage = "123"
            
            guard let data = snapshot?.data() else {
                self.errorMessage = "No data found"
                return
                
            }
//            self.errorMessage = "Data: \(data.description)"
            
            self.chatUser = .init(data: data)
            
            
        }
    }
    
    @Published var isUserCurrentlyLoggedOut = false
    
    func handleSignOut() {
        isUserCurrentlyLoggedOut.toggle()
        try? FirebaseManager.shared.auth.signOut()
    }
    
}




struct MainMessagesView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var shouldShowLogOutOptions = false
    
    @State var shouldNavigateToChatLogView = false
    
    @State var showMessages = false
    
    @ObservedObject private var vm = MainMessagesViewModel()
    
    var body: some View {
        NavigationView {
            
            VStack {
                
                customNavBar
                
                messagesView
                
                //customNavBar
                
                NavigationLink("", isActive: $shouldNavigateToChatLogView) {
                    ChatLogView(chatUser: self.chatUser)
                }
            }
            .navigationBarHidden(true)
            .background(
                    LinearGradient(gradient: Gradient(colors: [Color(red: 229 / 255, green: 212 / 255, blue: 207 / 255), Color(red: 178 / 255, green: 191 / 255, blue: 199 / 255)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                )
        }
    }
    
    
    private var customNavBar: some View {
        
        HStack(spacing: 16) {

            VStack(alignment: .leading, spacing: 4) {
                Text("Private Messages")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255))

                
            }
            Spacer()
            newMessageButton
        }
        .padding()
        .background(Color(red: 110 / 255, green: 160 / 255, blue: 154 / 255))
        //.background(Color(red: 200 / 255, green: 162 / 255, blue: 200 / 255))
    }
    
    private var messagesView: some View {
        ScrollView {
            ForEach(vm.recentMessages) { recentMessage in
                
                
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
                    
                   
                    VStack {
                        
                        
                        
                        Button {
                            
                            self.showMessages.toggle()
                            
                        }
                        label :{
                            
                            
                            ZStack {
                                
                                HStack(spacing: 16) {
                                    
                                    WebImage(url: URL(string: recentMessage.profileImageUrl))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 54, height: 54)
                                        .clipped()
                                        .cornerRadius(64)
                                    
                                    
                                    
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text(recentMessage.email.replacingOccurrences(of: "@gmail.com", with: "") ?? "")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(Color(red: 60 / 255, green: 110 / 255, blue: 104 / 255))
                                            //.foregroundColor(Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255))
                                        Text(recentMessage.text)
                                            .font(.system(size: 14))
                                            .foregroundColor(Color(red: 100 / 255, green: 110 / 255, blue: 104 / 255))
                                            //.foregroundColor(Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255))
                                            .multilineTextAlignment(.leading)
                                    }
                                    Spacer()
                                    
                                    Text("now")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(Color(red: 100 / 255, green: 110 / 255, blue: 104 / 255))
                                        //.foregroundColor(Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255))
                                    
                                }
                            }
                            
                        }
                       // /*
                        .fullScreenCover(isPresented: $showMessages, content: {
                            
                            ChatLogView(chatUser: .init(data: ["uid": recentMessage.toId, "email": recentMessage.email, "profileImageUrl": recentMessage.profileImageUrl]))
                             
                        })
                      //  */
                        
                        // end of navigationLink
                        


                            
                    }.padding(.horizontal)
                    
                }
                .padding(.horizontal)
                .padding(.vertical, 5)
                
 
            }
        }
    }
    
    @State var shouldShowNewMessageScreen = false
    
    private var newMessageButton: some View {
        Button {
            shouldShowNewMessageScreen.toggle()
        } label: {
            Image(systemName: "plus.message.fill")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255))
        }
        
        .fullScreenCover(isPresented: $shouldShowNewMessageScreen) {
            CreateNewMessageView(didSelectNewUser: { user in
                self.shouldNavigateToChatLogView.toggle()
                self.chatUser = user
            })
        }
        
    }
    
    @State var chatUser: ChatUser?
    
}



struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        
        MainMessagesView()
    }
}

