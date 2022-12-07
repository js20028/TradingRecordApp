//
//  CoinListViewController.swift.swift
//  TradingRecordApp
//
//  Created by 곽재선 on 2022/09/20.
//

import UIKit

class CoinListViewController: UITableViewController {
    
    var coinList: [CoinInfo] = []
    var coinSymbolList: [String] = ["BTC", "ETH", "KLAY", "MATIC", "SOL"]
    var coinNameList = ["비트코인", "이더리움", "클레이튼", "폴리곤", "솔라나"]
    
    let refreshCon = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getCoinData()
        
        self.initRefresh()
        
        self.registerXib()
        
//        UIFont.familyNames.sorted().forEach { familyName in
//            print("*** \(familyName) ***")
//            UIFont.fontNames(forFamilyName: familyName).forEach { fontName in
//                print("\(fontName)")
//            }
//            print("---------------------")
//        }
        
    }
    
    private func getCoinData() {
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
            // print(self.coinList)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }.resume()
    }
    
    // xib 등록
    private func registerXib() {
        let nibName = UINib(nibName: "CoinListCell", bundle: nil)
        self.tableView.register(nibName, forCellReuseIdentifier: "CoinListCell")
        
        let customHeaderUINib = UINib(nibName: "CoinListHeaderView", bundle: nil)
        self.tableView.register(customHeaderUINib, forHeaderFooterViewReuseIdentifier: "CoinListHeaderView")
    }
    
    private func makeCoinList(coin: Coin) -> [CoinInfo] {
        let coinList = [
            coin.data.BTC,
            coin.data.ETH,
            coin.data.KLAY,
            coin.data.MATIC,
            coin.data.SOL
        ]
        return coinList
    }
    
    // 당겨서 새로고침 초기화
    private func initRefresh() {
        refreshCon.addTarget(self, action: #selector(refreshTable(refresh:)), for: .valueChanged)
        refreshCon.attributedTitle = NSAttributedString(string: "새로고침")
        
        self.tableView.refreshControl = refreshCon
    }
    
    // 새로고침 시 코인데이터를 다시 받아와 테이블뷰 갱신
    @objc func refreshTable(refresh: UIRefreshControl) {
        DispatchQueue.main.async {
            self.getCoinData()
            self.tableView.reloadData()
            refresh.endRefreshing()
        }
    }
}

extension CoinListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CoinListCell", for: indexPath) as? CoinListCell else { return UITableViewCell() }
        cell.coinNameLabel.text = self.coinNameList[indexPath.row]
        cell.coinSymbolLabel.text = self.coinSymbolList[indexPath.row]
        cell.coinPriceLabel.text = self.coinList[indexPath.row].coinPrice
        cell.changeRateLabel.text = "\(self.coinList[indexPath.row].changeRate)%"
        if Double(self.coinList[indexPath.row].changeRate)! >= 0 {
            cell.changeRateLabel.textColor = .red
        } else {
            cell.changeRateLabel.textColor = .blue
        }
        
        return cell
                
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CoinListHeaderView") as? CoinListHeaderView else { return UITableViewHeaderFooterView()}
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}

