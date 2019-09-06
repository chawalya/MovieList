//
//  MovieWorker.swift
//  MovieList
//
//  Created by Chawalya Tantisevi on 3/9/2562 BE.
//  Copyright © 2562 SCB. All rights reserved.
//

import Foundation

protocol MovieStoreProtocol {
  func getMovieList(page:Int,sort: Main.GetMovieList.SortData,_ completion: @escaping (Result<MovieList>) -> Void)
}

class MovieWorker {
  
  var store: MovieStoreProtocol
  
  init(store: MovieStoreProtocol) {
    self.store = store
  }
  
  // MARK: - Business Logic
  
  func getMovieList(page:Int,sort: Main.GetMovieList.SortData,_ completion: @escaping (Result<MovieList>) -> Void) {
    // NOTE: Do the work
    store.getMovieList(page:page,sort: sort) {
      // The worker may perform some small business logic before returning the result to the Interactor
      completion($0)
    }
  }
}
