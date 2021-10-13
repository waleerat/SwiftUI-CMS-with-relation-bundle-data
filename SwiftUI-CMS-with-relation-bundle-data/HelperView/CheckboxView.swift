//
//  CheckboxView.swift
//  SwiftUI-CMS-with-relation-bundle-data
//
//  Created by Waleerat Gottlieb on 2021-10-13.
//

import SwiftUI

struct CheckboxView: View {
    @Binding var isChecked: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action , label: {
            Image(systemName: isChecked ? "checkmark.square" : "square")
        }) 
    }
}
