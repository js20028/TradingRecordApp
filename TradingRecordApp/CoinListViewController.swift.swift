//
//  CoinListViewController.swift.swift
//  TradingRecordApp
//
//  Created by 곽재선 on 2022/09/20.
//

import UIKit

class CoinListViewController: UITableViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getCoinData()
    }
    
    func getCoinData() {
        guard let coinURL = URL(string: "https://api.bithumb.com/public/ticker/KLAY_KRW") else { return }
        let session = URLSession(configuration: .default)
        session.dataTask(with: coinURL) { data, response, error in
            if error != nil {
                print(error!)
                return
            }
            guard let data = data else { return }
            let dataString = String(data: data, encoding: .utf8)
            print(dataString!)
        }.resume()
    }
}
