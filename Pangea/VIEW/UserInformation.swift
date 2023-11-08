//
//  UserInformation.swift
//  Pangea
//
//  Created by Lillian Cain on 10/24/23.
//

import SwiftUI

struct UserInformation: View {
    let value: Int
    let title: String
    
    var body: some View {
        VStack {
            Text("\(value)")
            Text(title)
        }
        .frame(width: 75)
    }
}
