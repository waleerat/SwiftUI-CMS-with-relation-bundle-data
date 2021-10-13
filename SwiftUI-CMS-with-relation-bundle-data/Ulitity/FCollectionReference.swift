//
//  FCollectionReference.swift
//  LetsMeet
//
//  Created by David Kababyan on 30/06/2020.
//

import Foundation
import Firebase


enum FCollectionReference: String {
    case Skill = "pia_skill"
    case SkillBundle = "pia_skillBundle"
    case Profile = "pia_profile"
    
} 

func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    
    return Firestore.firestore().collection(collectionReference.rawValue)
}
