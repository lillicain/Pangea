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
            ScrollViewReader { proxy in
                
                LazyVStack(spacing: 35) {
                    ForEach(searchViewModel.users, id: \.username) { user in
                        
                        NavigationLink(destination: Screen(user: user)) {
                            HStack {
                                ProfileImageManager(user: user, size: .small)
                                VStack(alignment: .leading) {
                                    Text(user.username)
                                        .searchCompletion(user.username)
                                
                                    
                                    if let name = user.name {
                                        Text(name)
                                    }
                                }
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    .onChange(of: searchText, perform: { value in
                        withAnimation(.easeIn) {
                            proxy.scrollTo(value)
    
                        }
                        
                    })
                    
                }
                .padding(5)
                .padding(.top)
                .searchable(text: $searchText, prompt: "Search...")
                
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
