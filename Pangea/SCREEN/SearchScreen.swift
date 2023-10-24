//
//  SearchView.swift
//  Pangea
//
//  Created by Lillian Cain on 10/23/23.
//

import SwiftUI

struct SearchScreen: View {
    @StateObject var searchViewModel = SearchViewModel()
    
    @State var searchText = ""
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 25) {
                ForEach(searchViewModel.users) { user in
                    NavigationLink(destination: Screen(user: user)) {
                        HStack {
                            ProfileImageManager(user: user, size: .small)
                            VStack(alignment: .leading) {
                                Text(user.username)
                                
                                if let name = user.name {
                                    Text(name)
                                }
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.top)
            .searchable(text: $searchText, prompt: "Search...")
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SearchScreen()
}
