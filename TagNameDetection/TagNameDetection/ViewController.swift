//
//  ViewController.swift
//  TagNameDetection
//
//  Created by datt on 04/04/18.
//  Copyright © 2018 Datt. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    @IBOutlet weak var tagTextView: DPTagTextView!
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var lblTagName: UILabel!
    @IBOutlet weak var switchTagDetection: UISwitch!
    
    let isTagDetection = true
    let arrUsers : [String] = ["Datt Patel", "Dharmesh Shah","Arpit Dhamane","Nirzar Gandhi","Pooja Shah","Nilomi Shah","Pradip Rathod","Jiten Goswami"]
    let arrHashTag : [String] = ["random", "memes", "meme", "love", "photography", "art", "humor", "like", "follow", "funny", "photooftheday"]
    var arrSearchUsers = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (isTagDetection) {
            switchTagDetection.setOn(isTagDetection, animated: true)
            tagTextView.setTagDetection(true)
            
            let tag1 = DPTag(name: "Lorem Ipsum", range: NSRange(location: 41, length: 11))
            let tag2 = DPTag(id: "567681647", name: "suffered", range: NSRange(location: 86, length: 9), data: ["withHashTag" : "#suffered"], isHashTag: true,customTextAttributes: [NSAttributedString.Key.foregroundColor: UIColor.green,NSAttributedString.Key.backgroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)])
            let tag3 = DPTag(name: "humour", range: NSRange(location: 133, length: 7), isHashTag: true)
            
            tagTextView.setText("There are many variations of passages of Lorem Ipsum available, but the majority have #suffered alteration in some form, by injected #humour, or randomised words which don't look even slightly believable.", arrTags: [tag1, tag2, tag3])
            
        }

        self.tagTextView.dpTagDelegate = self
        tbl.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tbl.isHidden = true
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func tagDetectionSwitchAction(_ sender: UISwitch) {
        tagTextView.setTagDetection(sender.isOn)
    }
    @IBAction func btnClearAction(_ sender: UIButton) {
        tagTextView.setText(nil, arrTags: [])
        print(tagTextView.arrTags)
    }
    
}
// MARK:- DPTagTextViewDelegate
extension ViewController : DPTagTextViewDelegate {
    
    func dpTagTextView(_ textView: DPTagTextView, didChangedTagSearchString strSearch: String, isHashTag: Bool) {
        
        if (strSearch.count == 0) {
            tbl.isHidden = true
        } else {
            tbl.isHidden = false
        }
        print(strSearch)
        arrSearchUsers = (isHashTag ? arrHashTag : arrUsers).filter({ (str) -> Bool in
            return str.lowercased().contains(strSearch.lowercased())
        })
        tbl.reloadData()
        
    }
    
    func dpTagTextView(_ textView: DPTagTextView, didInsertTag tag: DPTag) {
        
    }
    
    func dpTagTextView(_ textView: DPTagTextView, didRemoveTag tag: DPTag) {
        
    }
    
    func dpTagTextView(_ textView: DPTagTextView, didSelectTag tag: DPTag) {
        lblTagName.text = "\(tag.name) : \(tag.range) : \(tag.isHashTag ? tagTextView.hashTagSymbol : tagTextView.mentionSymbol)"
    }
    
    func dpTagTextView(_ textView: DPTagTextView, didChangedTags arrTags: [DPTag]) {
        
    }
    
}
// MARK:- UITableViewDelegate & UITableViewDataSource
extension ViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSearchUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        cell.textLabel?.text = arrSearchUsers[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tagTextView.addTag(tagText: arrSearchUsers[indexPath.row])
        tbl.isHidden = true
    }
    
}

