//
//  Settings.swift
//  TikimUI
//
//  Created by Bùi Đặng Bình on 7/4/25.
//

import SwiftUI

public struct SettingsSection<Content: View>: View {
    let title: String
    let icon: String
    let content: Content

    public init(title: String, icon: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color.appAccent)
                    .padding(8)
                    .background(Color.appAccent.opacity(0.1))
                    .clipShape(Circle())

                Text(title)
                    .font(.headline)
                    .foregroundColor(Color.appText)
            }
            .padding(.horizontal)

            content
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.appMantle)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.appAccent.opacity(0.15), lineWidth: 1)
                )
        }
        .padding(.horizontal)
    }
}

public struct SettingRow<Content: View>: View {
    let title: String
    let content: Content

    public init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(Color.appSubtitle)

            content
        }
    }
}

public struct ThemeButton: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let theme: AppTheme

    public init(theme: AppTheme) {
        self.theme = theme
    }

    public var body: some View {
        let isSelected = themeManager.theme == theme

        Button(action: {
            themeManager.theme = theme
        }) {
            VStack(spacing: 8) {
                Image(systemName: theme.icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? Color.appAccent : Color.appText)

                Text(theme.rawValue)
                    .font(.caption)
                    .foregroundColor(isSelected ? Color.appAccent : Color.appText)
            }
            .frame(width: 80, height: 70)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        isSelected
                            ? Color.appAccent.opacity(0.1) : Color.appSurface2.opacity(0.5))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

public struct AppearanceSetting: View {
    public init() {}

    public var body: some View {
        SettingsSection(title: "Appearance", icon: "paintpalette") {
                VStack(spacing: 16) {
                    HStack {
                        Text("App Theme")
                            .foregroundColor(Color.appText)
                            .font(.headline)
                        Spacer()
                    }

                    HStack(spacing: 20) {
                        ForEach(AppTheme.allCases) { theme in
                            ThemeButton(theme: theme)
                        }
                        Spacer()
                    }
                }
                .padding()
            }
    }
}

public struct FeatureRow: View {
    let icon: String
    let text: String

    public init(icon: String, text: String) {
        self.icon = icon
        self.text = text
    }

    public var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(Color.appAccent)
                .frame(width: 24, height: 24)

            Text(text)
                .foregroundColor(Color.appText)
                .fixedSize(horizontal: false, vertical: true)

            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}

// MARK: - Custom Group Box Style
public struct CatppuccinGroupBoxStyle: GroupBoxStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
                .padding(.bottom, 4)

            configuration.content
        }
        .padding()
        .background(Color.appSurface)
        .cornerRadius(12)
    }
}

// MARK: - Custom Navigation Bar
public struct CustomNavigationBar<LeadingContent: View, TrailingContent: View>: View {
    var title: String
    var leadingContent: LeadingContent
    var trailingContent: TrailingContent

    public init(
        title: String,
        @ViewBuilder leadingContent: () -> LeadingContent,
        @ViewBuilder trailingContent: () -> TrailingContent
    ) {
        self.title = title
        self.leadingContent = leadingContent()
        self.trailingContent = trailingContent()
    }

    public var body: some View {
        HStack {
            leadingContent

            Spacer()

            Text(title)
                .font(.headline)
                .foregroundColor(Color.appText)

            Spacer()

            trailingContent
        }
        .padding()
        .background(Color.appBackground)
    }
}

// Convenience initializer with just a title
extension CustomNavigationBar where LeadingContent == EmptyView, TrailingContent == EmptyView {
    public init(title: String) {
        self.init(
            title: title,
            leadingContent: { EmptyView() },
            trailingContent: { EmptyView() }
        )
    }
}
