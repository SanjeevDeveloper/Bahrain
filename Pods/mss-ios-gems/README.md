# mss-ios-gems

[![CI Status](http://img.shields.io/travis/Kashish Verma/mss-ios-gems.svg?style=flat)](https://travis-ci.org/Kashish Verma/mss-ios-gems)
[![Version](https://img.shields.io/cocoapods/v/mss-ios-gems.svg?style=flat)](http://cocoapods.org/pods/mss-ios-gems)
[![License](https://img.shields.io/cocoapods/l/mss-ios-gems.svg?style=flat)](http://cocoapods.org/pods/mss-ios-gems)
[![Platform](https://img.shields.io/cocoapods/p/mss-ios-gems.svg?style=flat)](http://cocoapods.org/pods/mss-ios-gems)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

mss-ios-gems is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'mss-ios-gems'
```

## USAGE

#### 1. To handle your console log, paste the following code in the didFinishLaunch function in your AppDelegate

```ruby
ConfigureGems.sharedInstance.consolePrintingEnabled = false
```
and always use the printToConsole() function instead of normal print() function.

#### 2. This library has custom image picker with built in flow image cropper. To use it, use the following code

```ruby
let customImagePicker = CustomImagePicker()
customImagePicker.delegate = self
customImagePicker.keepAspectRatio = true
customImagePicker.openImagePickerOn(self)
```
You can also configure the cropper with properties like 
```ruby
customImagePicker.backgroundColor = .gray
customImagePicker.barTintColor = .red
customImagePicker.tintColor = .black
```

#### 3. To show/hide activity indicator, use the following code:

```ruby
ManageHudder.sharedInstance.startActivityIndicator()
ManageHudder.sharedInstance.stopActivityIndicator()
```

#### 4. To check internet connectivity

```ruby
if NetworkingWrapper.sharedInstance.isConnectedToInternet() {
// Do your stuff
}
```

#### 5. To interact with network operations use the Networking wrapper class.
eg. To hit any url without any header or parameters use the following method.

```ruby
NetworkingWrapper.sharedInstance.connect(url: "your api url", httpMethod: .get) { (response) in
// do whatever with response
}
```
There are various other functions with different parameters(headers, parameters) also available.


#### 6. To use the placeholder functionality with uitextview

```ruby
let textViewObj = UITextView()
textViewObj.placeholderColor = UIColor.blue
textViewObj.placeholder = "placeholder"
```

#### 7. Validation is now easy to perform using the Validator class.

```ruby
let validatorObj = Validator()
let name = nameTextField.text!
if !validatorObj.validateRequired(name) {
// validation not passed
}
```
This class has also other functions for validating charcters count, valid email etc.

#### 8. Common functions class has various commonly used functions.
for eg. generating random number, converting json to model and reverse, opening url outside app, etc.


#### 9. This library also contains an extension file which contains various useful UIKit objects extensions to speed up the development.


## Note

```ruby
This library supports Localization. Currently only english and french language is added. We will add more languages and various other useful functionality in its future release.

For any query or suggestions please email at my given email-id below.
```


## Author

Kashish Verma, kashishverma@mastersoftwaresolutions.com

## License

mss-ios-gems is available under the MIT license. See the LICENSE file for more info.
