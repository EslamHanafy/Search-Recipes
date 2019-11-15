//
//  ImageViewer.swift
//  Newroz
//
//  Created by Eslam on 11/3/19.
//  Copyright © 2019 magdsoft. All rights reserved.
//

import Foundation
import NVActivityIndicatorView
import AXPhotoViewer
import SDWebImage

class ImageViewer {
    class func show(_ url: URL?, from view: UIImageView? = nil, with title: NSAttributedString? = nil, and caption: NSAttributedString? = nil, fromController controller: UIViewController? = getCurrentViewController()) {
        if url == nil { return }
        
        let boxes = [ImageBox(url!, with: title, and: caption)]
        let dataSource = AXPhotosDataSource(photos: boxes)
        display(dataSource, from: view, fromController: controller)
    }
    
    
    private class func display(_ data: AXPhotosDataSource, from view: UIImageView?, fromController controller: UIViewController?) {
        let info = AXTransitionInfo(startingView: view, endingView: nil)
        
        let viewer = AXPhotosViewController(pagingConfig: nil, transitionInfo: info)
        viewer.dataSource = data
        controller?.present(viewer, animated: true, completion: nil)
    }
}
