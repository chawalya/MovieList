//
//  DetailModels.swift
//  MovieList
//
//  Created by Chawalya Tantisevi on 2/9/2562 BE.
//  Copyright (c) 2562 SCB. All rights reserved.
//

import UIKit

struct Detail {
  /// This structure represents a use case
  struct GetMovieDetail {
    /// Data struct sent to Interactor
    struct Request {}
    /// Data struct sent to Presenter
    struct Response {
      let movie: MovieDetail?
    }
    /// Data struct sent to ViewController
    struct ViewModel {
      let displayedMovie: DisplayedMovie
      struct DisplayedMovie {
        let title: String
        let detail: String
        let category: String
        let language: String
        let posterUrl: String?
      }
    }
  }
    
    struct SetVoting {
      /// Data struct sent to Interactor
      struct Request {
        let voteUser: Double
      }
      /// Data struct sent to Presenter
      struct Response {
        
      }
      /// Data struct sent to ViewController
      struct ViewModel {
        
      }
    }
  
}
