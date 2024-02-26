//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Vladislav Vintenbakh on 5/11/23.
//

import Foundation

struct NetworkClient {
    
    private enum NetworkError: Error {
        case codeError
    }
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // check whether there is an error
            if let error {
                handler(.failure(error))
                return
            }
            
            // check whether the status code indicates success
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                return
            }
            
            // return the data
            guard let data else { return }
            handler(.success(data))
        }
        
        task.resume()
    }
}
