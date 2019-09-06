//
//  MainRouter.swift
//  MovieList
//
//  Created by Chawalya Tantisevi on 2/9/2562 BE.
//  Copyright (c) 2562 SCB. All rights reserved.
//

import UIKit

protocol MainRouterInput {
    func navigateToDetail()
}

class MainRouter: MainRouterInput {
    weak var viewController: MainViewController!

    // MARK: - Navigation

    func navigateToDetail() {
        if let detailViewController = UIStoryboard(name: "Detail", bundle: nil).instantiateInitialViewController() as? DetailViewController {
            detailViewController.interactor.id = viewController.interactor.selectedMovie?.id
            detailViewController.delegate = viewController
            viewController.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }

    // MARK: - Communication

    func passDataToNextScene(segue: UIStoryboardSegue) {
        // NOTE: Teach the router which scenes it can communicate with

        if segue.identifier == "ShowSomewhereScene" {
            passDataToSomewhereScene(segue: segue)
        }
    }

    func passDataToSomewhereScene(segue: UIStoryboardSegue) {
        // NOTE: Teach the router how to pass data to the next scene

        // let someWhereViewController = segue.destinationViewController as! SomeWhereViewController
        // someWhereViewController.interactor.model = viewController.interactor.model
    }
}
