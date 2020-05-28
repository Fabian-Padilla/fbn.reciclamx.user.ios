 //
//  Api.swift
//  reciclamx.user.ios
//
//  Created by Guillermo Padilla Lam on 13/05/20.
//  Copyright © 2020 gp Apps. All rights reserved.
//

import Foundation
 

 
 protocol SecurityDelegate : class {
    func didUserInserted(_ securityManager: Api, user: UserBiz)
    func didFail(width error: Error)
    func emailAlreadyExist(_ securityManager: Api)
 }
 
 // utilizo class para poder crear una referencia weak, esto con el afan de evitar un "retain cycle", que basicamente es cuando dos objetos tienen definidos una referencia strong, recordar que por default todas son definidas como strong, si ambas son strong, entonces el ARC (automatic reference counting) no decrementara el retain count para la liberacion de la memoria, en el link hay una explicacion mas formal, 
 // https://krakendev.io/blog/weak-and-unowned-references-in-swift
 protocol ApiLoginDelegate : class {
    func didUserLogedIn(_ loginManager: Api, login: LoginResponse)
    func wrongCredentials(_ loginManager: Api, login: LoginRequest)
    func didFail(_ apiManager: Api, width error: Error)
 }
 
 public enum ApiError : Error {
    case TokenExpired
    case RequestError
 }

public struct Api {
    
    let defaultToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImZibi5yZWNpY2xhbXhAZ21haWwuY29tIiwidXNlcklkIjoiNWViYjdiYmQ3YzcwMTc0NzBkN2ZlMzBiIiwiaWF0IjoxNTg5NjYzMDkyLCJleHAiOjE1ODk2NjY2OTJ9.HT4ansW77WUaXLRMsqXvP-Ika0FC3SBZwijQOZHRAck"
    
    private let reciclaApiUrl = "http://localhost:8080/"
    
    weak var securityDelegate: SecurityDelegate?
    weak var apiLoginDelegate: ApiLoginDelegate?
    
    
    func post(login: LoginRequest) {
        self.post(login: login, token: nil)
    }
    
    private func post(login: LoginRequest, token: String?) {
        
        let currentToken = token ?? UserDefaults.standard.string(forKey: "reciclamx.api.token") ?? defaultToken
        
        guard let url = URL(string: "\(reciclaApiUrl)auth/postLogin") else { return }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(currentToken)", forHTTPHeaderField: "Authorization")
        
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(login) 
        } catch { self.apiLoginDelegate?.didFail(self, width: error) }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                print("Post login regreso error.")
                return
            }
            
            guard let dataSafe = data else { return }
            
            guard let httpResponse = response as? HTTPURLResponse else { return }
            
            switch httpResponse.statusCode {
            case 200:
                let decoder = JSONDecoder()
                do {
                    let loginResponse = try decoder.decode(LoginResponse.self, from: dataSafe)
                    self.apiLoginDelegate?.didUserLogedIn(self, login: loginResponse)
                    print("Login successful")
                    //
                } catch { self.apiLoginDelegate?.didFail(self, width: error) }
            case 203:
                self.apiLoginDelegate?.wrongCredentials(self, login: login)
            case 401:
                do {
                    if let jsonData = try JSONSerialization.jsonObject(with: dataSafe, options: .mutableContainers) as? [String: Any] {
                        guard let message = jsonData["message"]  as? String else { print("Error al validar si el token expiro"); return }
                        if(message.contains("Token expirado")) {
                            self.postWithTokenRequest(request: login, postFunction: self.post(login:token:))
                        }
                    }
                } catch { self.apiLoginDelegate?.didFail(self, width: error) }
            case 500:
                print("Internal server error requested \(httpResponse.statusCode)")
            default:
                print("Codigo recibido no despachado \(httpResponse.statusCode)")
            }
        }
        
        task.resume()
    }
    
    
    private func postWithTokenRequest<T>(request: T, postFunction: @escaping (_ request: T, _ token: String) -> () ) {
        
        if let urlRequestToken = URL(string: "\(reciclaApiUrl)auth/requestToken") {
            
            let parameters = [
                "email": "fbn.reciclamx@gmail.com",
                "password": "Elemento1430"
            ]
            
            var urlRequest = URLRequest(url: urlRequestToken)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch { print(error) }
            
            let session = URLSession.shared
            let task = session.dataTask(with: urlRequest) { data, response, error in
                
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
                                
                                //  se guarda el token
                                UserDefaults.standard.set(securityBiz.token, forKey: "reciclamx.api.token")
                                //  de nuevo, se intenta insertar el usuario
                                
                                postFunction(request,securityBiz.token)
                                //self.post(user: user, token: securityBiz.token)
                                
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
    
    public func post(user: UserBiz) {
        post(user: user, token: nil)
    }
    
    private func post(user: UserBiz, token: String?) {
        
        let tokenSafe = token ?? UserDefaults.standard.string(forKey: "reciclamx.api.token") ?? defaultToken
        
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
                                        self.postWithTokenRequest(request: user, postFunction: self.post(user:token:))
                                                                  
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
