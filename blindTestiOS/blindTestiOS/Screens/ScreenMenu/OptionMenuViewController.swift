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
    
    lazy var accessoryBrowser: HMAccessoryBrowser = {
      let browser = HMAccessoryBrowser()
      browser.delegate = self
      return browser
      }()
    var randomHomeName: String = {
      return "Home \(arc4random_uniform(UInt32.max))"
      }()

    let roomName = "Bedroom 1"

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
    
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        manager.addHome(withName: randomHomeName){ (home: HMHome!, error: Error!) in

            if error != nil {
                print("Could not add the home")
                return
            }
            
            let strongSelf = self
            strongSelf.home = home
            print("Successfully added a home")
            print("Adding a room to the home...")
            
            home.addRoom(withName: strongSelf.roomName){ (room: HMRoom!, error: Error!) in
                if error != nil {
                    print("Failed to add a room...")
                    return
                }
                strongSelf.room = room
                print("Successfully added a room.")
                print("Discovering accessories now...")
                strongSelf.accessoryBrowser.startSearchingForNewAccessories()
            }
        }
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
