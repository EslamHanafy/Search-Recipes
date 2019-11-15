//
//  DetailsViewController.swift
//  RecipeSearch
//
//  Created by Eslam on 11/15/19.
//  Copyright © 2019 EslamHanafy. All rights reserved.
//

import UIKit
import SafariServices
import SDWebImage
import NVActivityIndicatorView

class DetailsViewController: UIViewController {
    @IBOutlet var recipeImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var ingredientsTextView: UITextView!
    @IBOutlet var loaderView: NVActivityIndicatorView!
    
    
    var recipe: Recipe!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        displayRecipeData()
    }
    

    
    //MARK: - IBActions
    @IBAction func backAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func publisherAction() {
        if #available(iOS 11.0, *) {
            openSafaryController(with: recipe.url.url)
        }else {
            open(recipe.url.url)
        }
    }
    
    @IBAction func imageAction() {
        ImageViewer.show(recipe.image.url, from: recipeImageView, fromController: self)
    }
}

//MARK: - Helpers
extension DetailsViewController {
    @available(iOS 11, *)
    func openSafaryController(with url: URL?) {
        if let url = url {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true

            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
    
    func open(_ url: URL?) {
        if let url = url, UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            "Sorry, can not open the publisher's website link".display()
        }
    }
    
    func displayRecipeData() {
        displayRecipeImage()
        
        titleLabel.text = recipe.title
        ingredientsTextView.text = recipe.ingredients
    }
    
    func displayRecipeImage() {
        loaderView.startAnimating()
        recipeImageView.sd_setImage(with: recipe.image.url) {
            [weak self] (_, error, _, _) in
            if error == nil {
                self?.loaderView.stopAnimating()
            }
        }
    }
}
