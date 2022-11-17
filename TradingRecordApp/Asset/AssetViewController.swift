//
//  AssetViewController.swift
//  TradingRecordApp
//
//  Created by 곽재선 on 2022/10/05.
//

import UIKit

class AssetViewController: UIViewController {

    @IBOutlet weak var totalAssetWon: UILabel!
    @IBOutlet weak var totalAssetDollar: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    var totalAsset = [[Asset](), [Asset](), [Asset]()]
    
//    var exchanges: [Asset] = []
//    var wallets: [Asset] = []
//    var others: [Asset] = []
    var sections: [String] = ["거래소", "지갑", "기타"]
    var coin: Coin!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 테이블 뷰 최상단 잘림 해결
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        self.getCoinData()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.totalAssetWon.text = "₩ \(self.makeTotalAssetSum())"
        self.totalAssetDollar.text = "$ \(self.makeTotalAssetSum() / 1340)"
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
            
            self.coin = coinData!
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }.resume()
    }
    
    private func makeTotalAssetSum() -> Int {
        var sum = 0
        for i in 0..<3 {
            for asset in self.totalAsset[i] {
                sum += asset.assetsSum
            }
        }
        return sum
    }
    
    private func matchCoinInfoTotal(assets: [[Asset]], coin: Coin) {
        for i in 0..<3 {
            for asset in assets[i] {
                for var assetDetail in asset.assets {
                    switch assetDetail.coinName.uppercased() {
                    case "이더리움", "ETH":
                        assetDetail.coinInfo = coin.data.ETH
                    case "클레이튼", "KLAY":
                        assetDetail.coinInfo = coin.data.KLAY
                    case "폴리곤", "MATIC":
                        assetDetail.coinInfo = coin.data.MATIC
                    case "솔라나", "SOL":
                        assetDetail.coinInfo = coin.data.SOL
                    default:
                        break
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let addAssetViewController = segue.destination as? AddAssetViewController else { return }
        addAssetViewController.delegate = self
        addAssetViewController.totalAsset = self.totalAsset
        
    }
}

extension AssetViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "AssetListCell", for: indexPath) as? AssetListCell else { return UITableViewCell() }
        
        cell.assetNameLabel.text = self.totalAsset[indexPath.section][indexPath.row].categoryName
        cell.holdingAssetLabel.text = "\(self.totalAsset[indexPath.section][indexPath.row].assetsSum) 원"
        
        
//        switch indexPath.section {
//        case 0:
//            cell.assetNameLabel.text = self.exchanges[indexPath.row].categoryName
//        case 1:
//            cell.assetNameLabel.text = self.wallets[indexPath.row].categoryName
//        case 2:
//            cell.assetNameLabel.text = self.others[indexPath.row].categoryName
//        default:
//            break
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return self.totalAsset[0].count
        case 1:
            return self.totalAsset[1].count
        case 2:
            return self.totalAsset[2].count
        default:
            return 0
        }
        
//        switch section {
//        case 0:
//            return self.exchanges.count
//        case 1:
//            return self.wallets.count
//        case 2:
//            return self.others.count
//        default:
//            return 0
//        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "AssetDetailViewController") as? AssetDetailViewController else { return }
        
        viewController.assetDetailList = self.totalAsset[indexPath.section][indexPath.row].assets
        viewController.indexPath = indexPath
        viewController.delegate = self
        
//        switch indexPath.section {
//        case 0:
//            viewController.assetDetailList = self.exchanges[indexPath.row].assets
//        case 1:
//            viewController.assetDetailList = self.wallets[indexPath.row].assets
//        case 2:
//            viewController.assetDetailList = self.others[indexPath.row].assets
//        default:
//            break
//        }
        
//        self.show(viewController, sender: nil)
//        self.performSegue(withIdentifier: "showAssetDetail", sender: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
    }
}

extension AssetViewController: AddAssetDelegate {
    func didSelectAdd(asset: Asset, isNew: Bool, index: Int) {
        
        if isNew {
            self.totalAsset[asset.categoryValue].append(asset)
        } else {
            self.totalAsset[asset.categoryValue][index] = asset
        }
        
//        switch asset.categoryValue {
//        case 0:
//            self.exchanges.append(asset)
//        case 1:
//            self.wallets.append(asset)
//        case 2:
//            self.others.append(asset)
//        default:
//            break
//        }
        
        self.tableView.reloadData()
    }
}

extension AssetViewController: AssetDetailDelegate {
    func sendAssetDetail(assetDetailList: [AssetDetail], indexPath: IndexPath, sum: Int) {
        self.totalAsset[indexPath.section][indexPath.row].assets = assetDetailList
        self.totalAsset[indexPath.section][indexPath.row].assetsSum = sum
        self.tableView.reloadData()
    }
}
