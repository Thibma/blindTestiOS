//
//  MainMenuViewController.swift
//  blindTestiOS
//
//  Created by Thibault BALSAMO on 22/01/2021.
//

import UIKit
import AVFoundation

class MainMenuViewController: UIViewController {
    
    let gameplayWebServices: GameplayWebServices = GameplayWebServices()
    let themeWebServices: ThemeWebServices = ThemeWebServices()
    
    var user: User!
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var scoresButton: UIButton!
    @IBOutlet weak var optionButton: UIButton!
    @IBOutlet weak var deconnexionButton: UIButton!
    
    class func newInstance(user: User) -> MainMenuViewController {
        let mainMenuViewController = MainMenuViewController()
        mainMenuViewController.user = user
        return mainMenuViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        labelUsername.text = "Salut " + user.nickname + " !"
        setBackground()
        playButton.layer.cornerRadius = 8
        scoresButton.layer.cornerRadius = 8
        optionButton.layer.cornerRadius = 8
        deconnexionButton.layer.cornerRadius = 8
        
    }

    
    @IBAction func playTouchButton(_ sender: Any) {
        self.showSpinner(onView: self.view)
        self.gameplayWebServices.getAllGameplay { (gameplays) in
            self.themeWebServices.getAllThemes { (themes) in
                guard gameplays.count > 0,
                      themes.count > 0 else {
                    self.removeSpinner()
                    let alert = UIAlertController(title: "Erreur de connexion", message: "Impossible de se connecter, vérifiez la connexion.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                self.removeSpinner()
                let viewController = PlayMenuViewController.newInstance(gameplays: gameplays, themes: themes)
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    @IBAction func scoresTouchButton(_ sender: Any) {
    }
    @IBAction func optionTouchButton(_ sender: Any) {
        let viewController = OptionMenuViewController.newInstance()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func deconnexionTouchPushButton(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "idUser")
        self.navigationController?.pushViewController(WelcomeViewController(), animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
}
