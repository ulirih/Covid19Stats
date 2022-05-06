//
//  CasesViewController.swift
//  Covid19Stats
//
//  Created by andrey perevedniuk on 02.05.2022.
//

import UIKit

enum ScreenState {
    case loading
    case completed
}

class CasesViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var countryLabel: UILabel!
    
    private let service = CovidService()
    private var state: ScreenState = .loading {
        didSet {
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.hidesWhenStopped = true
        fetchData()
    }
    
    func fetchData() {
        state = .loading
        service.getCommonCases(countryCode: "md") { [weak self] result, error in
            if error != nil {
                print("RequetError: \(error!)")
            }
            
            guard let data = result else { return }
            
            DispatchQueue.main.async {
                self?.state = .completed
                self?.countryLabel.text = data.country
                print(data.country)
            }
        }
    }
    
    private func updateViews() {
        state == .loading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        countryLabel.isHidden = state == .loading
    }
}
