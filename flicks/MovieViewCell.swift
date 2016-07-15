//
//  MovieViewCell.swift
//  flicks
//
//  Created by Martene Mendy on 7/14/16.
//  Copyright © 2016 Martene Mendy. All rights reserved.
//

import UIKit

import AFNetworking

class MovieViewCell: UITableViewCell {
   @IBOutlet weak var movieTitle: UILabel!
   @IBOutlet weak var movieSynopsis: UILabel!
   @IBOutlet weak var movieImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
