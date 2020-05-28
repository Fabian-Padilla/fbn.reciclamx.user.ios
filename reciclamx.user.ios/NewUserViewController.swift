//
//  NewUserViewController.swift
//  reciclamx.user.ios
//
//  Created by Guillermo Padilla Lam on 03/05/20.
//  Copyright © 2020 gp Apps. All rights reserved.
//

import UIKit

class NewUserViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var nombreText: UITextField!
    @IBOutlet weak var paternoText: UITextField!
    @IBOutlet weak var maternoText: UITextField!
    @IBOutlet weak var telefonoText: UITextField!
    @IBOutlet weak var birthDayText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var passwordConfirmText: UITextField!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var paternoLabel: UILabel!
    @IBOutlet weak var maternoLabel: UILabel!
    @IBOutlet weak var telefonoLabel: UILabel!
    @IBOutlet weak var birthDayLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordConfirmLabel: UILabel!
    
    private var api = Api()
    
    private var originalLabelColor = UIColor.white
    
    struct labelValues {
        let normal: String
        let error: String?
        let empty: String?
    }
    
    let emailValues = labelValues(normal: "Email", error: "Verifica tu email", empty: "Tu email es requerido")
    let nombreValues = labelValues(normal: "Nombre", error: nil, empty: "Tu nombre es requerido")
    let paternoValues = labelValues(normal: "Apellido paterno", error: nil, empty: "Tu apellido paterno es requerido")
    let maternoValues = labelValues(normal: "Apellido materno", error: nil, empty: nil)
    let telefonoValues = labelValues(normal: "Telefono", error: "Verifica tu número de teléfono", empty: "Tu número de teléfono es requerido")
    let birthDayValues = labelValues(normal: "Fecha de nacimiento", error: nil, empty: "La fecha de nacimiento es requerida")
    let passwordValues = labelValues(normal: "Password", error: "Tu contraseña no cumple lo requerido", empty: "Tu contraseña es requerida")
    let passwordConfirmValues = labelValues(normal: "Confirma tu contraseña", error: "La contraseña no coincide", empty: "Confirma tu contraseña" )
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        originalLabelColor = emailLabel.textColor
        
        emailText.delegate = self
        nombreText.delegate = self
        paternoText.delegate = self
        maternoText.delegate = self
        passwordText.delegate = self
        passwordConfirmText.delegate = self
        
        birthDayText.setInputViewDatePicker(target: self, selector: #selector(tapDone))
        
        api.securityDelegate = self
    }
    
    func formHasErrors() -> Bool {
        
        let fieldHasError = { (textField: UITextField!, label: UILabel, verbose: labelValues, isValid: (_ text: String) -> Bool) -> Int in
           
            if(verbose.empty != nil && textField!.text!.trimmingCharacters(in: [" "]).count == 0) {
                    label.textColor = UIColor.red
                    label.text = verbose.empty
                    return 1
                } else if(!isValid(textField.text!)) {
                    label.textColor = UIColor.red
                    label.text = verbose.error
                    return 1
                } else {
                    label.textColor = self.originalLabelColor
                    label.text = verbose.normal
                    return 0
                }
        }
        
        var errors = 0
        
        errors += fieldHasError(emailText, emailLabel, emailValues, isValidEmail)
        errors += fieldHasError(nombreText, nombreLabel, nombreValues, {_ in return true})
        errors += fieldHasError(paternoText, paternoLabel, paternoValues, {_ in return true})
        errors += fieldHasError(maternoText, maternoLabel, maternoValues, {_ in return true})
        errors += fieldHasError(telefonoText, telefonoLabel, telefonoValues, {_ in return true})
        errors += fieldHasError(birthDayText, birthDayLabel, birthDayValues, {_ in return true})
        errors += fieldHasError(passwordText, passwordLabel, passwordValues, {_ in
            guard let password = passwordText.text else { return false }
            if password.count < 5 { return false }
            return true
        })
        errors += fieldHasError(passwordConfirmText, passwordConfirmLabel, passwordConfirmValues, {_ in
            guard let password = passwordText.text else { return false }
            guard let passwordConfirm = passwordConfirmText.text else { return false }
            if password != passwordConfirm { return false }
            return true
        })
        
        return errors > 0
    }
    
    @objc func tapDone() {
        if let datePicker = self.birthDayText.inputView as? UIDatePicker {
            let dateformatter = DateFormatter()
            //dateformatter.dateStyle = .medium
            dateformatter.dateFormat = "MMM dd, yyyy"
            self.birthDayText.text = dateformatter.string(from: datePicker.date)
        }
        self.birthDayText.resignFirstResponder()
    }           	
    
    @IBAction func SaveNewUserAction(_ sender: UIButton) {
        
        if !formHasErrors() {
            
            let formatterGet = DateFormatter()
            formatterGet.dateFormat = "MMM dd, yyyy"
            
            let formatterWrite = DateFormatter()
            formatterWrite.dateFormat = "yyyy-MM-dd"
            
            if let date = formatterGet.date(from: birthDayText.text!) {
            
                let birthDayString = formatterWrite.string(from: date)
                
                let userBiz = UserBiz(_id: nil, email: emailText.text!, nombres: nombreText.text!, apellidoPaterno: paternoText.text!, apellidoMaterno: maternoText.text!, fechaNacimiento: birthDayString, emailValidado: true, password: passwordText.text!, fechaInsercion: nil)
                
                api.post(user: userBiz)
                
            } else {
                print("Error al convertir la fecha de nacimiento a yyyy-MM-dd")
            }
            //api.postLogin()
        } else {
            Alert.ShowBasicAlert(on: self, with: "No se puede crear el usuario", message: "Verifica tu información")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSelectReciclaje" {
            let selectMaterialVC = segue.destination as! SelectMaterialMenuViewController
            selectMaterialVC.welcomeMode = true
        }
    }

}

extension NewUserViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //        if textField == self.emailText {
        //            validateFields(textField: self.emailText)
        //        }
    }
    
    // esta funcion se usa gracias a que el controlador usa UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        
        guard let newRange = Range(range, in: currentText) else { return false }
        
        return currentText.replacingCharacters(in: newRange, with: string).count <= 30
    }
}


extension NewUserViewController : SecurityDelegate {
    
    func didUserInserted(_ securityManager: Api, user: UserBiz) {
        print("El usuario fue insertado")
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "goToSelectReciclaje", sender: self)
        }
    }
    
    func emailAlreadyExist(_ securityManager: Api) {
        print("El usuario ya existe")
        
        
        DispatchQueue.main.async {
            //self.emailLabel.text = "Este email ya esta registrado"
            Alert.ShowBasicAlert(on: self, with: "No se puede crear el usuario", message: "El correo electrónico ya existe")
        }
    }
    
    func didFail(width error: Error) {
        print(error)
    }
}
