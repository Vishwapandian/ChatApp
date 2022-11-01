//
//  ChatLogView.swift
//  ChatApp
//
//  Created by Vishwa Pandian on 12/30/21.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI



struct ChatMessage: Identifiable {
    
    var id: String { documentId }
    
    let documentId: String
    let fromId, toId, text: String
    
    init(documentId: String, data: [String: Any]) {
        self.documentId = documentId
        self.fromId = data["fromId"] as? String ?? ""
        self.toId = data["toId"] as? String ?? ""
        self.text = data["text"] as? String ?? ""
    }
}

class ChatLogViewModel: ObservableObject {
    
    @Published var chatText = ""
    @Published var errorMessage = ""
    @Published var chatMessages = [ChatMessage]()
    
    let chatUser: ChatUser?
    
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        
        fetchMessages()
    }
    
    private func fetchMessages() {
        
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        // MODIFY THIS TO MAKE GCS
        guard let toId = chatUser?.id else { return }
        
        FirebaseManager.shared.firestore.collection("messages").document(fromId)
            .collection(toId)
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "failed ro listen for messages \(error)"
                    print(error)
                    return
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        let data = change.document.data()
                        self.chatMessages.append(.init(documentId: change.document.documentID, data: data))
                    }
                })
                
                DispatchQueue.main.async {
                    self.count += 1
                }
                
            }
        
    }
    
    func handleSend() {
        print(chatText)
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        guard let toId = chatUser?.uid else { return }
        
        let document = FirebaseManager.shared.firestore.collection("messages")
            .document(fromId)
            .collection(toId)
            .document()
        
        let messageData = ["fromId" : fromId, "toId" : toId, "text" : self.chatText, "timestamp" : Timestamp()] as [String : Any]
        
        document.setData(messageData) { error in
            if let error = error {
                print(error)
                self.errorMessage = "Failed to save message into Firestore: \(error)"
                return
            }
            
            print("Successfully saved current user sending message")
            
            self.percsistRecentMessage()
            
            self.chatText = ""
            self.count += 1
        }
        
        let recipientMessageDocument = FirebaseManager.shared.firestore.collection("messages")
            .document(toId)
            .collection(fromId)
            .document()
        
        recipientMessageDocument.setData(messageData) { error in
            if let error = error {
                print(error)
                self.errorMessage = "Failed to save message into Firestore: \(error)"
                return
            }
            
            print("Recipient saved message as well")
        }
    }
    
    private func percsistRecentMessage() {
        
        guard let uid =  FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        guard let toId = self.chatUser?.uid else { return }
        
        let document = FirebaseManager.shared.firestore.collection("recent_messages").document(uid).collection("messages").document(toId)
        
        
        
        let data = [
        
            "timestamp": Timestamp(),
            "text": self.chatText,
            "fromId": uid,
            "toId": toId,
            "profileImageUrl": chatUser?.profileImageUrl ?? "",
            "email": chatUser?.email ?? "",
            "firstName": chatUser?.firstName ?? ""
            
        ] as [String: Any]
        
        
        
        
        
        document.setData(data) { error in
            if let error = error {
                self.errorMessage = "Failed to save recent message: \(error)"
                return
            }
        }
        
    }
    
    @Published var count = 0
}



