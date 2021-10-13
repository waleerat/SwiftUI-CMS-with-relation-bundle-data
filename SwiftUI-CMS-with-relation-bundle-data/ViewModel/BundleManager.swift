//
//  BundleManager.swift
//  SwiftUI-CMS-with-relation-bundle-data
//
//  Created by Waleerat Gottlieb on 2021-10-12.
//

import Foundation
class BundleManager {
    
    class func getAllBundleRows(completion: @escaping (_ bundleRows: [ProfileBundleModel]) -> Void) {
         // Note: - Get Bundle Rows
        FirebaseReference(.SkillBundle).getDocuments { (snapshot, error) in
            
            var skillBundleRows: [ProfileBundleModel] = [] // Note: - All Section bundle
            guard let snapshot = snapshot else { return }
            
            if !snapshot.isEmpty {
                for snapshot in snapshot.documents {
                    let row = snapshot.data()
                    let rowStructure = ProfileBundleModel(id: row["id"] as? String ?? "",
                                                          profileId: row["profileId"] as? String ?? "",
                                                          skillId: row["skillId"] as? String ?? "")
                    skillBundleRows.append(rowStructure)
                }
                completion(skillBundleRows)
                return
            } else {
                completion([])
            }
        }
        
     }
    
    // Note: - Remove Section Bundle
    class func saveProfileIdToBundle(bundelRow: ProfileBundleModel) {
        let dictionaryForm = ["id" : bundelRow.id,
                              "profileId": bundelRow.profileId,
                              "skillId": bundelRow.skillId]
       
        FirebaseReference(.SkillBundle).document(bundelRow.id).setData(dictionaryForm) { error in }
         
    }
    
    class func removeProfileIdFormBundle(bundleId: String) { 
        FirebaseReference(.SkillBundle).document(bundleId).delete() { error in  }
    }
}
