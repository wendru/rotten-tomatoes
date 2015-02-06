//
//  MovieCell.swift
//  rotten-tomatoes
//
//  Created by Andrew Wen on 2/4/15.
//  Copyright (c) 2015 wendru. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var runTime: UILabel!
    @IBOutlet weak var mpaaRating: UILabel!
    @IBOutlet weak var criticsRating: UILabel!
    @IBOutlet weak var audienceRating: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
