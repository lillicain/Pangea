//
//  SearchView.swift
//  Pangea
//
//  Created by Lillian Cain on 10/23/23.
//

import SwiftUI

struct SearchScreen: View {
    
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    @StateObject var searchViewModel = SearchViewModel()
    
    @State var searchText = ""
    
    var body: some View {
        ScrollView {
            ScrollViewReader { proxy in
                LazyVStack(spacing: 35) {
                    ForEach(searchViewModel.users, id: \.username) { user in
                        NavigationLink(destination: Screen(user: user)) {
                            
                            VStack {
                                RoundedRectangle(cornerRadius: 25, style: .circular)
                                    .foregroundColor(authenticationViewModel.green[0])
                                    .frame(width: 350, height: 95)
                                
                                    .overlay {
                                        ZStack {
                                            HStack {
                                                ProfileImageManager(user: user, size: .small)
                                                
                                                VStack(alignment: .leading) {
                                                    Text(user.username)
                                                        .fontWeight(.semibold)
                                                        .kerning(2.5)
                                                    
                                                    if let name = user.name {
                                                        Text(name)
                                                    }
                                                }
                                            }
                                            .padding()
                                            .background(.white)
                                            .frame(width: 325, height: 82.5, alignment: .leading)
                                            .clipShape(RoundedRectangle(cornerRadius: 25))
                                        }
                                        .padding()
                                        .background(.white)
                                        .frame(width: 325, height: 82.5)
                                        .clipShape(RoundedRectangle(cornerRadius: 25))
                                        
                                        Spacer()
                                    }
                            }
                        }
                    }
                    .onChange(of: searchText, { oldValue, newValue in
                        withAnimation(.spring()) {
                            proxy.scrollTo(newValue, anchor: .top)
                        }
                    })
                }
                .padding(5)
                .padding(.top)
                .searchable(text: $searchText, prompt: "Search...")
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .background(LinearGradient(colors: [.clear, .clear, .clear, .clear, authenticationViewModel.violet[0].opacity(0.05)], startPoint: .top, endPoint: .bottom))
    }
}
