//
//  DPTagTextView.swift
//  TagNameDetection
//
//  Created by datt on 29/05/18.
//  Copyright © 2018 Datt. All rights reserved.
//

import UIKit

struct DPTag {
    let strTagName : String
    let tagID : Int
    let data : [String:AnyObject]?
    
    init(strTagName: String , tagID: Int , data: [String:AnyObject] = [:]) {
        self.strTagName = strTagName
        self.tagID = tagID
        self.data = data
    }
    
}

protocol DPTagTextViewDelegate {
    func tagSearchString(_ strSearch : String)
    func removeTag(at index : Int , tag : DPTag)
    func insertTag(at index : Int , tag : DPTag)
    func detectTag(at index : Int , tag : DPTag)
}

class DPTagTextView: UITextView , UITextViewDelegate {

    private var arrRange : [Range<String.Index>] = []
    private var arrTags : [DPTag] = [DPTag]()
    private var tapGesture = UITapGestureRecognizer()
    var dpTagDelegate : DPTagTextViewDelegate!
    var arrSearchWith = ["@","#"]
    var txtFont : UIFont = UIFont(name: "HelveticaNeue", size: CGFloat(15))!
    var tagFont : UIFont = UIFont(name: "HelveticaNeue-Bold", size: CGFloat(17.0))!
    private var hack_shouldIgnorePredictiveInput = false
    private var predictiveTextWatcher = 0
    
    @IBInspectable public var tagPrefix: String = "@["
    @IBInspectable public var tagPostfix: String = "]"
    @IBInspectable public var txtColor : UIColor = .black
    @IBInspectable public var tagTxtColor : UIColor = .black
    @IBInspectable public var tagBackgroundColor : UIColor = .clear
    
    
    func setDelegateToTextView() {
        self.delegate = self
    }
    
    func getAllTag(_ str:String) -> [DPTag] {
        arrTags = [DPTag]()
        setAllTag(str)
        return arrTags
    }
    func setAllTag(_ str:String) {
        if let strTag = str.slice(from: tagPrefix, to: tagPostfix) {
            arrTags.append(DPTag(strTagName: strTag, tagID: -1, data: [:]))
            let strTemp = str.replacingOccurrences(of: "\(tagPrefix)\(strTag)\(tagPostfix)", with: strTag)
            setAllTag(strTemp)
        }
    }
    
    func setTxtAndTag(str:String , tags:[DPTag]) {
        arrTags = tags
        setTxt(str)
    }
    
