//
//  OMDbAPIResult.swift
//  OMDb Demo
//
//  Created by Denis Aleksandrov on 2/1/21.
//

import Foundation

struct OMDbAPIResult: Codable {
    var Title:      String = "-- default placeholder --"
    var Year:       String = ""
    var Rated:      String = ""
    var Released:   String = ""
    var Runtime:    String = ""
    var Genre:      String = ""
    var Director:   String = ""
    var Writer:     String = ""
    var Actors:     String = ""
    var Plot:       String = ""
    var Language:   String = ""
    var Country:    String = ""
    var Awards:     String = ""
    var Poster:     String = ""
    var Ratings:    [RatingsArray] = []
    var Metascore:  String = ""
    var imdbRating: String = ""
    var imdbVotes:  String = ""
    var imdbID:     String = ""
    var `Type`:     String = ""
    var DVD:        String = ""
    var BoxOffice:  String = ""
    var Production: String = ""
    var Website:    String = ""
    var Response:   String = ""
    
    // This space intentionally left black to align line numbers.
    
    var dictionaryRepresentation: [String: Any] {
        return [
            "Title":      Title,
            "Year":       Year,
            "Rated":      Rated,
            "Released":   Released,
            "Runtime":    Runtime,
            "Genre":      Genre,
            "Director":   Director,
            "Writer":     Writer,
            "Actors":     Actors,
            "Plot":       Plot,
            "Language":   Language,
            "Country":    Country,
            "Awards":     Awards,
            "Poster":     Poster,
            "Ratings":    Ratings,
            "Metascore":  Metascore,
            "imdbRating": imdbRating,
            "imdbVotes":  imdbVotes,
            "imdbID":     imdbID,
            "Type":       `Type`,
            "DVD":        DVD,
            "BoxOffice":  BoxOffice,
            "Production": Production,
            "Website":    Website,
            "Response":   Response
        ]
    }
    
//    init(Title: String) {
//        self.Title = Title
//    }
//
//    init(Title: String, Poster: String) {
//        self.Title  = Title
//        self.Poster = Poster
//    }
}

struct RatingsArray: Codable{
    var Source: String = ""
    var Value:  String = ""
}
