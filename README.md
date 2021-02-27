# DPTagTextView
[![Platform](https://img.shields.io/cocoapods/p/DPTagTextView.svg?style=flat)](http://cocoapods.org/pods/DPTagTextView)
[![Language: Swift 5](https://img.shields.io/badge/language-swift5-f48041.svg?style=flat)](https://developer.apple.com/swift)
[![License](https://img.shields.io/cocoapods/l/DPOTPView.svg?style=flat)](https://github.com/Datt1994/DPTagTextView/blob/master/LICENSE)
[![Version](https://img.shields.io/cocoapods/v/DPTagTextView.svg?style=flat)](http://cocoapods.org/pods/DPTagTextView)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Add & detect tag/mention using Textview.

<img src="https://user-images.githubusercontent.com/19645535/109400852-14133300-7971-11eb-9301-6d8321fbf5b3.mp4" srcold="https://user-images.githubusercontent.com/19645535/109400040-5f771280-796c-11eb-86a4-6a5f12ee13c7.mp4" width="400" />





## Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C & Swift. You can install it with the following command:

```bash
$ gem install cocoapods
```
#### Podfile

To integrate DPTagDetectionTextView into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'

target 'TargetName' do
use_frameworks!
pod 'DPTagTextView'
end
```

Then, run the following command:

```bash
$ pod install
```

## Installation with Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate `DPOTPView` into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "Datt1994/DPTagTextView"
```

Run `carthage` to build the framework and drag the framework (`DPTagTextView.framework`) into your Xcode project.

## Installation with Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler.

To add the library as package dependency to your Xcode project, select File > Swift Packages > Add Package Dependency and enter its repository URL `https://github.com/Datt1994/DPTagTextView.git`


## Add Manually 
  
  Download Project and copy-paste `DPTagTextView.swift` file into your project 


## How to use
![AddClass](https://user-images.githubusercontent.com/19645535/42803028-4d108e06-89c2-11e8-9b4a-8cbd92db385d.png)

👆Add DPTagTextView to UITextView Custom Class.


## Code

**Set up**
```swift
tagTextView.dpTagDelegate = self // set DPTagTextViewDelegate Delegate 
tagTextView.setTagDetection(true) // true :- detecte tag on tap , false :- Search Tags using mentionSymbol & hashTagSymbol.
tagTextView.mentionSymbol = "@" // Search start with this mentionSymbol.
tagTextView.hashTagSymbol = "#" // Search start with this hashTagSymbol for hashtagging.
tagTextView.allowsHashTagUsingSpace = true // Add HashTag using space
tagTextView.textViewAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)] // set textview defult text Attributes
tagTextView.mentionTagTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blue,
NSAttributedString.Key.backgroundColor: UIColor.lightGray,
NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)] // set textview mentionTag text Attributes
tagTextView.hashTagTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red,
NSAttributedString.Key.backgroundColor: UIColor.lightGray,
NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)] // set textview hashTag text Attributes

//Set pre text and tags 
let tag1 = DPTag(name: "Lorem Ipsum", range: NSRange(location: 41, length: 11))
let tag2 = DPTag(id: "567681647", name: "suffered", range: NSRange(location: 86, length: 9), data: ["withHashTag" : "#suffered"], isHashTag: true,customTextAttributes: [NSAttributedString.Key.foregroundColor: UIColor.green,NSAttributedString.Key.backgroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)])
let tag3 = DPTag(name: "humour", range: NSRange(location: 133, length: 7), isHashTag: true)

tagTextView.setText("There are many variations of passages of Lorem Ipsum available, but the majority have #suffered alteration in some form, by injected #humour, or randomised words which don't look even slightly believable.", arrTags: [tag1, tag2, tag3])

//Clear textview 
tagTextView.setText(nil, arrTags: [])

//Add tag replacing serached string
//tagTextView.addTag(allText: String?, tagText: String, id: String, data: [String : Any], customTextAttributes: [NSAttributedString.Key : Any], isAppendSpace: Bool)
tagTextView.addTag(tagText: "User Name")
```

**Delegate Methods**
```swift
extension ViewController : DPTagTextViewDelegate {
    func dpTagTextView(_ textView: DPTagTextView, didChangedTagSearchString strSearch: String, isHashTag: Bool) {
    }
    
    func dpTagTextView(_ textView: DPTagTextView, didInsertTag tag: DPTag) {
    }
    
    func dpTagTextView(_ textView: DPTagTextView, didRemoveTag tag: DPTag) {
    }
    
    func dpTagTextView(_ textView: DPTagTextView, didSelectTag tag: DPTag) {
    }
    
    func dpTagTextView(_ textView: DPTagTextView, didChangedTags arrTags: [DPTag]) {
    }
}
```
