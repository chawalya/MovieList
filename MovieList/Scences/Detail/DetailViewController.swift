//
//  DetailViewController.swift
//  MovieList
//
//  Created by Chawalya Tantisevi on 2/9/2562 BE.
//  Copyright (c) 2562 SCB. All rights reserved.
//

import UIKit
import AlamofireImage
protocol DetailViewControllerInterface: class {
  func displayMovieDetail(viewModel: Detail.GetMovieDetail.ViewModel)
}

class DetailViewController: UIViewController, DetailViewControllerInterface {
  var interactor: DetailInteractorInterface!
  var router: DetailRouter!
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var TitleLabel: UILabel!
  @IBOutlet weak var DetailLabel: UILabel!
  

  // MARK: - Object lifecycle

  override func awakeFromNib() {
    super.awakeFromNib()
    configure(viewController: self)
  }

  // MARK: - Configuration

  private func configure(viewController: DetailViewController) {
    let router = DetailRouter()
    router.viewController = viewController

    let presenter = DetailPresenter()
    presenter.viewController = viewController

    let interactor = DetailInteractor()
    interactor.presenter = presenter
    interactor.worker = MovieDetailWorker(store: MovieDetailStore())

    viewController.interactor = interactor
    viewController.router = router
  }

  // MARK: - View lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    getMovieDetail()
  }

  // MARK: - Event handling

  func getMovieDetail() {
    let request = Detail.GetMovieDetail.Request()
    interactor.getMovieDetail(request: request)
  }

  // MARK: - Display logic

  func displayMovieDetail(viewModel: Detail.GetMovieDetail.ViewModel) {
    let displayedMovie = viewModel.displayedMovie
    if let posterUrl = displayedMovie.posterUrl, let url = URL(string: posterUrl) {
      imageView.loadImageUrlDetail(url)
    } else {
      imageView.image = nil
    }
    TitleLabel.text = displayedMovie.title
    DetailLabel.text = displayedMovie.detail
    
  }

  // MARK: - Router

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    router.passDataToNextScene(segue: segue)
  }

  @IBAction func unwindToDetailViewController(from segue: UIStoryboardSegue) {
    print("unwind...")
    router.passDataToNextScene(segue: segue)
  }
}

extension UIImageView{
  func loadImageUrlDetail(_ urlString: URL) {
    af_setImage(withURL: urlString)
  }

}
