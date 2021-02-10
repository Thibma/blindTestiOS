//
//  WelcomeViewController.swift
//  blindTestiOS
//
//  Created by Thibault BALSAMO on 15/01/2021.
//

import UIKit
import AVFoundation

class WelcomeViewController: UIViewController {
    @IBOutlet weak var inscriptionButton: UIButton!
    @IBOutlet weak var connexionButton: UIButton!
    
    var player: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.inscriptionButton.layer.cornerRadius = 8
        self.connexionButton.layer.cornerRadius = 8
        
        self.setBackground()
    
    }
    @IBAction func clickedConnexionButton(_ sender: Any) {
        player = self.setAudioButton()
        self.navigationController?.pushViewController(LoginViewController(), animated: true)
    }
    
    @IBAction func clickedInscriptionButton(_ sender: Any) {
        player = self.setAudioButton()
        self.navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
}
