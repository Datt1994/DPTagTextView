# DPTagDetectionTextView

Tag detection from Textview.

## Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C & Swift. You can install it with the following command:

```bash
$ gem install cocoapods
```
#### Podfile

To integrate DPTagDetectionTextView into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'TargetName' do
use_frameworks!
pod 'DPTagDetectionTextView'
end
```

Then, run the following command:

```bash
$ pod install
```


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
//tagTextView.addTag(allText: <#T##String?#>, tagText: <#T##String#>, id: <#T##String#>, data: <#T##[String : Any]#>, customTextAttributes: <#T##[NSAttributedString.Key : Any]?#>, isAppendSpace: <#T##Bool#>)
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
