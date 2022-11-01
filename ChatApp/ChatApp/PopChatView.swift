//
//  pop
//
//  Created by Vishwa Pandian on 11/23/21.
//

import SwiftUI



struct PopChatView: View {
    
    @State var whatView = 1
    
    var body: some View {
        
        if whatView == 1 {
        
        ZStack {
            
        Image("image1")
                .resizable()
                .frame(height: 860)
                .padding(.bottom, 40)
            
        Text("Should Ole be sacked?")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 780)
            
            Rectangle()
                .fill(Color.white)
                .frame(width: 400, height: 262)
                .padding(.top, 700)
            
            HStack {
            
                
                NavigationLink(destination: View2()) {
                    
                    ZStack {
                        
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .strokeBorder(Color.gray, lineWidth: 2)
                        .frame(width: 150, height: 70)
                    
                    
                        
                    Text("Join +")
                            .foregroundColor(.black)
                    }
                    
                }
                .padding()
                
                //----------------------
                Button {
                    
                    whatView = 2
                    
                        } label: {
                            ZStack {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .strokeBorder(Color.gray, lineWidth: 2)
                                .frame(width: 150, height: 70)
                            
                                
                            Text("Next")
                                    .foregroundColor(.black)
                            }
                        }
                        .padding()
            
            
        }
            .padding(.top, 550)
            
            
        }
            
        } else if (whatView == 2) {
            ZStack {
                
            Image("image2")
                    .resizable()
                    .frame(height: 860)
                    .padding(.bottom, 40)
                
            Text("Jake Paul Fight")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 780)
                
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 400, height: 262)
                    .padding(.top, 700)
                
                HStack {
                
                    NavigationLink(destination: View3()) {
                        
                        ZStack {
                            
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .strokeBorder(Color.gray, lineWidth: 2)
                            .frame(width: 150, height: 70)
                        
                        
                            
                        Text("Join +")
                                .foregroundColor(.black)
                        }
                        
                    }
                        .padding()
                    
                    
                    Button {
                               whatView = 1
                            } label: {
                                ZStack {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .strokeBorder(Color.gray, lineWidth: 2)
                                    .frame(width: 150, height: 70)
                                
                                    
                                Text("Next")
                                        .foregroundColor(.black)
                                }
                            }
                            .padding()
                
                
            }
                .padding(.top, 550)
                
                
            }
        }// whatView
            
            
        
        
            
    }
}

struct View2: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        
        ZStack {
        Image("image1")
                .resizable()
                .frame(height: 860)
                .padding(.bottom, 40)
            
        Text("Should Ole be sacked?")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 780)
            
        }
        .offset(y: -20)
        
        .navigationBarBackButtonHidden(true)
                    .navigationBarItems(leading: Button(action : {
                        self.mode.wrappedValue.dismiss()
                    }){
                        Image(systemName: "arrow.left")
                    })
        
    }
}

struct View3: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        
        ZStack {
        
            
        Image("image2")
                .resizable()
                .frame(height: 860)
                .padding(.bottom, 40)
            
        Text("Jake Paul Fight")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 780)
            
            
        }
        .offset(y: -20)
        
        
        .navigationBarBackButtonHidden(true)
                    .navigationBarItems(leading: Button(action : {
                        self.mode.wrappedValue.dismiss()
                    }){
                        Image(systemName: "arrow.left")
                    })
        
    }
}


struct PopChatView_Previews: PreviewProvider {
    static var previews: some View {
        View2()
    }
}
