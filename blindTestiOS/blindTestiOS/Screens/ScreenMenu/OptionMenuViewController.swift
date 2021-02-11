//
//  OptionMenuViewController.swift
//  blindTestiOS
//
//  Created by Thibault BALSAMO on 02/02/2021.
//

import UIKit
import HomeKit
import AVFoundation

class OptionMenuViewController: UIViewController {
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    var player: AVAudioPlayer!
    
    let homeName: String = { HomeStore.shared.homeName }()
    let roomName: String = { HomeStore.shared.roomName }()
        
    class func newInstance() -> OptionMenuViewController {
        let optionMenuVC = OptionMenuViewController()
        return optionMenuVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBtn.layer.cornerRadius = 8
        backBtn.layer.cornerRadius = 8
        setBackground()
        HomeStore.shared.homeManager.delegate = self
        HomeStore.shared.accessoryBrowser.delegate = self
    }

    @IBAction func backBtnAction(_ sender: Any) {

        player = setAudioBackButton()
        self.navigationController?.popViewController(animated: true)

    }
    
    @IBAction func addBtnAction(_ sender: Any) {
        player = setAudioButton()
        findHomeWithLightBulbAccessory()
    }
}

extension OptionMenuViewController: HMHomeManagerDelegate, HMAccessoryBrowserDelegate, HMHomeDelegate {
    
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        guard let _: HMHome = HomeStore.shared.homeManager.primaryHome else {
            createHome()
            return
        }

        guard let _: HMRoom = HomeStore.shared.homeManager.primaryHome?.getRoom() else {
            createRoom()
            return
        }
    }
    
    func createHome(){
        HomeStore.shared.homeManager.addHome(withName: homeName){ (home: HMHome!, error: Error!) in
            if error != nil {
                self.showMessage(message: "Could not add the home")
                return
            }
            
            HomeStore.shared.homeManager.updatePrimaryHome(home) { (error: Error!) in
                if(error != nil) {
                    self.showMessage(message: "Could not define primery home")
                    return
                }
                self.createRoom()
            }
        }
    }
    
    func createRoom(){
        HomeStore.shared.homeManager.primaryHome?.addRoom(withName: roomName){ (room: HMRoom!, error: Error!) in
            if error != nil {
                self.showMessage(message: "Failed to create the room...")
                return
            }
            
            self.findHomeWithLightBulbAccessory()
        }
    }
    
    func findHomeWithLightBulbAccessory() {
        guard let room: HMRoom = HomeStore.shared.homeManager.primaryHome?.getRoom() else { return }
        let accessories: [HMAccessory] = room.getAccessories()
        print(accessories)
        HomeStore.shared.accessoryBrowser.startSearchingForNewAccessories()
    }
    
    func accessoryBrowser(_ browser: HMAccessoryBrowser, didFindNewAccessory accessory: HMAccessory) {
        let isConnected = HomeStore.shared.homeManager.primaryHome?.getRoom()?.accessories.first(where: { return $0.uniqueIdentifier == accessory.uniqueIdentifier }) != nil
        if isConnected { return }
        
        HomeStore.shared.homeManager.primaryHome?.addAccessory(accessory){(error: Error!) in
            if error != nil {
                self.showMessage(message: "Failed to add the accessory to the home")
                return
            }
            
            guard let room: HMRoom = HomeStore.shared.homeManager.primaryHome?.getRoom() else { return }
            HomeStore.shared.homeManager.primaryHome?.assignAccessory(accessory, to:room){ (error) in
                if error != nil{
                    self.showMessage(message: "Failed to assign the accessory to the room")
                }
            }
        }
    }
}
