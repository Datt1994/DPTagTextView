//
//  ViewController.swift
//  TagNameDetection
//
//  Created by datt on 04/04/18.
//  Copyright © 2018 Datt. All rights reserved.
//

import UIKit

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

class ViewController: UIViewController , UITextViewDelegate {
    @IBOutlet weak var txtMain: UITextView!
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var lbl: UILabel!
    
    let isTagDetection = true
    
    var strSearch = String()
    var rangeCurrent : UITextRange!
    let arrUsers : [String] = ["Datt Patel", "Dharmesh Shah","Arpit Dhamane","Nirzar Gandhi","Pooja Shah","Nilomi Shah","Pradip Rathod","Jiten Goswami"]
    var arrRange : [Range<String.Index>] = []
    var arrAddedUser : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (isTagDetection) {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnTextView(_:)))
            self.txtMain.addGestureRecognizer(tapGesture)
            self.txtMain.isEditable = false
            self.txtMain.isSelectable = false
            
            let str =  "Hello, All the Information about @[Datt Patel] is related to @[Dharmesh Shah] and @[Arpit Dhamane] which can be Defined by @[Nirzar Gandhi] and @[Pooja Shah] who are in company with @[Nilomi Shah] , @[Pradip Rathod] and @[Jiten Goswami] "
            
            arrAddedUser = arrUsers
           setTxtView(str)
        }
        txtMain.delegate = self;

        tbl.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tbl.isHidden = true
        // Do any additional setup after loading the view, typically from a nib.
    }

    func setTxtView(_ str:String) {
        arrRange = [Range<String.Index>]()
        var strTemp = str
        for i in arrAddedUser {
            for range in strTemp.ranges(of: "@[\(i)]") {
                let rng = range.lowerBound ..< strTemp.index(before: strTemp.index(before: strTemp.index(before: range.upperBound)))
//                strTemp.replaceSubrange(rng, with: i)
                strTemp = strTemp.replacingCharacters(in: range, with: i)
                arrRange.append(rng)
                break
            }
        }
        let formattedString = NSMutableAttributedString(string:strTemp)
        for range in arrRange {
            formattedString.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "HelveticaNeue-Bold", size: CGFloat(17.0))!, range: NSRange(location:range.lowerBound.encodedOffset,length:range.upperBound.encodedOffset-range.lowerBound.encodedOffset))
        }
        
        self.txtMain.attributedText = formattedString
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

        print("index:-\(charIndex)")

        for i in 0 ..< arrRange.count {
            if arrRange[i].lowerBound.encodedOffset <= charIndex && arrRange[i].upperBound.encodedOffset > charIndex {
                print("name:-\(arrUsers[i])")
            }
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        self.tbl.isHidden = true
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        if newText.contains("@") {
//            if let range = newText.range(of: "@") {
            var rangSearch = newText.startIndex ..< newText.endIndex
            var isIN = false
                for rang in newText.ranges(of: "@") {
                    if (rang.lowerBound.encodedOffset < range.upperBound){
                        func searchRang() {
                            var i = 0
                            if (text.count == 0) {
                                i = -range.length
                            } else {
                                i = text.count
                            }
                            rangSearch = rang.upperBound ..< "\(newText)\(newText)".index(rang.lowerBound, offsetBy:  range.upperBound + i - rang.lowerBound.encodedOffset)
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
                strSearch = String(newText[rangSearch])
                print(strSearch)
                if strSearch.count > 2 {
                    self.tbl.isHidden = false
                    //                    self.predicate(forPrefix: strSearch)
                    //                        return true
                }
            }
        }
        
        
        
        var strTxtView = textView.text ?? ""
        var selectedRange = range
        var deletedRanges = [Int]()
        var newString = NSString(string: textView.text!).replacingCharacters(in: range, with: text)
        var isFirst = false
        for i in 0 ..< arrRange.count {
//            var rangeLength = 0
//            if text.count == 0 {
//                rangeLength = -range.length
//            } else {
//                rangeLength = range.length
//            }
            
            if arrRange[i].lowerBound.encodedOffset  <= range.location  && arrRange[i].upperBound.encodedOffset > range.location  {
                //                print("name:-\(arrUsers[i])")
                
                deletedRanges.append(i)
                isFirst = true
            } else if ((range.location < arrRange[i].lowerBound.encodedOffset || range.location < arrRange[i].upperBound.encodedOffset) && (range.location + range.length > arrRange[i].lowerBound.encodedOffset || range.location + range.length > arrRange[i].upperBound.encodedOffset)) {
                deletedRanges.append(i)
                isFirst = false
            }
            
            if (text.count != 0) {
                
                //                for j in i ..< arrRange.count {
                if (arrRange[i].lowerBound.encodedOffset >= range.location) {
                    arrRange[i] = "\(newString)\(newString)".index(arrRange[i].lowerBound, offsetBy: text.count) ..< "\(newString)\(newString)".index(arrRange[i].upperBound, offsetBy:text.count)
                }
                //                }
            } else {
                if (arrRange[i].lowerBound.encodedOffset >= range.location && deletedRanges.count == 0) {
                    
                    arrRange[i] = "\(strTxtView)\(strTxtView)".index(arrRange[i].lowerBound, offsetBy: -(range.length)) ..< "\(strTxtView)\(strTxtView)".index(arrRange[i].upperBound, offsetBy:-(range.length))
                }
            }
        }
        //
        if (deletedRanges.count > 0) {
            
            if (deletedRanges.count == 1 && isFirst) {
                let removedRange = arrRange[deletedRanges[0]]
                arrRange.remove(at: deletedRanges[0])
                arrAddedUser.remove(at: deletedRanges[0])
                
                if (deletedRanges[0] < arrRange.count && text.count == 0) {
                    for i in deletedRanges[0] ..< arrRange.count {
                        arrRange[i] = "\(strTxtView)\(strTxtView)".index(arrRange[i].lowerBound, offsetBy: (removedRange.lowerBound.encodedOffset - removedRange.upperBound.encodedOffset)) ..< "\(strTxtView)\(strTxtView)".index(arrRange[i].upperBound, offsetBy:(removedRange.lowerBound.encodedOffset - removedRange.upperBound.encodedOffset))
                    }
                }
                if (text.count == 0){
                    strTxtView.removeSubrange(removedRange)
                    selectedRange.location = removedRange.lowerBound.encodedOffset
                    newString = strTxtView
                }
            } else {
                for deletedRange in deletedRanges.reversed() {
                    arrRange.remove(at: deletedRange)
                    arrAddedUser.remove(at: deletedRange)
                }
                if (deletedRanges[0] < arrRange.count && text.count == 0) {
                    for i in deletedRanges[0] ..< arrRange.count {
                        arrRange[i] = "\(strTxtView)\(strTxtView)".index(arrRange[i].lowerBound, offsetBy: -range.length) ..< "\(strTxtView)\(strTxtView)".index(arrRange[i].upperBound, offsetBy:-range.length)
                    }
                }
            }
        }
        
        for rag in arrRange.reversed() {
            //            var r = rag
            //            r = newString.index(after: r.lowerBound) ..< r.upperBound
            newString.insert("]", at: rag.upperBound)
            newString.insert("[", at: rag.lowerBound)
            newString.insert("@", at: rag.lowerBound)
        }
        setTxtView(newString)
        
        
        if (text.count != 0 ) {
            selectedRange.location += 1
        } else {
            selectedRange.length = 0
        }
        textView.selectedRange = selectedRange
        return false
    }
}
extension ViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        cell.textLabel?.text = arrUsers[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
            var strTemp = txtMain.text ?? ""
            var insertIndex = -1
            if let range = strTemp.range(of: "@\(strSearch)") {
                strTemp = strTemp.replacingOccurrences(of: "@\(strSearch)", with: "\(arrUsers[indexPath.row]) " , options: .literal, range: nil)
                //                strTemp = "\(strTemp)\((arrUserListTag[indexPath.row].title)!) "
                let r = range.lowerBound ..< "\(strTemp)\(strTemp)".index(range.lowerBound, offsetBy: (arrUsers[indexPath.row].count))
                
                for i in 0 ..< arrRange.count {
                    if (arrRange[i].upperBound.encodedOffset > r.upperBound.encodedOffset && insertIndex == -1) {
                        arrRange.insert(r, at: i)
                        arrAddedUser.insert(arrUsers[indexPath.row], at: i)
                        insertIndex = i
                    }
                }
                if (insertIndex == -1) {
                    arrRange.append(r)
                    arrAddedUser.append(arrUsers[indexPath.row])
                } else {
                    for i in insertIndex+1 ..< arrRange.count {
                        arrRange[i] = "\(strTemp)\(strTemp)".index(arrRange[i].lowerBound, offsetBy: arrUsers[indexPath.row].count - "@\(strSearch)".count + 1) ..< "\(strTemp)\(strTemp)".index(arrRange[i].upperBound, offsetBy:arrUsers[indexPath.row].count - "@\(strSearch)".count + 1)
                    }
                }
                
                for rag in arrRange.reversed() {
                    strTemp.insert("]", at: rag.upperBound)
                    strTemp.insert("[", at: rag.lowerBound)
                    strTemp.insert("@", at: rag.lowerBound)
                }
                print(strTemp)
            }
            
        
            setTxtView(strTemp)
         if (insertIndex != -1) {
            txtMain.selectedRange = NSMakeRange(arrRange[insertIndex].upperBound.encodedOffset, 0)
         }
            tbl.isHidden = true
            strSearch = ""
        
    }
    
}
