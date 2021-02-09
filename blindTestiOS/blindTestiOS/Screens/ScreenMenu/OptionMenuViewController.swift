//
//  OptionMenuViewController.swift
//  blindTestiOS
//
//  Created by Thibault BALSAMO on 02/02/2021.
//

import UIKit
import HomeKit

class OptionMenuViewController: UIViewController {
    @IBOutlet weak var accessoriesTV: UITableView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    var array: [String] = []
    enum Identifier: String { case accessories }
    
    
    
    var accessories = [HMAccessory]()
    var home: HMHome!
    var room: HMRoom!
    var accessory = HMAccessory()
    
    lazy var accessoryBrowser: HMAccessoryBrowser = {
      let browser = HMAccessoryBrowser()
      browser.delegate = self
      return browser
    }()
    
    var homeName = "Main Home"
    let roomName = "Main Room"
    let accessoryName = "LightBulb"

    var homeManager: HMHomeManager!
    
    
    class func newInstance() -> OptionMenuViewController {
        let optionMenuVC = OptionMenuViewController()
        return optionMenuVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeManager = HMHomeManager()
        homeManager.delegate = self
        // Do any additional setup after loading the view.
    }

    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addBtnAction(_ sender: Any) {
    }


}

extension OptionMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let _: String =  self.array[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.accessories.rawValue, for: indexPath) //as! UITableViewCell
        cell.textLabel?.text = "Test"
        return cell
    }
}

extension OptionMenuViewController: HMHomeManagerDelegate, HMAccessoryBrowserDelegate {
    
    func createHome(){
        homeManager.addHome(withName: homeName){ (home: HMHome!, error: Error!) in
            if error != nil {
                print("Could not add the home")
                return
            }
            
            let strongSelf = self
            strongSelf.home = home
            print("Successfully added the home")
            print("Creating the room...")
            self.createRoom()
        }
    }
    
    func createRoom(){
        home.addRoom(withName: roomName){ (room: HMRoom!, error: Error!) in
            if error != nil {
                print("Failed to create the room...")
                return
            }
            let strongSelf = self
            strongSelf.room = room
            
            print("Successfully created a room.")
            print("Discovering accessories now...")
            strongSelf.accessoryBrowser.startSearchingForNewAccessories()
            strongSelf.findHomeWithLightBulbAccessory()
        }
    }
    
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        if let home = homeManager.homes.first(where: { $0.name == homeName }){
            self.home = home
            findHomeWithLightBulbAccessory()
            return
        }
        createHome()
    }
    
    func findHomeWithLightBulbAccessory() {
        if let accessory = accessories.first(where: { $0.name == accessoryName }) {
            print("Found the projector accessory in the room")
            self.accessory = accessory
            //lowerBrightnessOfProjector()
            return
        }
        
        print("Could not find the projector accessory in the room")
        print("Starting to search for all available accessories")
        accessoryBrowser.startSearchingForNewAccessories()
    }
    
    func accessoryBrowser(_ browser: HMAccessoryBrowser, didFindNewAccessory accessory: HMAccessory) {
        print("Found a new accessory \(accessory)")
        print("Adding it to the home...")
        
        home.addAccessory(accessory){(error: Error!) in
            let strongSelf = self
            if error != nil {
                print("Failed to add the accessory to the home")
                print("Error = \(String(describing: error))")
                return
            }
            
            print("Successfully added the accessory to the home")
            print("Assigning the accessory to the room...")
            
            strongSelf.home.assignAccessory(accessory, to: strongSelf.room) {(error: Error!) in
                if error != nil{
                    print("Failed to assign the accessory to the room")
                    print("Error = \(String(describing: error))")
                    return
                }
                print("Successfully assigned the accessory to the room")
                strongSelf.findServicesForAccessory(accessory: accessory)
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
    
    func accessoryBrowser(_ browser: HMAccessoryBrowser, didRemoveNewAccessory accessory: HMAccessory){
        print("An accessory has been removed")

    }
    
}
