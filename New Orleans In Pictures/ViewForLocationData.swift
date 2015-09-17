//
//  ViewForLocationData.swift
//  New Orleans In Pictures
//
//  Created by Alexander Nizhniy on 07.08.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import UIKit

@IBDesignable class ViewForLocationData: UIView {
    
    @IBOutlet weak var compassImageView: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var singleCompassImageView: UIImageView!
    var view: UIView!
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        super.init(frame: frame)
        xibSetup()
    }
    
    required init(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        super.init(coder: aDecoder)!
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "ViewForLocationData", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
}
