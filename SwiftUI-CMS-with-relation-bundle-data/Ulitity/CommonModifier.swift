//
//  CommonModifier.swift
//  SwiftUI-MVVM-and-Design-Pattern
//
//  Created by Waleerat Gottlieb on 2021-09-23.
//

import SwiftUI

 

struct ScreenEdgesPaddingModifier : ViewModifier {
    func body(content: Content) -> some View {
    content
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .padding(.top, kSafeAreaTop)
        .padding(.bottom, kSafeAreaBottom! + 15)
        .accentColor(.accentColor)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

 
struct TextTitleModifier : ViewModifier {
    @State var foreground: Color = Color(kForeground)
    func body(content: Content) -> some View {
    content
            .font(.title2) 
            .foregroundColor(foreground)
            .multilineTextAlignment(.leading)
    }
}

struct TextDescriptionModifier : ViewModifier {
    @State var foreground: Color = Color(kForeground)
    func body(content: Content) -> some View {
    content
            .font(.caption)
            .foregroundColor(foreground)
            .multilineTextAlignment(.leading)
    }
}

struct InputModifier : ViewModifier {
    @State var foreground: Color = Color(kForeground)
    func body(content: Content) -> some View {
    content
            .font(.caption)
            .foregroundColor(foreground)
            .multilineTextAlignment(.leading)
    }
} 


struct NavigationBarHiddenModifier : ViewModifier {
    func body(content: Content) -> some View {
    content
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct ThumbnailImageModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .frame(width: 60 , height: 70 )
            .aspectRatio(contentMode: .fit)
            .cornerRadius(5)
    }
}


struct ImageModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .frame(width: 120 , height: 150 )
            .aspectRatio(contentMode: .fit)
            .cornerRadius(5)
    }
}

struct ImageFullScreenModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .frame(width: kScreen.width * 0.9, height: kScreen.height - (kSafeAreaTop! + kSafeAreaBottom!) - 200)
            .scaledToFit()
            .cornerRadius(10)
    }
}

struct ShadowModifier : ViewModifier {
   func body(content: Content) -> some View {
   content
       .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 8, x: 0.0, y: 4.0)
   }
}
