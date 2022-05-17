//
//  VaccinesViewController.swift
//  Covid19Stats
//
//  Created by andrey perevedniuk on 02.05.2022.
//

import UIKit

class VaccinesViewController: UIViewController {
    
    @IBOutlet weak var countryCodeTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var vaccineStackData: UIStackView!
    @IBOutlet weak var peopleVaccinatedLabel: UILabel!
    @IBOutlet weak var percentVaccinatedLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var populationStackData: UIStackView!
    
    private let userDefaults = UserDefaults.standard
    private let countryCodeKey = "countryCode"
    private let service = CovidService()
    
    private var state: ScreenState = .empty {
        didSet {
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.hidesWhenStopped = true
        countryCodeTextField.delegate = self
        
        initData()
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
        service.getVaccinesInfo(countryCode: country) { [weak self] result in
            switch result {
            case .failure(let err):
                self?.state = .error
                print(err)
            case .success(let data):
                let vacccine = data.All
                
                self?.state = .completed
                self?.countryNameLabel.text = vacccine.country
                self?.peopleVaccinatedLabel.text = vacccine.people_vaccinated.toGroupingSeparator()
                self?.percentVaccinatedLabel.text = vacccine.vaccinatedPerceent
                self?.populationLabel.text = vacccine.population.toGroupingSeparator()
            }
        }
    }
    
    private func updateViews() {
        state == .loading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        
        countryNameLabel.isHidden = state != .completed
        vaccineStackData.isHidden = state != .completed
        populationStackData.isHidden = state != .completed
    }
}

extension VaccinesViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, text.count > 0 {
            countryCodeTextField.resignFirstResponder()
            userDefaults.set(text, forKey: countryCodeKey)
            fetchData(country: text)
        }
        
        return true
    }
}
