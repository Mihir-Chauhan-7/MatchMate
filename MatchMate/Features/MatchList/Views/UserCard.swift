//
//  PersonCard.swift
//  MatchMate
//
//  Created by Mihir Chauhan on 02/04/25.
//


import SwiftUI
import SDWebImageSwiftUI

struct UserCard: View {
    
    var user: People
    var status: Int
    var favouriteButtonPressed: ((_ isFavourite: Bool) -> Void)?
    
    init (user: People, status: Int, favouriteButtonPressed: ((_ isFavourite: Bool) -> Void)? = nil) {
        self.user = user
        self.status = status
        self.favouriteButtonPressed = favouriteButtonPressed
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .center, spacing: 0) {
                HStack {
                    WebImage(url: URL(string: user.imageLarge ?? "")) {
                        $0.resizable()
                    } placeholder: {
                        Rectangle().foregroundColor(.gray)
                    }.onSuccess { image, data, cacheType in
                        // Success
                        // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
                    }
                    .indicator(.activity) // Activity Indicator
                    //.transition(.fade(duration: 0.5)) // Fade Transition with duration
                    .scaledToFit()
                    .frame(width: 250, height: 250, alignment: .center)
                }
                Text("\(user.firstName ?? "") \(user.lastName ?? "")")
                    .foregroundColor(AppColors.appPrimaryColor)
                    .font(.title)
                    .padding(.top, 15)
                HStack {
                    Text(user.address != nil
                         ? "\(user.address ?? ""), \(user.city ?? ""), \(user.state ?? ""), \(user.country ?? "")"
                         : user.email ?? "")
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .foregroundColor(AppColors.appSecondaryColor)
                        .font(.subheadline)
                }
                .padding(.horizontal, 25)
                
                VStack {
                    if [1, 2].contains(status) {
                        Button {
                            // action will be here
                        } label: {
                            Text(status == 1 ? AppConstants.accepted : AppConstants.declined)
                                .foregroundColor(AppColors.appTextColor)
                                .font(.system(size: 16, weight: .semibold))
                                .frame(maxWidth: .infinity, minHeight: 52)
                                .background(status == 1 ? AppColors.appPrimaryColor : AppColors.appSecondaryColor)
                                .cornerRadius(15)
                        }.frame(width: 250)
                    }
                    else { HStack(spacing: 40) {
                        Button {
                            self.favouriteButtonPressed?(true)
                        } label: {
                            Image(systemName: AppImages.acceptIcon)
                                .resizable()
                                .frame(width: 52, height: 52)
                                .foregroundColor(AppColors.appPrimaryColor)
                                .background(AppColors.appTextColor)
                                .cornerRadius(26)
                        }
                        Button {
                            self.favouriteButtonPressed?(false)
                        } label: {
                            Image(systemName: AppImages.declineIcon)
                                .resizable()
                                .frame(width: 52, height: 52)
                                .foregroundColor(AppColors.appPrimaryColor)
                                .background(AppColors.appTextColor)
                                .cornerRadius(26)
                        }
                    }
                    }
                }.padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
            }
            .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
            .frame(width: 300, alignment: .center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .foregroundStyle(.ultraThinMaterial)
                .shadow(radius: 5)
        )
    }
}
