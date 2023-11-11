//
//  PostItemView.swift
//  Pangea
//
//  Created by Lillian Cain on 10/22/23.
//

import SwiftUI
import Kingfisher

struct PostItemView: View {
    @StateObject var postItemViewModel: PostItemViewModel
    
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    init(user: User) {
        self._postItemViewModel = StateObject(wrappedValue: PostItemViewModel(user: user))
    }
    
    private let gridItems: [GridItem] = [.init(.flexible(), spacing: 5), .init(.flexible(), spacing: 5)]
    private let imageDimension: CGFloat = (UIScreen.main.bounds.width / 2) - 2.5
    
    var body: some View {
        LazyVGrid(columns: gridItems, spacing: 5) {
            ForEach(postItemViewModel.posts) { post in
                KFImage(URL(string: post.imageUrl))
                    .resizable()
                    .scaledToFill()
                    .frame(width: imageDimension, height: imageDimension)
                    .clipped()
            }
        }
    }
}
