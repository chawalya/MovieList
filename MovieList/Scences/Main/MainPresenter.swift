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
    func presentSetSelectMovie(reponse: Main.SetSelectMovie.Response)
    func presentSetTotalPage(reponse: Main.SetLoadMore.Response)
}

class MainPresenter: MainPresenterInterface {
    weak var viewController: MainViewControllerInterface!

    func presentMovieList(response: Main.GetMovieList.Response) {
        typealias ViewModel = Main.GetMovieList.ViewModel
        typealias DisplayedMovie = Main.GetMovieList.ViewModel.DisplayedMovie
        typealias MovieViewModel = Main.GetMovieList.ViewModel.MovieViewModel
        var viewModel: ViewModel
        switch response.result {
        case let .success(data):
            let totalPage = data.totalPages
            let displayedMovies = data.results.map { (element) -> DisplayedMovie in
                let retrieveDict = UserDefaults.standard.dictionary(forKey: "voteByUser")
                var vote = element.voteAverage
                if let userVote = retrieveDict?[String(element.id)] as? Double {
                    vote = userVote
                }
                return DisplayedMovie(name: element.title,
                                      popularity: "Popularity : \(element.popularity)",
                                      vote: "\(vote)",
                                      backdropUrl: "https://image.tmdb.org/t/p/original\(element.backdropPath ?? "")",
                                      posterUrl: "https://image.tmdb.org/t/p/original\(element.posterPath ?? "")")
            }
            let movieViewModel = MovieViewModel(displayedMovies: displayedMovies, totalPage: totalPage)
            viewModel = ViewModel(content: .success(movieViewModel))
        case let .failure(error):
            viewModel = ViewModel(content: .failure(error))
        }
        viewController.displayMovieList(viewModel: viewModel)
    }

    func presentSetSelectMovie(reponse: Main.SetSelectMovie.Response) {
        let viewModel = Main.SetSelectMovie.ViewModel()
        viewController.displaySelectMovie(viewModel: viewModel)
    }

    func presentSetTotalPage(reponse: Main.SetLoadMore.Response) {
    }
}
