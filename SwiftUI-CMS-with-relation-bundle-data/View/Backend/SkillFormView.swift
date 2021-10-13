//
//  SkillFormView.swift
//  SwiftUI-CMS-with-relation-bundle-data
//
//  Created by Waleerat Gottlieb on 2021-10-12.
//

import SwiftUI
import Kingfisher

struct SkillFormView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var skillVM: SkillVM
    
    @Binding var isReload: Bool
    @Binding var isShowFormView: Bool
    @State var objectId:String = ""
    @State var name:String = ""
    
    @State var isSaved: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color(kBackground).opacity(0.5)
                .blur(radius: (isShowFormView)  ? 8.0 : 0, opaque: false)
                .onTapGesture(perform: {
                    isShowFormView.toggle()
                })
                
                .ignoresSafeArea()
            // MARK: - Start
            VStack(spacing: 20){
                HStack {
                    Text((skillVM.selectedRow == nil ? "Add" : "Update"))
                        .modifier(TextTitleModifier())
                    
                    Spacer()
                    // Note: - Add button will enable if skillRows[0].name.isEmpty
                    ButtonTextAction(buttonLabel: .constant("Save"), isActive: .constant(!name.isEmpty), action: {
                        saveToFirebase(objectId: objectId)
                    }).disabled(name.isEmpty)
                }
                
                TextFieldInputView(textInput: $name, textFieldTitle: "Skill", textPlaceholder: "Skill Name", editorType: editor.textinput)
            }
            .padding()
            .background(Color(kBackground))
            
            .cornerRadius(10)
            .blur(radius: (isSaved)  ? 8.0 : 0, opaque: false)
            .modifier(ShadowModifier())
            .modifier(ScreenEdgesPaddingModifier())
            .onChange(of: isSaved, perform: { _ in
                if isSaved {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        isShowFormView = false
                        isReload = true
                        self.presentationMode.wrappedValue.dismiss()
                   }
                }
            })
            .onAppear() {
                if let currentRow = skillVM.selectedRow {
                    self.objectId = currentRow.id
                    self.name = currentRow.name
                } else {
                    objectId = UUID().uuidString
                }
            }
            .onTapGesture {
                withAnimation() {
                    hideKeyboard()
                }
              }
            // MARK: - End 
            
        }
        .modifier(NavigationBarHiddenModifier())
        
    }
    
    
    // MARK: - HELPER FUNCTIONS
    func saveToFirebase(objectId: String){
        // Note: - Save to Firebase
        
        
        
        let modelData = SkillModel(id: objectId,
                                     name: name)
        
        skillVM.SaveRecord(objectId: objectId, modelData: modelData) { isCompleted in
            isSaved = true
        }
    }
}
