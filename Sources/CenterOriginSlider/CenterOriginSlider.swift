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

struct CenterOriginSlider: View {
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
    public var range: ClosedRange<CGFloat>

    /// The increment by which the value should change. If this is none, the value changes continuously.
    public let increment: Increment

    /// The size of the slider's thumb.
    public let thumbSize: CGFloat

    /// The color of the slider's thumb.
    public let thumbColor: Color

    /// The size of the center most point of the slider,
    public let centerPointSize: CGFloat

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

    private var center: CGFloat {
        (range.upperBound + range.lowerBound) / 2
    }
    private var normalizedPosition: CGFloat {
        (value - center) / (range.upperBound - center)
    }

    public init(
        _ orientation: Orientation,
        value: Binding<CGFloat>,
        range: ClosedRange<CGFloat>,
        increment: Increment = .none,
        thumbSize: CGFloat = 16,
        thumbColor: Color = .white,
        centerPointSize: CGFloat = 0,
        guideBarCornerRadius: CGFloat = 2,
        guideBarColor: Color = .gray,
        guideBarHeight: CGFloat = 4,
        trackingBarColor: Color = .white,
        trackingBarHeight: CGFloat = 4,
        shadow: CGFloat = 2,
        shadowColor: Color = .gray
    ) {
        self.orientation = orientation
        self._value = value
        self.range = range
        self.increment = increment
        self.thumbSize = thumbSize
        self.thumbColor = thumbColor
        self.centerPointSize = centerPointSize
        self.guideBarCornerRadius = guideBarCornerRadius
        self.guideBarColor = guideBarColor
        self.guideBarHeight = guideBarHeight
        self.trackingBarColor = trackingBarColor
        self.trackingBarHeight = trackingBarHeight
        self.shadow = shadow
        self.shadowColor = shadowColor
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                guideBar
                centerPointCircle
                trackingBar(in: proxy)
                thumb(in: proxy)
                    .gesture(DragGesture().onChanged { dragGesture(gesture: $0, proxy: proxy) })
            }
            .rotationEffect(.degrees(orientation == .vertical ? 180 : 0))
        }
    }

    private func dragGesture(gesture: DragGesture.Value, proxy: GeometryProxy) {
        let normalizedLocation: CGFloat
        switch orientation {
        case .horizontal:
            normalizedLocation = (gesture.location.x - thumbSize / 2) / (proxy.size.width / 2)
        case .vertical:
            normalizedLocation = (gesture.location.y - thumbSize / 2) / (proxy.size.height / 2)
        }

        let updatedValue = normalizedLocation * (range.upperBound - center)
        let clampedValue = max(min(updatedValue, range.upperBound), range.lowerBound)
        switch increment {
        case .fixed(let increment):
            value = (clampedValue / increment).rounded() * increment
        case .none:
            value = clampedValue
        }
    }
}

private extension CenterOriginSlider {
    private func thumb(in proxy: GeometryProxy) -> some View {
        Circle()
            .fill(thumbColor)
            .frame(width: thumbSize, height: thumbSize)
            .shadow(color: shadowColor, radius: shadow)
            .offset(
                x: orientation == .horizontal ? proxy.size.width / 2 * normalizedPosition : 0,
                y: orientation == .horizontal ? 0 : proxy.size.height / 2 * normalizedPosition
            )
    }

    private func trackingBar(in proxy: GeometryProxy) -> some View {
        Rectangle()
            .fill(trackingBarColor)
            .frame(size: getRectangleSize(proxy: proxy))
            .alignmentGuide(HorizontalAlignment.center, computeValue: { d in
                if case .horizontal = orientation {
                    value > center ? d[.leading] : d[.trailing]
                } else {
                    d[HorizontalAlignment.center]
                }
            })
            .alignmentGuide(VerticalAlignment.center) { d in
                if case .vertical = orientation {
                    value > center ? d[.top] : d[.bottom]
                } else {
                    d[VerticalAlignment.center]
                }
            }
    }

    private var guideBar: some View {
        Rectangle()
            .fill(guideBarColor)
            .clipShape(RoundedRectangle(cornerRadius: guideBarCornerRadius))
            .frame(
                width: orientation == .horizontal ? nil : guideBarHeight,
                height: orientation == .horizontal ? guideBarHeight : nil
            )
    }

    private var centerPointCircle: some View {
        Circle()
            .fill(trackingBarColor)
            .frame(width: centerPointSize, height: centerPointSize)
    }

    private func getRectangleSize(proxy: GeometryProxy) -> CGSize {
        switch orientation {
        case .horizontal:
            CGSize(width: abs(proxy.size.width / 2 * normalizedPosition), height: trackingBarHeight)
        case .vertical:
            CGSize(width: trackingBarHeight, height: abs(proxy.size.height / 2 * normalizedPosition))
        }
    }
}
