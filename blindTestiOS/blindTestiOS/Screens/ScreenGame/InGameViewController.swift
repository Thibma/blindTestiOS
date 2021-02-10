//
//  InGameViewController.swift
//  blindTestiOS
//
//  Created by Thibault BALSAMO on 24/01/2021.
//

import UIKit
import AVFoundation
import HomeKit

class InGameViewController: UIViewController {
    
    @IBOutlet weak var stackViewTop: UIStackView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var numberMusicLabel: UILabel!
    @IBOutlet weak var musicImageView: UIImageView!
    @IBOutlet weak var responseLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    
    @IBOutlet weak var response1Button: UIButton!
    @IBOutlet weak var response2Button: UIButton!
    @IBOutlet weak var response3Button: UIButton!
    @IBOutlet weak var response4Button: UIButton!
    
    @IBOutlet weak var pauseButton: UIButton!
    
    var player: AVAudioPlayer!
    
    var game: Game!
    var gameplay: Gameplay!
    var theme: Theme!
    
    var musicInGame: [Music]!
    var detailInGame: [Detail]!
    
    var blindtest: [Blindtest] = []
    
    var imageLoad: UIImage!
    
    var currentMusic = 0
    
    var waitingView: UIView?
    
    var timer: TimerCircle = TimerCircle(timeTotal: 10.0)
    var score = 0

    struct Colors {
        static var start: UIColor = UIColor.systemGreen
        static var middle: UIColor = UIColor.systemOrange
        static var end: UIColor = UIColor.systemRed
    }
    
    struct Hues {
        static var start: CGFloat = 110
        static var middle: CGFloat = 0
        static var end: CGFloat = 360
    }
    
    var accessories: [HMAccessory] = []
    let homeName: String = { HomeStore.shared.homeName }()
    let roomName: String = { HomeStore.shared.roomName }()

    class func newInstance(gameplay: Gameplay, theme: Theme, musicInGame: [Music]!, detailInGame: [Detail]!) -> InGameViewController {
        let viewController = InGameViewController()
        viewController.gameplay = gameplay
        viewController.theme = theme
        viewController.musicInGame = musicInGame
        viewController.detailInGame = detailInGame
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        self.response1Button.layer.cornerRadius = 8
        self.response2Button.layer.cornerRadius = 8
        self.response3Button.layer.cornerRadius = 8
        self.response4Button.layer.cornerRadius = 8
        self.pauseButton.layer.cornerRadius = 8
        
        self.waitBeginGame()
        preparationMusic()
        
        HomeStore.shared.homeManager.delegate = self
        self.findAccessories()
    }
    

    
    func preparationMusic() {
        let urlstring = "https://api-4moc-blindtest.herokuapp.com/song/file/" + musicInGame[currentMusic].urlMusic + "?token=JbQzTPdnbMrsN9bwEsQCbRDvZmCRukKJcEQAhxusagUst"
        let url = URL(string: urlstring)
        downloadFileFromURL(url: url!)
        
        let urlImage = "https://api-4moc-blindtest.herokuapp.com/detail/file/" + detailInGame[currentMusic].imageUrl + "?token=JbQzTPdnbMrsN9bwEsQCbRDvZmCRukKJcEQAhxusagUst"
        let url2 = URL(string: urlImage)
        downloadImage(from: url2!)
    }
    
