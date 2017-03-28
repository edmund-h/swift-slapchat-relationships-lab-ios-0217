//
//  TableViewController.swift
//  SlapChat
//
//  Created by Ian Rahman on 7/16/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

// credit to eirnym, adapted this from their OBJC code

// generates a random date and time

import UIKit

class TableViewController: UITableViewController{

    let store = DataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if store.getMessageCount() < 1000 {
            store.generateTestData()
        }
        
        DataStore.dateFormatter.dateFormat = "MMMM d, yyyy (hh:mm)"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.getMessageCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath)
        let messageForCell = store.getMessage(at: indexPath.row)
        cell.tag = indexPath.row
        let date = DataStore.dateFormatter.string(from: messageForCell.createdAt as! Date)
        cell.textLabel?.text = "\(date )"
        cell.detailTextLabel?.text = messageForCell.content
        return cell
    }
    
    
}
