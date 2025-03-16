//
//  TabPickerView.swift
//  TikimUI
//
//  Created by Bùi Đặng Bình on 16/3/25.
//

import SwiftUI

public struct TabPickerView<T: Hashable>: View {
    @Binding var selection: T
    let options: [(value: T, title: String)]
    @Namespace private var animation

    public init(selection: Binding<T>, options: [(value: T, title: String)]) {
        self._selection = selection
        self.options = options
    }

    public var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<options.count, id: \.self) { index in
                let option = options[index]
                pickerButton(title: option.title, value: option.value)
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.appSurface1)
        )
    }

    private func pickerButton(title: String, value: T) -> some View {
        let isSelected = selection == value

        return Text(title)
            .font(.system(.body, design: .rounded).weight(.semibold))
            .foregroundColor(isSelected ? Color.appText : Color.appSubtitle)
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .background(
                Group {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.appAccent.opacity(0.2))
                            .matchedGeometryEffect(id: "TAB", in: animation)
                    }
                }
            )
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.easeIn(duration: 0.15)) {
                    selection = value
                }
            }
    }
}
