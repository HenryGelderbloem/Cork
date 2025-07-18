//
//  Licensing View.swift
//  Cork
//
//  Created by David Bureš on 18.03.2024.
//

import CorkShared
import SwiftUI
import Defaults

struct LicensingView: View
{
    @Default(.demoActivatedAt) var demoActivatedAt: Date?
    @Default(.hasValidatedEmail) var hasValidatedEmail: Bool

    @Environment(AppState.self) var appState: AppState

    var body: some View
    {
        VStack
        {
            switch appState.licensingState
            {
            case .notBoughtOrHasNotActivatedDemo:
                Licensing_NotBoughtOrActivatedView()
            case .demo:
                Licensing_DemoView()
            case .bought:
                Licensing_BoughtView()
            case .selfCompiled:
                Licensing_SelfCompiledView()
            }
        }
        .onAppear
        {
            #if SELF_COMPILED
                appState.licensingState = .selfCompiled
            #else

                AppConstants.shared.logger.debug("Has validated email? \(hasValidatedEmail ? "YES" : "NO")")

                if hasValidatedEmail
                {
                    appState.licensingState = .bought
                }
                else
                {
                    if let demoActivatedAt
                    {
                        if ((demoActivatedAt.timeIntervalSinceNow) + AppConstants.shared.demoLengthInSeconds) > 0
                        { // Check if there is still time on the demo
                            appState.licensingState = .demo
                        }
                        else
                        {
                            appState.licensingState = .notBoughtOrHasNotActivatedDemo
                        }
                    }
                }
            #endif
        }
    }
}
