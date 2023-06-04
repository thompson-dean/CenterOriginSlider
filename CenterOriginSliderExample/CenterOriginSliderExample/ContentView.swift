//
//  ContentView.swift
//  CenterOriginSliderExample
//
//  Created by Dean Thompson on 2023/06/04.
//

import SwiftUI

struct ContentView: View {
    @State var value: Float = 0
    @State var value2: Float = 0
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                CenterOriginSlider(
                            minValue: -100,
                            maxValue: 100,
                            sliderValue: $value
                        )
                
                CenterOriginSlider(
                    minValue: -50,
                    maxValue: 50,
                    sliderValue: $value2,
                    thumbSize: 24,
                    thumbColor: .red,
                    guideBarCornerRadius: 4,
                    guideBarColor: .blue.opacity(0.2),
                    guideBarHeight: 6,
                    trackingBarColor: .blue,
                    trackingBarHeight: 6,
                    shadow: 2,
                    backgroundColor: .clear
                )
                        
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

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
    
    /// The background color of the whole View.
    public let backgroundColor: Color
    
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
        shadow: Int = 0,
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
        self.backgroundColor = backgroundColor
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
            .background(backgroundColor)
        }
    }
}
