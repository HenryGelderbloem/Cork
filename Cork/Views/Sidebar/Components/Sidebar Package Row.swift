//
//  Sidebar Package Row.swift
//  Cork
//
//  Created by Seb Jachec on 08/09/2023.
//

import CorkShared
import SwiftUI
import Defaults

struct SidebarPackageRow: View
{
    let package: BrewPackage

    @Default(.enableSwipeActions) var enableSwipeActions: Bool

    @Environment(AppState.self) var appState: AppState
    @Environment(BrewPackagesTracker.self) var brewPackagesTracker: BrewPackagesTracker
    @Environment(OutdatedPackagesTracker.self) var outdatedPackagesTracker: OutdatedPackagesTracker

    var body: some View
    {
        NavigationLink(value: package)
        {
            PackageListItem(packageItem: package)
        }
        .contextMenu
        {
            SidebarContextMenu(package: package)
        }
        .modify
        { viewProxy in
            if enableSwipeActions
            {
                viewProxy
                    .swipeActions(edge: .leading, allowsFullSwipe: false)
                    {
                        TagUntagButton(package: package)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false)
                    {
                        PurgePackageButton(package: package)
                            .tint(.red)
                        
                        UninstallPackageButton(package: package)
                            .tint(.orange)
                    }
            }
            else
            {
                viewProxy
            }
        }
    }
}
