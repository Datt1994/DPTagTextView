//
//  ViewController.swift
//  TagNameDetection
//
//  Created by datt on 04/04/18.
//  Copyright © 2018 Datt. All rights reserved.
//

import UIKit


class ViewController: UIViewController , UITextViewDelegate {
    @IBOutlet weak var txtMain: DPTagTextView!
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var lblTagName: UILabel!
    
    let isTagDetection = true
    
    var strSearch = String()
    let arrUsers : [String] = ["Datt Patel", "Dharmesh Shah","Arpit Dhamane","Nirzar Gandhi","Pooja Shah","Nilomi Shah","Pradip Rathod","Jiten Goswami"]
    var arrRange : [Range<String.Index>] = []
    var arrTagedUser : [String] = []
    let tagPrefix = "@[---"
    let tagPostfix = "---]"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (isTagDetection) {
           
            let str =  "Hello, All the Information about @[---Datt Patel---] is related to @[---Dharmesh Shah---] and @[---Arpit Dhamane---] which can be Defined by @[---Nirzar Gandhi---] and @[---Pooja Shah---] who are in company with @[---Nilomi Shah---] , @[---Pradip Rathod---] and @[---Jiten Goswami---] "
            self.txtMain.setTagDetection(isTagDetection)
            arrTagedUser = arrUsers
//            self.txtMain.tagPrefix = tagPrefix
//            self.txtMain.tagPostfix = tagPostfix
//            self.txtMain.arrTags = arrUsers
            _ = self.txtMain.getAllTag(str)
            self.txtMain.setTxt(str)
        }
        
//        txtMain.setDelegateToTextView()
        self.txtMain.delegate = self
        self.txtMain.dpTagDelegate = self
        tbl.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tbl.isHidden = true
        // Do any additional setup after loading the view, typically from a nib.
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return txtMain.dpTagTextView(textView, shouldChangeTextIn: range, replacementText: text)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func tagDetectionSwitchAction(_ sender: UISwitch) {
        txtMain.setTagDetection(sender.isOn)
    }
}
extension ViewController : DPTagTextViewDelegate {
    func tagSearchString(_ str: String) {
        if (str.count == 0) {
            tbl.isHidden = true
        } else {
            tbl.isHidden = false
        }
        print(str)
        strSearch = str
    }
    
    func removeTag(at index: Int, tagName: String) {
        arrTagedUser.remove(at: index)
    }
    
    func insertTag(at index: Int, tagName: String) {
        arrTagedUser.insert(tagName, at: index)
    }
    
    func detectTag(at index: Int, tagName: String) {
        print(tagName)
        lblTagName.text = tagName
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
        
        txtMain.insertTag(arrUsers[indexPath.row], strSearch: strSearch)
        tbl.isHidden = true
        strSearch = ""
        
    }
    
}

