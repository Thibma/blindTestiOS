//
//  UiViewController.swift
//  blindTestiOS
//
//  Created by Thibault BALSAMO on 20/01/2021.
//

import Foundation
import UIKit
import AVFoundation

var vSpinner: UIView?
var alert: UIAlertController?

extension UIViewController {
    
    func setBackground() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background.jpg")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
            
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
            
        vSpinner = spinnerView
    }
        
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
    
    func showMessage(message: String) {
        alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "OK", style: .default) { _ in self.removeMessage() }
        alert?.addAction(actionOK)
        DispatchQueue.main.sync {
            self.present(alert!, animated: true){}
        }
    }
    
    func removeMessage(){
        DispatchQueue.main.async{
            alert?.dismiss(animated: true){}
            alert = nil
        }
    }
    
    func setAudioButton() -> AVAudioPlayer? {
        guard let sound = Bundle.main.url(forResource: "ButtonSound", withExtension: "wav") else {
            return nil
        }
        
        guard let player = try? AVAudioPlayer(contentsOf: sound) else {
            return nil
        }
        
        player.volume = 0.5
        player.play()
        return player
    }
    
    func setAudioBackButton() -> AVAudioPlayer? {
        guard let sound = Bundle.main.url(forResource: "BackButton", withExtension: "wav") else {
            return nil
        }
        
        guard let player = try? AVAudioPlayer(contentsOf: sound) else {
            return nil
        }
        
        player.volume = 0.5
        player.play()
        return player
    }
}
