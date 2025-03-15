//
//  AppTheme.swift
//  TikimUI
//
//  Created by Bùi Đặng Bình on 15/3/25.
//

import SwiftUI

struct CatppuccinColors {
    struct Latte {
        static let rosewater = Color(hex: "#dc8a78")
        static let flamingo = Color(hex: "#dd7878")
        static let pink = Color(hex: "#ea76cb")
        static let mauve = Color(hex: "#8839ef")
        static let red = Color(hex: "#d20f39")
        static let maroon = Color(hex: "#e64553")
        static let peach = Color(hex: "#fe640b")
        static let yellow = Color(hex: "#df8e1d")
        static let green = Color(hex: "#40a02b")
        static let teal = Color(hex: "#179299")
        static let sky = Color(hex: "#04a5e5")
        static let sapphire = Color(hex: "#209fb5")
        static let blue = Color(hex: "#1e66f5")
        static let lavender = Color(hex: "#7287fd")

        static let text = Color(hex: "#4c4f69")
        static let subtext1 = Color(hex: "#5c5f77")
        static let subtext0 = Color(hex: "#6c6f85")
        static let overlay2 = Color(hex: "#7c7f93")
        static let overlay1 = Color(hex: "#8c8fa1")
        static let overlay0 = Color(hex: "#9ca0b0")
        static let surface2 = Color(hex: "#acb0be")
        static let surface1 = Color(hex: "#bcc0cc")
        static let surface0 = Color(hex: "#ccd0da")
        static let base = Color(hex: "#eff1f5")
        static let mantle = Color(hex: "#e6e9ef")
        static let crust = Color(hex: "#dce0e8")
    }

    struct Macchiato {
        static let rosewater = Color(hex: "#f4dbd6")
        static let flamingo = Color(hex: "#f0c6c6")
        static let pink = Color(hex: "#f5bde6")
        static let mauve = Color(hex: "#c6a0f6")
        static let red = Color(hex: "#ed8796")
        static let maroon = Color(hex: "#ee99a0")
        static let peach = Color(hex: "#f5a97f")
        static let yellow = Color(hex: "#eed49f")
        static let green = Color(hex: "#a6da95")
        static let teal = Color(hex: "#8bd5ca")
        static let sky = Color(hex: "#91d7e3")
        static let sapphire = Color(hex: "#7dc4e4")
        static let blue = Color(hex: "#8aadf4")
        static let lavender = Color(hex: "#b7bdf8")

        static let text = Color(hex: "#cad3f5")
        static let subtext1 = Color(hex: "#b8c0e0")
        static let subtext0 = Color(hex: "#a5adcb")
        static let overlay2 = Color(hex: "#939ab7")
        static let overlay1 = Color(hex: "#8087a2")
        static let overlay0 = Color(hex: "#6e738d")
        static let surface2 = Color(hex: "#5b6078")
        static let surface1 = Color(hex: "#494d64")
        static let surface0 = Color(hex: "#363a4f")
        static let base = Color(hex: "#24273a")
        static let mantle = Color(hex: "#1e2030")
        static let crust = Color(hex: "#181926")
    }
}

