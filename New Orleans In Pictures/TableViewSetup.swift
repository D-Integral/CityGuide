//
//  TableViewSetup.swift
//  New Orleans In Pictures
//
//  Created by Alexander Nuzhniy on 20.07.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import UIKit

extension DetailViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 3 ? 2 : 1
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0: return isCurrentDevicePadInLandscapeMode() ? heightForMapOnPadInLadscape() : self.tableView.frame.size.width
        case 1: return 40
        case 2: return heightForDescription()
        case 3: return 45
        default: return 0.0
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = .clearColor()
    }
    
    func heightForDescription() -> CGFloat {
        
        let contentSize = self.descriptionTextView.sizeThatFits(self.descriptionTextView.bounds.size)
        var frame = self.descriptionTextView.frame
        frame.size.height = contentSize.height
        self.descriptionTextView.frame = frame
        
        return frame.size.height
    }
    
    func heightForMapOnPadInLadscape() -> CGFloat {
        return UIScreen.mainScreen().bounds.size.height - 95.0 - (self.navigationController?.navigationBar.bounds.size.height)! - heightForDescription() - 55
    }
}

