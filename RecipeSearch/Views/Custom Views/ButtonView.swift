//
//  ButtonView.swift
//  Newroz
//
//  Created by Eslam on 4/12/19.
//  Copyright © 2019 magdsoft. All rights reserved.
//

import UIKit

@IBDesignable
class ButtonView: UIButton {
    
    @IBInspectable var image: UIImage? = nil {
        didSet {
            _imageView.image = image
        }
    }
    
    @IBInspectable var sizeMultiplier: CGFloat = 0.37 {
        didSet {
            if sizeMultiplier == 0 || sizeMultiplier > 1.0 {
                sizeMultiplier = oldValue
            }
        }
    }
    
    
    private lazy var _imageView: UIImageView = {
        let view = UIImageView(frame: CGRect.zero)
        view.image = image
        view.contentMode = .scaleAspectFit
        self.addSubview(view)
        return view
    }()
    
    
    override func draw(_ rect: CGRect) {
        prepareImageView(withRect: rect)
    }
    
    
    func prepareImageView(withRect rect: CGRect) {
        let size = rect.height * sizeMultiplier
        _imageView.frame.size = CGSize(width: size, height: size)
        _imageView.center = CGPoint(x: rect.midX, y: rect.midY)
    }
}
