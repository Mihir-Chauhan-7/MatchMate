//
//  ContentView.swift
//  MatchMate
//
//  Created by Mihir Chauhan on 02/04/25.
//

import SwiftUI
import CoreData
import SDWebImageSwiftUI

struct MatchListView: View {
    @State private var isLoadMore = false
    @State private var isFinishAlertVisible: Bool = false

    private let gridSpacing: CGFloat = 10
    private let gridItemPadding: CGFloat = 15
       private let loadMoreDelay: Double = 1.5
    let threeColumnGrid = [GridItem(.flexible())]
    
    @StateObject var viewModel = MatchListViewModel()
    
    var body: some View {
        VStack {
            if viewModel.isLoading && viewModel.isEmptyData {
                progressView()
            } else if viewModel.isError {
                noDataView(title: AppConstants.errorFetching, icon: AppImages.errorHeart, description: AppConstants.descriptionTryAgain)
            } else if viewModel.users.count > 0 {
                matchList()
            }
            else {
                noDataView(title: AppConstants.noMatchFound, icon: AppImages.noDataHeart, description: AppConstants.descriptionTryAgain)
            }
        }.task {
            viewModel.getUsers()
        }.alert(isPresented: $viewModel.isFinishAlertVisible) {
            Alert(title: Text(AppConstants.noMoreMatch), dismissButton: .default(Text(AppConstants.gotIt)))
        }
        
        if viewModel.isLoading && !viewModel.isEmptyData {
            progressView()
        }
    }
    
    @ViewBuilder
    func matchList() -> some View {
        ScrollView {
            LazyVGrid(columns: threeColumnGrid, spacing: gridSpacing) {
                ForEach(viewModel.users.indices, id: \.self) { index in
                    var user = viewModel.users[index]
                    UserCard(user: user, status: viewModel.getStatus(email: user.email ?? ""), favouriteButtonPressed: { isFavourite in
                        guard let email = user.email else { return }
                        viewModel.updateProfile(email: email, status: isFavourite ? MatchAcceptDeclineStatus.accepted.rawValue : MatchAcceptDeclineStatus.declined.rawValue)
                    }).onAppear() {
                        self.loadMoreIfNeeded(currentIndex: index)
                    }
                }
            }
            .padding(.horizontal, gridItemPadding)
        }
    }
    
    @ViewBuilder
    func noDataView(title: String, icon: String, description: String) -> some View {
        ContentUnavailableView(
            title,
            systemImage: icon,
            description: Text(description)
        )
    }
    
    @ViewBuilder
    func progressView() -> some View {
        ProgressView(AppConstants.loadingMore)
            .foregroundStyle(AppColors.appPrimaryColor)
            .tint(AppColors.appPrimaryColor)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
    }

    
    private func loadMoreIfNeeded(currentIndex: Int) {
        guard !isLoadMore else { return }
        viewModel.loadMoreUsers(currentIndex: currentIndex)
    }
}
