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
    func displaySelectMovie(viewModel: Main.SetSelectMovie.ViewModel)
}

class MainViewController: UIViewController, MainViewControllerInterface {
    var interactor: MainInteractorInterface!
    var router: MainRouter!
    var refreshControl = UIRefreshControl()
    var displayedMovies: [Main.GetMovieList.ViewModel.DisplayedMovie] = []
    var sort: Main.GetMovieList.SortData?
    @IBAction func sortButton(_ sender: Any) {
        showSortingAlert()
    }

    @IBOutlet var tableView: UITableView!

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
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }

    @objc func pullToRefresh() {
        let request = Main.PullToRefresh.Request(currentPage: 1)
        interactor.pushToRefresh(request: request)
    }

    private func showSortingAlert() {
        let alert = UIAlertController(title: "Sort", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ASC", style: .default, handler: { _ in
//      let request = Main.GetMovieList.Request(useCache: false, page: 1, sortType: .ASC)
            self.sort = Main.GetMovieList.SortData.ASC
            let request = Main.GetMovieList.Request(useCache: false, sortType: .ASC)
            self.pushGetMovieListToInteractor(request: request)
        }))

        alert.addAction(UIAlertAction(title: "DESC", style: .default, handler: { _ in
            self.sort = Main.GetMovieList.SortData.DESC
            let request = Main.GetMovieList.Request(useCache: false, sortType: .DESC)
            self.pushGetMovieListToInteractor(request: request)
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in

        }))
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Event handling

    func pushGetMovieListToInteractor(request: Main.GetMovieList.Request) {
        interactor.getMovieList(request: request)
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: false)
    }

    func getMovieList() {
        let request = Main.GetMovieList.Request(useCache: false, sortType: .ASC)
        interactor.getMovieList(request: request)
    }

    func updateNewVoteMovieList() {
        let request = Main.GetMovieList.Request(useCache: true, sortType: .ASC)
        interactor.getMovieList(request: request)
    }

    // MARK: - Display logic

    func displayMovieList(viewModel: Main.GetMovieList.ViewModel) {
        switch viewModel.content {
        case let .success(data):
            displayedMovies = data.displayedMovies
            refreshControl.endRefreshing()
            tableView.reloadData()
        case let .failure(error):
            let alert = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
            present(alert, animated: true)
        }
    }

    func displaySelectMovie(viewModel: Main.SetSelectMovie.ViewModel) {
        router.navigateToDetail()
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
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
        if indexPath.row == (displayedMovies.count - 1) {
//      currentPage += 1
//      if currentPage <= totalPage {
//        getMovieList()
//      }
            let request = Main.SetLoadMore.Request(sort: sort ?? .ASC)
            interactor.setCountPage(request: request)
            // find lastCell in tableView
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let request = Main.SetSelectMovie.Request(index: indexPath.row)
        interactor.setSelectMovie(request: request)
    }
}

extension MainViewController: DetailViewControllerDelegate {
    func setNewVote() {
        updateNewVoteMovieList()
    }
}
