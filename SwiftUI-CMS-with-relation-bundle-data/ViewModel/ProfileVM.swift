//
//  ProfileVM.swift
//  SwiftUI-CMS-with-relation-bundle-data
//
//  Created by Waleerat Gottlieb on 2021-10-12.
//

import Foundation
import Accessibility

class ProfileVM: ObservableObject {
    @Published var contentRows: [ProfileModel] = []
    @Published var profileId: String?
    @Published var selectedRow: ProfileModel?
 
    @Published var profileFilterRows: [ProfileModel] = [] // Note: - Profile By skillId
    @Published var profileBundleRows: [ProfileBundleModel] = [] // Note: - All bundle rows
  
    @Published var profileVMRows: [ProfileViewModel] = []
    
    var skillVM  = SkillVM()
    
    init(){
        BundleManager.getAllBundleRows { bundleRows in
            self.profileBundleRows = bundleRows
            self.getRecords { contentRows in
                self.getProfileForFrontEnd { profileVMRows in
                    self.profileVMRows = profileVMRows ?? []
                }
            }
        }
    }
     
    
    func getRecords(completion: @escaping (_ contentRows: [ProfileModel]?) -> Void) {
        self.contentRows = []
         
        FirebaseReference(.Profile).getDocuments { [self] (snapshot, error) in
            
            guard let snapshot = snapshot else { return }
            
            if !snapshot.isEmpty {
                for snapshot in snapshot.documents {
                    let rowData = snapshot.data()
                    let rowStructure = dictionaryToStructrue(rowData)
                    self.contentRows.append(rowStructure)
                }
                completion(self.contentRows)
            }
        }
    }
    
    func getBundleSkillByProfileId(profileId: String, completion : @escaping (_ bundleRows: [ProfileBundleModel]?) -> Void){
        
        let selectedBundle =  self.profileBundleRows.filter { $0.profileId == profileId }
        completion(selectedBundle)
        
    }
    
    
    func getProfileForFrontEnd(completion: @escaping (_ profileVMRows: [ProfileViewModel]?) -> Void) {
        var profileVMRows: [ProfileViewModel] = []
        
        for contentRow in self.contentRows {
            var profileSkillRows: [SkillModel] = []
            self.getBundleSkillByProfileId(profileId: contentRow.id) { bundleRows in
                if let bundleRows = bundleRows {
                    
                    for row in bundleRows {
                        for skill in self.skillVM.contentRows {
                            if skill.id == row.skillId {
                                profileSkillRows.append(skill)
                            }
                        }
                    }
                    
                }
                profileVMRows.append(ProfileViewModel(id: contentRow.id,
                                                      name: contentRow.name,
                                                      imageURL: contentRow.imageURL,
                                                      skills: profileSkillRows))
            }
        } 
        completion(profileVMRows)
        
    }
    
    // Note: - Create/Update Record
    func SaveRecord(objectId: String, modelData: ProfileModel, completion: @escaping (_ isCompleted: Bool?) -> Void) {
        
        let dictionaryRowData = self.structureToDictionary(modelData)
        FirebaseReference(.Profile).document(objectId).setData(dictionaryRowData) {
            error in
            DispatchQueue.main.async {
                if error != nil {
                    completion(false)
                }
                completion(true)
            }
        }
    }
    
    
    func updateFilterRows(objectId: String,skillChecked:[String:Bool]){
        // Note: - Add new bundels
        for (key, value) in skillChecked {
             
            if value {
                let selectedBundle =  self.profileBundleRows.filter { $0.profileId == objectId && $0.skillId == key }
                if selectedBundle.count == 0 {
                    BundleManager.saveProfileIdToBundle(bundelRow: ProfileBundleModel(id: UUID().uuidString, profileId: objectId, skillId: key))
                }
            } else {
                let selectedBundle =  self.profileBundleRows.filter { $0.profileId == objectId && $0.skillId == key }
                if selectedBundle.count > 0 {
                    print(" >> Delete \(key) value \(value)")
                    BundleManager.removeProfileIdFormBundle(bundleId: selectedBundle[0].id)
                }
            }
        }
        
    }
     
    
    // Note: - Delete Record
    func removeRecord(objectId: String, completion: @escaping (_ isCompleted:Bool?) -> Void) {
        FirebaseReference(.Profile).document(objectId).delete() { error in
            if let _ = error {
                completion(false)
            } else {
                // Note: - get selected row
                let selectedBundleRows =  self.profileBundleRows.filter { $0.profileId == objectId }
                for bundleRow in selectedBundleRows {
                    BundleManager.removeProfileIdFormBundle(bundleId: bundleRow.id)
                }
                
                completion(true)
            }
        }
    }
    
    
    func structureToDictionary(_ row : ProfileModel) -> [String : Any] {
        return NSDictionary(
            objects:
                [row.id,
                 row.name,
                 row.imageURL
                ],
            forKeys: [
                "id" as NSCopying,
                "name" as NSCopying,
                "imageURL" as NSCopying
            ]
        ) as! [String : Any]
    }
    
    func dictionaryToStructrue(_ dictionaryRow : [String : Any]) -> ProfileModel {
        return ProfileModel(id: dictionaryRow["id"] as? String ?? "",
                            name: dictionaryRow["name"] as? String ?? "",
                            imageURL: dictionaryRow["imageURL"] as? String ?? "")
    }
    
}