    func clearTextWithTag() {
        self.text = ""
        self.arrTags = []
        self.arrRange = []
    }
    func setTagDetection(_ isTagDetection : Bool) {
        self.removeGestureRecognizer(tapGesture)
        if isTagDetection {
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnTextView(_:)))
            self.addGestureRecognizer(tapGesture)
            self.isEditable = false
            self.isSelectable = false
        } else {
            self.isEditable = true
            self.isSelectable = true
        }
    }
    func insertTag(_ strTag : String , tagID : Int , tagData : [String:AnyObject] = [:] , strSearch : String) {
        var strTemp = text ?? ""
        var insertIndex = -1
        
        for str in arrSearchWith {
            if let range = strTemp.range(of: "\(str)\(strSearch)") {
                strTemp = strTemp.replacingOccurrences(of: "\(str)\(strSearch)", with: "\(strTag) " , options: .literal, range: nil)
                //                strTemp = "\(strTemp)\((arrUserListTag[indexPath.row].title)!) "
                let r = range.lowerBound ..< "\(strTemp)\(strTemp)".utf16.index(range.lowerBound, offsetBy: (strTag.count))
                
                for i in 0 ..< arrRange.count {
                    if (arrRange[i].upperBound.utf16Offset(in: strTemp) > r.upperBound.utf16Offset(in: strTemp) && insertIndex == -1) {
                        arrRange.insert(r, at: i)
                        arrTags.insert(DPTag(strTagName: strTag, tagID: tagID, data: tagData), at: i)
                        insertIndex = i
                    }
                }
                if (insertIndex == -1) {
                    arrRange.append(r)
                    arrTags.append(DPTag(strTagName: strTag, tagID: tagID, data: tagData))
                } else {
                    for i in insertIndex+1 ..< arrRange.count {
                        arrRange[i] = "\(strTemp)\(strTemp)".utf16.index(arrRange[i].lowerBound, offsetBy: strTag.count - "\(str)\(strSearch)".count + 1) ..< "\(strTemp)\(strTemp)".utf16.index(arrRange[i].upperBound, offsetBy:strTag.count - "\(str)\(strSearch)".count + 1)
                    }
                }
                
                for rag in arrRange.reversed() {
                    strTemp.insert(contentsOf: tagPostfix, at: rag.upperBound)
                    strTemp.insert(contentsOf: tagPrefix, at: rag.lowerBound)
                    //                    strTemp.insert("@", at: rag.lowerBound)
                }
                //            print(strTemp)
                
                setTxt(strTemp)
                
                if (insertIndex != -1) {
                    self.selectedRange = NSMakeRange(arrRange[insertIndex].upperBound.utf16Offset(in: strTemp), 0)
                    dpTagDelegate.insertTag(at: insertIndex, tag: DPTag(strTagName: strTag, tagID: tagID, data: tagData))
                } else {
                    dpTagDelegate.insertTag(at: arrTags.count - 1, tag: DPTag(strTagName: strTag, tagID: tagID, data: tagData))
                }
                break
            }
        }
    }
    func setTxt(_ str:String) {
        arrRange = [Range<String.Index>]()
        var strTemp = str
        for _ in arrTags {
            if let strTag = strTemp.slice(from: tagPrefix, to: tagPostfix) {
                for range in strTemp.ranges(of: "\(tagPrefix)\(strTag)\(tagPostfix)") {
                    let rng = range.lowerBound ..< "\(strTemp)\(strTemp)".utf16.index(range.upperBound, offsetBy: -(tagPrefix.count + tagPostfix.count))
                    //                strTemp.replaceSubrange(rng, with: i)
                    strTemp = strTemp.replacingCharacters(in: range, with: strTag)
                    arrRange.append(rng)
                    break
                }
            }
        }
        
        let formattedString = NSMutableAttributedString(string:strTemp)
        formattedString.addAttributes([NSAttributedString.Key.font: txtFont , NSAttributedString.Key.foregroundColor : txtColor ] , range: NSRange(location:0,length:formattedString.length))
        for range in arrRange {
            formattedString.addAttributes([NSAttributedString.Key.font : tagFont , NSAttributedString.Key.backgroundColor : tagBackgroundColor, NSAttributedString.Key.foregroundColor : tagTxtColor] , range: NSRange(location:range.lowerBound.utf16Offset(in: strTemp),length:range.upperBound.utf16Offset(in: strTemp)-range.lowerBound.utf16Offset(in: strTemp)))
        }
        
        self.attributedText = formattedString
        
        //        self.txtMain.text = strTemp
    }
    
    fileprivate func dpTagTextView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if predictiveTextWatcher == 1 {
            predictiveTextWatcher = 0
            return false
        }
        if hack_shouldIgnorePredictiveInput {
             predictiveTextWatcher += 1
            hack_shouldIgnorePredictiveInput = false
            return false
        }
        hack_shouldIgnorePredictiveInput = true
        // for Search
        //        self.tbl.isHidden = true
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        
        func search(with str : String) {
            //            if let range = newText.range(of: "@") {
            var rangSearch = newText.startIndex ..< newText.endIndex
            var isIN = false
            for rang in newText.ranges(of: str) {
                if (rang.lowerBound.utf16Offset(in: newText) < range.lowerBound) {
                    func searchRang() {
                        var i = 0
                        if (text.utf16Count == 0) {
                            i = -range.length
//                            rangSearch = /*"\(newText)\(newText)".utf16.index(rang.upperBound, offsetBy:  i + 1)*/rang.upperBound ..< "\(newText)\(newText)".utf16.index(rang.lowerBound, offsetBy:  range.upperBound + i - rang.lowerBound.encodedOffset)
                        } else {
                             i = -range.length + text.utf16Count
                        }
                        rangSearch = rang.upperBound ..< "\(newText)\(newText)".utf16.index(rang.lowerBound, offsetBy:  range.upperBound + i - rang.lowerBound.utf16Offset(in: newText))
                        isIN = true
                    }
                    if (arrRange.count > 0) {
                        var isGo = true
                        for r in arrRange {
                            if (range.upperBound > r.upperBound.utf16Offset(in: newText) && rang.upperBound.utf16Offset(in: newText) < r.upperBound.utf16Offset(in: newText)) {
                                isGo = false
                            }
                        }
                        if (isGo) {
                            searchRang()
                        }
                    } else {
                        searchRang()
                    }
                }
            }
            if (isIN) {
                let strSearch = String(newText[rangSearch])
//                                print(strSearch)
                if strSearch.utf16Count > 0 /*&& !(text.utf16Count == 0 && strSearch.utf16Count == 1)*/ {
                    dpTagDelegate.tagSearchString(strSearch)
                    //                    self.tbl.isHidden = false
                    //                    self.predicate(forPrefix: strSearch)
                    //                    return true
                }
                else {
                    dpTagDelegate.tagSearchString("")
                }
            }
            else {
                dpTagDelegate.tagSearchString("")
            }
        }
        
        for str in arrSearchWith {
            if newText.contains(str) {
                search(with:str)
            }
        }
        
        
        // for add and remove tag
        var strTxtView = textView.text ?? ""
        var selectedRange = range
        var deletedRanges = [Int]()
        var newString = NSString(string: textView.text ?? "").replacingCharacters(in: range, with: text)
        var isFirst = false
        for i in 0 ..< arrRange.count {
            
            func detectTag() -> Bool {
                if (arrRange[i].lowerBound.utf16Offset(in: strTxtView)  < range.location  && arrRange[i].upperBound.utf16Offset(in: strTxtView) > range.location)  {
                    //                print("name:-\(arrUsers[i])")
                    deletedRanges.append(i)
                    isFirst = true
                    return true
                }
                return false
            }
            if ((range.location < arrRange[i].lowerBound.utf16Offset(in: strTxtView) || range.location < arrRange[i].upperBound.utf16Offset(in: strTxtView)) && (range.location + range.length > arrRange[i].lowerBound.utf16Offset(in: strTxtView) || range.location + range.length > arrRange[i].upperBound.utf16Offset(in: strTxtView))) {
                if (!detectTag()) {
                    deletedRanges.append(i)
                    isFirst = false
                }
            } else {
                _ = detectTag()
            }
            
            if (text.utf16Count != 0) {
                
                //                for j in i ..< arrRange.count {
                if (arrRange[i].lowerBound.utf16Offset(in: strTxtView) >= range.location +  range.length) {
                    arrRange[i] = "\(newString)\(newString)".utf16.index(arrRange[i].lowerBound, offsetBy: text.utf16Count - range.length) ..< "\(newString)\(newString)".utf16.index(arrRange[i].upperBound, offsetBy:text.utf16Count - range.length)
                }
                //                }
            } else {
                if (arrRange[i].lowerBound.utf16Offset(in: strTxtView) >= range.location && deletedRanges.count == 0) {
                    
                    arrRange[i] = "\(strTxtView)\(strTxtView)".utf16.index(arrRange[i].lowerBound, offsetBy: -(range.length)) ..< "\(strTxtView)\(strTxtView)".utf16.index(arrRange[i].upperBound, offsetBy:-(range.length))
                }
            }
        }
        //
        if (deletedRanges.count > 0) {
            
            if (deletedRanges.count == 1 && isFirst) {
                let removedRange = arrRange[deletedRanges[0]]
                dpTagDelegate.removeTag(at: deletedRanges[0], tag: arrTags[deletedRanges[0]])
                arrRange.remove(at: deletedRanges[0])
                arrTags.remove(at: deletedRanges[0])
                
                if (deletedRanges[0] < arrRange.count && text.utf16Count == 0) {
                    for i in deletedRanges[0] ..< arrRange.count {
                        arrRange[i] = "\(strTxtView)\(strTxtView)".utf16.index(arrRange[i].lowerBound, offsetBy: (removedRange.lowerBound.utf16Offset(in: strTxtView) - removedRange.upperBound.utf16Offset(in: strTxtView))) ..< "\(strTxtView)\(strTxtView)".utf16.index(arrRange[i].upperBound, offsetBy:(removedRange.lowerBound.utf16Offset(in: strTxtView) - removedRange.upperBound.utf16Offset(in: strTxtView)))
                    }
                }
                if (text.utf16Count == 0){
                    strTxtView.removeSubrange(removedRange)
                    selectedRange.location = removedRange.lowerBound.utf16Offset(in: strTxtView)
                    newString = strTxtView
                }
            } else {
                for deletedRange in deletedRanges.reversed() {
                    dpTagDelegate.removeTag(at: deletedRange, tag: arrTags[deletedRange])
                    arrRange.remove(at: deletedRange)
                    arrTags.remove(at: deletedRange)
                }
                if (deletedRanges[0] < arrRange.count && text.utf16Count == 0) {
                    for i in deletedRanges[0] ..< arrRange.count {
                        arrRange[i] = "\(strTxtView)\(strTxtView)".utf16.index(arrRange[i].lowerBound, offsetBy: -range.length) ..< "\(strTxtView)\(strTxtView)".utf16.index(arrRange[i].upperBound, offsetBy:-range.length)
                    }
                }
            }
        }
        
        for rag in arrRange.reversed() {
            newString.insert(contentsOf: tagPostfix, at: rag.upperBound)
            newString.insert(contentsOf: tagPrefix, at: rag.lowerBound)
        }

        if (text.utf16Count != 0 ) {
            selectedRange.location += text.utf16Count
        }
        
        selectedRange.length = 0
        self.isScrollEnabled = false;
        setTxt(newString)
        self.isScrollEnabled = true;
        textView.selectedRange = selectedRange
        
        hack_shouldIgnorePredictiveInput = false
        return false
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
       return dpTagTextView(textView, shouldChangeTextIn: range, replacementText: text)
    }
    @objc private final func tapOnTextView(_ recognizer: UITapGestureRecognizer){
        // for Lable
        //        // only detect taps in attributed text
        //        guard let attributedText = lbl.attributedText, gesture.state == .ended else {
        //            return
        //        }
        //
        //        // Configure NSTextContainer
        //        let textContainer = NSTextContainer(size: lbl.bounds.size)
        //        textContainer.lineFragmentPadding = 0.0
        //        textContainer.lineBreakMode = lbl.lineBreakMode
        //        textContainer.maximumNumberOfLines = lbl.numberOfLines
        //
        //        // Configure NSLayoutManager and add the text container
        //        let layoutManager = NSLayoutManager()
        //        layoutManager.addTextContainer(textContainer)
        //
        //        // Configure NSTextStorage and apply the layout manager
        //        let textStorage = NSTextStorage(attributedString: attributedText)
        //        textStorage.addAttribute(NSAttributedStringKey.font, value: lbl.font, range: NSMakeRange(0, attributedText.length))
        //        textStorage.addLayoutManager(layoutManager)
        //
        //        // get the tapped character location
        //        let locationOfTouchInLabel = gesture.location(in: gesture.view)
        //
        //        // account for text alignment and insets
        //        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        //        var alignmentOffset: CGFloat!
        //        switch lbl.textAlignment {
        //        case .left, .natural, .justified:
        //            alignmentOffset = 0.0
        //        case .center:
        //            alignmentOffset = 0.5
        //        case .right:
        //            alignmentOffset = 1.0
        //        }
        //        let xOffset = ((lbl.bounds.size.width - textBoundingBox.size.width) * alignmentOffset) - textBoundingBox.origin.x
        //        let yOffset = ((lbl.bounds.size.height - textBoundingBox.size.height) * alignmentOffset) - textBoundingBox.origin.y
        //        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - xOffset, y: locationOfTouchInLabel.y - yOffset)
        //
        //        // figure out which character was tapped
        //        let characterTapped = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        //
        //        // figure out how many characters are in the string up to and including the line tapped
        //        let lineTapped = Int(ceil(locationOfTouchInLabel.y / lbl.font.lineHeight)) - 1
        //        let rightMostPointInLineTapped = CGPoint(x: lbl.bounds.size.width, y: lbl.font.lineHeight * CGFloat(lineTapped))
        //        let charsInLineTapped = layoutManager.characterIndex(for: rightMostPointInLineTapped, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        //
        //        // ignore taps past the end of the current line
        //        if characterTapped < charsInLineTapped {
        ////            onCharacterTapped?(self, characterTapped)
        //
        //
        ////            print(lineTapped)
        ////            print(rightMostPointInLineTapped)
        //        }
        //        print(characterTapped)
        //        for i in 0 ..< arrRange.count {
        //            if arrRange[i].lowerBound.encodedOffset <= characterTapped && arrRange[i].upperBound.encodedOffset > characterTapped {
        //                            print("name:-\(arrUsers[i])")
        //            }
        //        }
        
        
        guard let textView = recognizer.view as? UITextView else {
            return
        }
        
        var location: CGPoint = recognizer.location(in: textView)
        location.x -= textView.textContainerInset.left
        location.y -= textView.textContainerInset.top
        
        let charIndex = textView.layoutManager.characterIndex(for: location, in: textView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        guard charIndex < textView.textStorage.length else {
            return
        }
        
//        print("index:-\(charIndex)")
        
        for i in 0 ..< arrRange.count {
            if arrRange[i].lowerBound.utf16Offset(in: self.text) <= charIndex && arrRange[i].upperBound.utf16Offset(in: self.text) > charIndex {
//                print("name:-\(arrTags[i])")
                dpTagDelegate.detectTag(at: i, tag: arrTags[i])
            }
        }
    }
    override func addGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        if (gestureRecognizer.isKind(of: UILongPressGestureRecognizer.self)) {
            gestureRecognizer.isEnabled = false;
        }
        super.addGestureRecognizer(gestureRecognizer)
        return
    }
}
extension String {
    var utf16Count : Int {
        return utf16.count
    }
}
extension String {
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}
extension StringProtocol where Index == String.Index {
    func index<T: StringProtocol>(of string: T, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
    func endIndex<T: StringProtocol>(of string: T, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.upperBound
    }
    func indexes<T: StringProtocol>(of string: T, options: String.CompareOptions = []) -> [Index] {
        var result: [Index] = []
        var start = startIndex
        while start < endIndex, let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range.lowerBound)
            start = range.lowerBound < range.upperBound ? range.upperBound : index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
    func ranges<T: StringProtocol>(of string: T, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var start = startIndex
        while start < endIndex, let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range)
            start = range.lowerBound < range.upperBound  ? range.upperBound : index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}

