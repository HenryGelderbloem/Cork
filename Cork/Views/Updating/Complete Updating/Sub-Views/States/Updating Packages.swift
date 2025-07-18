//
//  Updating Packages.swift
//  Cork
//
//  Created by David Bureš on 17.10.2023.
//

import SwiftUI

struct UpdatingPackagesStateView: View
{
    @Environment(AppState.self) var appState: AppState
    @Environment(OutdatedPackagesTracker.self) var outdatedPackagesTracker: OutdatedPackagesTracker
    @EnvironmentObject var updateProgressTracker: UpdateProgressTracker

    @ObservedObject var updateProcessDetailsStage: UpdatingProcessDetails

    @Binding var packageUpdatingStep: PackageUpdatingProcessSteps

    @Binding var isShowingRealTimeTerminalOutput: Bool

    var body: some View
    {
        VStack(alignment: .leading)
        {
            VStack(alignment: .leading, spacing: 3)
            {
                Text("update-packages.updating.updating")

                SubtitleText(text: updateProcessDetailsStage.currentStage.rawValue)
            }

            LiveTerminalOutputView(
                lineArray: $updateProgressTracker.realTimeOutput,
                isRealTimeTerminalOutputExpanded: $isShowingRealTimeTerminalOutput
            )
        }
        .task
        {
            await updatePackages(updateProgressTracker: updateProgressTracker, detailStage: updateProcessDetailsStage)

            packageUpdatingStep = .updatingOutdatedPackageTracker
        }
    }
}
