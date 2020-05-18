 //
//  Api.swift
//  reciclamx.user.ios
//
//  Created by Guillermo Padilla Lam on 13/05/20.
//  Copyright © 2020 gp Apps. All rights reserved.
//

import Foundation
 

 
 public protocol SecurityDelegate {
    func didUserInserted(_ securityManager: Api, user: UserBiz)
    func didFail(width error: Error)
    func emailAlreadyExist(_ securityManager: Api)
 }
 
 public enum ApiError : Error {
    case TokenExpired
    case RequestError
 }

public struct Api {
    
    let staticToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImZibi5yZWNpY2xhbXhAZ21haWwuY29tIiwidXNlcklkIjoiNWViYjdiYmQ3YzcwMTc0NzBkN2ZlMzBiIiwiaWF0IjoxNTg5NjYzMDkyLCJleHAiOjE1ODk2NjY2OTJ9.HT4ansW77WUaXLRMsqXvP-Ika0FC3SBZwijQOZHRAck"
    
    private let reciclaApiUrl = "http://localhost:8080/"
    
    var securityDelegate: SecurityDelegate?
    
    
    private func postWithTokenRequest(user: UserBiz) {
        
        
            if let urlRequestToken = URL(string: "\(reciclaApiUrl)auth/requestToken") {
                
                let parameters = [
                        "email": "fbn.reciclamx@gmail.com",
                        "password": "Elemento1430"
                    ]
                    
                    var request = URLRequest(url: urlRequestToken)
                    request.httpMethod = "POST"
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.addValue("application/json", forHTTPHeaderField: "Accept")
                    
                    do {
                        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                    } catch { print(error) }
                    
                    let session = URLSession.shared
                    let task = session.dataTask(with: request) { data, response, error in
                        
                        // queda pendiente guardar el token !!!!!!
                        
                        if error != nil { print("Error") }
                        var securityBiz: SecurityBiz
                        
                        if let httpResponse = response as? HTTPURLResponse {
                            switch httpResponse.statusCode {
                            case 200...299:
                                if let dataSafe = data {
                                    let decode = JSONDecoder()
                                    do {
                                        securityBiz = try decode.decode(SecurityBiz.self, from: dataSafe)
                                        //  de nuevo, se intenta insertar el usuario
                                        self.post(user: user, token: securityBiz.token)
                                        
                                    } catch { self.securityDelegate?.didFail(width: error) }
                                }
                            default:
                                print("Http code \(httpResponse.statusCode)")
                            }
                        }
                    }
                    
                    task.resume()
                }
    }
    
    public func post(user: UserBiz, token: String?) {
        
        let tokenSafe = token ?? staticToken
        
        if let url = URL(string: "\(reciclaApiUrl)usuario/post") {
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("Bearer \(tokenSafe)", forHTTPHeaderField: "Authorization")
            
            do {
                let encoder = JSONEncoder()
                let json = try encoder.encode(user)
                print(json)
                request.httpBody = json
            } catch { self.securityDelegate?.didFail(width: error) }
            
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                if(error != nil) {
                    self.securityDelegate?.didFail(width: error!)
                    return
                }
                
                guard let dataSafe = data else { return }
                
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 401: // error con el token
                        print("Not authenticated \(httpResponse.statusCode)")
                        do {
                            if let jsonDictionary = try JSONSerialization.jsonObject(with: dataSafe, options: .mutableContainers) as? [String: Any] {
                                if let message = jsonDictionary["message"] as? String {
                                    if message.contains("Token expirado") {
                                        print(jsonDictionary["message"]!)
                                        
                                        //throw ApiError.TokenExpired
                                        self.postWithTokenRequest(user: user)
                                    } else { print("puede haber error en el request") }
                                }
                            }
                        } catch { self.securityDelegate?.didFail(width: error) }
                    case 200:
                        self.securityDelegate?.didUserInserted(self, user: user)
                    case 202:
                        do {
                            if let jsonDictionary = try JSONSerialization.jsonObject(with: dataSafe, options: .mutableContainers) as? [String: Any] {
                                if let message = jsonDictionary["message"] as? String {
                                    if message.contains("El email ya existe") {
                                        self.securityDelegate?.emailAlreadyExist(self)
                                    }
                                }
                            }
                        } catch { self.securityDelegate?.didFail(width: error) }
                        
                    case 400:
                        print("No se recibio el token") // puede venir del middleware o del createUsuario,
                    default:
                        print("Error no reconocido \(httpResponse.statusCode)")
                    }
                }
            }
            
            task.resume()
        }
    }
 }
