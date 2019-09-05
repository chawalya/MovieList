//
//  DetailPresenter.swift
//  MovieList
//
//  Created by Chawalya Tantisevi on 2/9/2562 BE.
//  Copyright (c) 2562 SCB. All rights reserved.
//

import UIKit

protocol DetailPresenterInterface {
  func presentMovieDetail(response: Detail.GetMovieDetail.Response)
  func presentSetNewVoting(reponse: Detail.SetVoting.Response)
}

class DetailPresenter: DetailPresenterInterface {
  weak var viewController: DetailViewControllerInterface!

  // MARK: - Presentation logic

  func presentMovieDetail(response: Detail.GetMovieDetail.Response) {
    typealias ViewModel = Detail.GetMovieDetail.ViewModel
    var viewModel: ViewModel
    switch response.result{
    case .success(let movie):
//    guard let movie = response.result else { return }
      let displayMovie = Detail.GetMovieDetail.ViewModel.DisplayedMovie(
        title: movie?.title ?? "",
        detail: movie?.overview ?? "",
      category: movie?.genres.first?.name ?? "",
      language: movie?.originalLanguage ?? "",
      posterUrl: "https://image.tmdb.org/t/p/original\(movie?.posterPath)")
    
//      let ViewModelsend = DisplayedMovie(DisplayedMovie: displayMovie)
      viewModel = ViewModel(displayedMovie: .success(displayMovie))

//    viewController.displayMovieDetail(viewModel: viewModel)
    case .failure(let error): 
      viewModel = ViewModel(displayedMovie: .failure(error))
    }
    viewController.displayMovieDetail(viewModel: viewModel)


  }
  func presentSetNewVoting(reponse: Detail.SetVoting.Response){
    let viewModel = Detail.SetVoting.ViewModel()
    viewController.displayNewVote(viewModel: viewModel)
    
  }
  
  
}
