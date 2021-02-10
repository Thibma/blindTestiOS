//
//  HistoricTableViewCell.swift
//  blindTestiOS
//
//  Created by Thibault BALSAMO on 09/02/2021.
//

import UIKit

class HistoricTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var gamePlayLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var themeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
