//
//  SearchViewController.swift
//  RecipeSearch
//
//  Created by Eslam on 11/14/19.
//  Copyright © 2019 EslamHanafy. All rights reserved.
//

import UIKit
import SearchTextField

class SearchViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchTextField: SearchTextField!
    @IBOutlet var noDataView: UIView!
    
    
    var recipes: [Recipe] = [] {
        didSet {
            noDataView.isHidden = recipes.count > 0
            tableView.reloadData()
        }
    }
    
    var keyword: String {
        return searchTextField.text ?? ""
    }
    
    var page = 0
    
    let refresher = UIRefreshControl()
    let manager = APIManager()
    
    let detailsId = "Details"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initTableView()
        initSearchTextField()
    }
    
    
    
    //MARK: - IBActions
    @IBAction func searchAction() {
        guard !keyword.withoutSpaces.isEmpty else {
            return
        }
        
        CacheManager.shared.add(keyword)
        searchTextField.filterStrings(CacheManager.shared.keywords)
        
        page = 0
        manager.getResipes(with: keyword, at: page, withLoader: true, onComplete: handleSearchResult(_:))
    }
}

//MARK: - Helpers
extension SearchViewController {
    @objc func refreshData() {
        manager.getResipes(with: keyword, at: 0) {
            [weak self] result in
            guard let self = self else { return }
            self.handleSearchResult(result)
            if result.error == nil { self.page = 0 }
        }
    }
    
    func getNextPageIfNeeded(fromInedx indexPath: IndexPath) {
        if indexPath.row == recipes.count - 1 {
            manager.getResipes(with: keyword, at: page + 1) {
                [weak self] result in
                guard let self = self else { return }
                if let error = result.error {
                    error.localizedDescription.display()
                }else {
                    self.recipes += self.filteredRecipes(from: result.recipes)
                    self.page += 1
                }
            }
        }
    }
    
    func filteredRecipes(from recipes: [Recipe]) -> [Recipe] {
        return recipes.filter({ recipe in
            !self.recipes.contains(where: { recipe.id == $0.id })
        })
    }
    
    func handleSearchResult(_ result: SearchResult) {
        refresher.endRefreshing()
        
        if let error = result.error {
            error.localizedDescription.display()
        }else {
            self.recipes = result.recipes
        }
    }
}

//MARK: - Search Text Field
extension SearchViewController {
    func initSearchTextField() {
        searchTextField.filterStrings(CacheManager.shared.keywords)
        searchTextField.theme.bgColor = .white
        searchTextField.theme.font = UIFont.systemFont(ofSize: 15)
        searchTextField.theme.cellHeight = 40
        searchTextField.startVisible = true
    }
}

//MARK: - Table View
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SearchTableViewCell
        cell.configure(with: recipes[indexPath.row])
        getNextPageIfNeeded(fromInedx: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainQueue { [unowned self] in
            self.performSegue(withIdentifier: self.detailsId, sender: self.recipes[indexPath.row])
        }
    }
    
    func initTableView() {
        tableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refresher
        }else {
            tableView.addSubview(refresher)
        }
        
        refresher.addTarget(self, action: #selector(self.refreshData), for: .valueChanged)
    }
}

// MARK: - Navigation
extension SearchViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailsId {
            (segue.destination as! DetailsViewController).recipe = (sender as! Recipe)
        }
    }
}
