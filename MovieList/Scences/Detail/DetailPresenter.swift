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
    guard let movie = response.movie else { return }
    let displayMovie = Detail.GetMovieDetail.ViewModel.DisplayedMovie(
      title: movie.title,
      detail: movie.overview,
      category: movie.genres.first?.name ?? "",
      language: movie.originalLanguage,
      posterUrl: "https://image.tmdb.org/t/p/original\(movie.posterPath)")
    
    let viewModel = Detail.GetMovieDetail.ViewModel(displayedMovie: displayMovie)
    viewController.displayMovieDetail(viewModel: viewModel)
  }
  func presentSetNewVoting(reponse: Detail.SetVoting.Response){
    let viewModel = Detail.SetVoting.ViewModel()
    viewController.displayNewVote(viewModel: viewModel)
    
  }
  
  
}
