//
//  CommonMethods.swift
//  Servants
//
//  Created by Eslam on 11/23/16.
//  Copyright © 2016 magdsoft. All rights reserved.
//

import UIKit
import SystemConfiguration


public var screenWidth:CGFloat { get { return UIScreen.main.bounds.size.width } }
public var screenHeight:CGFloat { get { return UIScreen.main.bounds.size.height } }
public var isIpad: Bool { return UIScreen.main.traitCollection.horizontalSizeClass == .regular }


func ESLog(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    Swift.print("", terminator: terminator)
    Swift.print("===========================================================", terminator: terminator)
    let output = items.map { "*\($0)" }.joined(separator: separator)
    Swift.print(output, terminator: terminator)
    #endif
}

func getCurrentViewController() -> UIViewController? {
    
    // we must get the root UIViewController and iterate through presented views
    if let rootController = UIApplication.shared.keyWindow?.rootViewController {
        
        var currentController: UIViewController! = rootController
        
        // Each ViewController keeps track of the view it has presented, so we
        // can move from the head to the tail, which will always be the current view
        while( currentController.presentedViewController != nil ) {
            
            currentController = currentController.presentedViewController
        }
        return currentController
    }
    
    return nil
}

func isConnectedToNetwork() -> Bool {
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            SCNetworkReachabilityCreateWithAddress(nil, $0)
        }
    }) else {
        return false
    }
    
    var flags: SCNetworkReachabilityFlags = []
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
        return false
    }
    
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    
    return (isReachable && !needsConnection)
}

