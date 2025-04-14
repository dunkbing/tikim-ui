//
//  Backport.swift
//  TikimUI
//
//  Created by Bùi Đặng Bình on 15/3/25.
//

import Foundation
import SwiftUI

public struct Backport<Content> {
    public let content: Content

    public init(_ content: Content) {
        self.content = content
    }
}

extension View {
    public var backport: Backport<Self> { Backport(self) }
}

extension Backport where Content: View {
    @available(macOS 12.0, *)
    @ViewBuilder func scrollContentBackground(_ visibility: Visibility) -> some View {
        if #available(iOS 16, macOS 13, *) {
            content.scrollContentBackground(visibility)
        } else {
            content
        }
    }

    @ViewBuilder func hideScrollIndicators() -> some View {
        if #available(iOS 16, macOS 13, *) {
            content.scrollIndicators(.hidden)
        } else {
            content
        }
    }

    @ViewBuilder
    public func hideNavigationBar() -> some View {
        #if os(iOS)
        content.navigationBarHidden(true)
        #endif
        content
    }

    @ViewBuilder func customBackNavigation(title: String, color: Color = Color.appAccent) -> some View {
        if #available(iOS 16, macOS 13, *) {
            content.navigationBarBackButtonHidden(true)
//                .toolbar {
//                    #if !os(macOS)
//                    ToolbarItem(placement: .navigationBarLeading) {
//                        BackButton(label: title, color: color)
//                    }
//                    #endif
//                }
        } else {
            content
        }
    }
}
