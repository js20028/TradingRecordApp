//
//  Asset.swift
//  TradingRecordApp
//
//  Created by 곽재선 on 2022/10/26.
//

import Foundation
import RealmSwift

class AssetCategory: Object {
    var assetList = List<Asset>()
}

class Asset: Object {
    @objc dynamic var categoryValue: Int = 0
    @objc dynamic var categoryName: String = ""
    @objc dynamic var assetsSum: Int = 0
    var assets = List<AssetDetail>()
}

class AssetDetail: Object {
    @objc dynamic var coinName: String = ""
    @objc dynamic var coinAmount: Double = 0
    @objc dynamic var coinPrice: String = ""
    @objc dynamic var changeRate: String = ""
}


//struct Asset {
//    let categoryValue: Int
//    let categoryName: String
//    var assetsSum: Int
//    var assets: [AssetDetail]
//}
//
//struct AssetDetail {
//    let coinName: String
//    var coinAmount: Double
//    var coinInfo: CoinInfo
//}

