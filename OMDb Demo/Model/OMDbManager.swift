//
//  OMDbManager.swift
//  OMDb Demo
//
//  Created by Denis Aleksandrov on 2/3/21.
//

import Foundation

protocol OMDbManagerDelegate {
    func didUpdateMovieData(_ omdbManager: OMDbManager, movieModel: OMDbAPIResult)
    func didFailWithError(error: Error)
}

struct OMDbManager {
    static let secrets = parseSecrets()
    static let OMDb_API_KEY = secrets.api_key
    
    var delegate: OMDbManagerDelegate?
    
    let omdbApiUrl = "https://www.omdbapi.com/?"
    
    func fetchOMDbAPIResultWithURLSession(movieTitle: String) {
        let urlString = omdbApiUrl +
                        "apikey=" + OMDbManager.OMDb_API_KEY +
                        "&t=" + movieTitle.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!
        print(#function + ": \(urlString)")
        performURLSessionRequest(with: urlString)
    }
    
    func performURLSessionRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let movieData = self.parseJSON(safeData) {
                        self.delegate?.didUpdateMovieData(self, movieModel: movieData)
                    }
                    print(#function + ": data from URLSession.dataTask: \n \(safeData.debugDescription)")
                }
                
                if let safeResponse = response {
                    //print(#function + ": response from URLSession.dataTask: \n \(safeResponse)")
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ movieData: Data) -> OMDbAPIResult? {
        let decoder = JSONDecoder()
        do {

            let decodedData = try decoder.decode(OMDbAPIResult.self, from: movieData)
            let omdbModel = OMDbAPIResult(
                                Title:      decodedData.Title,
                                Year:       decodedData.Year,
                                Rated:      decodedData.Rated,
                                Released:   decodedData.Released,
                                Runtime:    decodedData.Runtime,
                                Genre:      decodedData.Genre,
                                Director:   decodedData.Director,
                                Writer:     decodedData.Writer,
                                Actors:     decodedData.Actors,
                                Plot:       decodedData.Plot,
                                Language:   decodedData.Language,
                                Country:    decodedData.Country,
                                Awards:     decodedData.Awards,
                                Poster:     decodedData.Poster,
                                Ratings:    decodedData.Ratings,
                                Metascore:  decodedData.Metascore,
                                imdbRating: decodedData.imdbRating,
                                imdbVotes:  decodedData.imdbVotes,
                                imdbID:     decodedData.imdbID,
                                Type:       decodedData.Type,
                                DVD:        decodedData.DVD,
                                BoxOffice:  decodedData.BoxOffice,
                                Production: decodedData.Production,
                                Website:    decodedData.Website,
                                Response:   decodedData.Response
                            )
            print(#function + ": decodedData.Title is \"\(decodedData.Title)\"")
            return omdbModel
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
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
