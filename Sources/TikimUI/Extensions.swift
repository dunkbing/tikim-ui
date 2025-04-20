//
//  Extensions.swift
//  TikimUI
//
//  Created by Bùi Đặng Bình on 20/4/25.
//

import SwiftUI

public extension String {
    public var localized: LocalizedStringKey {
        return LocalizedStringKey(self)
    }

    public func localized(with arguments: CVarArg...) -> LocalizedStringKey {
        return LocalizedStringKey(String(format: self, arguments))
    }
}
