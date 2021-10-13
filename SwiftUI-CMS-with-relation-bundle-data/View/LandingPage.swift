//
//  LandingPage.swift
//  SwiftUI-MVVM-and-Design-Pattern
//
//  Created by Waleerat Gottlieb on 2021-09-23.
//

import SwiftUI
struct LandingPage: View {
    
    @AppStorage("tabIndex") private var tabIndex: Int = 0
    
    var body: some View{
        // tabview with navigation bar...
        ZStack(alignment: .bottom) {
           // Color(.orange).opacity(0.5)
            // changing view based on index...
            switch (self.tabIndex) {
            case 0 : HomeView()
            case 1 : ProfileIndexView()
            case 2 : SkillIndexView()
            default: HomeView()
            }
            // Note: - Tab bar
            TabFontendMenuView()
        }
        .edgesIgnoringSafeArea(.all)
        .padding(0)
    }
}

// MARK: - Tab menu View
// MARK: - Tab menu View
struct TabMenuModel : Identifiable {
    var id: Int
    var systemName: String
    var title: String
}


struct TabFontendMenuView:View {
    @AppStorage("tabIndex") private var tabIndex: Int = 0
   
    @State var tabItems : [TabMenuModel] = [
        TabMenuModel(id: 0, systemName: "house", title: "Home"),
        TabMenuModel(id: 1, systemName: "person", title: "Profile"),
        TabMenuModel(id: 2, systemName: "chevron.left.slash.chevron.right", title: "Skill") 
    ]
    
    var body: some View {
        ZStack(alignment: .top) {
            HStack{
                ForEach(tabItems) { row in
                     Button(action: {
                         self.tabIndex = row.id
                       }) {
                         TabIconMenuView(tabIndex: $tabIndex,
                                      currentIndex: row.id,
                                      systemName: row.systemName,
                                      title: row.title)
                     }
                    if (row.id != tabItems.count - 1){
                       Spacer()
                    }
                }
               
            }
            .frame(height: 40)
            .padding(.horizontal, 20)
            .padding(.top)
            .padding(.bottom, kSafeAreaBottom)
            .background(Color.white)
            .foregroundColor(Color.black)
            .shadow(color: Color.primary.opacity(0.08), radius: 5, x: 0, y: -5)
        }
    }
}

struct TabIconMenuView: View {
    @Binding var tabIndex: Int
    @State var currentIndex:Int
    @State var systemName:String
    @State var title:String
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Image(systemName: systemName)
                .font(.system(size: 25))
                .padding(.horizontal)
                .foregroundColor(currentIndex == self.tabIndex ? Color.accentColor : Color.primary.opacity(0.25))
            Text(title)
                .font(.caption)
                .foregroundColor(currentIndex == self.tabIndex ? Color.accentColor : Color.primary.opacity(0.25))
        }
        
    }
}
