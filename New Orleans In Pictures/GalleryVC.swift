//
//  GalleryVC.swift
//  New Orleans In Pictures
//
//  Created by Skorokhod, Dmytro on 4/24/15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import UIKit
import CoreData

let cellReuseIdentifier = "pictureCell"
let headerReuseIdentifier = "standardHeader"

class GalleryVC: UICollectionViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {
    
    let headerTexts = ["I want to see", "What To See In New Orleans", "Already Seen"]
    
    var currentManagedObject: NSManagedObject!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.clearsSelectionOnViewWillAppear = false
        self.setBackgroundImage(UIImage(named: "Texture_New_Orleans_2.png")!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func sightNames() -> NSArray
    {
        var sightNames = [String]()
        
        for pointOfInterest in SightsListKeeper.sharedKeeper.pointsOfInterest
        {
            if true != pointOfInterest.valueForKey("seen") as? Bool && true != pointOfInterest.valueForKey("planned") as? Bool {
                sightNames += [pointOfInterest.valueForKey("name") as! String]
            }
        }
        
        return sightNames
    }
    
    func wantToSeeSights() -> NSArray {
        
        var wantToSeeSights = [String]()
        
        for pointOfInterest in SightsListKeeper.sharedKeeper.pointsOfInterest {
            if true == pointOfInterest.valueForKey("planned") as? Bool {
                wantToSeeSights += [pointOfInterest.valueForKey("name") as! String]
            }
        }
        
        return wantToSeeSights
    }
    
    func alreadySeenSights() -> NSArray {
        
        var alreadySeenSights = [String]()
        
        for pointOfInterest in SightsListKeeper.sharedKeeper.pointsOfInterest {
            if true == pointOfInterest.valueForKey("seen") as? Bool {
                alreadySeenSights += [pointOfInterest.valueForKey("name") as! String]
            }
        }
        
        return alreadySeenSights
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 3
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0: return self.wantToSeeSights().count
        case 1: return self.sightNames().count
        case 2: return self.alreadySeenSights().count
        default: return 0
        }
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as! PictureCell
        
        switch indexPath.section {
        case 0:
            cell.imageView.image = UIImage(named: wantToSeeSights()[indexPath.row] as! String)
        case 1:
            cell.imageView.image = UIImage(named: sightNames()[indexPath.row] as! String)
        case 2:
            cell.imageView.image = UIImage(named: alreadySeenSights()[indexPath.row] as! String)
        default: break
        }
    
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView
    {
        var header: HeaderView?
        
        if UICollectionElementKindSectionHeader == kind
        {
            header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: headerReuseIdentifier, forIndexPath: indexPath) as? HeaderView
            
            switch indexPath.section {
            case 0:
                if 0 == self.wantToSeeSights().count {
                    header?.headerLabel.text = ""
                } else {
                    header?.headerLabel.text = headerTexts[indexPath.section]
                }
            case 1:
                if 0 == self.sightNames().count {
                    header?.headerLabel.text = ""
                } else {
                    header?.headerLabel.text = headerTexts[indexPath.section]
                }
            case 2:
                if 0 == self.alreadySeenSights().count {
                    header?.headerLabel.text = ""
                } else {
                    header?.headerLabel.text = headerTexts[indexPath.section]
                }
            default: header?.headerLabel.text = headerTexts[indexPath.section]
            }
        }
        
        return header!
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        self.currentManagedObject = self.managedObjectForSelecteditemAtIndexPath(indexPath)
        self.performSegueWithIdentifier("toTable", sender: self)
    }
    
    func managedObjectForSelecteditemAtIndexPath(indexPath: NSIndexPath) -> NSManagedObject {
        
        var selectedObject: NSManagedObject!
        var objects = SightsListKeeper.sharedKeeper.pointsOfInterest
        
        switch indexPath.section {
        case 0:
            for object in objects as! [NSManagedObject] {
                if self.wantToSeeSights()[indexPath.row] as? String == object.valueForKey("name") as? String {
                    selectedObject = object
                    break
                }
            }
        case 1:
            for object in objects as! [NSManagedObject] {
                if self.sightNames()[indexPath.row] as? String == object.valueForKey("name") as? String {
                    selectedObject = object
                    break
                }
            }
        case 2:
            for object in objects as! [NSManagedObject] {
                if self.alreadySeenSights()[indexPath.row] as? String == object.valueForKey("name") as? String {
                    selectedObject = object
                    break
                }
            }
        default: break
        }
        
        return selectedObject
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(150.0, 150.0)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.delegate = self
        
        self.collectionView?.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        if self.navigationController?.delegate === self {
            self.navigationController?.delegate = nil
        }
    }
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if fromVC == self && toVC.isKindOfClass(TableViewController) {
            return TransitionFromGalleryToDetail()
        } else {
            return nil
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let tableVC = segue.destinationViewController as! TableViewController
        var chosenCellIndexPaths = self.collectionView?.indexPathsForSelectedItems()
        var indexPath = (chosenCellIndexPaths as! [NSIndexPath])[0]
        var cell = self.collectionView?.cellForItemAtIndexPath(indexPath) as! PictureCell
        
        tableVC.selectedCellIndexPath = indexPath
        tableVC.image = cell.imageView.image!
        tableVC.currentManagedObject = self.currentManagedObject
        
        switch indexPath.section {
        case 0:
            tableVC.titleLabelText = (wantToSeeSights()[indexPath.row] as? String)!
            tableVC.sightName = (wantToSeeSights()[indexPath.row] as? String)!
        case 1:
            tableVC.titleLabelText = (sightNames()[indexPath.row] as? String)!
            tableVC.sightName = (sightNames()[indexPath.row] as? String)!
        case 2:
            tableVC.titleLabelText = (alreadySeenSights()[indexPath.row] as? String)!
            tableVC.sightName = (alreadySeenSights()[indexPath.row] as? String)!
        default: break
        }
    }
    
    func setBackgroundImage(image: UIImage) {
        self.collectionView?.frame = self.view.frame
        self.collectionView?.backgroundColor = UIColor(patternImage: image)
    }
}
