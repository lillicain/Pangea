//
//  PangeaView.swift
//  Pangea
//
//  Created by Lillian Cain on 10/31/23.
//

import SwiftUI

struct PangeaView: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    var body: some View {
        NavigationStack {
//            ZStack {
                authenticationViewModel.green[0]
                    .ignoresSafeArea(.all)
                
                VStack {
                    Text("PANGEA")
                        .font(FontSeven.medium)
                        .foregroundColor(authenticationViewModel.blue[0])
                        .kerning(7.5)
                        .offset(x: -3.5, y: 3.5)
                        .overlay {
                            Text("PANGEA")
                        }
//                }
            }
        }
    }
}

#Preview {
    PangeaView()
}
