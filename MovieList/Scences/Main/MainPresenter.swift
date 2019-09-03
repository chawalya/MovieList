//
//  MainPresenter.swift
//  MovieList
//
//  Created by Chawalya Tantisevi on 2/9/2562 BE.
//  Copyright (c) 2562 SCB. All rights reserved.
//

import UIKit

protocol MainPresenterInterface {
  func presentMovieList(response: Main.GetMovieList.Response)
}

class MainPresenter: MainPresenterInterface {
  weak var viewController: MainViewControllerInterface!

  // MARK: - Presentation logic

  func presentMovieList(response: Main.GetMovieList.Response) {
    typealias ViewModel = Main.GetMovieList.ViewModel
    typealias DisplayedMovie = Main.GetMovieList.ViewModel.DisplayedMovie
    var viewModel: ViewModel
    switch response.result {
    case .success(let data):
      let displayedMovies = data.results.map { (element) -> DisplayedMovie in
       
        return DisplayedMovie(name: element.title,
                              popularity: "\(element.popularity)",
                              vote: "\(element.voteAverage)",
                              backdropUrl: "https://image.tmdb.org/t/p/original\(element.backdropPath ?? "")",
                              posterUrl: "https://image.tmdb.org/t/p/original\(element.posterPath ?? "")")
      }
      viewModel = ViewModel(content: .success(displayedMovies))
    case .failure(let error):
      viewModel = ViewModel(content: .failure(error))
    }
    viewController.displayMovieList(viewModel: viewModel)

//    let viewModel = Main.Something.ViewModel()
//    viewController.displaySomething(viewModel: viewModel)
  }
}
