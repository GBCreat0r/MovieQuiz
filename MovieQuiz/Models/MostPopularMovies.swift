//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by semrumyantsev on 30.01.2025.
//

import Foundation

struct MostPopularMovies: Codable {
    let errorMessage: String
    let items: [MostPopularMovie]
}

struct MostPopularMovie: Codable {
    let title: String
    let rating: String
    let imageURL: URL
    
    var resizeImageURL: URL {
        let urlString = imageURL.absoluteString
        let imageUrlString = urlString.components(separatedBy: "._") [0] +
        "._V0_UX600_.jpg"
        guard let newURL = URL(string: imageUrlString) else { return imageURL}
        return newURL
    }
    
    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
    }
}
