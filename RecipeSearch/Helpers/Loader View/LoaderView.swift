//
//  LoaderView.swift
//  Servants
//
//  Created by Eslam on 11/14/16.
//  Copyright © 2016 magdsoft. All rights reserved.
//

import UIKit
import NVActivityIndicatorView


class LoaderView: UIView {
    static let shared: LoaderView = LoaderView.getInstance()
    
    @IBOutlet var loader: NVActivityIndicatorView!
    @IBOutlet var titleLabel: UILabel!
    
    
    static var onCancel: (()->())?
    
    
    
    /// get new instance from LoaderView and add it to the main window
    ///
    /// - Returns: new LoaderView
    fileprivate static func getInstance() -> LoaderView {
        let window = UIApplication.shared.keyWindow!
        
        let view = Bundle.main.loadNibNamed("LoaderView", owner: window, options: nil)?.first as! LoaderView
        view.frame = window.frame
        view.isHidden = true
        window.addSubview(view)
        return view
    }
    
    
    //MARK: - IBAction
    @IBAction func cancelAction() {
        displayConfirmationAlert()
    }
}

//MARK: - Show/Hide Options
extension LoaderView {
    static func show(withTitle title: String? = nil) {
        mainQueue {
            if let title = title {
                shared.titleLabel.text = title
                shared.titleLabel.isHidden = false
            }else {
                shared.titleLabel.isHidden = true
            }
            
            if shared.isHidden {
                UIApplication.shared.keyWindow?.bringSubviewToFront(shared)
                shared.isHidden = false
                shared.loader.startAnimating()
            }
        }
    }
    
    
    /// hide the loader view
    static func hide() {
        guard !shared.isHidden else { return }
        mainQueue {
            LoaderView.onCancel = nil
            UIApplication.shared.keyWindow?.sendSubviewToBack(LoaderView.shared)
            shared.titleLabel.isHidden = true
            shared.titleLabel.text = ""
            shared.isHidden = true
            shared.loader.stopAnimating()
        }
    }
}

//MARK: - Helpers
extension LoaderView {
    static func comeToWindowIfNeeded() {
        if !shared.isHidden {
            UIApplication.shared.keyWindow?.bringSubviewToFront(LoaderView.shared)
        }
    }
    
    /// display cancel request confirmation alert
    fileprivate func displayConfirmationAlert() {
        let alert = UIAlertController(title: "Cancel", message: "Are you sure you want to cancel this request?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (_) in
            LoaderView.onCancel?()
            LoaderView.hide()
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (_) in
            UIApplication.shared.keyWindow?.bringSubviewToFront(self)
        }))
        
        UIApplication.shared.keyWindow?.sendSubviewToBack(self)
        getCurrentViewController()?.present(alert, animated: true, completion: nil)
    }
}
