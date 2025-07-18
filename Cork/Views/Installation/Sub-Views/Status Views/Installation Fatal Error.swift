//
//  Installation Fatal Error.swift
//  Cork
//
//  Created by David Bureš - P on 24.01.2025.
//

import SwiftUI

struct InstallationFatalErrorView: View
{
    let packageBeingInstalled: BrewPackage

    var body: some View
    {
        ComplexWithIcon(systemName: "exclamationmark.triangle")
        {
            HeadlineWithSubheadline(
                headline: "add-package.fatal-error-\(packageBeingInstalled.name)",
                subheadline: "add-package.fatal-error.description",
                alignment: .leading
            )
        }
        .toolbar
        {
            ToolbarItem(placement: .destructiveAction)
            {
                Button
                {
                    restartApp()
                } label: {
                    Text("action.restart")
                }
            }
        }
    }
}
