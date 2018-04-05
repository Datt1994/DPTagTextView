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

class ViewController: UIViewController {
    @IBOutlet weak var txtMain: UITextView!
    var rangeCurrent : UITextRange!
    var strTextView : String!
    let arrUsers : [String] = ["Datt Patel", "Dharmesh Shah","Arpit Dhamane","Nirzar Gandhi","Pooja Shah","Nilomi Shah","Pradip Rathod","Jiten Goswami"]
    var arrRange : [ClosedRange<String.Index>] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnTextView(_:)))
        self.txtMain.addGestureRecognizer(tapGesture)
        
        var str =  "Hello, All the Information about *Datt Patel* is related to *Dharmesh Shah* and *Arpit Dhamane* which can be Defined by *Nirzar Gandhi* and *Pooja Shah* who are in company with *Nilomi Shah* , *Pradip Rathod* and *Jiten Goswami* "
        
        for i in arrUsers {
            for range in str.ranges(of: "*\(i)*") {
                let rng = str.index(before: range.lowerBound) ... str.index(before: str.index(before: range.upperBound))
                str = str.replacingOccurrences(of: "*\(i)*", with: i)
                arrRange.append(rng)
            }
        }
        let formattedString = NSMutableAttributedString(string:str)
        for range in arrRange {
            formattedString.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "HelveticaNeue-Bold", size: CGFloat(17.0))!, range: NSRange(location:range.lowerBound.encodedOffset,length:range.upperBound.encodedOffset-range.lowerBound.encodedOffset))
        }
        
        self.txtMain.attributedText = formattedString
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc private final func tapOnTextView(_ recognizer: UITapGestureRecognizer){
        
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
}
