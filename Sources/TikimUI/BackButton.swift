//
//  CustomBackButton.swift
//  TikimUI
//
//  Created by Bùi Đặng Bình on 17/3/25.
//

import SwiftUI

public struct BackButton: View {
    @Environment(\.presentationMode) var presentationMode
    var label: String = ""
    var color: Color = Color.appAccent

    public init(label: String) {
        self.label = label
    }

    public init() {}

    public var body: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack(spacing: 6) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                if !label.isEmpty {
                    Text(LocalizedStringKey(label))
                        .fontWeight(.medium)
                }
            }
            .foregroundColor(color)
            .padding(.vertical, 10)
            .padding(.horizontal, 14)
            .background(Color.appSurface.opacity(0.5))
            .cornerRadius(10)
        }
    }
}

public struct DismissButton: View {
    @Binding var isPresented: Bool
    var label: String = "Cancel"
    var color: Color = Color.appRed

    public init(isPresented: Binding<Bool>, label: String) {
        self._isPresented = isPresented
        self.label = label
    }

    public var body: some View {
        Button(action: {
            isPresented = false
        }) {
            HStack(spacing: 6) {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .bold))
                Text(label)
                    .fontWeight(.medium)
            }
            .foregroundColor(color)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(color.opacity(0.1))
            .cornerRadius(10)
        }
    }
}
