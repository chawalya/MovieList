//
//  MovieCell.swift
//  MovieList
//
//  Created by Chawalya Tantisevi on 2/9/2562 BE.
//  Copyright © 2562 SCB. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieCell: UITableViewCell {
  
  @IBOutlet weak var moviePoster: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var backdrop: UIImageView!
  @IBOutlet weak var ratingLabel: UILabel!
  @IBOutlet weak var popLabel: UILabel!
  

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
  
  func updateUI(_ displayedMovies: Main.GetMovieList.ViewModel.DisplayedMovie) {
    titleLabel.text = displayedMovies.name
    popLabel.text = displayedMovies.popularity
    if let posterUrl = displayedMovies.posterUrl, let url = URL(string: posterUrl) {
      moviePoster.loadImageUrl(url)
    } else {
      moviePoster.image = nil
    }
    if let backdropUrl = displayedMovies.backdropUrl, let url = URL(string: backdropUrl){
      backdrop.loadImageUrl(url)
    } else {
      backdrop.image = nil
    }
  }
}

extension UIImageView {
  func load(url: URL) {
    DispatchQueue.global().async { [weak self] in
      if let data = try? Data(contentsOf: url) {
        if let image = UIImage(data: data) {
          DispatchQueue.main.async {
            self?.image = image
          }
        }
      }
    }
  }
  
  func loadImageUrl(_ urlString: URL) {
    af_setImage(withURL: urlString)
  }
  
}



