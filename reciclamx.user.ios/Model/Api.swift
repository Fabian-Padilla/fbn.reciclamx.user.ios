 //
//  Api.swift
//  reciclamx.user.ios
//
//  Created by Guillermo Padilla Lam on 13/05/20.
//  Copyright © 2020 gp Apps. All rights reserved.
//

import Foundation

struct Api {
    
    private let reciclaApiUrl = "http://localhost:8080/"
    private let token = ""
    
    func postLogin() {
        self.performRequest(urlString: "\(reciclaApiUrl)auth/requestToken")
    }
    
    private func performRequest(urlString: String) {
        print(urlString)
        //  1. create a URL
        if let url = URL(string: urlString) {
            
            var request = URLRequest(url: url)
            
            let session = URLSession.shared
            
            request.httpMethod = "POST"
            
            let parameters = [
                "email": "fbn.reciclamx@gmail.com",
                "password": "Elemento1430"
            ]
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let task = session.dataTask(with: request, completionHandler: handle)
            
            task.resume()
            
        }
    }
    
    private func handle(data: Data?, response: URLResponse?, error: Error?) {
        if error != nil {
            print(error!)
            return
        }
        
        if let safeData = data {
            //let dataString = String(data: safeData, encoding: .utf8)
            //print(dataString)
            
            do {
                if let json = try JSONSerialization.jsonObject(with: safeData, options: .mutableContainers) as? [String: Any]
                {
                    print(json["token"]!)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
 }
