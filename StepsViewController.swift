//
//  StepsViewController.swift
//  New Orleans In Pictures
//
//  Created by Александр Нужный on 02.06.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import UIKit

class StepsViewController: UITableViewController {
    
    var steps: [AnyObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var popRecognizer: UIScreenEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: "handlePopRecognizer:")
        popRecognizer.edges = UIRectEdge.Left
        self.view.addGestureRecognizer(popRecognizer)
        
        self.setBackgroundImage(UIImage(named: "Texture_New_Orleans_1.png")!, forView: self.tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return steps.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! StepTableViewCell
        cell.instructionLabel.text = "\(indexPath.row + 1). \(self.steps[indexPath.row].instructions)"
        cell.contentView.backgroundColor = UIColor(patternImage: UIImage(named: "Texture_New_Orleans_1.png")!)
        
        return cell
    }
    
    override func viewWillAppear(animated: Bool) {
        animateTable()
    }
    
    func animateTable() {
        tableView.reloadData()
        
        let cells = tableView.visibleCells()
        let tableHeight = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as! UITableViewCell
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as! UITableViewCell
            UIView.animateWithDuration(1.0, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: nil, animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                }, completion: nil)
            index += 1
        }
    }
    
    func setBackgroundImage(image: UIImage, forView view: UIView) {
        self.view.backgroundColor = UIColor(patternImage: image)
        view.backgroundColor = UIColor(patternImage: image)
    }
}