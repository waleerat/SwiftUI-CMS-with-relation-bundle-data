//
//  ProfileIndexView.swift
//  SwiftUI-CMS-with-relation-bundle-data
//
//  Created by Waleerat Gottlieb on 2021-10-12.
//

import SwiftUI

struct ProfileIndexView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var profileVM = ProfileVM()
    @ObservedObject var skillVM = SkillVM()
    
    @State var isShowFormView: Bool = false
    @State var isReload: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color(kBackground)
                .ignoresSafeArea()
            // MARK: - Start
            
            VStack(alignment: .trailing, spacing: 20){
                
                HStack {
                    Text("Profiles")
                        .modifier(TextTitleModifier())
                    Spacer()
                    ButtonWithCircleIconAction(systemName: "plus", action: {
                        isShowFormView = true
                    })
                }
                
                List{
                    // Note: - Row preview
                  
                    ForEach(profileVM.contentRows) { row in
                        
                        HStack {
                            Text(row.name).modifier(TextDescriptionModifier(foreground: Color.black))
                            Spacer()
                        }
                       .onTapGesture(perform: {
                            // Note: - Open Sheet to update
                            self.isShowFormView.toggle()
                            profileVM.selectedRow = row
                        })
                        .frame(width: kScreen.width * 0.8)
                        .listRowBackground(Color.white)
                      
                    }.onDelete(perform: delete)
                    //: END LOOP CONTENT ROWS
                }.listStyle(PlainListStyle())
                Spacer()
            }
            //:VSTACK
            .onChange(of: isReload, perform: { _ in
                if isReload {
                    // Note: - Fetching All data
                    profileVM.getRecords { _ in }
                    profileVM.selectedRow = nil
                    // Note: - Close buttom sheet
                    isReload = false
                }
            })
            .sheet(isPresented: $isShowFormView, content: {
                if isShowFormView {
                    ProfileFormView(isReload: $isReload, isShowFormView: $isShowFormView)
                    .environmentObject(profileVM)
                    .environmentObject(skillVM)
                }
            })
            .frame(width: kScreen.width * 0.9)
            
            // MARK: - End
        }
        .modifier(ScreenEdgesPaddingModifier())
    }
    
    // MARK: - HELPER FUNCTIONS
    func delete(at offsets: IndexSet) {
        let objectId = profileVM.contentRows[offsets.first!].id
        profileVM.removeRecord(objectId: objectId) { (isSuccess) in  }
        profileVM.contentRows.remove(atOffsets: offsets)
    }
}
 
