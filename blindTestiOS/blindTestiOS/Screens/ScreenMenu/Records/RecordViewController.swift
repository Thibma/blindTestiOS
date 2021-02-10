//
//  RecordViewController.swift
//  blindTestiOS
//
//  Created by Thibault BALSAMO on 09/02/2021.
//

import UIKit

class RecordViewController: UIViewController {
    @IBOutlet weak var gameModePickerView: UIPickerView!
    @IBOutlet weak var themePickerView: UIPickerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    enum Identifier: String {
          case games
    }
    
    let themeWebServices: ThemeWebServices = ThemeWebServices()
    let gameModeWebServices: GameplayWebServices = GameplayWebServices()
    let gameWebServices: GameWebService = GameWebService()
    let blindtestWebServices: BlindtestWebService = BlindtestWebService()
    let songWebServices: SongWebServices = SongWebServices()
    let userWebServices: UserWebServices = UserWebServices()
    
    
    var themes: [Theme] = []
    var gameplays: [Gameplay] = []
    var allGames: [Game]!
    var blindtest: [Blindtest] = []
    var song: [Music] = []
    
    var gamesSelected: [Game] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.startAnimating()
        self.view.backgroundColor = UIColor.red.withAlphaComponent(0)
        self.tableView.backgroundColor = UIColor.red.withAlphaComponent(0)
        self.tableView.rowHeight = 150
        loadData()

    }
    
    func loadData() {
        self.themeWebServices.getAllThemes { (themes) in
            print("load theme")
            self.themes = themes
            self.gameModeWebServices.getAllGameplay { (gameplays) in
                print("load gameplay")
                self.gameplays = gameplays
                self.gameWebServices.getAllBestGames { (games) in
                    self.allGames = games
                    let count = 0
                    self.getBlindtest(count: count)
                }
            }
        }
    }
    
    func getBlindtest(count: Int) {
        if count == allGames.count {
            print("load blindtest")
            let countSong = 0
            self.getSong(count: countSong)
        }
        else {
            self.blindtestWebServices.getBlindtestByGame(game: allGames[count]) { (blindtest) in
                self.blindtest.append(blindtest[0])
                self.getBlindtest(count: count + 1)
            }
        }
        
    }
    
    func getSong(count: Int) {
        if count == allGames.count {
            print("load song")
            let countUser = 0
            self.getUser(count: countUser)
            
        }
        else {
            self.songWebServices.getByBlindtestId(id: blindtest[count].musicId) { (music) in
                self.song.append(music!)
                self.getSong(count: count + 1)
            }
        }
    }
    
    func getUser(count: Int) {
        if count == allGames.count {
            print("load user")
            let countTheme = 0
            self.getTheme(count: countTheme)
            
        }
        else {
            self.userWebServices.getById(id: allGames[count].idUser) { (user) in
                self.allGames[count].user = user
                self.getUser(count: count + 1)
            }
        }
    }
    
    func getTheme(count: Int) {
        if count == song.count {
            self.gameModeWebServices.getAllGameplay { (gameplays) in
                print("load done")
                self.gameplays = gameplays
                    
                let cellNib = UINib(nibName: "RecordTableViewCell", bundle: nil)
                self.tableView.register(cellNib, forCellReuseIdentifier: Identifier.games.rawValue)
                self.tableView.dataSource = self // écouteur des data de la liste
                self.tableView.delegate = self // écouteur des évènements utilisateur
                self.themePickerView.delegate = self
                self.themePickerView.dataSource = self
                self.gameModePickerView.delegate = self
                self.gameModePickerView.dataSource = self
                self.activityIndicator.removeFromSuperview()
                self.reloadData()
            }
        }
        else {
            self.themeWebServices.getById(id: song[count].idTheme) { (theme) in
                self.allGames[count].theme = theme
                self.getTheme(count: count + 1)
            }
        }
    }

    func reloadData() {
        gamesSelected = []
        for game in allGames {
            if gamesSelected.count == 10 {
                break
            }
            if game.theme.id == themes[themePickerView.selectedRow(inComponent: 0)].id &&
                game.idGameplay == gameplays[gameModePickerView.selectedRow(inComponent: 0)].id{
                gamesSelected.append(game)
            }
        }
        self.tableView.reloadData()
    }
    
}

extension RecordViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gamesSelected.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.games.rawValue, for: indexPath) as! RecordTableViewCell
        cell.backgroundColor = UIColor.red.withAlphaComponent(0)
        let game = self.gamesSelected[indexPath.row]
        
        cell.dateLabel.text = game.getDateFromString()
        cell.gamemodeLabel.text = self.gameplays[gameModePickerView.selectedRow(inComponent: 0)].name
        cell.scoreLabel.text = String(game.score)
        cell.themeLabel.text = self.themes[themePickerView.selectedRow(inComponent: 0)].name
        cell.playerLabel.text = game.user.nickname
        
        switch indexPath.row {
        case 0:
            cell.classeLabel.textColor = .systemOrange
            break
        case 1:
            cell.classeLabel.textColor = .systemGray
            break
        case 2:
            cell.classeLabel.textColor = .brown
            break
        default:
            cell.classeLabel.textColor = UIColor(named: "Primary")
            break
        }
        cell.classeLabel.text = String(indexPath.row + 1)
        
        return cell
    }
    
}

extension RecordViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
        reloadData()
    }
    
    
}
