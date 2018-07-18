# DPTagDetectionTextView
Tag detection from Textview.



## Installation
Copy & paste DPVideoMerger.swift file into your project



## How to use
![AddClass](https://user-images.githubusercontent.com/19645535/42803028-4d108e06-89c2-11e8-9b4a-8cbd92db385d.png)

👆Add DPTagTextView to UITextView Custom Class.

![Properties](https://user-images.githubusercontent.com/19645535/42803080-775b94f8-89c2-11e8-9535-041adf802675.png)

👆Use this properties as per your requirments.



## Code

**Set up**
```swift
self.txtMain.dpTagDelegate = self // set DPTagTextViewDelegate Delegate 
self.txtMain.setTxt("hello @[---Datt---]")
self.txtMain.tagPrefix = "@[---" // or use Interface Builder
self.txtMain.tagPostfix = "---]" // or use Interface Builder
self.txtMain.setTagDetection(true) // true :- detecte tag on tap , false :- Search Tags using @,#,etc.
self.txtMain.arrSearchWith = ["@","#","$$"] // Search start with this strings.
let arrTags = self.txtMain.getAllTag("hello @[---Datt---]") // get all tags from string.
self.txtMain.txtFont = UIFont(name: "HelveticaNeue", size: CGFloat(15))! // set textview text font family 
self.txtMain.tagFont = UIFont(name: "HelveticaNeue-Bold", size: CGFloat(17.0))! // set textview tag font family 
```

**Delegate Methods**
```swift
extension ViewController : DPTagTextViewDelegate {
    func tagSearchString(_ str: String) {
    }
    
    func removeTag(at index: Int, tagName: String) {
    }
    
    func insertTag(at index: Int, tagName: String) {
    }
    
    func detectTag(at index: Int, tagName: String) {
    }
}
```
