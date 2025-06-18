//
//  RegistrationViewController.swift
//  PhotoSave
//
//  Created by Alex Mac PRO on 20.10.2024.
//

import UIKit
import SwiftyKeychainKit 

class Registration: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var repassTextFieldOutlet: UITextField!
    @IBOutlet weak var passTextFieldOutlet: UITextField!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Предполагается, что setBackgroundImage - это ваш метод-расширение
        setBackgroundImage(namePicter: "backgroundPS")
    }
    
    // MARK: - IBActions
    
    @IBAction func savePassword(_ sender: UIButton) {
        if self.passTextFieldOutlet.text == self.repassTextFieldOutlet.text {
            
            // Я оставляю вашу оригинальную логику, но настоятельно рекомендую ее заменить.
            UserDefaults.standard.set(self.passTextFieldOutlet.text, forKey: "password")
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            
            self.navigationController?.popToRootViewController(animated: true)
            
        } else {
            // Пароли не совпадают, очищаем поля
            self.passTextFieldOutlet.text = ""
            self.repassTextFieldOutlet.text = ""
        }
    }
}

// MARK: - UITextFieldDelegate

extension Registration: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Если фокус на первом поле, переключиться на второе.
        // Если на втором, сохранить пароль.
        if textField == passTextFieldOutlet {
            repassTextFieldOutlet.becomeFirstResponder()
        } else if textField == repassTextFieldOutlet {
            savePassword(UIButton()) // Вызываем сохранение
            hideKeyboard()
        }
        return true
    }
    
    private func hideKeyboard() {
        passTextFieldOutlet.resignFirstResponder()
        repassTextFieldOutlet.resignFirstResponder()
    }
}
