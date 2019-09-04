//
//  MovieDetailStore.swift
//  MovieList
//
//  Created by Chawalya Tantisevi on 4/9/2562 BE.
//  Copyright © 2562 SCB. All rights reserved.
//

import Foundation
import Alamofire
class MovieDetailStore: MovieDetailProtocol {

  
  
  
  
  func getMovieDetail(id: Int, completion: @escaping (Result<MovieDetail>) -> Void) {
    
    let url = "https://api.themoviedb.org/3/movie/\(id)?api_key=328c283cd27bd1877d9080ccb1604c91"
    AF.request(URL(string: url)!, method: .get).responseJSON  { response in
      switch response.result {
      case .success:
        do {
          print("success feed")
          let decoder = JSONDecoder()
          let result = try decoder.decode(MovieDetail.self, from: response.data!)
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
