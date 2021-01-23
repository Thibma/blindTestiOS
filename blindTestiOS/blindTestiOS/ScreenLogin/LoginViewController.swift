//
//  LoginViewController.swift
//  blindTestiOS
//
//  Created by Thibault BALSAMO on 20/01/2021.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var connexionButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        
        self.nicknameTextField.setBottomLine()
        self.passwordTextField.setBottomLine()
        
        self.connexionButton.layer.cornerRadius = 8
        self.cancelButton.layer.cornerRadius = 8
    }

    @IBAction func touchConnexionButton(_ sender: Any) {
        guard self.nicknameTextField.text?.count != 0,
              let nickname = self.nicknameTextField.text,
              self.passwordTextField.text?.count != 0,
              let password = self.passwordTextField.text else {
            let alert = UIAlertController(title: "Attention", message: "Merci de remplir tous les champs", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let user = User(nickname: nickname, password: password)
        
    }
    
    
    @IBAction func touchCancelButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
