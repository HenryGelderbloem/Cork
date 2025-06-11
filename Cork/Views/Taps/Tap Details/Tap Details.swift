//
//  Tap Details.swift
//  Cork
//
//  Created by David Bureš on 12.03.2023.
//

import SwiftUI
import CorkShared
import ButtonKit

struct TapDetailView: View, Sendable
{
    let tap: BrewTap

    @Environment(AppState.self) var appState: AppState
    @Environment(TapTracker.self) var tapTracker: TapTracker

    @State private var isLoadingTapInfo: Bool = true
    
    @State var tapInfo: TapInfo?

    @State private var erroredOut: Bool = false
    @State private var errorOutReason: String = ""

    var body: some View
    {
        VStack(alignment: .leading)
        {
            if isLoadingTapInfo
            {
                HStack(alignment: .center)
                {
                    VStack(alignment: .center)
                    {
                        ProgressView
                        {
                            Text("tap-details.loading")
                        }
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            }
            else
            {
                if erroredOut
                { /// Show this if there was an error during the info loading process
                    InlineFatalError(errorMessage: "alert.generic.couldnt-parse-json", errorDescription: errorOutReason)
                }
                else
                {
                    if let tapInfo
                    {
                        VStack(alignment: .leading, spacing: 10)
                        {
                            FullSizeGroupedForm
                            {
                                TapDetailsInfo(
                                    tap: tap,
                                    tapInfo: tapInfo
                                )
                                
                                TapDetailsIncludedPackages(includedFormulae: tapInfo.formulaNames, includedCasks: tapInfo.caskTokens)
                            }
                            .scrollDisabled(true)
                            
                            ButtonBottomRow
                            {
                                Spacer()
                                
                                AsyncButton
                                {
                                    try await removeTap(name: tap.name, tapTracker: tapTracker, appState: appState)
                                } label: {
                                    Text("tap-details.remove-\(tap.name)")
                                }
                                .asyncButtonStyle(.trailing)
                                .disabledWhenLoading()
                            }
                        }
                    }
                    else
                    {
                        InlineFatalError(errorMessage: "alert.generic.couldnt-parse-json", errorDescription: errorOutReason)
                    }
                }
            }
        }
        .frame(minWidth: 450, minHeight: 400, alignment: .topLeading)
        .task(id: tap.id)
        {
            isLoadingTapInfo = true
            
            defer
            {
                isLoadingTapInfo = false
            }

            async let tapInfoRaw: String = await shell(AppConstants.shared.brewExecutablePath, ["tap-info", "--json", tap.name]).standardOutput

            do
            {
                tapInfo = try await parseTapInfo(from: tapInfoRaw)
            }
            catch let parsingError
            {
                AppConstants.shared.logger.error("Failed while parsing package info: \(parsingError, privacy: .public)")

                errorOutReason = parsingError.localizedDescription

                erroredOut = true
            }
        }
    }
}
