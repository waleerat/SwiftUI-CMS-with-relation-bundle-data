//
//  SkillVM.swift
//  SwiftUI-CMS-with-relation-bundle-data
//
//  Created by Waleerat Gottlieb on 2021-10-12.
//

import Foundation

class SkillVM: ObservableObject {
    @Published var contentRows: [SkillModel] = []
    @Published var selectedRow: SkillModel?
    
    init() {
        getRecords()
    }
 
    func getRecords() {
        self.contentRows = []
        FirebaseReference(.Skill).getDocuments { [self] (snapshot, error) in
            
            guard let snapshot = snapshot else { return }
            
            if !snapshot.isEmpty {
                for snapshot in snapshot.documents {
                    let rowData = snapshot.data()
                    let rowStructure = dictionaryToStructrue(rowData)
                    self.contentRows.append(rowStructure)
                }
            }
        }
         
    }
    
    func getSelectedRow(selectedRow: SkillModel) {
        self.selectedRow = selectedRow
    }
    
    // Note: - Create/Update Record
    func SaveRecord(objectId: String, modelData: SkillModel, completion: @escaping (_ isCompleted: Bool?) -> Void) {
        
        let dictionaryRowData = self.structureToDictionary(modelData)
        FirebaseReference(.Skill).document(objectId).setData(dictionaryRowData) {
            error in
            DispatchQueue.main.async {
                if error != nil {
                    completion(false)
                }
                completion(true)
            }
        }
    }
    
    // Note: - Delete Record
    func removeRecord(objectId: String, completion: @escaping (_ isCompleted:Bool?) -> Void) {
        FirebaseReference(.Skill).document(objectId).delete() { error in
            if let _ = error {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    
    func structureToDictionary(_ row : SkillModel) -> [String : Any] {
        return NSDictionary(
            objects:
                [row.id,
                 row.name
                ],
            forKeys: [
                "id" as NSCopying,
                "name" as NSCopying
            ]
        ) as! [String : Any]
    }
    
    func dictionaryToStructrue(_ dictionaryRow : [String : Any]) -> SkillModel {
        return SkillModel(id: dictionaryRow["id"] as? String ?? "",
                            name: dictionaryRow["name"] as? String ?? "")
                           
    }
    
}
