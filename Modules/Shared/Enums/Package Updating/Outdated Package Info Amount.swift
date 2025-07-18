//
//  Outdated Package Info Amount.swift
//  Cork
//
//  Created by David Bureš on 17.07.2024.
//

import Foundation
import Defaults

public enum OutdatedPackageInfoAmount: String, Identifiable, Codable, CaseIterable, Defaults.Serializable
{
    public var id: Self
    {
        self
    }

    case none, versionOnly, all

    public var localizedName: String
    {
        switch self
        {
        case .none:
            return String(localized: "settings.general.outdated-packages.display-amount.none")
        case .versionOnly:
            return String(localized: "settings.general.outdated-packages.display-amount.version-only")
        case .all:
            return String(localized: "settings.general.outdated-packages.display-amount.all")
        }
    }
}