struct ChatLogView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    let chatUser: ChatUser?
    
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        self.vm = .init(chatUser: chatUser)
    }
    
    @ObservedObject var vm: ChatLogViewModel
    
    var body: some View {
        ZStack {
            VStack {
                
                customNavBar
                messagesView
                
            }
            //messagesView
            Text(vm.errorMessage)
        }
        
        //.navigationTitle(chatUser?.email ?? "")
          //  .navigationBarTitleDisplayMode(.inline)
        
        .navigationBarHidden(true)
            .background(
                    LinearGradient(gradient: Gradient(colors: [Color(red: 229 / 255, green: 212 / 255, blue: 207 / 255), Color(red: 178 / 255, green: 191 / 255, blue: 199 / 255)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                )

    }
    
    
    private var customNavBar: some View {
        
        HStack(spacing: 16) {
            
            Button {
                
                presentationMode.wrappedValue.dismiss()
                
            } label: {
                Image(systemName: "chevron.down")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255))
            }
            
            WebImage(url: URL(string: chatUser?.profileImageUrl ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
                .clipped()
                .cornerRadius(64)

            VStack(alignment: .leading, spacing: 4) {
                Text(chatUser?.email ?? "")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255))

                
            }
            Spacer()
            //newMessageButton
        }
        .padding()
        .background(Color(red: 110 / 255, green: 160 / 255, blue: 154 / 255))
    }
    
    static let emptyScrollToString = "Empty"
    
    private var messagesView: some View {
        VStack {
            if #available(iOS 15.0, *) {
                ScrollView {
                    ScrollViewReader { scrollViewProxy in
                        VStack {
                            ForEach(vm.chatMessages) { message in
                                MessageView(message: message)
                            }
                            
                            HStack{ Spacer() }
                            .id(Self.emptyScrollToString)
                        }
                        .onReceive(vm.$count) { _ in
                            withAnimation(.easeOut(duration: 0.5)) {
                                scrollViewProxy.scrollTo(Self.emptyScrollToString, anchor: .bottom)
                            }
                            
                        }
                        
                        
                        
                    }
                    
                }
                .safeAreaInset(edge: .bottom) {
                    chatBottomBar
                        //.background(Color.white.ignoresSafeArea())
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    private var chatBottomBar: some View {
        HStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 24))
                .foregroundColor(Color(red: 110 / 255, green: 160 / 255, blue: 154 / 255))
            
            
            
            ZStack {
                DescriptionPlaceholder()
                TextEditor(text: $vm.chatText)
                    .opacity(vm.chatText.isEmpty ? 0.5 : 1)
                    .background(Color(red: 230 / 255, green: 230 / 255, blue: 255 / 255).opacity(0))
                    .cornerRadius(10)
            }
            .frame(height: 40)
            
            Button {
                
                if (vm.chatText == "") {
                    
                } else {
                    vm.handleSend()
                }
                
                //vm.handleSend()
                
            } label: {
                Text("Send")
                    .foregroundColor(Color(red: 110 / 255, green: 160 / 255, blue: 154 / 255))
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .cornerRadius(10)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(red: 230 / 255, green: 230 / 255, blue: 255 / 255).opacity(0.5))
    }
}

struct MessageView: View {
    
    let message: ChatMessage
    
    var body: some View {
        VStack {
            if message.fromId == FirebaseManager.shared.auth.currentUser?.uid {
                
                HStack {
                    Spacer()
                    HStack {
                        Text(message.text)
                            .foregroundColor(.black)
                    }
                    .padding(12)
                    .background(Color(red: 230 / 255, green: 230 / 255, blue: 255 / 255))
                    .cornerRadius(12)
                    .opacity(0.8)
                    //.shadow(radius: 1)
                }
                
            } else {
                HStack {
                    HStack {
                        Text(message.text)
                            .foregroundColor(.white)
                    }
                    .padding(12)
                    .background(Color(red: 110 / 255, green: 160 / 255, blue: 154 / 255))
                    .cornerRadius(12)
                    Spacer()
                    
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 1)
    }
}

private struct DescriptionPlaceholder: View {
    var body: some View {
        HStack {
            Text("Message...")
                .foregroundColor(Color(.gray))
                .font(.system(size: 17))
                .padding(.leading, 5)
                .padding(.top, -4)
            Spacer()
        }
    }
}

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatLogView(chatUser: .init(data: ["uid": "DkdnSV2dg5cN4fygeS6HXjWPJbl1", "email": "Chitra", "profileImageUrl": "https://firebasestorage.googleapis.com:443/v0/b/chatapp-a2c01.appspot.com/o/DkdnSV2dg5cN4fygeS6HXjWPJbl1?alt=media&token=52f37d6a-79aa-4fba-baaa-7978621221ef"]))
        }
    }
}
