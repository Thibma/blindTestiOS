//
//  ResultGameViewController.swift
//  blindTestiOS
//
//  Created by Thibault BALSAMO on 08/02/2021.
//

import UIKit
import AVFoundation

class ResultGameViewController: UIViewController {
    @IBOutlet weak var gamemodeLabel: UILabel!
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var numberOfSongLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var player: AVAudioPlayer!
    
    var gameplay: Gameplay!
    var theme: Theme!
    var song: Int!
    var game: Game!
    
    class func newInstance(gameplay: Gameplay, theme: Theme, song: Int, game: Game) -> ResultGameViewController {
        let viewController = ResultGameViewController()
        viewController.gameplay = gameplay
        viewController.theme = theme
        viewController.song = song
        viewController.game = game
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        self.backButton.layer.cornerRadius = 8
        self.shareButton.layer.cornerRadius = 8
        
        self.gamemodeLabel.text = self.gameplay.name
        self.themeLabel.text = self.theme.name
        self.numberOfSongLabel.text = String(song)
        self.scoreLabel.text = String(game.score)

    }

    @IBAction func sharePressButton(_ sender: Any) {
        player = self.setAudioButton()
        let text = "J'ai fait un score de \(game.score) sur l'application AudiQuizz sur le thème des \(self.theme.name) en mode \(self.gameplay.name) ! Viens tester tes connaissances en musiques en téléchargeant AudiQuizz !"
        let vc = UIActivityViewController(activityItems: [text], applicationActivities: [])
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func backPressButton(_ sender: Any) {
        player = self.setAudioBackButton()
        let  vc =  self.navigationController?.viewControllers.filter({$0 is MainMenuViewController}).first

        self.navigationController?.popToViewController(vc!, animated: true)
    }
    
}
