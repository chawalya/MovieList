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
    func setCountPage(request: Main.SetLoadMore.Request)
    func pullToRefresh(request: Main.PullToRefresh.Request)
    var selectedMovie: Movie? { get }

}

class MainInteractor: MainInteractorInterface {
    var presenter: MainPresenterInterface!
    var worker: MovieWorker?
    var selectedMovie: Movie?
    var movieList: MovieList?
    var loading = false
    var currentPage: Int = 1
    var totalPage: Int = 0
    var sortCurrent: Main.GetMovieList.SortData?
    var sort: Main.GetMovieList.SortData?


    // MARK: - Business logic

    func getMovieList(request: Main.GetMovieList.Request) {
        typealias Response = Main.GetMovieList.Response
//    let page = request.page
        var page = currentPage
        sort = request.sortType
        if sortCurrent != sort {
            page = 1
            currentPage = 1
            sortCurrent = sort
        }
        if let movieList = movieList, request.useCache {
            let response = Response(result: .success(movieList))
            presenter.presentMovieList(response: response)
        } else {
            if !loading { // false
                loading = true
                worker?.getMovieList(page: page, sort: sort ?? .ASC) { [weak self] result in
                    self?.loading = false
                    var response: Response
                    switch result {
                    case let .success(data):
                        var results: [Movie]
                        if page == 1 {
                            self?.movieList = nil
                        }
                        if let movieList = self?.movieList {
                            results = movieList.results + data.results
                        } else {
                            results = data.results
                            self?.totalPage = data.totalPages
                        }
                        let movieList = MovieList(page: data.page,
                                                  totalResults: data.totalResults,
                                                  totalPages: data.totalPages,
                                                  results: results)
                        self?.movieList = movieList
                        response = Response(result: .success(movieList))

                    case let .failure(error):
                        response = Response(result: .failure(error))
                    }
                    self?.presenter.presentMovieList(response: response)
                }
            }
        }
    }

    func setSelectMovie(request: Main.SetSelectMovie.Request) {
        let index = request.index
        selectedMovie = movieList?.results[index]
        let response = Main.SetSelectMovie.Response()
        presenter.presentSetSelectMovie(reponse: response)
    }

    func setCountPage(request: Main.SetLoadMore.Request) {
        var sort = request.sort
        currentPage += 1
        if currentPage <= totalPage {
            let request = Main.GetMovieList.Request(useCache: false, sortType: sort)
            getMovieList(request: request)
        }
    }

    func pullToRefresh(request: Main.PullToRefresh.Request) {
        currentPage = request.currentPage
        movieList = nil
        let request = Main.GetMovieList.Request(useCache: false, sortType: sort ?? .ASC)
        getMovieList(request: request)
    }
}