    func downloadFileFromURL(url: URL){
        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: { [weak self](res, response, error) -> Void in
            self?.play(url: res!)
        })
            downloadTask.resume()
    }
    
    func play(url: URL) {
        do {
            self.player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.volume = 1.0
            player.play()
            
            DispatchQueue.main.sync {
                self.musicImageView.image = UIImage(systemName: "questionmark.square.fill")
                if gameplay.maxSongs != nil {
                    self.numberMusicLabel.text = "\(String(currentMusic + 1)) / \(String(gameplay.maxSongs!))"
                }
                else {
                    self.numberMusicLabel.text = "\(String(currentMusic + 1))"
                }
                
                self.responseLabel.text = ""
               
                if theme.id == "600dbd687bbba740895c550e" || theme.id == "60062da370625c99178c4adc" {
                    self.stateLabel.text = "D'où ça provient ?"
                    self.response1Button.setTitle(detailInGame[currentMusic].responses[0], for: .normal)
                    self.response2Button.setTitle(detailInGame[currentMusic].responses[1], for: .normal)
                    self.response3Button.setTitle(detailInGame[currentMusic].responses[2], for: .normal)
                    self.response4Button.setTitle(detailInGame[currentMusic].responses[3], for: .normal)
                }
                else {
                    self.stateLabel.text = "Quel est le nom de cette musique ?"
                    self.response1Button.setTitle(musicInGame[currentMusic].responses[0], for: .normal)
                    self.response2Button.setTitle(musicInGame[currentMusic].responses[1], for: .normal)
                    self.response3Button.setTitle(musicInGame[currentMusic].responses[2], for: .normal)
                    self.response4Button.setTitle(musicInGame[currentMusic].responses[3], for: .normal)
                }
                self.response1Button.backgroundColor = UIColor(named: "Primary")
                self.response2Button.backgroundColor = UIColor(named: "Primary")
                self.response3Button.backgroundColor = UIColor(named: "Primary")
                self.response4Button.backgroundColor = UIColor(named: "Primary")
                
                self.resetTimer()
                self.startTimer()
                
            }
            
            stopWait()
            
            
            
        } catch let error as NSError {
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
    }
    
    @IBAction func pushResponse1(_ sender: Any) {
        chooseResponse(number: 1)
    }
    
    @IBAction func pushResponse2(_ sender: Any) {
        chooseResponse(number: 2)
    }
    
    @IBAction func pushResponse3(_ sender: Any) {
        chooseResponse(number: 3)
    }
    
    @IBAction func pushResponse4(_ sender: Any) {
        chooseResponse(number: 4)
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            DispatchQueue.main.async() { [weak self] in
                self?.imageLoad = UIImage(data: data)
            }
        }
    }
    
    func chooseResponse(number: Int) {
        player.stop()
        self.pauseTimer()
        self.waitBeginGame()
        
        self.musicImageView.image = self.imageLoad
        
        var goodResponse = 1
        
        if theme.id == "600dbd687bbba740895c550e" || theme.id == "60062da370625c99178c4adc" {
            for response in detailInGame[currentMusic].responses {
                if response == detailInGame[currentMusic].name {
                    break
                }
                goodResponse += 1
                
            }
        }
        else {
            for response in musicInGame[currentMusic].responses {
                if response == musicInGame[currentMusic].name {
                    break
                }
                goodResponse += 1
            }
        }
        
        self.responseLabel.text = "\(musicInGame[currentMusic].name)\r\(detailInGame[currentMusic].name)"
        
        if number == -1 {
            self.stateLabel.text = "Temps écoulé !"
            switch goodResponse {
            case 1:
                self.response1Button.backgroundColor = .systemGreen
                break
            case 2:
                self.response2Button.backgroundColor = .systemGreen
                break
            case 3:
                self.response3Button.backgroundColor = .systemGreen
                break
            case 4:
                self.response4Button.backgroundColor = .systemGreen
                break
            default:
                break
            }
            blindtest.append(Blindtest(score: 0, musicId: musicInGame[currentMusic].id))
        }
        else {
            if number == goodResponse {
                self.stateLabel.text = "Bonne réponse ! + \(Int(timer.timeLeft) + 1) point(s) !"
                switch goodResponse {
                case 1:
                    self.response1Button.backgroundColor = .systemGreen
                    break
                case 2:
                    self.response2Button.backgroundColor = .systemGreen
                    break
                case 3:
                    self.response3Button.backgroundColor = .systemGreen
                    break
                case 4:
                    self.response4Button.backgroundColor = .systemGreen
                    break
                default:
                    break
                }
                self.score += Int(timer.timeLeft) + 1
                self.scoreLabel.text = String(self.score)
                blindtest.append(Blindtest(score: Int(timer.timeLeft) + 1, musicId: musicInGame[currentMusic].id))
            }
            else {
                self.stateLabel.text = "Mauvaise réponse !"
                switch number {
                case 1:
                    self.response1Button.backgroundColor = .systemRed
                    break
                case 2:
                    self.response2Button.backgroundColor = .systemRed
                    break
                case 3:
                    self.response3Button.backgroundColor = .systemRed
                    break
                case 4:
                    self.response4Button.backgroundColor = .systemRed
                    break
                default:
                    break
                }
                switch goodResponse {
                case 1:
                    self.response1Button.backgroundColor = .systemGreen
                    break
                case 2:
                    self.response2Button.backgroundColor = .systemGreen
                    break
                case 3:
                    self.response3Button.backgroundColor = .systemGreen
                    break
                case 4:
                    self.response4Button.backgroundColor = .systemGreen
                    break
                default:
                    break
                }
                blindtest.append(Blindtest(score: 0, musicId: musicInGame[currentMusic].id))
            }
        }
        currentMusic += 1
        if currentMusic < gameplay.maxSongs! {
            self.preparationMusic()
        }
        else {
            self.endGame()
        }
        
    }
    
    @IBAction func pausePressButton(_ sender: Any) {
        self.pauseTimer()
        player.pause()
        PauseViewController.showPause(parentVC: self)
    }
    
    func drawTimer() {
        stackViewTop.addArrangedSubview(timer.uiView)
    }
    
    func startTimer() {
        timer.startTimer(color: Colors.start)
        updateAccessoriesColor(hue: Hues.start)
        timer.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    func pauseTimer() {
        timer.pauseTimer()
    }
    
    func resumeTimer() {
        timer.resumeTimer()
        timer.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    func resetTimer() {
        stackViewTop.removeArrangedSubview(timer.uiView)
        timer.removeView()
        timer = TimerCircle(timeTotal: 10.0)
        drawTimer()
    }
    
    @objc func updateTime() {
        if timer.timeLeft / timer.timeTotal < 0.3 {
            timer.timeLeftShapeLayer.strokeColor = Colors.end.cgColor
            updateAccessoriesColor(hue: Hues.end)
        }
        else if timer.timeLeft / timer.timeTotal < 0.6 {
            timer.timeLeftShapeLayer.strokeColor = Colors.middle.cgColor
            updateAccessoriesColor(hue: Hues.middle)

        }
        if timer.timeLeft > 0 {
            timer.timeLeft = timer.endTime?.timeIntervalSinceNow ?? 0
            timer.timeLabel.text = timer.timeLeft.time
        } else {
            timer.timeLabel.text = "0"
            timer.timer.invalidate()
            self.chooseResponse(number: -1)
        }
    }
    
    /* A IMPLEMENTER */
    func endGame() {
        print(blindtest.count)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            print("ECRAN DES RESULTATS + UPLOAD API")
        }
    }
}

