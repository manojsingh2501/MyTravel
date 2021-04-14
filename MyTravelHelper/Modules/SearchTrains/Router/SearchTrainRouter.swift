//
//  SearchTrainRouter.swift
//  MyTravelHelper
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import UIKit
class SearchTrainRouter: PresenterToRouterProtocol {
    static func createModule() -> SearchTrainViewController {
        // swiftlint:disable force_cast
        let viewController = mainstoryboard.instantiateViewController(withIdentifier: "searchTrain") as! SearchTrainViewController
        let presenter: ViewToPresenterProtocol & InteractorToPresenterProtocol = SearchTrainPresenter()
        let webservice = WebService()
        let interactor: PresenterToInteractorProtocol = SearchTrainInteractor(webService: webservice)
        let router: PresenterToRouterProtocol = SearchTrainRouter()

        viewController.presenter = presenter
        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter

        return viewController
    }

    static var mainstoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
}
