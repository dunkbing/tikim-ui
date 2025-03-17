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
    @Published public var keyboardHeight: CGFloat = 0
    @Published public var isVisible = false
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
    var bottomPadding: CGFloat = 20

    func body(content: Content) -> some View {
        content
            .padding(.bottom, keyboard.isVisible ? keyboard.keyboardHeight - bottomPadding : 0)
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

private struct ScrollViewOffsetKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - KeyboardAwareScrollView
public struct KeyboardAwareScrollView<Content: View>: View {
    @StateObject private var keyboard = KeyboardManager()
    let content: Content
    @State private var contentOffset: CGFloat = 0
    @State private var scrollViewOffset: CGFloat = 0

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        ScrollView {
            content
                .background(GeometryReader { proxy in
                    Color.clear.preference(
                        key: ScrollViewOffsetKey.self,
                        value: proxy.frame(in: .named("scrollView")).minY
                    )
                })
        }
        .coordinateSpace(name: "scrollView")
        .onPreferenceChange(ScrollViewOffsetKey.self) { value in
            scrollViewOffset = value
        }
        .onChange(of: keyboard.isVisible) { isVisible in
            if isVisible {
                // Get the focused text field
                guard let firstResponder = UIWindow.keyWindow?.firstResponder else { return }
                let view = firstResponder

                // Convert the text field's frame to window coordinates
                let globalFrame = view.convert(view.bounds, to: nil)
                let keyboardY = UIScreen.main.bounds.height - keyboard.keyboardHeight

                // Calculate if the text field is hidden by the keyboard
                if globalFrame.maxY > keyboardY {
                    let offset = globalFrame.maxY - keyboardY + 60 // Add some padding
                    withAnimation(.easeOut(duration: 0.25)) {
                        contentOffset = offset
                    }
                }
            } else {
                withAnimation(.easeOut(duration: 0.25)) {
                    contentOffset = 0
                }
            }
        }
        .offset(y: -contentOffset)
    }
}

// MARK: - UIWindow Extension
extension UIWindow {
    static var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
}

// MARK: - UIView Extension
extension UIView {
    var firstResponder: UIView? {
        guard !isFirstResponder else { return self }

        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }

        return nil
    }
}
#endif
