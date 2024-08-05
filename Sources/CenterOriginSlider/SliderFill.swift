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

public struct SliderFill: View {
    let orientation: CenterOriginSlider.Orientation
    let height: CGFloat
    let color: Color
    let normalizedPosition: CGFloat

    public var body: some View {
        GeometryReader { proxy in
            RoundedRectangle(cornerRadius: height / 2)
                .fill(color)
                .frame(size: fillSize(in: proxy))
                .alignmentGuide(HorizontalAlignment.center) { d in
                    orientation == .horizontal && normalizedPosition > 0 ? d[.leading] : d[.trailing]
                }
                .alignmentGuide(VerticalAlignment.center) { d in
                    orientation == .vertical && normalizedPosition > 0 ? d[.top] : d[.bottom]
                }
        }
    }

    private func fillSize(in proxy: GeometryProxy) -> CGSize {
        switch orientation {
        case .horizontal:
            return CGSize(width: abs(proxy.size.width / 2 * normalizedPosition), height: height)
        case .vertical:
            return CGSize(width: height, height: abs(proxy.size.height / 2 * normalizedPosition))
        }
    }
}
