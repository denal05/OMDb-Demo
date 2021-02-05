//
//  ViewController.swift
//  OMDb Demo
//
//  Created by Denis Aleksandrov on 1/30/21.
//

import UIKit
import SwiftyJSON
import SDWebImage

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    static var movieData = OMDbAPIResult(Title: "~~PLACEHOLDER~~")
    static var movieDictionary = movieData.dictionaryRepresentation
    static var movieArray = Array(movieDictionary.values)
    
    var omdbManager = OMDbManager()
    
    let beforeTheRain = "tt0110882"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate   = self
        searchBar.delegate   = self
        omdbManager.delegate = self
        
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reusableTableCell")
        tableView.reloadData()
    }
}

//MARK: Table View

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SearchViewController.movieArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = SearchViewController.movieArray[indexPath.row]
        //print(#function + ": item is: \n \(item)")
        //  cell = tableView.dequeueReusableCell(withIdentifier: "reusableTableCell", for: indexPath)
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "reusableTableCell")
        if let stringItem = item as? String {
            cell.textLabel?.text = stringItem
            cell.detailTextLabel?.text = Array(SearchViewController.movieDictionary.keys)[indexPath.row]
        }
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
}

//MARK: Search Bar

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        print(#function + " => `\(searchBar.text!)`")
        if let safeSearchBarText = searchBar.text {
            omdbManager.fetchOMDbAPIResultWithURLSession(movieTitle: safeSearchBarText)
        }
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

//MARK: - OMDbManagerDelegate

extension SearchViewController: OMDbManagerDelegate {
    func didUpdateMovieData(_ omdbManager: OMDbManager, movieModel: OMDbAPIResult) {
        print(#function + ": \(movieModel.Title)")
        DispatchQueue.main.async {
            SearchViewController.movieData = movieModel
            SearchViewController.movieDictionary = SearchViewController.movieData.dictionaryRepresentation
            SearchViewController.movieArray = Array(SearchViewController.movieDictionary.values)
            print(#function + ": SearchViewController.movieArray is: \n \(SearchViewController.movieArray)")
            self.imageView.sd_setImage(with: URL(string: movieModel.Poster))
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(#function + ": \(error)")
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error:", message: "Couldn't find that movie title.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
}
