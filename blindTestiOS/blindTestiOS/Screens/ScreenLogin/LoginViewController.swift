//
//  LoginViewController.swift
//  blindTestiOS
//
//  Created by Thibault BALSAMO on 20/01/2021.
//

import UIKit
import AVFoundation

class LoginViewController: UIViewController {
    
    let userWebServices: UserWebServices = UserWebServices()
    
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var connexionButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var player: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        
        self.nicknameTextField.setBottomLine()
        self.passwordTextField.setBottomLine()
        
        self.connexionButton.layer.cornerRadius = 8
        self.cancelButton.layer.cornerRadius = 8
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func touchConnexionButton(_ sender: Any) {
        player = self.setAudioButton()
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
        self.showSpinner(onView: self.view)
        self.userWebServices.signIn(user: user) { (newUser) in
            guard let connectedUser = newUser else {
                self.removeSpinner()
                let alert = UIAlertController(title: "Erreur de connexion", message: "Vérifiez le login/mot de passe ou votre connexion.", preferredStyle: .alert)
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
    
    
    @IBAction func touchCancelButton(_ sender: Any) {
        player = self.setAudioBackButton()
        self.navigationController?.popViewController(animated: true)
    }
    
}
