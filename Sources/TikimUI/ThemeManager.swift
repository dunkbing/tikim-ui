//
//  ColorTheme.swift
//  viqr
//
//  Created by Bùi Đặng Bình on 14/3/25.
//

import SwiftUI

public enum AppTheme: String, CaseIterable, Identifiable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"

    public var id: String { self.rawValue }

    public var icon: String {
        switch self {
        case .system: return "circle.lefthalf.filled"
        case .light: return "sun.max.fill"
        case .dark: return "moon.fill"
        }
    }
}

@MainActor
public class ThemeManager: ObservableObject {
    public static let shared = ThemeManager()

    @Published public var theme: AppTheme {
        didSet {
            UserDefaults.standard.set(theme.rawValue, forKey: "appTheme")
            applyTheme()
        }
    }

    public init() {
        // Initialize with saved theme or use system default
        let savedTheme =
            UserDefaults.standard.string(forKey: "appTheme") ?? AppTheme.system.rawValue
        self.theme = AppTheme(rawValue: savedTheme) ?? .system
        applyTheme()
    }

    private func applyTheme() {
        #if os(iOS)
            // Set the UIKit user interface style - only works on iOS
            let scenes = UIApplication.shared.connectedScenes
            if let windowScene = scenes.first as? UIWindowScene,
                let window = windowScene.windows.first
            {
                window.overrideUserInterfaceStyle = userInterfaceStyle
            }
        #endif
    }

    #if os(iOS)
        var userInterfaceStyle: UIUserInterfaceStyle {
            switch theme {
            case .system:
                return .unspecified
            case .light:
                return .light
            case .dark:
                return .dark
            }
        }
    #endif

    public var colorScheme: ColorScheme? {
        switch theme {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

public struct ThemeAwareModifier: ViewModifier {
    @ObservedObject private var themeManager = ThemeManager.shared

    public func body(content: Content) -> some View {
        content
            .environment(\.colorScheme, themeManager.colorScheme ?? .light)
            .preferredColorScheme(themeManager.colorScheme)
            .id("theme-\(themeManager.theme)") // Force view recreation on theme change
    }
}

public extension View {
    func withTheming() -> some View {
        self.modifier(ThemeAwareModifier())
    }
}
