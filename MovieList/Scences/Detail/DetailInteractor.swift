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
    var voteCount: Int? { get set }
    var voteAvg: Double? { get set }
    var newVote: Double? { get set }
    func calculateVote(request: Detail.SetVoting.Request)
}

class DetailInteractor: DetailInteractorInterface {
    var presenter: DetailPresenterInterface!
    var worker: MovieDetailWorker?
    var selectedMovie: MovieDetail?
    var id: Int?
    var voteAvg: Double?
    var voteCount: Int?
    var newVote: Double?

    // MARK: - Business logic

    func getMovieDetail(request: Detail.GetMovieDetail.Request) {
        guard let id = id else { return }
      let response = Detail.SetStar.Response(id: id)
      presenter.presentStarVote(response: response)
        worker?.getMovieDetail(id: id) { [weak self] result in
            var response: Detail.GetMovieDetail.Response
            switch result {
            case let .success(data):
                self?.selectedMovie = data
                response = Detail.GetMovieDetail.Response(result: .success(data))
            case let .failure(error):
                response = Detail.GetMovieDetail.Response(result: .failure(error))
            }
            self?.presenter.presentMovieDetail(response: response)
        }
    }

    func calculateVote(request: Detail.SetVoting.Request) {
        guard let id = id else { return }
        voteCount = selectedMovie?.voteCount
        let count = Double(voteCount ?? 0)
        voteAvg = selectedMovie?.voteAverage
        let avg = voteAvg ?? 0.0
        newVote = ((avg * count) + (request.voteUser * 2)) / (count + 1)
      var retrieveStar = UserDefaults.standard.dictionary(forKey: "rateStar") ?? [:]
      retrieveStar[String(id)] = request.voteUser
        var retrieveDict = UserDefaults.standard.dictionary(forKey: "voteByUser") ?? [:]
        retrieveDict[String(id)] = newVote
        UserDefaults.standard.set(retrieveDict, forKey: "voteByUser")
      UserDefaults.standard.set(retrieveStar, forKey: "rateStar")
      
      
        let response2 = Detail.SetVoting.Response()
        presenter.presentSetNewVoting(reponse: response2)
    }
}
