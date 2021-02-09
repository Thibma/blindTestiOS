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
    
    
    
    //var accessories = [HMAccessory]()
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
    
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        let home = homeManager.homes.first(where: { $0.name == homeName })
        if(home == nil) {
            createHome()
            return
        }
        
        self.home = home!
        print("Found home : \(self.home!)")
        
        let room = self.home.rooms.first(where: { $0.name == roomName})
        if room == nil {
            createRoom()
            return
        }
        self.room = room
        print("Found room: \(self.room!)")
        findHomeWithLightBulbAccessory()
    }
    
    func createHome(){
        homeManager.addHome(withName: homeName){ (home: HMHome!, error: Error!) in
            if error != nil {
                print("Could not add the home")
                return
            }
            
            self.home = home
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
            self.room = room
            
            print("Successfully created a room.")
            print("Discovering accessories now...")
            //self.accessoryBrowser.startSearchingForNewAccessories() // to delete
            self.findHomeWithLightBulbAccessory()
        }
    }
    
    func findHomeWithLightBulbAccessory() {
        if let accessory = room.accessories.first(where: { $0.name == accessoryName }) {
            print("Found the lightbulb accessory in the room")
            self.accessory = accessory
            lowerBrightnessOfLightbulb() // to uncomment and modify
            return
        }
        
        print("Could not find the lighbulb accessory in the room")
        print("Starting to search for all available accessories")
        accessoryBrowser.startSearchingForNewAccessories()
    }
    
    func accessoryBrowser(_ browser: HMAccessoryBrowser, didFindNewAccessory accessory: HMAccessory) {
        print("Found an accessory \(accessory)")
        
        if(accessory.name != accessoryName) {
            print("The accessory is not a '\(accessoryName)'")
            print("The accessory will not be added to the home")
            return
        }
        
        print("Adding it to the home...")
        home.addAccessory(accessory){(error: Error!) in
            if error != nil {
                print("Failed to add the accessory to the home")
                print("Error = \(String(describing: error))")
                return
            }
            
            print("Successfully added the accessory to the home")
            print("Assigning the lightbulb to the room...")
            
            self.home.assignAccessory(accessory, to: self.room){ (error) in
                if error != nil{
                    print("Failed to assign the accessory to the room")
                    print("Error = \(String(describing: error))")
                    return
                }
                self.accessory = accessory
                print("Successfully assigned the lightbulb to the room")
                //self.findServicesForAccessory(accessory: accessory) // to delete
                self.lowerBrightnessOfLightbulb()
            }
        }
    }
    
    func lowerBrightnessOfLightbulb(){
        var brightnessCharacteristic: HMCharacteristic!
        print("Finding the brightness characteristic of the lightbulb...")
        
        for service in accessory.services as [HMService]{
            print(service)
            for characteristic in service.characteristics as [HMCharacteristic]{
                if characteristic.characteristicType == HMCharacteristicTypeBrightness{
                    print("Found it")
                    brightnessCharacteristic = characteristic
                }
            }
        }

        if brightnessCharacteristic == nil{
            print("Cannot find it")
            return
        }
        
        if brightnessCharacteristic.isReadable() == false {
            print("Cannot read the value of the brightness characteristic")
            return
        }

        print("Reading the value of the brightness characteristic...")

        brightnessCharacteristic.readValue {(error: Error!) in
            if error != nil{
                print("Cannot read the brightness value : \(String(describing: error))")
                return
            }
                
            print("Read the brightness value. Setting it now...")
            if !brightnessCharacteristic.isWritable(){
                print("The brightness characteristic is not writable")
                return
            }
            
            let newValue = (brightnessCharacteristic.value as! Float) - 1.0
            
            brightnessCharacteristic.writeValue(newValue) {(error: Error!) in
                if error != nil{
                    print("Failed to set the brightness value")
                    return
                }
                print("Successfully set the brightness value")
            }
        }

        if !(brightnessCharacteristic.value is Float){
          print("The value of the brightness is not Float. Cannot set it")
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
