//
//  MovieDetailWorker.swift
//  MovieList
//
//  Created by Chawalya Tantisevi on 4/9/2562 BE.
//  Copyright © 2562 SCB. All rights reserved.
//

import UIKit

protocol MovieDetailProtocol {
    func getMovieDetail(id: Int, completion: @escaping (Result<MovieDetail>) -> Void)
}

class MovieDetailWorker {
    var store: MovieDetailProtocol

    init(store: MovieDetailProtocol) {
        self.store = store
    }

    // MARK: - Business Logic

    func getMovieDetail(id: Int, completion: @escaping (Result<MovieDetail>) -> Void) {
        // NOTE: Do the work

        store.getMovieDetail(id: id) {
            // The worker may perform some small business logic before returning the result to the Interactor
            completion($0)
        }
    }
}
