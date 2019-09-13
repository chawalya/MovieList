//
//  DetailInteractorTests.swift
//  MovieList
//
//  Created by Chawalya Tantisevi on 12/9/2562 BE.
//  Copyright (c) 2562 SCB. All rights reserved.
//

@testable import MovieList
import XCTest

class DetailInteractorTests: XCTestCase {

  // MARK: - Subject under test

  var sut: DetailInteractor!
  var detailWorkerOutputSpy = DetailWorkerOutputSpy(store: MovieDetailStore())
  var detailPresenOutputSpy = DetailPresentOutputSpy()


  // MARK: - Test lifecycle

  override func setUp() {
    super.setUp()
    setupDetailInteractor()
  }

  override func tearDown() {
    super.tearDown()
  }

  // MARK: - Test setup

  func setupDetailInteractor() {
    sut = DetailInteractor()
    sut.worker = detailWorkerOutputSpy
    sut.presenter = detailPresenOutputSpy
  }

  // MARK: - Test doubles
  class DetailWorkerOutputSpy : MovieDetailWorker{
    var getMovieDetailCalled = false
    var failure = false
    override func getMovieDetail(id: Int, completion: @escaping (Result<MovieDetail>) -> Void) {
      getMovieDetailCalled = true
      if failure {
        completion(Result.failure(NSError(domain: "", code: 0, userInfo: nil)))
      }
      else {
        completion(Result.success(MovieDetail(genres: [Genre(id: 1, name: "Action")]
         , id: 1, imdbID: "", originalLanguage: "", overview: "", popularity: 0.0, title: "", voteAverage: 0.0, voteCount: 0, posterPath: "")))
      }
    }
  }
  
  class DetailPresentOutputSpy : DetailPresenterInterface{
    
    var presentMovieDetailCalled = false
    var presentSetNewVotingCalled = false
    var presentStarVoteCalled = false
    
    func presentMovieDetail(response: Detail.GetMovieDetail.Response) {
      presentMovieDetailCalled = true
    }
    
    func presentSetNewVoting(reponse: Detail.SetVoting.Response) {
      presentSetNewVotingCalled = true
    }
    
    func presentStarVote(response: Detail.SetStar.Response) {
      presentStarVoteCalled = true
    }
  }
  // MARK: - Tests

  func testGetMovieDetailForSuccess() {
    // Given
    sut.id = 1
    // When
     let request = Detail.GetMovieDetail.Request()
    sut.getMovieDetail(request: request)
    // Then
    XCTAssert(detailWorkerOutputSpy.getMovieDetailCalled)
    XCTAssert(detailPresenOutputSpy.presentMovieDetailCalled)
  }
  
  func testGetMovieDetailForFail() {
    // Given
    sut.id = 1
    detailWorkerOutputSpy.failure = true
    // When
    let request = Detail.GetMovieDetail.Request()
    sut.getMovieDetail(request: request)
    // Then
    XCTAssert(detailWorkerOutputSpy.getMovieDetailCalled)
    XCTAssert(detailPresenOutputSpy.presentMovieDetailCalled)
  }

  func testCalculateVote() {
    // Given
    sut.voteCount = 0
    sut.id = 1
    let request = Detail.SetVoting.Request(voteUser: 0.0)
    // When
    sut.calculateVote(request: request)
    // Then
    XCTAssert(detailPresenOutputSpy.presentSetNewVotingCalled)
  }
}

