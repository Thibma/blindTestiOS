//
//  HistoricViewController.swift
//  blindTestiOS
//
//  Created by Thibault BALSAMO on 09/02/2021.
//

import UIKit

class HistoricViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let gameWebServices: GameWebService = GameWebService()
    let gameplayWebServices: GameplayWebServices = GameplayWebServices()
    let blindtestWebServices: BlindtestWebService = BlindtestWebService()
    let songWebServices: SongWebServices = SongWebServices()
    let themeWebServices: ThemeWebServices = ThemeWebServices()
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var games: [Game]!
    var blindtest: [Blindtest] = []
    var song: [Music] = []
    var theme: [Theme] = []
    var gameplays: [Gameplay] = []
    
    enum Identifier: String {
          case games
         }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red.withAlphaComponent(0)
        self.tableView.backgroundColor = UIColor.red.withAlphaComponent(0)
        self.tableView.rowHeight = 100
        activityIndicator.startAnimating()
        loadData()
    }
    
    func loadData() {
        self.gameWebServices.getAllGamesByUser(userId: UserDefaults.standard.string(forKey: "idUser")!) { (games) in
            self.games = games
            self.games.reverse()
            let count = 0
            self.getBlindtest(count: count)
        }
    }
    
    func getBlindtest(count: Int) {
        if count == games.count {
            let countSong = 0
            self.getSong(count: countSong)
        }
        else {
            self.blindtestWebServices.getBlindtestByGame(game: games[count]) { (blindtest) in
                self.blindtest.append(blindtest[0])
                self.getBlindtest(count: count + 1)
            }
        }
        
    }
    
    func getSong(count: Int) {
        if count == games.count {
            let countTheme = 0
            self.getTheme(count: countTheme)
            
        }
        else {
            self.songWebServices.getByBlindtestId(id: blindtest[count].musicId) { (music) in
                self.song.append(music!)
                self.getSong(count: count + 1)
            }
        }
    }
    
    func getTheme(count: Int) {
        if count == song.count {
            self.gameplayWebServices.getAllGameplay { (gameplays) in
                self.gameplays = gameplays
                    
                let cellNib = UINib(nibName: "HistoricTableViewCell", bundle: nil)
                self.tableView.register(cellNib, forCellReuseIdentifier: Identifier.games.rawValue)
                self.tableView.dataSource = self // écouteur des data de la liste
                self.tableView.delegate = self // écouteur des évènements utilisateur
                self.tableView.reloadData()
                self.activityIndicator.removeFromSuperview()
            }
        }
        else {
            self.themeWebServices.getById(id: song[count].idTheme) { (theme) in
                self.theme.append(theme!)
                self.getTheme(count: count + 1)
            }
        }
    }

}

extension HistoricViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.games.rawValue, for: indexPath) as! HistoricTableViewCell
        cell.backgroundColor = UIColor.red.withAlphaComponent(0)
        let game = self.games[indexPath.row]
        let gameplay = game.getGameplayFromId(gameplays: gameplays)
        
        cell.dateLabel.text = game.getDateFromString()
        cell.gamePlayLabel.text = gameplay?.name
        cell.scoreLabel.text = String(game.score)
        cell.themeLabel.text = theme[indexPath.row].name
        return cell
    }
    
    
}
