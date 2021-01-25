//
//  WaitingScreenViewController.swift
//  blindTestiOS
//
//  Created by Thibault BALSAMO on 20/01/2021.
//

import UIKit

class WaitingScreenViewController: UIViewController {

    let userWebService: UserWebServices = UserWebServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        /*DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.navigationController?.pushViewController(WelcomeViewController(), animated: true)
        }*/
        
        DispatchQueue.main.async {
            guard let getId = UserDefaults.standard.string(forKey: "idUser") else {
                self.navigationController?.pushViewController(WelcomeViewController(), animated: true)
                self.dismiss(animated: true, completion: nil)
                return
            }
            
            self.userWebService.getById(id: getId) { (user) in
                guard let connectedUser = user else {
                    self.navigationController?.pushViewController(WelcomeViewController(), animated: true)
                    return
                }
                let mainViewController = MainMenuViewController.newInstance(user: connectedUser)
                self.navigationController?.pushViewController(mainViewController, animated: true)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
