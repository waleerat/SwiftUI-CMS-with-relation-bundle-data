//
//  ProfileFormView.swift
//  SwiftUI-CMS-with-relation-bundle-data
//
//  Created by Waleerat Gottlieb on 2021-10-12.
//

import SwiftUI
import Kingfisher

struct ProfileFormView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var profileVM: ProfileVM
    @EnvironmentObject var skillVM: SkillVM 
    
    @Binding var isReload: Bool
    @Binding var isShowFormView: Bool
    @State var objectId:String = ""
    @State var name:String = ""
    @State var imageURL: String = ""
    
    @State var isSaved: Bool = false
    
    @State var skillChecked:[String:Bool] = [:]
    @State var columns: Int = 2
    
   
    var body: some View {
        ZStack(alignment: .bottom) {
            Color(kBackground)
                .ignoresSafeArea()
            // MARK: - Start
            VStack(spacing: 20){
                HStack {
                    ButtonWithCircleIconAction(systemName: "xmark", action: {
                        isReload = true
                        self.presentationMode.wrappedValue.dismiss()
                    })
                    
                    Text((profileVM.selectedRow == nil ? "Add" : "Update"))
                        .modifier(TextTitleModifier())
                    
                    Spacer()
                    // Note: - Add button will enable if profileRows[0].name.isEmpty
                    ButtonTextAction(buttonLabel: .constant("Save"), isActive: .constant(!name.isEmpty), action: {
                        saveToFirebase(objectId: objectId)
                    }).disabled(name.isEmpty)
                }
                
                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: columns), alignment: .center, spacing: 10) {
                    ForEach(skillVM.contentRows) { row in
                        
                        HStack{
                            CheckboxView(isChecked: .constant((skillChecked[row.id] ?? false))) {
                                skillChecked[row.id]?.toggle() 
                            }
                            Text(row.name)
                                .modifier(TextDescriptionModifier())
                            Spacer()
                        }
                        
                    }
                }
             
                
                if !imageURL.isEmpty {
                    if imageURL.verifyUrl() {
                        KFImage(URL(string: imageURL)!)
                            .resizable()
                            .scaledToFit()
                            .modifier(ImageModifier())
                    } else {
                        Image(systemName : "doc.richtext")
                            .resizable()
                            .scaledToFit()
                            .modifier(ImageModifier())
                    }
                } else {
                    Image(systemName : "doc.richtext")
                        .resizable()
                        .scaledToFit()
                        .modifier(ImageModifier())
                }
                
                TextFieldInputView(textInput: $name, textFieldTitle: "profile", textPlaceholder: "profile Name", editorType: editor.textinput)
                
                TextFieldInputView(textInput: $imageURL, textFieldTitle: "Image URL", textPlaceholder: "http://", editorType: editor.textarea)
                
                Spacer()
            }
            .padding()
            .background(Color(kBackground))
            
            .cornerRadius(10)
            .blur(radius: (isSaved)  ? 8.0 : 0, opaque: false)
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
                // Note: - Set checkbox values
                for skill in skillVM.contentRows {
                    skillChecked[skill.id] = false
                }
                // Note: - get selected data
                if let currentRow = profileVM.selectedRow {
                    self.objectId = currentRow.id
                    self.name = currentRow.name
                    self.imageURL = currentRow.imageURL
                    // Note: - Get bundle
                    profileVM.getBundleSkillByProfileId(profileId: self.objectId) { bundleRows in
                        
                        if let bundleRows = bundleRows {
                            for bundleRow in bundleRows {
                                skillChecked[bundleRow.skillId] = true
                            }
                        }
                    }
                    
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
        let modelData = ProfileModel(id: objectId,
                                     name: name,
                                     imageURL: imageURL)
        
        profileVM.SaveRecord(objectId: objectId, modelData: modelData) { isCompleted in
            
            let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .background)
            dispatchQueue.async{
                profileVM.updateFilterRows(objectId: objectId, skillChecked: skillChecked)
            }
            isSaved = true
        }
    }
    
 
}

