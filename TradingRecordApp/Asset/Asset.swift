//
//  Asset.swift
//  TradingRecordApp
//
//  Created by 곽재선 on 2022/10/26.
//

import Foundation

struct Asset {
    let categoryValue: Int
    let categoryName: String
    var assetsSum: Int
    var assets: [AssetDetail]
}

struct AssetDetail {
    let coinName: String
    var coinAmount: Double
    var coinInfo: CoinInfo
}
