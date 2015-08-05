//
//  TableViewSetup.swift
//  New Orleans In Pictures
//
//  Created by Alexander Nuzhniy on 20.07.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import UIKit

extension TableViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 3 ? 2 : 1
    }
    
    func setupTableViewBackground() {
        for section in 0..<tableView.numberOfSections(){
            setupBackgroundforCellInSection(section)
        }
    }
    
    func setupBackgroundforCellInSection(section: Int) {
        var cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: section))
        setupBackgroundForCell(&cell!)
        
        if section == 3 {
            for i in 0...1 {
                var cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: section))
                setupBackgroundForCell(&cell!)
            }
        }
    }
    
    func setupBackgroundForCell(inout cell: UITableViewCell) {
        cell.contentView.backgroundColor = UIColor(patternImage: UIImage(named: backgroundImage)!)
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
}

