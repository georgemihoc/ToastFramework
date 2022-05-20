# ToastFrameworkSwift

[![Version](https://img.shields.io/cocoapods/v/ToastFrameworkSwift)](https://cocoapods.org/pods/ToastFrameworkSwift)
[![Platform](https://img.shields.io/cocoapods/p/ToastFrameworkSwift)](https://cocoapods.org/pods/ToastFrameworkSwift)
[![License](https://img.shields.io/cocoapods/l/ToastFrameworkSwift)](https://github.com/georgemihoc/ToastFrameworkSwift/blob/main/LICENSE)

A configurable Swift framework for UI Toast components.

<p align="center">
<img src="https://user-images.githubusercontent.com/45356920/169332591-e1eb102e-ee42-40e3-94d4-84cc0a573ca2.gif" width="50%" height="50%"/>
</p>

## Installation

ToastFrameworkSwift is an open-source framework available through [CocoaPods](https://cocoapods.org).

First step is to install CocoaPods. Skip this step if you already have CocoaPods installed on your machine.

```ruby
sudo gem install cocoapods
```

Initialize your project with CocoaPods from your project directory:

```ruby
pod init
```

For installation, add the required pod within your `Podfile` as shown below:

```ruby
pod 'ToastFrameworkSwift'
```

After adding the pod, run the below command :

```ruby
pod install
```

## ToastFrameworkSwift Example

To run the example project, clone the repo, and run `pod install` within the ToastFrameworkExample directory, using `Terminal`. 

Here you can see how different types of toasts look, both normal and CTA ones.

## Usage

After the installation step you should have generated the `.xcworkspace`. The next step now is to import `ToastFrameworkSwift` within your `ViewController`:

```swift
import ToastFrameworkSwift
```

### Configuration

The toast framework can be configured with the following properties:

```swift
// Enables or disables tap to dismiss behaviour for toasts. 
// When `true`, toast views will dismiss when tapped. When `false`, tapping will have no effect.
ToastManager.shared.isTapToDismissEnabled = true
```

```swift
// Enables or disables wipe to dismiss behaviour for toasts. 
// When `true`, toast views will dismiss when swiped. When `false`, swiping will have no effect.
ToastManager.shared.isSwipeToDismissEnabled = true
```

```swift
// Enables or disables queueing behaviour for toasts. 
// When `true`, toast views will appear one after the other. When `false`, toast overlapping might happen
ToastManager.shared.isQueueEnabled = true
```

```swift
// The default duration for toasts. Default value is 1.0
ToastManager.shared.duration = 2
```

```swift
// This property sets up the haptic feedback type. The types can be found 
// within `HapticFeedback` class. When `.none`, there won't be any haptic feedback.
ToastManager.shared.hapticFeedbackType = .impactLight
```

### Basic Toast
```swift
func presentBasicToast() {
    view.showToast(message: "This is a Basic Toast.")
}
```

### Basic Toast with customizable background
```swift
func presentBasicGrayToast() {
    view.showToast(message: "This is a Basic Gray Toast.", toastColor: .gray)
}
```

### Basic Toast with customizable background and text color
```swift
func presentBasicBlackTextToast() {
    view.showToast(message: "This is a Black Text Toast.", toastColor: .gray, textColor: .black)
}
```
### CTA Toast that presents a follow-up Toast on action
```swift
func presentCTAToast() {
    view.showCTAToast(message: "This is a CTA Toast.", actionTitle: "Press here") { [weak self] in
        self?.view.showToast(message: "This is the follow-up Toast.", toastColor: .systemGreen)
    }
}
```

## Author

George Mihoc, george.mihoc@gmail.com

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.


## License
[MIT](https://github.com/georgemihoc/ToastFrameworkSwift/blob/main/LICENSE) @ 2022 George Mihoc
