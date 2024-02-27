//
//  CurrencyServise.swift
//  Compass
//
//  Created by Onur Emren on 10.02.2024.
//

import Foundation
import UIKit

class CurrencyServise {
    func fetchData(from url: URL, completion: @escaping (Result<CurrencyModel, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? URLError(.unknown)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let model = try decoder.decode(CurrencyModel.self, from: data)
                completion(.success(model))
                print("\(model)")
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    
}
