//
//  MainModels.swift
//  MovieList
//
//  Created by Chawalya Tantisevi on 2/9/2562 BE.
//  Copyright (c) 2562 SCB. All rights reserved.
//

import UIKit

struct Main {
    enum SortData {
        case ASC
        case DESC
    }

    /// This structure represents a use case
    struct GetMovieList {
        /// Data struct sent to Interactor
        enum SortData {
            case ASC
            case DESC
        }

        struct Request {
            let useCache: Bool
            let sortType: SortData
        }

        /// Data struct sent to Presenter
        struct Response {
            let result: Result<MovieList>
        }

        /// Data struct sent to ViewController
        struct ViewModel {
            let content: Result<MovieViewModel>
            struct DisplayedMovie {
                let name: String
                let popularity: String
                let vote: String
                let backdropUrl, posterUrl: URL?
            }

            struct MovieViewModel {
                let displayedMovies: [DisplayedMovie]
                let totalPage: Int
            }
        }
    }

    struct SetSelectMovie {
        /// Data struct sent to Interactor
        struct Request {
            let index: Int
        }

        /// Data struct sent to Presenter
        struct Response {
        }

        /// Data struct sent to ViewController
        struct ViewModel {
        }
    }

    struct SetLoadMore {
        /// Data struct sent to Interactor
        struct Request {
            let sort: GetMovieList.SortData
        }

        /// Data struct sent to Presenter
        struct Response {
            let totalPage: Int
            let currentPage: Int
        }

        /// Data struct sent to ViewController
        struct ViewModel {
        }
    }

    struct PullToRefresh {
        /// Data struct sent to Interactor
        struct Request {
            let currentPage: Int
        }

        /// Data struct sent to Presenter
        struct Response {
        }

        /// Data struct sent to ViewController
        struct ViewModel {
        }
    }
  
 

}
