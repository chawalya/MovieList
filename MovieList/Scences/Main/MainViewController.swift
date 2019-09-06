//
//  MainViewController.swift
//  MovieList
//
//  Created by Chawalya Tantisevi on 2/9/2562 BE.
//  Copyright (c) 2562 SCB. All rights reserved.
//

import UIKit

protocol MainViewControllerInterface: class {
  func displayMovieList(viewModel: Main.GetMovieList.ViewModel)
  func displaySetSelectMovie(viewModel: Main.SetSelectMovie.ViewModel)
  
}
class MainViewController: UIViewController, MainViewControllerInterface {
  var currentPage: Int = 1
  var interactor: MainInteractorInterface!
  var router: MainRouter!
  var sort: Main.GetMovieList.SortData = Main.GetMovieList.SortData.ASC
  
  @IBAction func sortButton(_ sender: Any) {
    showAlert()
  }
  
  @IBOutlet weak var tableView: UITableView!
  var displayedMovies: [Main.GetMovieList.ViewModel.DisplayedMovie] = []
  var totalPage: Int = 0
  override func awakeFromNib() {
    super.awakeFromNib()
    configure(viewController: self)
  }

  // MARK: - Configuration
  
  private func configure(viewController: MainViewController) {
    let router = MainRouter()
    router.viewController = viewController

    let presenter = MainPresenter()
    presenter.viewController = viewController

    let interactor = MainInteractor()
    interactor.presenter = presenter
    interactor.worker = MovieWorker(store: MovieRestStore())

    viewController.interactor = interactor
    viewController.router = router
  }

  // MARK: - View lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "MovieCell")
    getMovieList()
    
  }
  
  private func showAlert(){
    let alert = UIAlertController(title: "Sort", message: nil, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "ASC", style: .default, handler: { (_) in
      self.sort = Main.GetMovieList.SortData.ASC
      print("asc --------------------------------------------")
      let request = Main.GetMovieList.Request(useCache: false, page: 1, sortType: self.sort)
      self.interactor.getMovieList(request: request)
      self.tableView.reloadData()
    }))
    
    alert.addAction(UIAlertAction(title: "DESC", style: .default, handler: { (_) in
      self.sort = Main.GetMovieList.SortData.DESC
      print("desc --------------------------------------------")
      let request = Main.GetMovieList.Request(useCache: false, page: 1, sortType: self.sort)
      self.interactor.getMovieList(request: request)
      self.tableView.reloadData()
    }))
    
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
      
    }))
    
    self.present(alert,animated: true,completion: nil)
  }

  // MARK: - Event handling

  func getMovieList() {
    let request = Main.GetMovieList.Request(useCache: false, page: currentPage, sortType: sort)
    interactor.getMovieList(request: request)
  }
  
  func updateMovieList() {
    let request = Main.GetMovieList.Request(useCache: true, page: currentPage, sortType: sort)
    interactor.getMovieList(request: request)
  }
  
//  func getLoadMore() {
//    let request = Main.GetLoadMore.Request(page: <#T##Int#>)
//    interactor.getLoadMore(request: request)
//  }

  // MARK: - Display logic

  func displayMovieList(viewModel: Main.GetMovieList.ViewModel) {
    switch viewModel.content {
    case .success(let data):
      displayedMovies = data.displayedMovies
      totalPage = data.totalPage
      tableView.reloadData()
    case .failure(let error):
      let alert = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
      present(alert, animated: true)
    }
  }
  

  
  func displaySetSelectMovie(viewModel: Main.SetSelectMovie.ViewModel){
    router.navigateToDetail()
  }

  
//  // MARK: - Router
//
//  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    router.passDataToNextScene(segue: segue)
//  }
//
//  @IBAction func unwindToMainViewController(from segue: UIStoryboardSegue) {
//    print("unwind...")
//    router.passDataToNextScene(segue: segue)
//  }
}
extension MainViewController: UITableViewDataSource, UITableViewDelegate{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return displayedMovies.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell",
                                                   for: indexPath) as? MovieCell else {
                                                    return UITableViewCell()
    }
    cell.updateUI(displayedMovies[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == (displayedMovies.count - 1)
    {
      currentPage += 1
      if currentPage <= totalPage {
        getMovieList()
      }
      
      //find lastCell in tableView
    }
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let request = Main.SetSelectMovie.Request(index: indexPath.row)
    interactor.setSelectMovie(request: request)
  }
}
extension MainViewController: DetailViewControllerDelegate{
  func setNewVote() {
    updateMovieList()
  }
}

