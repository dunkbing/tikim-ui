//
//  KeyboardManager.swift
//  TikimUI
//
//  Created by Bùi Đặng Bình on 16/3/25.
//

import SwiftUI

#if os(iOS)
import UIKit

// MARK: - Keyboard Manager

@MainActor
class KeyboardManager: ObservableObject {
    @Published var keyboardHeight: CGFloat = 0
    @Published var isVisible = false
    private var cancellables: [NSObjectProtocol] = []

    init() {
        let showObserver = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self = self,
                  let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
                return
            }

            Task { @MainActor in
                self.keyboardHeight = keyboardFrame.height
                self.isVisible = true
            }
        }

        let hideObserver = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }

            Task { @MainActor in
                self.keyboardHeight = 0
                self.isVisible = false
            }
        }

        cancellables = [showObserver, hideObserver]

        // Store observers in UserDefaults to ensure they're removed
        cleanupOnDeinit()
    }

    private func cleanupOnDeinit() {
        // Create a copy of the observers that can be safely accessed outside the actor
        let observersCopy = cancellables

        // Use runtime mechanisms to ensure these get cleaned up
        let cleanupBlock: @convention(block) () -> Void = {
            for observer in observersCopy {
                NotificationCenter.default.removeObserver(observer)
            }
        }

        // Use objc_setAssociatedObject to attach the cleanup block to self
        objc_setAssociatedObject(self, "keyboardManagerCleanup", cleanupBlock, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

// MARK: - View Modifiers

/// A view modifier that adds padding to account for the keyboard
struct KeyboardAwareModifier: ViewModifier {
    @StateObject private var keyboard = KeyboardManager()
    
    func body(content: Content) -> some View {
        content
            .padding(.bottom, keyboard.isVisible ? keyboard.keyboardHeight - 20 : 0)
            .animation(.easeOut(duration: 0.25), value: keyboard.isVisible)
    }
}

/// A view modifier to dismiss the keyboard when tapping outside a text field
struct DismissKeyboardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), 
                                               to: nil, from: nil, for: nil)
            }
    }
}

// MARK: - View Extensions

public extension View {
    /// Make the view aware of the keyboard and adjust its position accordingly
    public func keyboardAware() -> some View {
        self.modifier(KeyboardAwareModifier())
    }
    
    /// Dismiss the keyboard when tapping outside text fields
    public func dismissKeyboardOnTap() -> some View {
        self.modifier(DismissKeyboardModifier())
    }
}
#endif
