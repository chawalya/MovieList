//
//  MainPresenterTests.swift
//  MovieList
//
//  Created by Chawalya Tantisevi on 12/9/2562 BE.
//  Copyright (c) 2562 SCB. All rights reserved.
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

  // MARK: - Test doubles

  // MARK: - Tests

  func testSomething() {
    // Given

    // When

    // Then
  }
}
