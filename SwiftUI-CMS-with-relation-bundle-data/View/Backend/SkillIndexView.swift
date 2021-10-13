//
//  SkillIndexView.swift
//  SwiftUI-CMS-with-relation-bundle-data
//
//  Created by Waleerat Gottlieb on 2021-10-12.
//

import SwiftUI
import Kingfisher


struct SkillIndexView: View {
    @Environment(\.presentationMode) var presentationMode
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
                    Text("Skills")
                        .modifier(TextTitleModifier())
                    Spacer()
                    ButtonWithCircleIconAction(systemName: "plus", action: {
                        isShowFormView = true
                    })
                }
                
                List{
                    // Note: - Row preview
                  
                    ForEach(skillVM.contentRows) { row in
                        
                        HStack {
                            Text(row.name).modifier(TextDescriptionModifier(foreground: Color.black))
                            
                            Spacer()
                        }
                       .onTapGesture(perform: {
                            // Note: - Open Sheet to update
                            self.isShowFormView.toggle()
                            skillVM.selectedRow = row
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
                    skillVM.getRecords()
                    skillVM.selectedRow = nil
                    // Note: - Close buttom sheet
                    isReload = false
                }
            }) 
            .frame(width: kScreen.width * 0.9)
           
            
            if isShowFormView {
                SkillFormView(isReload: $isReload, isShowFormView: $isShowFormView)
                .environmentObject(skillVM)
            }
            // MARK: - End
        }
        .modifier(ScreenEdgesPaddingModifier())
    }
    
    // MARK: - HELPER FUNCTIONS
    func delete(at offsets: IndexSet) {
        let objectId = skillVM.contentRows[offsets.first!].id
        skillVM.removeRecord(objectId: objectId) { (isSuccess) in  }
        skillVM.contentRows.remove(atOffsets: offsets)
    }
}
 
struct CategoryIndexView_Previews: PreviewProvider {
    static var previews: some View {
        SkillIndexView()
    }
}