extension InGameViewController {
    
    
    
    func waitBeginGame() {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width + 27, height: self.view.bounds.height + 60))
        view.backgroundColor = UIColor.init(red: 0, green: 0.5, blue: 0.5, alpha: 0)
        view.center = self.view.center
        
        DispatchQueue.main.async {
            self.view.addSubview(view)
        }
        
        self.waitingView = view
    }
    
    func stopWait() {
        DispatchQueue.main.async {
            self.waitingView?.removeFromSuperview()
            self.waitingView = nil
        }
    }
    
}

extension InGameViewController: PauseViewControllerDelegate {
    func leaveGame() {
        let  vc =  self.navigationController?.viewControllers.filter({$0 is MainMenuViewController}).first

        self.navigationController?.popToViewController(vc!, animated: true)
    }
    
    func resumeGame() {
        self.resumeTimer()
        player.play()
    }
    
}

extension InGameViewController: HMHomeManagerDelegate, HMAccessoryBrowserDelegate {
    
    func updateAccessoryColor(accessory: HMAccessory, hue: CGFloat){
        print("Finding the hue characteristic of the accessory...")
        
        for service in accessory.services as [HMService]{
            for characteristic in service.characteristics as [HMCharacteristic]{
                if characteristic.characteristicType != HMCharacteristicTypeHue && !characteristic.isReadable() {
                    continue
                }
                
                print("Reading the value of the hue characteristic...")

                characteristic.readValue {(error: Error!) in
                    if error != nil{
                        print("Cannot read the hue value : \(String(describing: error))")
                        return
                    }
                        
                    print("Read the hue value. Setting it now...")
                    if !characteristic.isWritable(){
                        print("The brightness characteristic is not writable")
                        return
                    }
                                
                    characteristic.writeValue(hue) {(error: Error!) in
                        if error != nil{
                            print("Failed to set the hue value")
                            return
                        }
                        print("Successfully set the hue value")
                    }
                }
                
            }
        }
    }
    
    func updateAccessoriesColor(hue: CGFloat){
        for accessory in accessories {
            self.updateAccessoryColor(accessory: accessory, hue: hue)
        }
    }
    
    func findAccessories() {
        let room = HomeStore.shared.homeManager.primaryHome?.rooms.first(where: { $0.name == roomName})
        if(room == nil) {
            print("no room found")
            return
        }
        
        let accessories = room?.accessories.filter({ (accessory: HMAccessory) in
            return accessory.isReachable && nil != accessory.services.first(where: { (service: HMService) in
                return nil != service.characteristics.first(where: { (characteristic: HMCharacteristic) in
                    return characteristic.characteristicType == HMCharacteristicTypeHue
                })
            })
        })
        guard (accessories != nil) else {
            print("no accessories found")
        }
        self.accessories = accessories!
    }
}
