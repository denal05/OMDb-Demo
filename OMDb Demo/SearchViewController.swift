//
//  ViewController.swift
//  OMDb Demo
//
//  Created by Denis Aleksandrov on 1/30/21.
//

import UIKit
import SwiftyJSON

class SearchViewController: UIViewController {

    static let secrets = parseSecrets()
    static let OMDb_API_KEY = secrets.api_key
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
