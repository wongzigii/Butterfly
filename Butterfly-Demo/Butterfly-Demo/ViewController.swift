//
//  ViewController.swift
//  Butterfly-Demo
//
//  Created by Wongzigii on 6/30/15.
//  Copyright (c) 2015 Wongzigii. All rights reserved.
//

import UIKit
import Butterfly

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var objectArray: Array<String>?
    
    var titleArray: Array<String>?
    
    var dateArray: Array<String>?
    
    var root = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        root = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("data", ofType: "plist")!)!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return root.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomSportCell", forIndexPath: indexPath) as! CustomCell
        cell.selectionStyle = .None
        
        let imgstr = root[indexPath.row]["bgimage"] as! String
        cell.backgroundImageView.image = UIImage(named: imgstr)
        
        let stadium = root[indexPath.row]["match"] as! String
        cell.stadiumLabel.text = stadium
        
        let date = root[indexPath.row]["date"] as! String
        cell.dateLabel.text = date
        
        let title = root[indexPath.row]["title"] as! String
        cell.titleLabel.text = title
        return cell
    }
}

public class CustomCell : UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stadiumLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
}
