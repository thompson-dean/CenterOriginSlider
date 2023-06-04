# CenterOriginSlider 

CenterOriginSlider is an open-source SwiftUI package that provides a customizable center origin slider for your iOS projects. This slider allows users to select values in a range, either negative or positive, from a center origin point.

This package provides a variety of customization options such as thumb size, color, guide bar style, tracking bar color, and more, making it a flexible choice for your user interface needs.

## Features

- Set the minimum and maximum values for your slider.
- Opt to increment values discretely or continuously.
- Customize the slider's thumb size, color, and shadow.
- Style the guide bar with your choice of corner radius, color, and height.
- Define the appearance of the tracking bar, including its color and height.

## Requirements

- iOS 14.0+
- mac OS 11.0+

## Installation

CenterOriginSlider is available through the Swift Package Manager. 

To add CenterOriginSlider to your Xcode project:
1. Select File > New > Package...
2. Enter `https://github.com/thompson-dean/CenterOriginSlider.git` into the package repository URL text box.
3. Follow the prompts to add the package to your project.

## Usage

First, import the `CenterOriginSlider` package in the file where you want to use it:

```swift
import SwiftUI
import CenterOriginSlider
```

```
struct ContentView: View {
    @State private var sliderValue: Float = 0.0

    var body: some View {
        CenterOriginSlider(
            minValue: -100,
            maxValue: 100,
            sliderValue: $sliderValue
        )
        .frame(width: 300, height: 60)
        .padding()
    }
}
```

In this example, the slider's value can vary from -100 to 100, starting from 0.

To further customize the slider, you can specify other properties as per your needs. For example:

```
CenterOriginSlider(
    minValue: -50,
    maxValue: 50,
    increment: 10,
    sliderValue: $sliderValue,
    thumbSize: 24,
    thumbColor: .red,
    guideBarCornerRadius: 4,
    guideBarColor: .blue.opacity(0.2),
    guideBarHeight: 6,
    trackingBarColor: .blue,
    trackingBarHeight: 6,
    shadow: 2
)
```
## Contribution
Contributions to the CenterOriginSlider project are welcome! Feel free to open a new issue or send a pull request, if you happen to find a bug, or would liek to add any new features.

## License
CenterOriginSlider is available under the MIT license.
