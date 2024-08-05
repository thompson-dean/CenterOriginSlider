// MIT License
//
// Copyright (c) 2023 Dean Thompson
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

/// `CenterOriginSlider` is a custom SwiftUI view that represents a slider. The slider's thumb can be moved horizontally or vertically
/// to select a value within a range. The slider's appearance and behavior can be customized with several options.
///

import SwiftUI

public struct CenterOriginSlider: View {
    public enum Orientation {
        case horizontal, vertical
    }

    public enum Increment {
        case none
        case fixed(CGFloat)
    }

    /// The orientation of the slider.
    public let orientation: Orientation

    /// A binding to a variable that holds the current slider value.
    @Binding public var value: CGFloat

    /// The lower and upper bounds of the slider
    public let range: ClosedRange<CGFloat>

    /// The increment by which the value should change. If this is none, the value changes continuously.
    public let increment: Increment

    /// The size of the slider's thumb.
    public let thumbSize: CGFloat

    /// The color of the slider's thumb.
    public let thumbColor: Color

    /// The corner radius of the slider's guide bar.
    public let guideBarCornerRadius: CGFloat

    /// The color of the slider's guide bar.
    public let guideBarColor: Color

    /// The height of the slider's guide bar.
    public let guideBarHeight: CGFloat

    /// The color of the slider's tracking bar.
    public let trackingBarColor: Color

    /// The height of the slider's tracking bar.
    public let trackingBarHeight: CGFloat

    /// The shadow radius of the slider's thumb.
    public let shadow: CGFloat

    /// The shadow radius' color.
    public let shadowColor: Color

    /// The background color of the whole View.
    public let backgroundColor: Color

    private var center: CGFloat {
        (range.upperBound + range.lowerBound) / 2
    }
    private var normalizedPosition: CGFloat {
        (value - center) / (range.upperBound - center)
    }

    public init(
        _ orientation: Orientation,
        value: Binding<CGFloat>,
        range: ClosedRange<CGFloat> = -100...100,
        increment: Increment = .none,
        thumbSize: CGFloat = 16,
        thumbColor: Color = .white,
        guideBarCornerRadius: CGFloat = 2,
        guideBarColor: Color = .gray,
        guideBarHeight: CGFloat = 4,
        trackingBarColor: Color = .white,
        trackingBarHeight: CGFloat = 4,
        shadow: CGFloat = 2,
        shadowColor: Color = .gray,
        backgroundColor: Color = .clear
    ) {
        self.orientation = orientation
        self._value = value
        self.range = range
        self.increment = increment
        self.thumbSize = thumbSize
        self.thumbColor = thumbColor
        self.guideBarCornerRadius = guideBarCornerRadius
        self.guideBarColor = guideBarColor
        self.guideBarHeight = guideBarHeight
        self.trackingBarColor = trackingBarColor
        self.trackingBarHeight = trackingBarHeight
        self.shadow = shadow
        self.shadowColor = shadowColor
        self.backgroundColor = backgroundColor
    }

    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                SliderTrack(orientation: orientation, height: guideBarHeight, color: guideBarColor, cornerRadius: guideBarCornerRadius)
                SliderFill(orientation: orientation, height: trackingBarHeight, color: trackingBarColor, normalizedPosition: normalizedPosition)
                SliderThumb(size: thumbSize, color: thumbColor)
                    .shadow(color: shadowColor, radius: shadow)
                    .offset(thumbOffset(in: proxy))
                    .gesture(sliderDragGesture(in: proxy))
            }
        }
        .background(backgroundColor)
    }

    private func thumbOffset(in proxy: GeometryProxy) -> CGSize {
        switch orientation {
        case .horizontal:
            return CGSize(width: proxy.size.width / 2 * normalizedPosition, height: 0)
        case .vertical:
            return CGSize(width: 0, height: proxy.size.height / 2 * normalizedPosition)
        }
    }

    private func sliderDragGesture(in proxy: GeometryProxy) -> some Gesture {
        DragGesture()
            .onChanged { gesture in
            let normalizedLocation = normalizedLocation(for: gesture, in: proxy)
            let updatedValue = normalizedLocation * (range.upperBound - center) + center
            let clampedValue = max(min(updatedValue, range.upperBound), range.lowerBound)

            withAnimation {
                switch increment {
                case .none:
                    value = clampedValue
                case .fixed(let incrementValue):
                    value = (clampedValue / incrementValue).rounded() * incrementValue
                }
            }
        }
    }

    private func normalizedLocation(for gesture: DragGesture.Value, in proxy: GeometryProxy) -> CGFloat {
        switch orientation {
        case .horizontal:
            return (gesture.location.x - thumbSize / 2) / (proxy.size.width / 2)
        case .vertical:
            return (gesture.location.y - thumbSize / 2) / (proxy.size.height / 2)
        }
    }
}
