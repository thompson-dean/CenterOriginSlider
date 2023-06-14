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
// SOFTWARE

/// `VerticalCenterOriginSlider` is a custom SwiftUI view that represents a slider. The slider's thumb can be moved vertically
/// to select a value within a range. The slider's appearance and behavior can be customized with several options.
///
import SwiftUI

struct VerticalCenterOriginSlider: View {
    
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
    public let shadow: CGFloat
    
    /// The shadow radius' color.
    public let shadowColor: Color
    
    /// The background color of the whole View.
    public let backgroundColor: Color
    
    @State public var accumulatedHeight: CGFloat = 0
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
        shadow: CGFloat = 0,
        shadowColor: Color = .clear,
        backgroundColor: Color = .clear
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
        self.shadowColor = shadowColor
        self.backgroundColor = backgroundColor
    }
    public var body: some View {
        GeometryReader { geometry in
            let sliderHeight = geometry.size.height - 32
            let valueRange = maxValue - minValue
            let dragGesture = DragGesture()
                .onChanged({ value in
                    let height = value.translation.height + accumulatedHeight
                    let limitedHeight = max(min(height, sliderHeight / 2 - thumbSize / 2), -sliderHeight / 2 + thumbSize / 2)
                    offset.height = limitedHeight
                    
                    let sliderProgress = (limitedHeight + sliderHeight / 2 - thumbSize / 2) / (sliderHeight - thumbSize)
                    let rawValue = maxValue - Float(sliderProgress) * valueRange // flip the range logic
                    
                    if let unwrappedIncrement = increment {
                        sliderValue = round(rawValue / unwrappedIncrement) * unwrappedIncrement
                    } else {
                        sliderValue = round(rawValue)
                    }
                })
                .onEnded({ value in
                    accumulatedHeight = offset.height
                })
            
            HStack(alignment: .center) {
                ZStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: guideBarCornerRadius)
                        .frame(width: guideBarHeight, height: sliderHeight)
                        .foregroundColor(guideBarColor)
                    VStack(spacing: 0) {
                        VStack {
                            Spacer()
                            Rectangle()
                                .frame(width: trackingBarHeight, height: max(sliderValue < 0 ? CGFloat((-sliderValue / valueRange) * Float(sliderHeight - thumbSize)) : 0, 0))
                                .foregroundColor(trackingBarColor)
                        }
                        .frame(maxHeight: .infinity)
                        VStack {
                            Rectangle()
                                .frame(width: trackingBarHeight, height: max(sliderValue > 0 ? CGFloat((sliderValue / valueRange) * Float(sliderHeight - thumbSize)) : 0, 0))
                                .foregroundColor(trackingBarColor)
                            Spacer()
                        }
                        .frame(maxHeight: .infinity)
                    }
                    .frame(maxHeight: .infinity)
                    Circle()
                        .frame(width: thumbSize, height: thumbSize)
                        .foregroundColor(thumbColor)
                        .offset(offset)
                        .shadow(color: shadowColor, radius: shadow)
                        .gesture(dragGesture)
                        .onChange(of: sliderValue) { value in
                            let sliderProgress = (value - minValue) / valueRange
                            let newHeight = sliderHeight / 2 - CGFloat(sliderProgress) * (sliderHeight - thumbSize) + thumbSize / 2 // flip the range logic
                            offset.height = newHeight
                        }
                }
                .padding(.vertical, 16)
            }
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
        }
    }
}

struct VerticalCenterOriginSlider_Previews: PreviewProvider {
    static var previews: some View {
        VerticalCenterOriginSlider(minValue: -10, maxValue: 10, sliderValue: .constant(10), backgroundColor: .black)
    }
}
