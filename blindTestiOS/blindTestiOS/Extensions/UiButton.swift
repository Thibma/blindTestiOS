//
//  UiButton.swift
//  blindTestiOS
//
//  Created by Thibault BALSAMO on 09/02/2021.
//

import Foundation
import AVFoundation
import UIKit

extension UIButton {
    
    func setAudio() -> AVAudioPlayer? {
        guard let sound = Bundle.main.url(forResource: "ButtonSound", withExtension: "wav") else {
            print("noon")
            return nil
        }
        
        guard let player = try? AVAudioPlayer(contentsOf: sound) else {
            print("ouin")
            return nil
        }
        
        player.play()
        return player
    }
    
}
