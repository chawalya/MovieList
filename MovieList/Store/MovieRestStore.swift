//
//  MobileRestStore.swift
//  MovieList
//
//  Created by Chawalya Tantisevi on 3/9/2562 BE.
//  Copyright © 2562 SCB. All rights reserved.
//

import Foundation
import Alamofire

class MovieRestStore: MovieStoreProtocol {
  
  func getMovieList(page:Int,sort: Main.GetMovieList.SortData,_ completion: @escaping (Result<MovieList>)-> Void) {
    var sort = sort == .DESC ? "release_date.desc" : "release_date.asc"
    var url = "http://api.themoviedb.org/3/discover/movie?api_key=328c283cd27bd1877d9080ccb1604c91&primary_release_date.lte=2016-12-31&sort_by=\(sort)&page=\(page)"
    AF.request(URL(string: url)!, method: .get).responseJSON  { response in
      switch response.result {
      case .success:
        do {
          print("success feed")
          let decoder = JSONDecoder()
          let result = try decoder.decode(MovieList.self, from: response.data!)
          completion(Result.success(result))
        } catch let error {
          print("error case success")
          print(error)
          completion(Result.failure(error))
        }
      case let .failure(error):
        print("error case failure")
        print(error)
        completion(Result.failure(error))
      }
    }
  }
}

