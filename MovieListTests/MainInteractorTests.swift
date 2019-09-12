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

  class MainWorkerOutputsSpy : MovieWorker {
    
    var getMovieListCalled = false
    var forfailure = false
    override func getMovieList(page: Int, sort: Main.GetMovieList.SortData, _ completion: @escaping (Result<MovieList>) -> Void) {
      getMovieListCalled = true
      if forfailure {
        
      }
      else {
        completion(Result.success(MovieList(page: <#T##Int#>, totalResults: <#T##Int#>, totalPages: <#T##Int#>, results: [Movie(popularity: <#T##Double#>, id: <#T##Int#>, video: <#T##Bool#>, voteCount: <#T##Int#>, voteAverage: <#T##Double#>, title: <#T##String#>, releaseDate: <#T##String#>, originalLanguage: <#T##String#>, originalTitle: <#T##String#>, genreIDS: <#T##[Int]#>, backdropPath: <#T##String?#>, adult: <#T##Bool#>, overview: <#T##String#>, posterPath: <#T##String?#>)])))
      }
    }
  }
  // MARK: - Test doubles

  // MARK: - Tests

  func testSomething() {
    // Given

    // When

    // Then
  }
}
