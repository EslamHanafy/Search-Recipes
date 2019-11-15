//
//  AppDelegate.swift
//  RecipeSearch
//
//  Created by Eslam on 11/14/19.
//  Copyright © 2019 EslamHanafy. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        
        sleep(3)
        
        return true
    }
}

