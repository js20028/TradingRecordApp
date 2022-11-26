//
//  AssetDetailListCell.swift
//  TradingRecordApp
//
//  Created by 곽재선 on 2022/10/29.
//

import UIKit

class AssetDetailListCell: UITableViewCell {

    @IBOutlet weak var coinNameDetail: UILabel!
    @IBOutlet weak var coinSymbolDetail: UILabel!
    @IBOutlet weak var coinPriceDetail: UILabel!
    @IBOutlet weak var changeRateDetail: UILabel!
    @IBOutlet weak var coinAmountDetail: UILabel!
    @IBOutlet weak var evaluatedPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
