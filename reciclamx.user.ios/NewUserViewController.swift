//
//  NewUserViewController.swift
//  reciclamx.user.ios
//
//  Created by Guillermo Padilla Lam on 03/05/20.
//  Copyright © 2020 gp Apps. All rights reserved.
//

import UIKit

class NewUserViewController: UIViewController, UITextFieldDelegate {
    
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
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordConfirmLabel: UILabel!
    
    
    private var originalLabelColor = UIColor.white
    private let newUserLogic = NewUserLogic()
    
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
    let passwordValues = labelValues(normal: "Password", error: "Tu contraseña no cumple lo requerido", empty: "Tu contraseña es requerida")
    let passwordConfirmValues = labelValues(normal: "Confirma tu password", error: "Tu password no coincide", empty: "Confirma tu password" )
    
    
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
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField == self.emailText {
//            validateFields(textField: self.emailText)
//        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        
        guard let newRange = Range(range, in: currentText) else { return false }
        
        return currentText.replacingCharacters(in: newRange, with: string).count <= 30
    }
    
    func validateFields() {
        
        let funcValidate = { (textField: UITextField!, label: UILabel, verbose: labelValues, isValid: (_ text: String) -> Bool) in
           
            if(verbose.empty != nil && textField!.text!.trimmingCharacters(in: [" "]).count == 0) {
                    label.textColor = UIColor.red
                    label.text = verbose.empty
                } else if(!isValid(textField.text!)) {
                    label.textColor = UIColor.red
                    label.text = verbose.error
                } else {
                    label.textColor = self.originalLabelColor
                    label.text = verbose.normal
                }
        }
        
        funcValidate(emailText, emailLabel, emailValues, isValidEmail)
        funcValidate(nombreText, nombreLabel, nombreValues, {_ in return true})
        funcValidate(paternoText, paternoLabel, paternoValues, {_ in return true})
        funcValidate(maternoText, maternoLabel, maternoValues, {_ in return true})
        funcValidate(passwordText, passwordLabel, passwordValues, {_ in
            
            guard let password = passwordText.text else { return false }
            if password.count < 5 || password.count > 12 { return false }
            
            return true
        })
        funcValidate(passwordConfirmText, passwordConfirmLabel, passwordConfirmValues, {_ in
            guard let password = passwordText.text else { return false }
            guard let passwordConfirm = passwordConfirmText.text else { return false }
            if password != passwordConfirm { return false }
            return true
        })
        
    }
    
    @objc func tapDone() {
        if let datePicker = self.birthDayText.inputView as? UIDatePicker {
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = .medium
            self.birthDayText.text = dateformatter.string(from: datePicker.date)
        }
        self.birthDayText.resignFirstResponder()
    }           	
    
    @IBAction func SaveNewUserAction(_ sender: UIButton) {
        validateFields()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
