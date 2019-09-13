//
//  MainInteractorTests.swift
//  MovieList
//
//  Created by Chawalya Tantisevi on 12/9/2562 BE.
//  Copyright (c) 2562 SCB. All rights reserved.
//

@testable import MovieList
import XCTest

class MainInteractorTests: XCTestCase {

  // MARK: - Subject under test

  var sut: MainInteractor!
  // MARK: - Test lifecycle

  override func setUp() {
    super.setUp()
    setupMainInteractor()
  }

  override func tearDown() {
    super.tearDown()
  }

  // MARK: - Test setup

  func setupMainInteractor() {
    sut = MainInteractor()

  }
  
  // MARK: - Test doubles

  class MainPresenterOutputSpy : MainPresenterInterface {
    
    var presentMovieListCalled = false
    var presentSetSelectMovie = false
    var presentSetTotalPage = false
  
    func presentMovieList(response: Main.GetMovieList.Response) {
      presentMovieListCalled = true

    }
    
    func presentSetSelectMovie(reponse: Main.SetSelectMovie.Response) {
      presentSetSelectMovie = true
    }
    
    func presentSetTotalPage(reponse: Main.SetLoadMore.Response) {
      presentSetTotalPage = true
    }
}
  
  class MainWorkerOutputsSpy : MovieWorker {
    var getMovieListCalled = false
    var failure = false
    override func getMovieList(page: Int, sort: Main.GetMovieList.SortData, _ completion: @escaping (Result<MovieList>) -> Void) {
      getMovieListCalled = true
      if failure {
        
        completion(Result.failure(NSError(domain: "", code: 0, userInfo: nil)))
      }
      else {
        completion(Result.success(MovieList(page: 1, totalResults: 10000, totalPages: 500, results: [Movie(popularity: 0.887, id: 432374, video: false, voteCount: 1, voteAverage: 10, title: "Dawn French Live: 30 Million Minutes", releaseDate: "2016-12-31", originalLanguage: "en", originalTitle: "Dawn French Live: 30 Million Minutes", genreIDS: [35], backdropPath: "/27RY4W57D6HWlY3FPmSphiIXco0.jpg", adult: false, overview: "Dawn French stars in her acclaimed one-woman show, the story of her life, filmed during its final West End run.", posterPath: "/cTUuMb83O9kFcXnQIQMgehEJX70.jpg")])))
      }
    }
  }
  
  // MARK: - Tests

  func testGetMovileListForNoCachecaseSuccess() {
    // Given
    let mainWorkerOutputsSpy = MainWorkerOutputsSpy(store: MovieRestStore())
    let mainPresenterOutputSpy = MainPresenterOutputSpy()
    sut.worker = mainWorkerOutputsSpy
    sut.presenter = mainPresenterOutputSpy
        // When
    let request = Main.GetMovieList.Request(useCache: false, sortType: .DESC)
    sut.getMovieList(request: request)
    // Then
    XCTAssertEqual(sut.sortCurrent, .DESC)
    XCTAssert(mainWorkerOutputsSpy.getMovieListCalled)
    XCTAssert(mainPresenterOutputSpy.presentMovieListCalled)
  }
  
  func testGetMovileListForNoCachecaseSuccess2() {
    // Given
    let mainWorkerOutputsSpy = MainWorkerOutputsSpy(store: MovieRestStore())
    let mainPresenterOutputSpy = MainPresenterOutputSpy()
    sut.worker = mainWorkerOutputsSpy
    sut.presenter = mainPresenterOutputSpy
    // When
    let request = Main.GetMovieList.Request(useCache: false, sortType: .ASC)
    sut.getMovieList(request: request)
    // Then
    XCTAssertEqual(sut.sortCurrent, .ASC)
    XCTAssert(mainWorkerOutputsSpy.getMovieListCalled)
    XCTAssert(mainPresenterOutputSpy.presentMovieListCalled)
  }
  
  func testGetMovileListForNoCachecaseFailure() {
    // Given
    let mainWorkerOutputsSpy = MainWorkerOutputsSpy(store: MovieRestStore())
    let mainPresenterOutputSpy = MainPresenterOutputSpy()
    sut.worker = mainWorkerOutputsSpy
    sut.presenter = mainPresenterOutputSpy
    mainWorkerOutputsSpy.failure = true
    // When
    let request = Main.GetMovieList.Request(useCache: false, sortType: .DESC)
    sut.getMovieList(request: request)
    // Then
    XCTAssertEqual(sut.sortCurrent, .DESC)
    XCTAssert(mainWorkerOutputsSpy.getMovieListCalled)
    XCTAssert(mainPresenterOutputSpy.presentMovieListCalled)
  }
  
  func testGetMovileListForNoCachecaseFailure2() {
    // Given
    let mainWorkerOutputsSpy = MainWorkerOutputsSpy(store: MovieRestStore())
    let mainPresenterOutputSpy = MainPresenterOutputSpy()
    sut.worker = mainWorkerOutputsSpy
    sut.presenter = mainPresenterOutputSpy
    mainWorkerOutputsSpy.failure = true
    // When
    let request = Main.GetMovieList.Request(useCache: false, sortType: .ASC)
    sut.getMovieList(request: request)
    // Then
    XCTAssertEqual(sut.sortCurrent, .ASC)
    XCTAssert(mainWorkerOutputsSpy.getMovieListCalled)
    XCTAssert(mainPresenterOutputSpy.presentMovieListCalled)
  }
  
