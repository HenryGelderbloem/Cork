//
//  Outdated Package.swift
//  Cork
//
//  Created by David Bureš on 15.03.2023.
//

import Foundation
import SwiftUI
import Defaults
import DefaultsMacros

@Observable @MainActor
class OutdatedPackagesTracker
{
    @ObservableDefault(.displayOnlyIntentionallyInstalledPackagesByDefault) @ObservationIgnored var displayOnlyIntentionallyInstalledPackagesByDefault: Bool
    
    @ObservableDefault(.includeGreedyOutdatedPackages) @ObservationIgnored var includeGreedyOutdatedPackages: Bool

    var outdatedPackages: Set<OutdatedPackage> = .init()

    var displayableOutdatedPackages: Set<OutdatedPackage>
    {
        /// Depending on whether greedy updating is enabled:
        /// - If enabled, include packages that are also self-updating
        /// - If disabled, include only packages whose updates are managed by Homebrew
        var relevantOutdatedPackages: Set<OutdatedPackage>
        
        if includeGreedyOutdatedPackages
        {
            relevantOutdatedPackages = outdatedPackages
        }
        else
        {
            relevantOutdatedPackages = outdatedPackages.filter{ $0.updatingManagedBy == .homebrew }
        }
        
        if displayOnlyIntentionallyInstalledPackagesByDefault
        {
            return relevantOutdatedPackages.filter(\.package.installedIntentionally)
        }
        else
        {
            return relevantOutdatedPackages
        }
    }
}

extension OutdatedPackagesTracker
{
    func setOutdatedPackages(to packages: Set<OutdatedPackage>)
    {
        self.outdatedPackages = packages
    }
}
