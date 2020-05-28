//
//  LoginWithEmailViewController.swift
//  reciclamx.user.ios
//
//  Created by Guillermo Padilla Lam on 17/05/20.
//  Copyright © 2020 gp Apps. All rights reserved.
//

import UIKit

class LoginWithEmailViewController: UIViewController {
    
    @IBOutlet weak var UserText: UITextField!
    @IBOutlet weak var PasswordText: UITextField!
    
    private var api = Api()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        api.apiLoginDelegate = self
    }
    
    @IBAction func ContinueAction(_ sender: Any) {
        
        if UserText!.text?.trimmingCharacters(in: [" "]) == "" {
            Alert.ShowBasicAlert(on: self, with: "No es posible continuar", message: "Introduce tu email")
        } else if  !isValidEmail(UserText!.text!) {
            Alert.ShowBasicAlert(on: self, with: "No es posible continuar", message: "Verifica tu email")
        } else if PasswordText!.text?.trimmingCharacters(in: [" "]) == "" {
            Alert.ShowBasicAlert(on: self, with: "No es posible continuar", message: "Introduce tu contraseña")
        }   
        
        api.post(login: LoginRequest(email: UserText!.text!, password: PasswordText!.text!))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "goToSelectReciclajeFromLogin" {
//            let selectMaterialVC = segue.destination as! SelectMaterialMenuViewController
//            selectMaterialVC.welcomeMode = true
//        }
    }

    
}

extension LoginWithEmailViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}


extension LoginWithEmailViewController : ApiLoginDelegate {
    func wrongCredentials(_ loginManager: Api, login: LoginRequest) {
        
        DispatchQueue.main.async {
            Alert.ShowBasicAlert(on: self, with: "No se puede ingresar", message: "Usuario o contraseña no validos")
        }
    }
    
    func didUserLogedIn(_ loginManager: Api, login: LoginResponse) {
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "goToSelectReciclajeFromLogin", sender: self)
        }
    }
    
    func didFail(_ apiManager: Api, width error: Error) {
        print("ApiLoginDelegate fail")
    }
}
