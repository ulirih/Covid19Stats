//
//  CasesViewController.swift
//  Covid19Stats
//
//  Created by andrey perevedniuk on 02.05.2022.
//

import UIKit

enum ScreenState {
    case empty
    case loading
    case completed
    case error
}

class CasesViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var casesDataStack: UIStackView!
    @IBOutlet weak var casesLabel: UILabel!
    @IBOutlet weak var deathsLabel: UILabel!
    @IBOutlet weak var casesPercentLabel: UILabel!
    @IBOutlet weak var deathsPercentLabel: UILabel!
    @IBOutlet weak var percentDataStack: UIStackView!
    @IBOutlet weak var countryDataStack: UIStackView!
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var lifeLabel: UILabel!
    @IBOutlet weak var countryCodeTextField: UITextField!
    
    private let service = CovidService()
    private let userDefaults = UserDefaults.standard
    private let countryCodeKey = "countryCode"
    
    private var state: ScreenState = .empty {
        didSet {
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countryCodeTextField.delegate = self
        activityIndicator.hidesWhenStopped = true
        
        initData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        countryCodeTextField.resignFirstResponder()
    }
    
    func initData() {
        let countryCode = userDefaults.string(forKey: countryCodeKey)
        
        if let code = countryCode {
            fetchData(country: code)
            countryCodeTextField.text = code
        } else {
            state = .empty
        }
    }
    
    func fetchData(country: String) {
        state = .loading
        service.getCommonCases(countryCode: country) { [weak self] result, error in
            if error != nil {
                print("RequetError: \(error!)")
            }
            
            guard let data = result else { return }
            
            DispatchQueue.main.async {
                self?.state = .completed
                self?.countryLabel.text = data.country
                self?.casesLabel.text = data.confirmed.toGroupingSeparator()
                self?.deathsLabel.text = data.deaths.toGroupingSeparator()
                self?.casesPercentLabel.text = data.confirmedPercent
                self?.deathsPercentLabel.text = data.deathsPercent
                self?.populationLabel.text = data.population.toGroupingSeparator()
                self?.lifeLabel.text = data.life_expectancy
            }
        }
    }
    
    private func updateViews() {
        state == .loading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        
        countryLabel.isHidden = state != .completed
        casesDataStack.isHidden = state != .completed
        percentDataStack.isHidden = state != .completed
        countryDataStack.isHidden = state != .completed
    }
}

extension CasesViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, text.count > 0 {
            countryCodeTextField.resignFirstResponder()
            userDefaults.set(text, forKey: countryCodeKey)
            fetchData(country: text)
        }
        
        return true
    }
}
