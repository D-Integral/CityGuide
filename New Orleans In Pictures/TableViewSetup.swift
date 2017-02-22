//
//  TableViewSetup.swift
//  New Orleans In Pictures
//
//  Created by Alexander Nuzhniy on 20.07.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import UIKit

extension DetailViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 3 ? 2 : 1
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0: return isCurrentDevicePadInLandscapeMode() ? heightForMapOnPadInLadscape() : self.tableView.frame.size.width
        case 1: return 40
        case 2: return heightForDescription()
        case 3: return 45
        default: return 0.0
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    func heightForDescription() -> CGFloat {
        
        let contentSize = self.descriptionTextView.sizeThatFits(self.descriptionTextView.bounds.size)
        var frame = self.descriptionTextView.frame
        frame.size.height = contentSize.height
        self.descriptionTextView.frame = frame
        
        return frame.size.height
    }
    
    func heightForMapOnPadInLadscape() -> CGFloat {
        return UIScreen.main.bounds.size.height - 95.0 - (self.navigationController?.navigationBar.bounds.size.height)! - heightForDescription() - 55
    }
}

