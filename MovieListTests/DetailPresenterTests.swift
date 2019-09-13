//
//  DetailPresenterTests.swift
//  MovieList
//
//  Created by Chawalya Tantisevi on 12/9/2562 BE.
//  Copyright (c) 2562 SCB. All rights reserved.
//

@testable import MovieList
import XCTest

class DetailPresenterTests: XCTestCase {

  // MARK: - Subject under test

  var sut: DetailPresenter!
  var detailPresenterOutputSpy = DetailPresenterOutputSpy()

  // MARK: - Test lifecycle

  override func setUp() {
    super.setUp()
    setupDetailPresenter()
  }

  override func tearDown() {
    super.tearDown()
  }

  // MARK: - Test setup

  func setupDetailPresenter() {
    sut = DetailPresenter()
    sut.viewController = detailPresenterOutputSpy
  }

  // MARK: - Test doubles
  class DetailPresenterOutputSpy : DetailViewControllerInterface{
    
    var displayMovieDetailCalled = false
    var displayNewVoteCalled = false
    var displayStarRateCalled = false
    var displayMovieDetailViewModel: Detail.GetMovieDetail.ViewModel?
    
    func displayMovieDetail(viewModel: Detail.GetMovieDetail.ViewModel) {
      displayMovieDetailCalled = true
      displayMovieDetailViewModel = viewModel
    }
    
    func displayNewVote(viewModel: Detail.SetVoting.ViewModel) {
      displayNewVoteCalled = true
    }
    
    func displayStarRate(viewModel: Detail.SetStar.ViewModel) {
      displayStarRateCalled = true
    }
    }
  

  // MARK: - Tests

  func testPresentSetNewVoting() {
    // Given
    // When
    let response = Detail.SetVoting.Response()
    sut.presentSetNewVoting(reponse: response)
    // Then
    XCTAssert(detailPresenterOutputSpy.displayNewVoteCalled)
  }
  
  func testPresentStarVote() {
    // Given
    // When
    let response = Detail.SetStar.Response(id: 1)
    sut.presentStarVote(response: response)
    // Then
    XCTAssert(detailPresenterOutputSpy.displayStarRateCalled)
  }
  
  func testPresentMovieDetailSuccess(){
    // Given
    // When
    let response = Detail.GetMovieDetail.Response(result: .success(MovieDetail(genres: [Genre(id: 1, name: "")], id: 1, imdbID: "", originalLanguage: "", overview: "", popularity: 0.0, title: "", voteAverage: 0.0, voteCount: 0, posterPath: "1")))
    sut.presentMovieDetail(response: response)
    // Then
    XCTAssert(detailPresenterOutputSpy.displayMovieDetailCalled)
    if let viewModel = detailPresenterOutputSpy.displayMovieDetailViewModel {
      switch viewModel.displayedMovie {
      case .success(let data):
        XCTAssertEqual(data.category, "Category : ")
        XCTAssertEqual(data.detail, "")
        XCTAssertEqual(data.posterUrl, "https://image.tmdb.org/t/p/original1")
        XCTAssertEqual(data.language,"Language : ")
        XCTAssertEqual(data.title, "")
      default: XCTFail()
      }
    }
    else {
      XCTFail()
    }
  }
  
  func testPresentMovieDetailFail(){
    // Given
    // When
    let response = Detail.GetMovieDetail.Response(result: .failure(NSError(domain: "", code: 0, userInfo: nil)))
    sut.presentMovieDetail(response: response)
    // Then
    XCTAssert(detailPresenterOutputSpy.displayMovieDetailCalled)
  }
  
}
