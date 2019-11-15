//
//  SearchTableViewCell.swift
//  RecipeSearch
//
//  Created by Eslam on 11/14/19.
//  Copyright © 2019 EslamHanafy. All rights reserved.
//

import UIKit
import SDWebImage
import NVActivityIndicatorView

class SearchTableViewCell: UITableViewCell {
    @IBOutlet var recipeImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var sourceLabel: UILabel!
    @IBOutlet var healthLabel: UILabel!
    @IBOutlet var loaderView: NVActivityIndicatorView!
    
    func configure(with recipe: Recipe) {
        titleLabel.text = recipe.title
        sourceLabel.text = recipe.source
        healthLabel.text = recipe.healthLabels
        
        configureRecipeImage(with: recipe.image.url)
    }
}

//MARK: - Helpers
private extension SearchTableViewCell {
    func configureRecipeImage(with url: URL?) {
        loaderView.startAnimating()
        recipeImageView.sd_setImage(with: url) { (image, _, _, _) in
            mainQueue { [weak self] in
                self?.loaderView.stopAnimating()
            }
        }
    }
}
