//
//  SearchTrainViewController.swift
//  MyTravelHelper
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import UIKit
import SwiftSpinner
import DropDown

class SearchTrainViewController: UIViewController {
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var sourceTxtField: UITextField!
    @IBOutlet weak var trainsListTable: UITableView!

    var stationsList: [Station] = [Station]()
    var trains: [StationTrain] = [StationTrain]()
    var presenter: ViewToPresenterProtocol?
    var dropDown = DropDown()
    var transitPoints: (source: String, destination: String) = ("", "")

    override func viewDidLoad() {
        super.viewDidLoad()
        trainsListTable.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        if stationsList.count == 0 {
            SwiftSpinner.useContainerView(view)
            SwiftSpinner.show(Alert.loadingStationMessage)
            presenter?.fetchallStations()
        }
    }

    @IBAction func searchTrainsTapped(_ sender: Any) {
        view.endEditing(true)
        showProgressIndicator(view: self.view)
        presenter?.searchTapped(source: transitPoints.source, destination: transitPoints.destination)
    }
}

extension SearchTrainViewController: PresenterToViewProtocol {
    func showNoInternetAvailabilityMessage() {
        trainsListTable.isHidden = true
        hideProgressIndicator(view: view)
        showAlert(title: Alert.NoInternet.title, message: Alert.NoInternet.message, actionTitle: Alert.actionTitle)
    }

    func showNoTrainAvailbilityFromSource() {
        trainsListTable.isHidden = true
        hideProgressIndicator(view: view)
        showAlert(title: Alert.NoTrainAvailbility.title, message: Alert.NoTrainAvailbility.message, actionTitle: Alert.actionTitle)
    }

    func updateLatestTrainList(trainsList: [StationTrain]) {
        hideProgressIndicator(view: view)
        trains = trainsList
        trainsListTable.isHidden = false
        trainsListTable.reloadData()
    }

    func showNoTrainsFoundAlert() {
        trainsListTable.isHidden = true
        hideProgressIndicator(view: view)
        trainsListTable.isHidden = true
        showAlert(title: Alert.NoTrainsFound.title, message: Alert.NoTrainsFound.message, actionTitle: Alert.actionTitle)
    }

    func showAlert(title: String, message: String,actionTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    func showInvalidSourceOrDestinationAlert() {
        trainsListTable.isHidden = true
        hideProgressIndicator(view: view)
        showAlert(title: Alert.InvalidSourceOrDestination.title, message: Alert.InvalidSourceOrDestination.message, actionTitle: Alert.actionTitle)
    }

    func saveFetchedStations(stations: [Station]?) {
        if let stations = stations {
          self.stationsList = stations
        }
        SwiftSpinner.hide()
    }
}

extension SearchTrainViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        dropDown = DropDown()
        dropDown.anchorView = textField
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: 0, y: (dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.dataSource = stationsList.map { $0.stationDesc }
        dropDown.selectionAction = { (_: Int, item: String) in
            if textField == self.sourceTxtField {
                self.transitPoints.source = item
            } else {
                self.transitPoints.destination = item
            }
            textField.text = item
        }
        dropDown.show()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dropDown.hide()
        return textField.resignFirstResponder()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let inputedText = textField.text {
            var desiredSearchText = inputedText
            if string != "\n" && !string.isEmpty {
                desiredSearchText += desiredSearchText
            } else {
                desiredSearchText = String(desiredSearchText.dropLast())
            }

            dropDown.dataSource = stationsList.map {$0.stationDesc}
            dropDown.show()
            dropDown.reloadAllComponents()
        }
        return true
    }
}

extension SearchTrainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trains.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "train", for: indexPath) as? TrainInfoCell else {
            return UITableViewCell()
        }
        let train = trains[indexPath.row]
        cell.trainCode.text = train.trainCode
        cell.souceInfoLabel.text = train.stationFullName
        cell.sourceTimeLabel.text = train.expDeparture
        if let destinationDetails = train.destinationDetails {
            cell.destinationInfoLabel.text = destinationDetails.locationFullName
            cell.destinationTimeLabel.text = destinationDetails.expDeparture
        }
        return cell
    }
}

extension SearchTrainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
