# DPTagDetectionTextView

Tag detection from Textview.

## Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C. You can install it with the following command:

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

![Properties](https://user-images.githubusercontent.com/19645535/42803080-775b94f8-89c2-11e8-9535-041adf802675.png)

👆Use this properties as per your requirments.



## Code

**Set up**
```swift
self.txtMain.dpTagDelegate = self // set DPTagTextViewDelegate Delegate 
self.txtMain.tagPrefix = "@[---" // or use Interface Builder
self.txtMain.tagPostfix = "---]" // or use Interface Builder
self.txtMain.setTagDetection(true) // true :- detecte tag on tap , false :- Search Tags using @,#,etc.
self.txtMain.arrSearchWith = ["@","#","$$"] // Search start with this strings.
let arrTags = self.txtMain.getAllTag("hello @[---Datt---]") // get all tags from string.
self.txtMain.txtFont = UIFont(name: "HelveticaNeue", size: CGFloat(15))! // set textview text font family 
self.txtMain.tagFont = UIFont(name: "HelveticaNeue-Bold", size: CGFloat(17.0))! // set textview tag font family 

var arrTags = [DPTag]()
for i in 0 ..< arrTagedUser.count { // arrTagedUser = ["Datt"]
    arrTags.append(DPTag(strTagName: arrTagedUser[i], tagID: i))
}
self.txtMain.setTxtAndTag(str: "hello @[---Datt---]", tags: arrTags)
self.txtMain.setTxt("hello @[---Datt---]")
```

**Delegate Methods**
```swift
extension ViewController : DPTagTextViewDelegate {
    func tagSearchString(_ str: String) {
    }
    
    func removeTag(at index: Int, tag: DPTag) {
    }
    
    func insertTag(at index: Int, tag: DPTag) {
    }
    
    func detectTag(at index: Int, tag: DPTag) {
    }
}
```
