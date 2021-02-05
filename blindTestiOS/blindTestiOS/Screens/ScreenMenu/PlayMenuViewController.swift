//
//  PlayMenuViewController.swift
//  blindTestiOS
//
//  Created by Thibault BALSAMO on 02/02/2021.
//

import UIKit

class PlayMenuViewController: UIViewController {
    
    let songWebServices: SongWebServices = SongWebServices()
    let detailsWebServices: DetailWebServices = DetailWebServices()
    
    @IBOutlet weak var gameModePickerView: UIPickerView!
    @IBOutlet weak var themePickerView: UIPickerView!
    @IBOutlet weak var descriptionGameModeLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var gameplays: [Gameplay]!
    var themes: [Theme]!
    
    class func newInstance(gameplays: [Gameplay], themes: [Theme]) -> PlayMenuViewController {
        let viewController = PlayMenuViewController()
        viewController.gameplays = gameplays
        viewController.themes = themes
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playButton.layer.cornerRadius = 8
        backButton.layer.cornerRadius = 8
        setBackground()
        
        self.descriptionGameModeLabel.text = gameplays[0].descr
        
        self.gameModePickerView.delegate = self
        self.gameModePickerView.dataSource = self
        self.themePickerView.delegate = self
        self.themePickerView.dataSource = self
        
    }
    @IBAction func playTouchButton(_ sender: Any) {
        //self.navigationController?.pushViewController(InGameViewController(), animated: true)
        
        // toutes les musiques
        self.showSpinner(onView: view)
        songWebServices.getAllSongs { (musics) in
            self.detailsWebServices.getAllDetail { (details) in
                
                guard musics.count > 0,
                      details.count > 0 else {
                    self.removeSpinner()
                    let alert = UIAlertController(title: "Erreur de connexion", message: "Impossible de se connecter, vérifiez la connexion.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                var musicTheme: [Music] = []
                var detailTheme: [Detail] = []
                
                for music in musics {
                    if music.idTheme == self.themes[self.themePickerView.selectedRow(inComponent: 0)].id {
                        musicTheme.append(music)
                        for detail in details {
                            if music.idDetail == detail.id {
                                detailTheme.append(detail)
                                break
                            }
                        }
                    }
                }
                
                if self.gameplays[self.gameModePickerView.selectedRow(inComponent: 0)].maxSongs == nil {
                    // Mode de jeu sans maxsongs
                }
                else {
                    var musicCopy = musicTheme
                    var detailCopy = detailTheme
                    
                    var musicInGame: [Music] = []
                    var detailInGame: [Detail] = []
                    
                    for _ in 0..<self.gameplays[self.gameModePickerView.selectedRow(inComponent: 0)].maxSongs! {
                        if musicCopy.count == 0 {
                            break
                        }
                        let random = Int.random(in: 0..<musicCopy.count)
                        let music = musicCopy[random]
                        musicCopy.remove(at: random)
                        let detail = detailCopy[random]
                        detailCopy.remove(at: random)
                        
                        music.setResponses(musics: musics)
                        detail.setResponses(details: details)
                        
                        musicInGame.append(music)
                        detailInGame.append(detail)
                    }
                    
                    if musicInGame.count == 0 {
                        self.removeSpinner()
                        let alert = UIAlertController(title: "Désolé...", message: "Ce thème n'est pas encore implémenté !", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK :(", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    
                    let inGameViewController = InGameViewController.newInstance(gameplay: self.gameplays[self.gameModePickerView.selectedRow(inComponent: 0)], theme: self.themes[self.themePickerView.selectedRow(inComponent: 0)], musicInGame: musicInGame, detailInGame: detailInGame)
                    self.navigationController?.pushViewController(inGameViewController, animated: true)
                }
            }
        }
    }
    
    @IBAction func backTouchButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}

extension PlayMenuViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == self.gameModePickerView {
            return gameplays.count
        }
        else {
            return themes.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label = UILabel()
        if let v = view as? UILabel { label = v }
        label.font = UIFont (name: "KGRedHands", size: 20)
        label.textAlignment = .center
        label.textColor = .white
        
        if pickerView == self.gameModePickerView {
            label.text = gameplays[row].name
        }
        else {
            label.text = themes[row].name
        }
    
        return label
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.gameModePickerView {
            self.descriptionGameModeLabel.text = self.gameplays[row].descr
        }
    }
    
}
