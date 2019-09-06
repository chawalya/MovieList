//
//  MainInteractor.swift
//  MovieList
//
//  Created by Chawalya Tantisevi on 2/9/2562 BE.
//  Copyright (c) 2562 SCB. All rights reserved.
//

import UIKit

protocol MainInteractorInterface {
  func getMovieList(request: Main.GetMovieList.Request)
  func setSelectMovie(request: Main.SetSelectMovie.Request)
//  func getLoadMore(request: Main.GetLoadMore.Request)
  var selectedMovie: Movie? { get }
  var id: Int? { get set }
}

class MainInteractor: MainInteractorInterface {
//  func getLoadMore(request: Main.GetLoadMore.Request) {
//
//  }
  var presenter: MainPresenterInterface!
  var worker: MovieWorker?
  var id: Int?
  var selectedMovie: Movie?
  var movieList: MovieList?
  
  // MARK: - Business logic

  func getMovieList(request: Main.GetMovieList.Request) {
    typealias Response = Main.GetMovieList.Response
    let page = request.page
    let sort = request.sortType
    if let movieList = movieList, request.useCache {
      let response = Response(result: .success(movieList))
      presenter.presentMovieList(response: response)
    } else {
      worker?.getMovieList(page:page,sort:sort) { [weak self] (result) in
        var response: Response
        switch result {
        case .success(let data):
          var results: [Movie]
          if page == 1{
            self?.movieList = nil
          }
          if let movieList = self?.movieList {
            results = movieList.results + data.results
          } else {
            results = data.results
          }
          let movieList = MovieList(page: data.page,
                                    totalResults: data.totalResults,
                                    totalPages: data.totalPages,
                                    results: results)
          self?.movieList = movieList
          response = Response(result: .success(movieList))
          
        case .failure(let error):
          response = Response(result: .failure(error))
          
        }
        self?.presenter.presentMovieList(response: response)
      }
    }
  }
  
  func setSelectMovie(request: Main.SetSelectMovie.Request) {
    let index = request.index
    selectedMovie = movieList?.results[index]
    self.id = selectedMovie?.id
    let response = Main.SetSelectMovie.Response()
    presenter.presentSetSelectMovie(reponse: response)
  }
  
  
}
