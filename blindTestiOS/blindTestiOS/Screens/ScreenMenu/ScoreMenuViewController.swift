//
//  ScoreMenuViewController.swift
//  blindTestiOS
//
//  Created by Thibault BALSAMO on 02/02/2021.
//

import UIKit
import AVFoundation

class ScoreMenuViewController: UIViewController {
    @IBOutlet weak var generalView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var backButton: UIButton!
    
    let historicViewController = HistoricViewController()
    let recordViewController = RecordViewController()
    
    var player: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        backButton.layer.cornerRadius = 8
        generalView.backgroundColor = UIColor.red.withAlphaComponent(0)
        
        let font = UIFont (name: "KGRedHands", size: 15)
        let normalAttribute: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: UIColor(named: "Primary")]
        self.segmentedControl.setTitleTextAttributes(normalAttribute, for: .normal)
        
        let selectedAttribute: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: UIColor(named: "Secondary")]
        self.segmentedControl.setTitleTextAttributes(selectedAttribute, for: .selected)
        
        
        historicViewController.view.frame = generalView.bounds
        historicViewController.view.bounds.size.width -= 50
        recordViewController.view.frame = generalView.bounds
        self.addChild(historicViewController)
        self.addChild(recordViewController)
        historicViewController.didMove(toParent: self)
        historicViewController.view.clipsToBounds = true
        recordViewController.didMove(toParent: self)
        recordViewController.view.clipsToBounds = true
        generalView.addSubview(historicViewController.view)

    }
    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            recordViewController.view.removeFromSuperview()
            generalView.addSubview(historicViewController.view)
        }
        else if sender.selectedSegmentIndex == 1 {
            historicViewController.view.removeFromSuperview()
            generalView.addSubview(recordViewController.view)
        }
    }
    
    @IBAction func backbuttonPressed(_ sender: Any) {
        player = self.setAudioBackButton()
        recordViewController.view.removeFromSuperview()
        recordViewController.removeFromParent()
        
        historicViewController.view.removeFromSuperview()
        historicViewController.removeFromParent()
        self.navigationController?.popViewController(animated: true)
    }
    
}
