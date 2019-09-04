//
//  DetailInteractor.swift
//  MovieList
//
//  Created by Chawalya Tantisevi on 2/9/2562 BE.
//  Copyright (c) 2562 SCB. All rights reserved.
//

import UIKit

protocol DetailInteractorInterface {
  func getMovieDetail(request: Detail.GetMovieDetail.Request)
  var selectedMovie: MovieDetail? { get set }
  var id: Int? { get set }
}

class DetailInteractor: DetailInteractorInterface {
  var presenter: DetailPresenterInterface!
  var worker: MovieDetailWorker?
  var selectedMovie: MovieDetail?
  var id: Int?

  // MARK: - Business logic

  func getMovieDetail(request: Detail.GetMovieDetail.Request) {
    guard let id = id else { return }
    worker?.getMovieDetail(id: id){ [weak self] result in
      var response: Detail.GetMovieDetail.Response
      switch result {
      case .success(let data):
        self?.selectedMovie = data
        response = Detail.GetMovieDetail.Response(movie: data)
      case .failure(let error):
        print("________________________")
        response = Detail.GetMovieDetail.Response(movie: nil)
      }
      self?.presenter.presentMovieDetail(response: response)
    }
  }
  
}



