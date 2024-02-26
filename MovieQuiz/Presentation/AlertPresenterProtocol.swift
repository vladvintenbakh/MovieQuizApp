//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Vladislav Vintenbakh on 21/10/23.
//

import Foundation

protocol AlertPresenterProtocol {
    var delegate: AlertPresenterDelegate? { get set }
    func displayAlert(alertContent: AlertModel)
}
