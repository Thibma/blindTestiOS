//
//  MainMenuViewController.swift
//  blindTestiOS
//
//  Created by Thibault BALSAMO on 22/01/2021.
//

import UIKit

class MainMenuViewController: UIViewController {
    
    var user: User!
    
    class func newInstance(user: User) -> MainMenuViewController {
        let mainMenuViewController = MainMenuViewController()
        mainMenuViewController.user = user
        return mainMenuViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func deconnexionTouchPushButton(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "idUser")
        self.navigationController?.pushViewController(WelcomeViewController(), animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
}
