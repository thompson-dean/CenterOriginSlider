//
//  ContentView.swift
//  CenterOriginSliderExample
//
//  Created by Dean Thompson on 2023/06/04.
//

import SwiftUI
import CenterOriginSlider

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
                    shadowColor: .gray,
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
