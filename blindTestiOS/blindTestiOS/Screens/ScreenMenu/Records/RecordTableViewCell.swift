//
//  RecordTableViewCell.swift
//  blindTestiOS
//
//  Created by Thibault BALSAMO on 10/02/2021.
//

import UIKit

class RecordTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var gamemodeLabel: UILabel!
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var classeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
}
