//
//  OptionMenuViewController.swift
//  blindTestiOS
//
//  Created by Thibault BALSAMO on 02/02/2021.
//

import UIKit
import HomeKit

class OptionMenuViewController: UIViewController {
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
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
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addBtnAction(_ sender: Any) {
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
        if(accessories.count == 0){
            
        }
        HomeStore.shared.accessoryBrowser.startSearchingForNewAccessories()
    }
    
    func accessoryBrowser(_ browser: HMAccessoryBrowser, didFindNewAccessory accessory: HMAccessory) {
       
        let isOK: Bool = nil != accessory.services.first(where: { (service: HMService) in
            return nil != service.characteristics.first(where: { (characteritic: HMCharacteristic) in
                return characteritic.characteristicType == HMCharacteristicTypeHue
            })
        })
        print(" - accessory :\(accessory)    isOK: \(accessory.hasHue())")
        findServicesForAccessory(accessory: accessory)
        if(!accessory.hasHue()) { return }
  
        HomeStore.shared.homeManager.primaryHome?.addAccessory(accessory){(error: Error!) in
            if error != nil {
                self.showMessage(message: "Failed to add the accessory to the home")
                return
            }
            
            guard let room: HMRoom = HomeStore.shared.homeManager.primaryHome?.getRoom() else { return }
            HomeStore.shared.homeManager.primaryHome?.assignAccessory(accessory, to:room){ (error) in
                if error != nil{
                    self.showMessage(message: "Failed to assign the accessory to the room")
                    return
                }
            }
        }
    }
    
    func findServicesForAccessory(accessory: HMAccessory){
            print("Finding services for this accessory...")
            for service in accessory.services as [HMService]{
                print(" Service name = \(service.name)")
                print(" Service type = \(service.serviceType)")

                print(" Finding the characteristics for this service...")
                findCharacteristicsOfService(service: service)
          }
        }
        
        func findCharacteristicsOfService(service: HMService){
          for characteristic in service.characteristics as [HMCharacteristic]{
            print("   Characteristic type = " +
              "\(characteristic.characteristicType)")
          }
        }
}
