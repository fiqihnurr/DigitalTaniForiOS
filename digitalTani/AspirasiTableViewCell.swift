//
//  AspirasiTableViewCell.swift
//  digitalTani
//
//  Created by FiqihNR on 9/18/17.
//  Copyright © 2017 FiqihNR. All rights reserved.
//

import UIKit

class AspirasiTableViewCell: UITableViewCell {

    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var dukungButton: UIButton!
    @IBOutlet weak var totalPendukung: UILabel!
    @IBOutlet weak var namaUserLabel: UILabel!
    @IBOutlet weak var tanggalPostLabel: UILabel!
    @IBOutlet weak var isiAspirasiLabel: UILabel!
    
       override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
