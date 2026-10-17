//
//  TabEnum.swift
//  feather
//
//  Created by samara on 22.03.2025.
//  Modified by Sajjad (idk)
//

import SwiftUI
import NimbleViews

enum TabEnum: String, CaseIterable, Hashable {
    case library
    case files
    case appstore
    case downloader
    case certificates
    case sources
    case settings
    case developer

    var title: String {
        switch self {
        case .library:      return .localized("Library")
        case .files:        return .localized("Signing & Files")
        case .appstore:     return .localized("App Store")
        case .downloader:   return .localized("Downloads")
        case .certificates: return .localized("Certificates")
        case .sources:      return .localized("Sources")
        case .settings:     return .localized("Settings")
        case .developer:    return .localized("Developer")
        }
    }
    
    var icon: String {
        switch self {
        case .library:      return "square.stack.3d.up.fill"
        case .files:        return "doc.badge.gearshape.fill"
        case .appstore:     return "sparkles.rectangle.stack.fill"
        case .downloader:   return "arrow.down.circle.fill"
        case .certificates: return "person.badge.shield.checkmark.fill"
        case .sources:      return "network"
        case .settings:     return "gearshape.fill"
        case .developer:    return "person.crop.circle.fill"
        }
    }
    
    @ViewBuilder
    static func view(for tab: TabEnum) -> some View {
        switch tab {
        case .library:      LibraryView()
        case .files:        FilesView()
        case .appstore:     AppstoreView()
        case .downloader:   DownloaderView()
        case .certificates: NBNavigationView(.localized("Certificates")) { CertificatesView() }
        case .sources:      SourcesView()
        case .settings:     SettingsView()
        case .developer:    DeveloperInfoView()
        }
    }
    
    static var defaultTabs: [TabEnum] {
        return [
            .library,
            .files,
            .appstore,
            .downloader,
            .settings
        ]
    }
    
    static var customizableTabs: [TabEnum] {
        return [
            .certificates,
            .sources,
            .developer
        ]
    }
}