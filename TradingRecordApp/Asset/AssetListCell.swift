//
//  AssetListCell.swift
//  TradingRecordApp
//
//  Created by 곽재선 on 2022/10/06.
//

import UIKit

class AssetListCell: UITableViewCell {

    @IBOutlet weak var assetNameLabel: UILabel!
    @IBOutlet weak var holdingAssetLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
