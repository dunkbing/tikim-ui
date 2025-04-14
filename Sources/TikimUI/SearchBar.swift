//
//  SearchBar.swift
//  TikimUI
//
//  Created by Bùi Đặng Bình on 6/4/25.
//

import Combine
import SwiftUI

public struct SearchBar: View {
    @Binding var text: String
    var placeholder: String
    var onCommit: (() -> Void)? = nil
    var onSearchTextChanged: ((String) -> Void)? = nil
    var onFocusChange: ((Bool) -> Void)? = nil
    var debounceTime: TimeInterval = 0.5

    // Animation states
    @State private var isFocused: Bool = false
    @FocusState private var isTextFieldFocused: Bool

    // Debouncing properties
    @State private var searchText: String = ""
    @State private var debouncedText: String = ""
    @State private var searchPublisher = PassthroughSubject<String, Never>()
    @State private var cancellables = Set<AnyCancellable>()

    public init(
        text: Binding<String>,
        placeholder: String,
        onCommit: (() -> Void)? = nil,
        onSearchTextChanged: ((String) -> Void)? = nil,
        onFocusChange: ((Bool) -> Void)? = nil,
        debounceTime: TimeInterval = 0.5
    ) {
        self._text = text
        self.placeholder = placeholder
        self.onCommit = onCommit
        self.onSearchTextChanged = onSearchTextChanged
        self.onFocusChange = onFocusChange
        self.debounceTime = debounceTime
        self._searchText = State(initialValue: text.wrappedValue)
        self._debouncedText = State(initialValue: text.wrappedValue)
    }

    public var body: some View {
        #if os(macOS)
            macSearchBar
        #else
            iosSearchBar
        #endif
    }

    #if os(macOS)
        private var macSearchBar: some View {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isFocused ? Color.appAccent : Color.appSubtitle)
                    .animation(.easeInOut(duration: 0.2), value: isFocused)

                TextField(placeholder, text: $searchText)
                    .foregroundColor(Color.appText)
                    .font(.system(size: 13))
                    .textFieldStyle(PlainTextFieldStyle())
                    .focused($isTextFieldFocused)
                    .onChange(of: isTextFieldFocused) { focused in
                        withAnimation {
                            isFocused = focused
                            onFocusChange?(focused)
                        }
                    }
                    .onChange(of: searchText) { newValue in
                        searchPublisher.send(newValue)
                    }
                    .onReceive(
                        searchPublisher
                            .debounce(for: .seconds(debounceTime), scheduler: RunLoop.main)
                    ) { debouncedValue in
                        debouncedText = debouncedValue
                        text = debouncedValue
                        onSearchTextChanged?(debouncedValue)
                    }
                    .onSubmit {
                        text = searchText
                        onSearchTextChanged?(searchText)
                        onCommit?()
                    }
                    .onAppear {
                        searchPublisher
                            .debounce(for: .seconds(debounceTime), scheduler: RunLoop.main)
                            .sink { [weak searchPublisher] value in
                                debouncedText = value
                                text = value
                                onSearchTextChanged?(value)
                            }
                            .store(in: &cancellables)
                    }

                if !searchText.isEmpty {
                    Button(action: {
                        withAnimation {
                            searchText = ""
                            searchPublisher.send("")
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 12))
                            .foregroundColor(Color.appSubtitle)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .transition(.opacity)
                }
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 8)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.appSurface2.opacity(isFocused ? 0.15 : 0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(
                                isFocused ? Color.appAccent.opacity(0.5) : Color.clear, lineWidth: 1
                            )
                    )
            )
            .animation(.easeInOut(duration: 0.2), value: isFocused)
            .animation(.easeInOut(duration: 0.2), value: searchText)
            .frame(maxHeight: 28)
        }
    #endif

    #if os(iOS)
        private var iosSearchBar: some View {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isFocused ? Color.appAccent : Color.appSubtitle)
                    .animation(.easeInOut(duration: 0.2), value: isFocused)

                TextField(placeholder, text: $searchText)
                    .foregroundColor(Color.appText)
                    .font(.system(size: 16))
                    .focused($isTextFieldFocused)
                    .onChange(of: isTextFieldFocused) { focused in
                        withAnimation {
                            isFocused = focused
                            onFocusChange?(focused)
                        }
                    }
                    .onChange(of: searchText) { newValue in
                        searchPublisher.send(newValue)
                    }
                    .onReceive(
                        searchPublisher
                            .debounce(for: .seconds(debounceTime), scheduler: RunLoop.main)
                    ) { debouncedValue in
                        debouncedText = debouncedValue
                        text = debouncedValue
                        onSearchTextChanged?(debouncedValue)
                    }
                    .submitLabel(.search)
                    .onSubmit {
                        text = searchText
                        onSearchTextChanged?(searchText)
                        onCommit?()
                    }
                    .onAppear {
                        searchPublisher
                            .debounce(for: .seconds(debounceTime), scheduler: RunLoop.main)
                            .sink { [weak searchPublisher] value in
                                debouncedText = value
                                text = value
                                onSearchTextChanged?(value)
                            }
                            .store(in: &cancellables)
                    }

                if !searchText.isEmpty {
                    Button(action: {
                        withAnimation {
                            searchText = ""
                            searchPublisher.send("")
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(Color.appSubtitle)
                    }
                    .transition(.opacity)
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.appSurface2.opacity(isFocused ? 0.15 : 0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isFocused ? Color.appAccent.opacity(0.5) : Color.clear,
                                lineWidth: 1.5)
                    )
            )
            .animation(.easeInOut(duration: 0.2), value: isFocused)
            .animation(.easeInOut(duration: 0.2), value: searchText)
        }
    #endif
}
