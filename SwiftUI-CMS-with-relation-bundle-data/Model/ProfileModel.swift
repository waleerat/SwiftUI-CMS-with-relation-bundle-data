//
//  ProfileModel.swift
//  SwiftUI-CMS-with-relation-bundle-data
//
//  Created by Waleerat Gottlieb on 2021-10-12.
//

import Foundation

struct ProfileModel: Identifiable, Hashable {
    var id: String
    var name: String
    var imageURL: String
}

struct ProfileBundleModel: Identifiable {
    var id: String
    var profileId: String
    var skillId: String
}



struct ProfileViewModel: Identifiable, Hashable {
    var id: String
    var name: String
    var imageURL: String
    var skills: [SkillModel]
}
