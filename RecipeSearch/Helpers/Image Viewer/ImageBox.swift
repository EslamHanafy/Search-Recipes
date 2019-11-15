//
//  ImageBox.swift
//  Newroz
//
//  Created by Eslam on 11/3/19.
//  Copyright © 2019 magdsoft. All rights reserved.
//

import Foundation
import AXPhotoViewer

class ImageBox: NSObject, AXPhotoProtocol {
    var url: URL?
    
    var image: UIImage?
    
    var imageData: Data?
    
    var attributedTitle: NSAttributedString?
    
    var attributedDescription: NSAttributedString?
    
    
    
    init(_ image: UIImage?, with title: NSAttributedString?, and caption: NSAttributedString?) {
        super.init()
        
        self.image = image
        self.imageData = image?.jpegData(compressionQuality: 1.0)
        self.attributedTitle = title
        self.attributedDescription = caption
    }
    
    init(_ url: URL?, with title: NSAttributedString?, and caption: NSAttributedString?) {
        self.url = url
        self.attributedTitle = title
        self.attributedDescription = caption
    }
}
