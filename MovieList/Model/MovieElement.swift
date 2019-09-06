//
//  MovieElement.swift
//  MovieList
//
//  Created by Chawalya Tantisevi on 3/9/2562 BE.
//  Copyright © 2562 SCB. All rights reserved.
//

import Foundation

struct MovieList: Codable {
    let page, totalResults, totalPages: Int
    let results: [Movie]

    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
}

struct Movie: Codable {
    let popularity: Double
    let id: Int
    let video: Bool
    let voteCount: Int
    let voteAverage: Double
    let title, releaseDate, originalLanguage, originalTitle: String
    let genreIDS: [Int]
    let backdropPath: String?
    let adult: Bool
    let overview: String
    let posterPath: String?

    enum CodingKeys: String, CodingKey {
        case popularity, id, video
        case voteCount = "vote_count"
        case voteAverage = "vote_average"
        case title
        case releaseDate = "release_date"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case genreIDS = "genre_ids"
        case backdropPath = "backdrop_path"
        case adult, overview
        case posterPath = "poster_path"
    }
}

struct MovieDetail: Codable {
    let genres: [Genre]
    let id: Int
    let imdbID, originalLanguage, overview: String
    let popularity: Double
    let title: String
    let voteAverage: Double
    let voteCount: Int
    let posterPath: String

    enum CodingKeys: String, CodingKey {
        case genres, id
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case overview, popularity
        case title
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case posterPath = "poster_path"
    }
}

// MARK: - BelongsToCollection

struct BelongsToCollection: Codable {
    let id: Int
    let name, posterPath, backdropPath: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}

// MARK: - Genre

struct Genre: Codable {
    let id: Int
    let name: String
}
