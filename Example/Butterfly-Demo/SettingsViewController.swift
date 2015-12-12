//
//  SettingsViewController.swift
//  Butterfly-Demo
//
//  Created by Wongzigii on 6/30/15.
//  Copyright (c) 2015 Wongzigii. All rights reserved.
//

import UIKit

let onLabelText = "Butterfly start listening motion."
let offLabelText = "Butterfly end listening motion."

class SettingsViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingsCell", forIndexPath: indexPath) as! SettingsCell
        cell.switcher.setOn(self.butterflyIsListening(), animated: false)
        cell.label.text = self.butterflyIsListening() ? onLabelText : offLabelText
        return cell
    }
    
    func butterflyIsListening() -> Bool {
        if ButterflyManager.sharedManager.isListeningShake == true {
            return true
        } else {
            return false
        }
    }
}

class SettingsCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var switcher: UISwitch!
    
    @IBAction func swichButtonState(sender: UISwitch) {
        //var delegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if sender.on == true {
            ButterflyManager.sharedManager.startListeningShake()
            self.label.text = onLabelText
        }else {
            ButterflyManager.sharedManager.stopListeningShake()
            self.label.text = offLabelText
        }
    }
}
