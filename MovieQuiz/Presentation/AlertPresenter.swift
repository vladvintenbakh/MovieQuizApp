//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Vladislav Vintenbakh on 21/10/23.
//

import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    weak var delegate: AlertPresenterDelegate?
    
    func displayAlert(alertContent: AlertModel) {
        let alert = UIAlertController(
            title: alertContent.title,
            message: alertContent.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertContent.buttonText, style: .default) { [weak self] _ in
            self?.delegate?.didShowAlert()
        }
        
        alert.addAction(action)
        
        delegate?.present(alert, animated: true, completion: nil)
    }
}
