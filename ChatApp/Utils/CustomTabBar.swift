//
//  CustomTabBar.swift
//  ChatApp
//
//  Created by Vishwa Pandian on 1/13/22.
//

import SwiftUI

struct CustomTabBar: View {
    
    @State var selectedIndex = 1
    
    
    var body: some View {
        VStack {
            
            ZStack {
                
                switch selectedIndex {
                case 2: HomeView()
                case 3: MainMessagesView()
                case 4: ProfileView()
                default: Text("Main")
                }
            }
            
            Spacer()
            
            HStack {
                
                Spacer()

                
                Button {
                    
                    selectedIndex = 1
                    
                } label: {
                    
                    if selectedIndex == 1 {
                        
                        Image(systemName: "house.fill")
                            .font(.system(size: 23))
                            .foregroundColor(Color(red: 20 / 255, green: 70 / 255, blue: 64 / 255))
                        
                    } else {
                        
                        Image(systemName: "house.fill")
                            .font(.system(size: 23))
                            .foregroundColor(Color.black)
                        
                    }
                    
                }
                .padding(.vertical, 10)
                
                Spacer()

                Button {
                    
                    selectedIndex = 2
                    
                } label: {
                    
                    if selectedIndex == 2 {
                        
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 23, weight: .bold))
                            .foregroundColor(Color(red: 20 / 255, green: 70 / 255, blue: 64 / 255))
                        
                    } else {
                        
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 23, weight: .bold))
                            .foregroundColor(Color.black)
                        
                    }


                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                
                Spacer()
                
                Button {
                    
                    selectedIndex = 3
                    
                } label: {
                    
                    if selectedIndex == 3 {
                        
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 23))
                            .foregroundColor(Color(red: 20 / 255, green: 70 / 255, blue: 64 / 255))
                        
                    } else {
                        
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 23))
                            .foregroundColor(Color.black)
                        
                    }

                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                
                Spacer()
                
                Button {
                    
                    selectedIndex = 4
                    
                } label: {
                    
                    if selectedIndex == 4 {
                        
                        Image(systemName: "person.fill")
                            .font(.system(size: 23))
                            .foregroundColor(Color(red: 20 / 255, green: 70 / 255, blue: 64 / 255))
                        
                    } else {
                        
                        Image(systemName: "person.fill")
                            .font(.system(size: 23))
                            .foregroundColor(Color.black)
                        
                    }

                }
                .padding(.vertical, 10)
                
                Spacer()
                
            }
            .opacity(0.5)
            
        }
        .background(
                LinearGradient(gradient: Gradient(colors: [Color(red: 229 / 255, green: 212 / 255, blue: 207 / 255), Color(red: 178 / 255, green: 191 / 255, blue: 199 / 255)]), startPoint: .topLeading, endPoint: .bottomTrailing)
            )
    }
}


struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar()
    }
}

