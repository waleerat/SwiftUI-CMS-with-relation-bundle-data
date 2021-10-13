//
//  HomeView.swift
//  SwiftUI-CMS-with-relation-bundle-data
//
//  Created by Waleerat Gottlieb on 2021-10-12.
//

import SwiftUI
import Kingfisher

struct HomeView: View {
    @ObservedObject var profileVM = ProfileVM()
    //@EnvironmentObject var profileVM: ProfileVM
    @State var columns: Int = 2
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color(kBackground)
                .ignoresSafeArea()
            
            VStack {
                ScrollView {
                    ForEach (profileVM.profileVMRows) { row in
                        VStack{
                            ZStack(alignment:.bottom) {
                                if !row.imageURL.isEmpty && row.imageURL.verifyUrl() {
                                    KFImage(URL(string: row.imageURL)!)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        //.cornerRadius(10)
                                } else {
                                    Image("backgroundImage")
                                        .resizable()
                                        .scaledToFill()
                                       // .cornerRadius(10)
                                }
                                
                                
                                VStack {
                                    Text(row.name).modifier(TextTitleModifier(foreground: Color.black))
                                    HStack{
                                        ForEach(row.skills) { skill in
                                            Text(skill.name)
                                                .padding(3)
                                                .foregroundColor(Color(kForeground))
                                                .background(Color(kBackground).opacity(0.8))
                                                .cornerRadius(3)
                                        }
                                    }
                                }
                                .padding()
                                .frame(width: kScreen.width)
                                .background(Color(kForeground).opacity(0.7))
                                
                            }
                        }//: VStack
                        .cornerRadius(10)
                        .modifier(ShadowModifier())
                    }
                }
                
                Spacer()
            }.onAppear() {
                
            }
        }
        .modifier(ScreenEdgesPaddingModifier())
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

 
