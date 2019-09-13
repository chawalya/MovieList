////
////  MainPresenterTests.swift
////  MovieList
////
////  Created by Chawalya Tantisevi on 12/9/2562 BE.
////  Copyright (c) 2562 SCB. All rights reserved.
////
//
@testable import MovieList
import XCTest

class MainPresenterTests: XCTestCase {

  // MARK: - Subject under test

  var sut: MainPresenter!
  // MARK: - Test lifecycle

  override func setUp() {
    super.setUp()
    setupMainPresenter()
  }

  override func tearDown() {
    super.tearDown()
  }

  // MARK: - Test setup

  func setupMainPresenter() {
    sut = MainPresenter()
  }
  
    // MARK: - Test doubles\
  class MainPresenterOutputSpy : MainViewControllerInterface{
    
    var displayMovieListCalled = false
    var displaySelectMovieCalled = false
    var displayMovieListViewModel : Main.GetMovieList.ViewModel?
    
    func displayMovieList(viewModel: Main.GetMovieList.ViewModel) {
      displayMovieListCalled = true
      displayMovieListViewModel = viewModel
    }
    
    func displaySelectMovie(viewModel: Main.SetSelectMovie.ViewModel) {
      displaySelectMovieCalled = true
    }
  }

  // MARK: - Tests

  func testPresentMovieListSuccess() {
    // Given
    let mainPresenterOutputSpy = MainPresenterOutputSpy()
    sut.viewController = mainPresenterOutputSpy

    // When
    sut.presentMovieList(response: Main.GetMovieList.Response(result: Result<MovieList>.success(MovieList(page: 0, totalResults: 0, totalPages: 0, results: [Movie(popularity: 0.0, id: 0, video: true, voteCount: 0, voteAverage: 0.0, title: "", releaseDate: "", originalLanguage: "", originalTitle: "", genreIDS: [0], backdropPath: "1", adult: true, overview: "", posterPath: "1")]))))
    // Then
    XCTAssert(mainPresenterOutputSpy.displayMovieListCalled)
    }
  
  func testPresentMovieListFail() {
    // Given
    let mainPresenterOutputSpy = MainPresenterOutputSpy()
    sut.viewController = mainPresenterOutputSpy
    // When
    sut.presentMovieList(response: Main.GetMovieList.Response(result: Result<MovieList>.failure(NSError(domain: "", code: 0, userInfo: nil))))
    // Then
    XCTAssert(mainPresenterOutputSpy.displayMovieListCalled)
  }
  
  func testPresentSetSelectMovie() {
    // Given
    let mainPresenterOutputSpy = MainPresenterOutputSpy()
    sut.viewController = mainPresenterOutputSpy
    // When
    let reponse = Main.SetSelectMovie.Response()
    sut.presentSetSelectMovie(reponse: reponse)
    // Then
    XCTAssert(mainPresenterOutputSpy.displaySelectMovieCalled)

  }

  
  
}
