//
//  ViewController.swift
//  OMDb Demo
//
//  Created by Denis Aleksandrov on 1/30/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class SearchViewController: UIViewController {

    static let secrets = parseSecrets()
    static let OMDb_API_KEY = secrets.api_key
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    let omdbApiDescriptionUrl = "https://www.omdbapi.com/?"
    let omdbApiPosterUrl      = "https://img.omdbapi.com/?"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchDataFromOMDbAPI(movieName: "tt3896198")
    }

    func fetchDataFromOMDbAPI(movieName: String) {
        let omdbParameters : [String:String] = [
            "i":            movieName,
            "apikey":       SearchViewController.OMDb_API_KEY
        ]
        
        Alamofire.request(omdbApiDescriptionUrl, method: .get, parameters: omdbParameters).responseJSON { (response) in
            if response.result.isSuccess {
                print(#function + ": \(response)")
                let movieJSON: JSON = JSON(response.result.value!)
                let movieTitle = movieJSON["Title"].stringValue
                let movieRatingsZerothSource = movieJSON["Ratings"][0]["Source"].stringValue
                let movieRatingsZerothValue  = movieJSON["Ratings"][0]["Value"].stringValue
//                self.descriptionLabel.text = movieDescription
                let posterImageURL = movieJSON["Poster"].stringValue
                self.imageView.sd_setImage(with: URL(string: posterImageURL))
            }
        }
    }
}

// https://stackoverflow.com/questions/24045570/how-do-i-get-a-plist-as-a-dictionary-in-swift
struct Secrets: Decodable {
    private enum CodingKeys: String, CodingKey {
        case api_key
    }
    
    let api_key: String
}

func parseSecrets() -> Secrets {
    let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist")!
    let data = try! Data(contentsOf: url)
    let decoder = PropertyListDecoder()
    return try! decoder.decode(Secrets.self, from: data)
}
