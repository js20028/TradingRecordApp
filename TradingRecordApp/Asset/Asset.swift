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
    let assets: [AssetDetail]
}

struct AssetDetail {
    let coinName: String
    var coinAmount: Double
}
