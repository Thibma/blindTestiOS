//
//  SignUpViewController.swift
//  blindTestiOS
//
//  Created by Thibault BALSAMO on 20/01/2021.
//

import UIKit

class SignUpViewController: UIViewController {
    
    let userWebServices: UserWebServices = UserWebServices()
    
    @IBOutlet weak var pseudoTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackground()
        self.pseudoTextField.setBottomLine()
        self.passwordTextField.setBottomLine()
        self.confirmPasswordTextField.setBottomLine()
        self.phoneTextField.setBottomLine()
        self.signUpButton.layer.cornerRadius = 8
        self.cancelButton.layer.cornerRadius = 8
        
        self.pseudoTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmPasswordTextField.delegate = self
        self.phoneTextField.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func cancelPressButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signUpPressButton(_ sender: Any) {
        guard self.pseudoTextField.text?.count != 0,
              let nickname = self.pseudoTextField.text,
              self.passwordTextField.text?.count != 0,
              let password = self.passwordTextField.text,
              self.passwordTextField.text!.count > 2,
              self.passwordTextField.text == self.confirmPasswordTextField.text,
              self.phoneTextField.text?.count != 0,
              let phone = self.phoneTextField.text else {
            let alert = UIAlertController(title: "Attention", message: "Verifiez si tous les champs sont remplis, si les mots de passe sont bons et si ils font plus de 3 caractères.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        self.showSpinner(onView: self.view)
        let user = User(nickname: nickname, password: password, phone: phone)
        self.userWebServices.signUp(user: user) { (newUser) in
            guard let connectedUser = newUser else {
                self.removeSpinner()
                let alert = UIAlertController(title: "Erreur lors de l'inscription", message: "Vérifiez les informations ou votre connexion internet.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            UserDefaults.standard.setValue(connectedUser.id, forKey: "idUser")
            let mainMenuViewController = MainMenuViewController.newInstance(user: connectedUser)
            self.removeSpinner()
            self.navigationController?.pushViewController(mainMenuViewController, animated: true)
        }
        
    }
    
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.pseudoTextField {
            self.passwordTextField.becomeFirstResponder()
        }
        else if textField == self.passwordTextField {
            self.confirmPasswordTextField.becomeFirstResponder()
        }
        else if textField == self.confirmPasswordTextField {
            self.phoneTextField.becomeFirstResponder()
        }
        else if textField == self.phoneTextField {
            textField.resignFirstResponder()
        }
        
        return true
    }
}
