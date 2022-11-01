//
//  HomeView.swift
//  ChatApp
//
//  Created by Vishwa Pandian on 12/31/21.
//

import SwiftUI
import SDWebImageSwiftUI

class MainMessagesViewModel2: ObservableObject {
    
    @Published var errorMessage = ""
    @Published var chatUser: ChatUser?
    
    init() {
        
        DispatchQueue.main.async {
            self.isUserCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
        }
        
        fetchCurrentUser()
        
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
            
            
            guard let data = snapshot?.data() else {
                self.errorMessage = "No data found"
                return
                
            }
            
            self.chatUser = .init(data: data)
            
            
        }
    }
    
    @Published var isUserCurrentlyLoggedOut = false
    
    func handleSignOut() {
        isUserCurrentlyLoggedOut.toggle()
        try? FirebaseManager.shared.auth.signOut()
    }
    
}

struct HomeView: View {
    
    @State var shouldShowLogOutOptions = false
    
    @State var shouldNavigateToChatLogView = false
    
    @ObservedObject private var vm = MainMessagesViewModel2()
    
    
    var body: some View {
        NavigationView {
            ZStack {
            VStack {
                
                
                customNavBar
                
                browseView
                
                            
            }
            .navigationBarHidden(true)
            //.navigationTitle("Search")
        }
            .background(
                    LinearGradient(gradient: Gradient(colors: [Color(red: 229 / 255, green: 212 / 255, blue: 207 / 255), Color(red: 178 / 255, green: 191 / 255, blue: 199 / 255)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                )

        }
    }

    
    
    var customNavBar: some View {
        ZStack {
        RoundedRectangle(cornerRadius: 15)
            .frame(height: 50)
            .foregroundColor(Color(red: 230 / 255, green: 230 / 255, blue: 255 / 255))
            .shadow(radius: 1)
            .opacity(0.5)
            
            HStack {
                
                Text("Search...")
                    .foregroundColor(Color(red: 100 / 255, green: 110 / 255, blue: 104 / 255))
                Spacer()
            }
            .padding()
        }
        .padding()

    }
    
    
    @State private var willMoveToNextScreen = false
    
    private var browseView: some View {
        
        HStack {
        ScrollView {
                        
            let items = ["Trending", "Soccer", "Movies", "Food", "Stocks", "Random"]
            
            ForEach(0...5, id: \.self) { num in
              
                
                NavigationLink(destination: PopChatView()) {
                    ZStack {
                    
                    Image(items[num])
                        .frame(width: 350, height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding()
                        .shadow(radius: 5)
                        
                        Text(items[num])
                            .font(.system(size: 35, weight: .bold))
                            .foregroundColor(Color.white)
                            .shadow(radius: 10)
                        
                    }
                }
              }
            }
        }
        .padding(.horizontal, 30)
    }
    
    

    
    //@State var chatUser: ChatUser?

    
}


struct MainMessagesView2_Previews: PreviewProvider {
    static var previews: some View {
        
        HomeView()
        //NavView()
    }
}
