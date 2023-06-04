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

/// `CenterOriginSlider` is a custom SwiftUI view that represents a slider. The slider's thumb can be moved horizontally
/// to select a value within a range. The slider's appearance and behavior can be customized with several options.
///
import SwiftUI

public struct CenterOriginSlider: View {

    /// The minimum value the slider can take.
    public let minValue: Float

    /// The maximum value the slider can take.
    public let maxValue: Float

    /// The increment by which the value should change. If this is nil, the value changes continuously.
    public let increment: Float?

    /// A binding to a variable that holds the current slider value.
    @Binding public var sliderValue: Float

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
    public let shadow: Int
    
    @State public var accumulatedWidth: CGFloat = 0
    @State public var offset: CGSize = .zero
    
    public init(
        minValue: Float,
        maxValue: Float,
        increment: Float? = nil,
        sliderValue: Binding<Float>,
        thumbSize: CGFloat = 16,
        thumbColor: Color = .white,
        guideBarCornerRadius: CGFloat = 2,
        guideBarColor: Color = .white.opacity(0.15),
        guideBarHeight: CGFloat = 4,
        trackingBarColor: Color = .white,
        trackingBarHeight: CGFloat = 4,
        shadow: Int = 0
    ) {
        self.minValue = minValue
        self.maxValue = maxValue
        self.increment = increment
        self._sliderValue = sliderValue
        self.thumbSize = thumbSize
        self.thumbColor = thumbColor
        self.guideBarCornerRadius = guideBarCornerRadius
        self.guideBarColor = guideBarColor
        self.guideBarHeight = guideBarHeight
        self.trackingBarColor = trackingBarColor
        self.trackingBarHeight = trackingBarHeight
        self.shadow = shadow
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let sliderWidth = geometry.size.width - 32
            let valueRange = maxValue - minValue
            let dragGesture = DragGesture()
                .onChanged({ value in
                    let width = value.translation.width + accumulatedWidth
                    let limitedWidth = max(min(width, sliderWidth / 2 - thumbSize / 2), -sliderWidth / 2 + thumbSize / 2)
                    offset.width = limitedWidth

                    let sliderProgress = (limitedWidth + sliderWidth / 2 - thumbSize / 2) / (sliderWidth - thumbSize)
                    let rawValue = minValue + Float(sliderProgress) * valueRange
                    
                    if let unwrappedIncrement = increment {
                        sliderValue = round(rawValue / unwrappedIncrement) * unwrappedIncrement
                    } else {
                        sliderValue = round(rawValue)
                    }
                })
                .onEnded({ value in
                    accumulatedWidth = offset.width
                })
            VStack(alignment: .center) {
                ZStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: guideBarCornerRadius)
                        .frame(width: sliderWidth, height: guideBarHeight)
                        .foregroundColor(guideBarColor)
                    HStack(spacing: 0) {
                        HStack {
                            Spacer()
                            Rectangle()
                                .frame(width: max(sliderValue < 0 ? CGFloat((-sliderValue / valueRange) * Float(sliderWidth - thumbSize)) : 0, 0), height: trackingBarHeight)
                                .foregroundColor(trackingBarColor)
                        }
                        .frame(maxWidth: .infinity)
                        HStack {
                            Rectangle()
                                .frame(width: max(sliderValue > 0 ? CGFloat((sliderValue / valueRange) * Float(sliderWidth - thumbSize)) : 0, 0), height: trackingBarHeight)
                                .foregroundColor(trackingBarColor)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity)
                    Circle()
                        .frame(width: thumbSize, height: thumbSize)
                        .foregroundColor(thumbColor)
                        .offset(offset)
                        .gesture(dragGesture)
                        .onChange(of: sliderValue) { value in
                            let sliderProgress = (value - minValue) / valueRange
                            let newWidth = CGFloat(sliderProgress) * (sliderWidth - thumbSize) - sliderWidth / 2 + thumbSize / 2
                            offset.width = newWidth
                        }
                }
                .padding(.horizontal, 16)
            }
            .frame(maxHeight: .infinity)
        }
    }
}


