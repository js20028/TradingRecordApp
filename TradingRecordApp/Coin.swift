//
//  Coin.swift
//  TradingRecordApp
//
//  Created by 곽재선 on 2022/09/21.
//

import Foundation

struct Coin: Codable {
    let data: Data
}

struct Data: Codable {
    let BTC: CoinInfo
    let ETH: CoinInfo
    let KLAY: CoinInfo
    let MATIC: CoinInfo
    let SOL: CoinInfo
}

struct CoinInfo: Codable {
    let coinPrice: String
    let changeRate: String
    
    enum CodingKeys: String, CodingKey {
        case coinPrice = "closing_price"
        case changeRate = "fluctate_rate_24H"
    }
}

