//
//  CustomBackButton.swift
//  TikimUI
//
//  Created by Bùi Đặng Bình on 17/3/25.
//

import SwiftUI

struct CustomBackButton: View {
    @Environment(\.presentationMode) var presentationMode
    var label: String = "Back"
    var color: Color = Color.appAccent
    
    var body: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack(spacing: 6) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                Text(label)
                    .fontWeight(.medium)
            }
            .foregroundColor(color)
            .padding(.vertical, 10)
            .padding(.horizontal, 14)
            .background(Color.appSurface.opacity(0.5))
            .cornerRadius(10)
        }
    }
}

// Extension to use with NavigationView
extension View {
    func customBackNavigation(title: String, color: Color = Color.appAccent) -> some View {
        self.navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    CustomBackButton(label: title, color: color)
                }
            }
    }
}

// For sheets that need custom dismissal
struct CustomDismissButton: View {
    @Binding var isPresented: Bool
    var label: String = "Cancel"
    var color: Color = Color.appRed
    
    var body: some View {
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
