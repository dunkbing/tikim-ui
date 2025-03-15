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
    var backport: Backport<Self> { Backport(self) }
}

extension Backport where Content: View {
    @ViewBuilder func scrollContentBackground(_ visibility: Visibility) -> some View {
        if #available(iOS 16, *) {
            content.scrollContentBackground(visibility)
        } else {
            content
        }
    }

    @ViewBuilder func hideScrollIndicators() -> some View {
        if #available(iOS 16, *) {
            content.scrollIndicators(.hidden)
        } else {
            content
        }
    }
}
