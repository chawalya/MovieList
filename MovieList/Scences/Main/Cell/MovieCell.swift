//
//  MovieCell.swift
//  MovieList
//
//  Created by Chawalya Tantisevi on 2/9/2562 BE.
//  Copyright © 2562 SCB. All rights reserved.
//

import AlamofireImage
import UIKit

class MovieCell: UITableViewCell {
    @IBOutlet var moviePoster: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var backdrop: UIImageView!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var popLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func updateUI(_ displayedMovies: Main.GetMovieList.ViewModel.DisplayedMovie) {
        titleLabel.text = displayedMovies.name
        ratingLabel.text = displayedMovies.vote
        popLabel.text = displayedMovies.popularity
      if let path = displayedMovies.posterUrl {
      moviePoster.loadImageUrl(path)
      }
      if let path = displayedMovies.backdropUrl {
        backdrop.loadImageUrl(path)
      }
      
    }
  override func prepareForReuse() {
    super.prepareForReuse()
    moviePoster.image = nil
    backdrop.image = nil
    
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
