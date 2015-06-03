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

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.clearsSelectionOnViewWillAppear = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sightNames() -> NSArray
    {
        var sightNames = [String]()
        
        for pointOfInterest in SightsListKeeper.sharedKeeper.pointsOfInterest
        {
            sightNames += [pointOfInterest.valueForKey("name") as! String]
        }
        
        return sightNames
    }
    
    func wantToSeeSights() -> NSArray {
        var wantToSeeSights = [String]()
        
        return wantToSeeSights
    }
    
    func alreadySeenSights() -> NSArray {
        var alreadySeenSights = [String]()
        
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
    
        cell.imageView.image = UIImage(named: sightNames()[indexPath.row] as! String)
        
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
                    header?.headerLabel.text = headerTexts[indexPath.section] + ": (you didn't add any sight yet)"
                }
            case 1:
                if 0 == self.sightNames().count {
                header?.headerLabel.text = headerTexts[indexPath.section] + ": (empty)"
                }
            case 2:
                if 0 == self.alreadySeenSights().count {
                    header?.headerLabel.text = headerTexts[indexPath.section] + ": (you haven't visited any sight yet)"
                }
            default: header?.headerLabel.text = headerTexts[indexPath.section]
            }
        }
        
        return header!
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(150.0, 150.0)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.delegate = self
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
        tableVC.selectedCellIndexPath = indexPath
        var cell = self.collectionView?.cellForItemAtIndexPath(indexPath) as! PictureCell
        
        tableVC.image = cell.imageView.image!
        tableVC.titleLabelText = (sightNames()[indexPath.row] as? String)!
    }
}
