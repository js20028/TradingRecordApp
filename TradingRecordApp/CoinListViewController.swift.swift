//
//  CoinListViewController.swift.swift
//  TradingRecordApp
//
//  Created by 곽재선 on 2022/09/20.
//

import UIKit

class CoinListViewController: UITableViewController {
    
    var coinList: [CoinInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getCoinData()
        
        let nibName = UINib(nibName: "CoinListCell", bundle: nil)
        self.tableView.register(nibName, forCellReuseIdentifier: "CoinListCell")
    }
    
    func getCoinData() {
        guard let coinURL = URL(string: "https://api.bithumb.com/public/ticker/ALL_KRW") else { return }
        let session = URLSession(configuration: .default)
        session.dataTask(with: coinURL) { data, response, error in
            if error != nil {
                print(error!)
                return
            }
            guard let data = data else { return }
            
            let decoder = JSONDecoder()
            let coinData = try? decoder.decode(Coin.self, from: data)
            
            self.coinList = self.makeCoinList(coin: coinData!)
            print(self.coinList)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }.resume()
    }
    
    func makeCoinList(coin: Coin) -> [CoinInfo] {
        var coinList = [
            coin.data.BTC,
            coin.data.ETH,
            coin.data.KLAY,
            coin.data.MATIC,
            coin.data.SOL
        ]
        coinList[0].coinName = "비트코인"
        coinList[1].coinName = "이더리움"
        coinList[2].coinName = "클레이튼"
        coinList[3].coinName = "폴리곤"
        coinList[4].coinName = "솔라나"
        
        return coinList
    }
}


extension CoinListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CoinListCell", for: indexPath) as? CoinListCell else { return UITableViewCell() }
        cell.coinNameLabel.text = self.coinList[indexPath.row].coinName
        cell.coinPriceLabel.text = self.coinList[indexPath.row].coinPriceDollar
        cell.changeRateLabel.text = self.coinList[indexPath.row].changeRate
        
        return cell
                
    }
}

