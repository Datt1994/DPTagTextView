//
//  DPTagTextView.swift
//  TagNameDetection
//
//  Created by datt on 29/05/18.
//  Copyright © 2018 Datt. All rights reserved.
//

import UIKit

protocol DPTagTextViewDelegate {
    func tagSearchString(_ strSearch : String)
    func removeTag(at index : Int , tagName : String)
    func insertTag(at index : Int , tagName : String)
    func detectTag(at index : Int , tagName : String)
}

class DPTagTextView: UITextView , UITextViewDelegate {

    var arrRange : [Range<String.Index>] = []
    var tagPrefix = "@["
    var tagPostfix = "]"
    var arrTags : [String]!
    var tapGesture = UITapGestureRecognizer()
    var dpTagDelegate : DPTagTextViewDelegate!
    
    func setDelegate() {
        self.delegate = self
    }
    
    func getAllTag(_ str:String) -> [String] {
        arrTags = [String]()
        setAllTag(str)
        return arrTags
    }
    func setAllTag(_ str:String) {
        if let strTag = str.slice(from: tagPrefix, to: tagPostfix) {
            arrTags.append(strTag)
            let strTemp = str.replacingOccurrences(of: "\(tagPrefix)\(strTag)\(tagPostfix)", with: strTag)
            setAllTag(strTemp)
        }
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
    func insertTag(_ strTag : String , strSearch : String) {
        var strTemp = text ?? ""
        var insertIndex = -1
        if let range = strTemp.range(of: "@\(strSearch)") {
            strTemp = strTemp.replacingOccurrences(of: "@\(strSearch)", with: "\(strTag) " , options: .literal, range: nil)
            //                strTemp = "\(strTemp)\((arrUserListTag[indexPath.row].title)!) "
            let r = range.lowerBound ..< "\(strTemp)\(strTemp)".utf16.index(range.lowerBound, offsetBy: (strTag.count))
            
            for i in 0 ..< arrRange.count {
                if (arrRange[i].upperBound.encodedOffset > r.upperBound.encodedOffset && insertIndex == -1) {
                    arrRange.insert(r, at: i)
                    arrTags.insert(strTag, at: i)
                    insertIndex = i
                }
            }
            if (insertIndex == -1) {
                arrRange.append(r)
                arrTags.append(strTag)
            } else {
                for i in insertIndex+1 ..< arrRange.count {
                    arrRange[i] = "\(strTemp)\(strTemp)".utf16.index(arrRange[i].lowerBound, offsetBy: strTag.count - "@\(strSearch)".count + 1) ..< "\(strTemp)\(strTemp)".utf16.index(arrRange[i].upperBound, offsetBy:strTag.count - "@\(strSearch)".count + 1)
                }
            }
            
            for rag in arrRange.reversed() {
                strTemp.insert(contentsOf: tagPostfix, at: rag.upperBound)
                strTemp.insert(contentsOf: tagPrefix, at: rag.lowerBound)
                //                    strTemp.insert("@", at: rag.lowerBound)
            }
//            print(strTemp)
        }
        
        setTxt(strTemp)
        
        if (insertIndex != -1) {
            self.selectedRange = NSMakeRange(arrRange[insertIndex].upperBound.encodedOffset, 0)
            dpTagDelegate.insertTag(at: insertIndex, tagName: strTag)
        }

        
    }
    func setTxt(_ str:String , font : UIFont = UIFont(name: "HelveticaNeue", size: CGFloat(15))! , tagFont : UIFont = UIFont(name: "HelveticaNeue-Bold", size: CGFloat(17.0))!) {
        arrRange = [Range<String.Index>]()
        var strTemp = str
        for _ in arrTags {
            let strTag = strTemp.slice(from: tagPrefix, to: tagPostfix)!
            for range in strTemp.ranges(of: "\(tagPrefix)\(strTag)\(tagPostfix)") {
                let rng = range.lowerBound ..< "\(strTemp)\(strTemp)".utf16.index(range.upperBound, offsetBy: -(tagPrefix.count + tagPostfix.count))
                //                strTemp.replaceSubrange(rng, with: i)
                strTemp = strTemp.replacingCharacters(in: range, with: strTag)
                arrRange.append(rng)
                break
            }
        }
        
        let formattedString = NSMutableAttributedString(string:strTemp)
        formattedString.addAttribute(NSAttributedStringKey.font, value: font , range: NSRange(location:0,length:formattedString.length))
        for range in arrRange {
            formattedString.addAttribute(NSAttributedStringKey.font, value: tagFont , range: NSRange(location:range.lowerBound.encodedOffset,length:range.upperBound.encodedOffset-range.lowerBound.encodedOffset))
        }
        
        self.attributedText = formattedString
        
        //        self.txtMain.text = strTemp
    }
    
     func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // for Search
//        self.tbl.isHidden = true
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        
        
        if newText.contains("@") {
            //            if let range = newText.range(of: "@") {
            var rangSearch = newText.startIndex ..< newText.endIndex
            var isIN = false
            for rang in newText.ranges(of: "@") {
                if (rang.lowerBound.encodedOffset < range.upperBound) {
                    func searchRang() {
                        if (text.utf16Count == 0) {
                            let i = -range.length
                            rangSearch = "\(newText)\(newText)".utf16.index(rang.upperBound, offsetBy:  i) ..< "\(newText)\(newText)".utf16.index(rang.lowerBound, offsetBy:  range.upperBound + i - rang.lowerBound.encodedOffset)
                        } else {
                            let i = text.utf16Count
                            rangSearch = rang.upperBound ..< "\(newText)\(newText)".utf16.index(rang.lowerBound, offsetBy:  range.upperBound + i - rang.lowerBound.encodedOffset)
                        }
                        isIN = true
                    }
                    if (arrRange.count > 0) {
                        var isGo = true
                        for r in arrRange {
                            if (range.upperBound > r.upperBound.encodedOffset && rang.upperBound.encodedOffset < r.upperBound.encodedOffset) {
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
                var strSearch = String(newText[rangSearch])
//                print(strSearch)
                if strSearch.utf16Count > 0 {
                    dpTagDelegate.tagSearchString(strSearch)
//                    self.tbl.isHidden = false
                    //                    self.predicate(forPrefix: strSearch)
                    //                    return true
                } else {
                    dpTagDelegate.tagSearchString("")
                }
            } else {
                dpTagDelegate.tagSearchString("")
            }
        }
        
        
        // for add and remove tag
        var strTxtView = textView.text ?? ""
        var selectedRange = range
        var deletedRanges = [Int]()
        var newString = NSString(string: textView.text!).replacingCharacters(in: range, with: text)
        var isFirst = false
        for i in 0 ..< arrRange.count {
        
            func detectTag() -> Bool {
                if (arrRange[i].lowerBound.encodedOffset  <= range.location  && arrRange[i].upperBound.encodedOffset > range.location)  {
                    //                print("name:-\(arrUsers[i])")
                    deletedRanges.append(i)
                    isFirst = true
                    return true
                }
                return false
            }
            if ((range.location < arrRange[i].lowerBound.encodedOffset || range.location < arrRange[i].upperBound.encodedOffset) && (range.location + range.length > arrRange[i].lowerBound.encodedOffset || range.location + range.length > arrRange[i].upperBound.encodedOffset)) {
                if (!detectTag()) {
                    deletedRanges.append(i)
                    isFirst = false
                }
            } else {
                _ = detectTag()
            }
            
            if (text.utf16Count != 0) {
                
                //                for j in i ..< arrRange.count {
                if (arrRange[i].lowerBound.encodedOffset >= range.location +  range.length) {
                    arrRange[i] = "\(newString)\(newString)".utf16.index(arrRange[i].lowerBound, offsetBy: text.utf16Count - range.length) ..< "\(newString)\(newString)".utf16.index(arrRange[i].upperBound, offsetBy:text.utf16Count - range.length)
                }
                //                }
            } else {
                if (arrRange[i].lowerBound.encodedOffset >= range.location && deletedRanges.count == 0) {
                    
                    arrRange[i] = "\(strTxtView)\(strTxtView)".utf16.index(arrRange[i].lowerBound, offsetBy: -(range.length)) ..< "\(strTxtView)\(strTxtView)".utf16.index(arrRange[i].upperBound, offsetBy:-(range.length))
                }
            }
        }
        //
        if (deletedRanges.count > 0) {
            
            if (deletedRanges.count == 1 && isFirst) {
                let removedRange = arrRange[deletedRanges[0]]
                dpTagDelegate.removeTag(at: deletedRanges[0], tagName: arrTags[deletedRanges[0]])
                arrRange.remove(at: deletedRanges[0])
                arrTags.remove(at: deletedRanges[0])
                
                if (deletedRanges[0] < arrRange.count && text.utf16Count == 0) {
                    for i in deletedRanges[0] ..< arrRange.count {
                        arrRange[i] = "\(strTxtView)\(strTxtView)".utf16.index(arrRange[i].lowerBound, offsetBy: (removedRange.lowerBound.encodedOffset - removedRange.upperBound.encodedOffset)) ..< "\(strTxtView)\(strTxtView)".utf16.index(arrRange[i].upperBound, offsetBy:(removedRange.lowerBound.encodedOffset - removedRange.upperBound.encodedOffset))
                    }
                }
                if (text.utf16Count == 0){
                    strTxtView.removeSubrange(removedRange)
                    selectedRange.location = removedRange.lowerBound.encodedOffset
                    newString = strTxtView
                }
            } else {
                for deletedRange in deletedRanges.reversed() {
                    dpTagDelegate.removeTag(at: deletedRange, tagName: arrTags[deletedRange])
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
        setTxt(newString)
        
        
        if (text.utf16Count != 0 ) {
            selectedRange.location += text.utf16Count
        }
        
        selectedRange.length = 0
        textView.selectedRange = selectedRange
        return false
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
            if arrRange[i].lowerBound.encodedOffset <= charIndex && arrRange[i].upperBound.encodedOffset > charIndex {
//                print("name:-\(arrTags[i])")
                dpTagDelegate.detectTag(at: i, tagName: arrTags[i])
            }
        }
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
