//
//  MainInteractor.swift
//  MovieList
//
//  Created by Chawalya Tantisevi on 2/9/2562 BE.
//  Copyright (c) 2562 SCB. All rights reserved.
//

import UIKit

protocol MainInteractorInterface {
  func getMobileList(request: Main.GetMovieList.Request)
//  func getLoadMore(request: Main.GetLoadMore.Request)
  
}

class MainInteractor: MainInteractorInterface {
//  func getLoadMore(request: Main.GetLoadMore.Request) {
//    <#code#>
//  }
  
  var presenter: MainPresenterInterface!
  var worker: MovieWorker?
  
  var movieList: MovieList?
  
  // MARK: - Business logic

  func getMobileList(request: Main.GetMovieList.Request) {
    typealias Response = Main.GetMovieList.Response
    worker?.getMovieList({ (result) in
      var response: Response
      switch result {
      case .success(let data):
        self.movieList = data
        response = Response(result: .success(data))
        
      case .failure(let error):
        response = Response(result: .failure(error))
        
      }
      self.presenter.presentMovieList(response: response)
    })
//    worker?.getMovieList({ [weak self] result in
//      var response: Response
//      switch result {
//      case .success(let data):
//        self?.movieList = Response
//        response = Response(result: .success(result: data))
//      case .failure(let error):
//        response = Response(result: .failure(userError: error))
//      }
//      self?.presenter.presentMobileList(response: response)
//    })

  }
}
