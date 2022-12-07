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
//    let ETC: CoinInfo
//    let XRP: CoinInfo
//    let BCH: CoinInfo
//    let DOGE: CoinInfo
//    let QTUM: CoinInfo
//    let BTG: CoinInfo
//    let EOS: CoinInfo
//    let ICX: CoinInfo
//    let TRX: CoinInfo
//    let ELF: CoinInfo
//    let OMG: CoinInfo
//    let KNC: CoinInfo
//    let GLM: CoinInfo
//    let ZIL: CoinInfo
//    let WAXP: CoinInfo
//    let POWR: CoinInfo
//    let LRC: CoinInfo
//    let STEEM: CoinInfo
}

struct CoinInfo: Codable {
    let coinPrice: String
    let changeRate: String
    
    var coinPriceDollar: String {
        var won = (Double(coinPrice) ?? 0)
        won = round(won / 1440 * 1000) / 1000
        return String(won)
    }
    
    enum CodingKeys: String, CodingKey {
        case coinPrice = "closing_price"
        case changeRate = "fluctate_rate_24H"
    }
}

