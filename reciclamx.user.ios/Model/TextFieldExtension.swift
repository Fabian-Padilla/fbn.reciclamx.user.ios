//
//  DatePickerFunctionality.swift
//  reciclamx.user.ios
//
//  Created by Guillermo Padilla Lam on 07/05/20.
//  Copyright © 2020 gp Apps. All rights reserved.
//

import UIKit

extension UITextField {
    
    func setInputViewDatePicker(target: Any, selector: Selector) {
        
        let width = UIScreen.main.bounds.size.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: width, height: 216))
        datePicker.datePickerMode = .date
        self.inputView = datePicker
        
        let cancel = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(tapCancel))
        let aceptar = UIBarButtonItem(title: "Aceptar", style: .plain, target: target, action: selector)
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: width, height: 44))
        toolBar.setItems([cancel, space, aceptar], animated: false)
        
        self.inputAccessoryView = toolBar
    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
}