  func testGetMovileListForUseCachecaseSuccess() {
    // Given
    let mainWorkerOutputsSpy = MainWorkerOutputsSpy(store: MovieRestStore())
    let mainPresenterOutputSpy = MainPresenterOutputSpy()
    sut.worker = mainWorkerOutputsSpy
    sut.presenter = mainPresenterOutputSpy
    sut.movieList = MovieList(page: 1, totalResults: 1, totalPages: 1, results: [])
    // When
    let request = Main.GetMovieList.Request(useCache: true, sortType: .DESC)
    sut.getMovieList(request: request)
    // Then
    XCTAssert(mainPresenterOutputSpy.presentMovieListCalled)
  }
  
  func testGetMovileListForUseCachecaseSuccess2() {
    // Given
    let mainWorkerOutputsSpy = MainWorkerOutputsSpy(store: MovieRestStore())
    let mainPresenterOutputSpy = MainPresenterOutputSpy()
    sut.worker = mainWorkerOutputsSpy
    sut.presenter = mainPresenterOutputSpy
    sut.movieList = MovieList(page: 1, totalResults: 1, totalPages: 1, results: [])
    // When
    let request = Main.GetMovieList.Request(useCache: true, sortType: .ASC)
    sut.getMovieList(request: request)
    // Then
    XCTAssert(mainPresenterOutputSpy.presentMovieListCalled)
  }
  
  func testGetMovileListForUseCachecaseFailure() {
    // Given
    let mainWorkerOutputsSpy = MainWorkerOutputsSpy(store: MovieRestStore())
    let mainPresenterOutputSpy = MainPresenterOutputSpy()
    sut.worker = mainWorkerOutputsSpy
    sut.presenter = mainPresenterOutputSpy
    sut.movieList = MovieList(page: 1, totalResults: 1, totalPages: 1, results: [])
    mainWorkerOutputsSpy.failure = true
    // When
    let request = Main.GetMovieList.Request(useCache: true, sortType: .DESC)
    sut.getMovieList(request: request)
    // Then
    XCTAssert(mainPresenterOutputSpy.presentMovieListCalled)
  }
  func testGetMovileListForUseCachecaseFailure2() {
    // Given
    let mainWorkerOutputsSpy = MainWorkerOutputsSpy(store: MovieRestStore())
    let mainPresenterOutputSpy = MainPresenterOutputSpy()
    sut.worker = mainWorkerOutputsSpy
    sut.presenter = mainPresenterOutputSpy
    sut.movieList = MovieList(page: 1, totalResults: 1, totalPages: 1, results: [])
    mainWorkerOutputsSpy.failure = true
    // When
    let request = Main.GetMovieList.Request(useCache: true, sortType: .ASC)
    sut.getMovieList(request: request)
    // Then
    XCTAssert(mainPresenterOutputSpy.presentMovieListCalled)
  }

  
  func testSetSelectMovie() {
    // Given
    let mainWorkerOutputsSpy = MainWorkerOutputsSpy(store: MovieRestStore())
    let mainPresenterOutputSpy = MainPresenterOutputSpy()
    sut.worker = mainWorkerOutputsSpy
    sut.presenter = mainPresenterOutputSpy
    // When
    let request = Main.SetSelectMovie.Request(index: 1)
    sut.setSelectMovie(request: request)
    // Then
    XCTAssert(mainPresenterOutputSpy.presentSetSelectMovie)
  }
  
  func testSetCountPage() {
    // Given
    let mainWorkerOutputsSpy = MainWorkerOutputsSpy(store: MovieRestStore())
    let mainPresenterOutputSpy = MainPresenterOutputSpy()
    sut.worker = mainWorkerOutputsSpy
    sut.presenter = mainPresenterOutputSpy
    sut.currentPage = 1
    sut.totalPage = 50
    // When
    let request = Main.SetLoadMore.Request(sort: .DESC)
    sut.setCountPage(request: request)
    // Then
    XCTAssert(mainPresenterOutputSpy.presentMovieListCalled)
  }
  
  func testSetCountPageFail() {
    // Given
    let mainWorkerOutputsSpy = MainWorkerOutputsSpy(store: MovieRestStore())
    let mainPresenterOutputSpy = MainPresenterOutputSpy()
    sut.worker = mainWorkerOutputsSpy
    sut.presenter = mainPresenterOutputSpy
    sut.currentPage = 51
    sut.totalPage = 50
    // When
    let request = Main.SetLoadMore.Request(sort: .DESC)
    sut.setCountPage(request: request)
    // Then
    XCTAssertEqual(mainPresenterOutputSpy.presentMovieListCalled, false)
  }

  func testPullToRefresh(){
    // Given
    let mainWorkerOutputsSpy = MainWorkerOutputsSpy(store: MovieRestStore())
    let mainPresenterOutputSpy = MainPresenterOutputSpy()
    sut.worker = mainWorkerOutputsSpy
    sut.presenter = mainPresenterOutputSpy
    // When
    let request = Main.PullToRefresh.Request(currentPage: 1)
    sut.pullToRefresh(request: request)
    // Then
    XCTAssert(mainPresenterOutputSpy.presentMovieListCalled)
  }
}
