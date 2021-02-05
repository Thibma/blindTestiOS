//
//  PauseViewController.swift
//  blindTestiOS
//
//  Created by Thibault BALSAMO on 05/02/2021.
//

import UIKit

protocol PauseViewControllerDelegate {
    func leaveGame()
    func resumeGame()
}

class PauseViewController: UIViewController {
    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var leaveButton: UIButton!
    
    var delegate: PauseViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.resumeButton.layer.cornerRadius = 8
        self.leaveButton.layer.cornerRadius = 8
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.50)
        viewPopup.backgroundColor = UIColor.black.withAlphaComponent(0)
        // Do any additional setup after loading the view.
    }

    static func showPause(parentVC: UIViewController) {
        let viewController = PauseViewController()
        viewController.modalPresentationStyle = .custom
        viewController.modalTransitionStyle = .crossDissolve
        
        viewController.delegate = parentVC as? PauseViewControllerDelegate
        
        parentVC.present(viewController, animated: true, completion: nil)
        
    }
    
    @IBAction func resumePressButton(_ sender: Any) {
        self.delegate?.resumeGame()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func leavePressButton(_ sender: Any) {
        self.delegate?.leaveGame()
        self.dismiss(animated: false, completion: nil)
    }
    
}