// Extension to create colors from hex values
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a: UInt64
        let r: UInt64
        let g: UInt64
        let b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    public static var appBackground: Color {
        AppColors.dynamicColor(
            light: CatppuccinColors.Latte.base, dark: CatppuccinColors.Macchiato.base)
    }

    public static var appText: Color {
        AppColors.dynamicColor(
            light: CatppuccinColors.Latte.text, dark: CatppuccinColors.Macchiato.text)
    }

    public static var appSubtitle: Color {
        AppColors.dynamicColor(
            light: CatppuccinColors.Latte.subtext0, dark: CatppuccinColors.Macchiato.subtext0)
    }

    public static var appAccent: Color {
        AppColors.dynamicColor(
            light: CatppuccinColors.Latte.blue, dark: CatppuccinColors.Macchiato.blue)
    }

    public static var appSecondaryAccent: Color {
        AppColors.dynamicColor(
            light: CatppuccinColors.Latte.mauve, dark: CatppuccinColors.Macchiato.mauve)
    }

    public static var appGreen: Color {
        AppColors.dynamicColor(
            light: CatppuccinColors.Latte.green, dark: CatppuccinColors.Macchiato.green)
    }

    public static var appRed: Color {
        AppColors.dynamicColor(
            light: CatppuccinColors.Latte.red, dark: CatppuccinColors.Macchiato.red)
    }

    public static var appOrange: Color {
        AppColors.dynamicColor(
            light: CatppuccinColors.Latte.peach, dark: CatppuccinColors.Macchiato.peach)
    }

    public static var appYellow: Color {
        AppColors.dynamicColor(
            light: CatppuccinColors.Latte.yellow, dark: CatppuccinColors.Macchiato.yellow)
    }

    public static var appSurface: Color {
        AppColors.dynamicColor(
            light: CatppuccinColors.Latte.surface0, dark: CatppuccinColors.Macchiato.surface0)
    }

    public static var appSurface1: Color {
        AppColors.dynamicColor(
            light: CatppuccinColors.Latte.surface1, dark: CatppuccinColors.Macchiato.surface1)
    }

    public static var appSurface2: Color {
        AppColors.dynamicColor(
            light: CatppuccinColors.Latte.surface2, dark: CatppuccinColors.Macchiato.surface2)
    }

    public static var appCrust: Color {
        AppColors.dynamicColor(
            light: CatppuccinColors.Latte.crust, dark: CatppuccinColors.Macchiato.crust)
    }

    public static var appMantle: Color {
        AppColors.dynamicColor(
            light: CatppuccinColors.Latte.mantle, dark: CatppuccinColors.Macchiato.mantle)
    }
}

class AppColors {
    static func dynamicColor(light: Color, dark: Color) -> Color {
        let theme = getCurrentTheme()

        switch theme {
        case .light:
            return light
        case .dark:
            return dark
        case .system:
            #if os(iOS)
                return UITraitCollection.current.userInterfaceStyle == .dark ? dark : light
            #elseif os(macOS)
                return NSAppearance.current.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua ? dark : light
            #else
                return light
            #endif
        }
    }

    // Helper method to safely get the current theme
    private static func getCurrentTheme() -> AppTheme {
        // First check UserDefaults directly
        if let themeName = UserDefaults.standard.string(forKey: "appTheme"),
           let theme = AppTheme(rawValue: themeName) {
            return theme
        }
        // Fallback to system if can't determine
        return .system
    }

    // App theme colors
    static var appBackground: Color {
        dynamicColor(light: CatppuccinColors.Latte.base, dark: CatppuccinColors.Macchiato.base)
    }

    static var appText: Color {
        dynamicColor(light: CatppuccinColors.Latte.text, dark: CatppuccinColors.Macchiato.text)
    }

    static var appSubtitle: Color {
        dynamicColor(
            light: CatppuccinColors.Latte.subtext0, dark: CatppuccinColors.Macchiato.subtext0)
    }

    static var appAccent: Color {
        dynamicColor(light: CatppuccinColors.Latte.blue, dark: CatppuccinColors.Macchiato.blue)
    }

    static var appSecondaryAccent: Color {
        dynamicColor(light: CatppuccinColors.Latte.mauve, dark: CatppuccinColors.Macchiato.mauve)
    }

    static var appGreen: Color {
        dynamicColor(light: CatppuccinColors.Latte.green, dark: CatppuccinColors.Macchiato.green)
    }

    static var appRed: Color {
        dynamicColor(light: CatppuccinColors.Latte.red, dark: CatppuccinColors.Macchiato.red)
    }

    static var appOrange: Color {
        dynamicColor(light: CatppuccinColors.Latte.peach, dark: CatppuccinColors.Macchiato.peach)
    }

    static var appYellow: Color {
        dynamicColor(light: CatppuccinColors.Latte.yellow, dark: CatppuccinColors.Macchiato.yellow)
    }

    static var appSurface: Color {
        dynamicColor(
            light: CatppuccinColors.Latte.surface0, dark: CatppuccinColors.Macchiato.surface0)
    }

    static var appSurface1: Color {
        dynamicColor(
            light: CatppuccinColors.Latte.surface1, dark: CatppuccinColors.Macchiato.surface1)
    }

    static var appSurface2: Color {
        dynamicColor(
            light: CatppuccinColors.Latte.surface2, dark: CatppuccinColors.Macchiato.surface2)
    }

    static var appCrust: Color {
        dynamicColor(light: CatppuccinColors.Latte.crust, dark: CatppuccinColors.Macchiato.crust)
    }

    static var appMantle: Color {
        dynamicColor(light: CatppuccinColors.Latte.mantle, dark: CatppuccinColors.Macchiato.mantle)
    }
}
