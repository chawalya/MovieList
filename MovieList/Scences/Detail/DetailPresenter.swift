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
  func presentStarVote(response: Detail.SetStar.Response)
}

class DetailPresenter: DetailPresenterInterface {
    weak var viewController: DetailViewControllerInterface!

    // MARK: - Presentation logic

    func presentMovieDetail(response: Detail.GetMovieDetail.Response) {
        typealias ViewModel = Detail.GetMovieDetail.ViewModel
        var viewModel: ViewModel
        switch response.result {
        case let .success(movie):
            let displayMovie = Detail.GetMovieDetail.ViewModel.DisplayedMovie(
                title: movie?.title ?? "",
                detail: movie?.overview ?? "",
                category: "Category : \(movie?.genres.first?.name ?? "")",
                language: "Language : \(movie?.originalLanguage ?? "")",
                posterUrl: "https://image.tmdb.org/t/p/original\(movie?.posterPath ?? "")")

            print(displayMovie.category)
            print(displayMovie.language)
            viewModel = ViewModel(displayedMovie: .success(displayMovie))

        case let .failure(error):
            viewModel = ViewModel(displayedMovie: .failure(error))
        }
        viewController.displayMovieDetail(viewModel: viewModel)
    }

    func presentSetNewVoting(reponse: Detail.SetVoting.Response) {
        let viewModel = Detail.SetVoting.ViewModel()
        viewController.displayNewVote(viewModel: viewModel)
    }
  func presentStarVote(response: Detail.SetStar.Response){
       let starVoteUser = UserDefaults.standard.dictionary(forKey: "rateStar")
    if let countStar = starVoteUser?[String(response.id)] as? Double{
      let viewModel = Detail.SetStar.ViewModel(star: countStar)
      viewController.displayStarRate(viewModel: viewModel)
      

    }

  }
}
