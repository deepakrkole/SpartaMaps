//
//  AppSettings.swift
//  SpartaMaps
//
//  Created by Jatin on 11/13/15.
//  Copyright © 2015 Jatin. All rights reserved.
//

import UIKit

class AppSettings: NSObject {

    static let appSettings : AppSettings = AppSettings();
    
    override init() {
        
    }
    
    func setZoom(zoom : CGFloat) {
    
        NSUserDefaults.standardUserDefaults().setFloat(Float(zoom), forKey: "zoomLevel");
        NSUserDefaults.standardUserDefaults().synchronize();
    }
    
    func getZoom() -> CGFloat {
    
        return CGFloat(NSUserDefaults.standardUserDefaults().floatForKey("zoomLevel"));
    }
    
    func setContentOffset (offset : CGPoint) {
    
        NSUserDefaults.standardUserDefaults().setObject(NSStringFromCGPoint(offset), forKey: "contentOffset");
        NSUserDefaults.standardUserDefaults().synchronize();
    }
    
    func getContentOffset () -> CGPoint {
        
        if ((NSUserDefaults.standardUserDefaults().objectForKey("contentOffset")) != nil) {
            
            return CGPointFromString(NSUserDefaults.standardUserDefaults().objectForKey("contentOffset") as! String);
        } else {
            
            return CGPointMake(0, 0);
        }
    }
}