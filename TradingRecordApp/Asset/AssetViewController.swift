//
//  AssetViewController.swift
//  TradingRecordApp
//
//  Created by 곽재선 on 2022/10/05.
//

import UIKit
import RealmSwift

class AssetViewController: UIViewController {

    @IBOutlet weak var totalAssetWon: UILabel!
    @IBOutlet weak var totalAssetDollar: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var totalAsset = [[Asset](), [Asset](), [Asset]()] {
        didSet {
            self.totalAssetWon.text = "₩ \(self.makeTotalAssetSum())"
            self.totalAssetDollar.text = "$ \(self.makeTotalAssetSum() / 1340)"
        }
    }
    
    var sections: [String] = ["거래소", "지갑", "기타"]
    var coin: Coin!
    
//    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 테이블 뷰 최상단 잘림 해결
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        self.getCoinData()
        
        self.makeRealmData()
        self.loadRealmData()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.totalAssetWon.text = "₩ \(self.makeTotalAssetSum())"
        self.totalAssetDollar.text = "$ \(self.makeTotalAssetSum() / 1340)"
    }
    
    // Realm DB 데이터 초기화 함수
    private func makeRealmData() {
        let realm = try! Realm()
        let savedAsset = realm.objects(AssetCategory.self)
        //print(Realm.Configuration.defaultConfiguration.fileURL!)

        while savedAsset.count < 3 {
            try! realm.write {
                realm.add(AssetCategory())
            }
        }
    }
    
    // Realm DB 데이터 불러와서 배열에 저장하는 함수
    private func loadRealmData() {
        let realm = try! Realm()
        
        let savedAsset = realm.objects(AssetCategory.self)
        for i in 0..<3 {
            for asset in savedAsset[i].assetList {
                self.totalAsset[i].append(asset)
            }
        }
        
        print(self.totalAsset)
    }
    
    // 코인정보 가져오는 함수
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
                for assetDetail in asset.assets {
                    switch assetDetail.coinName.uppercased() {
                    case "이더리움", "ETH":
                        assetDetail.coinPrice = coin.data.ETH.coinPrice
                        assetDetail.changeRate = coin.data.ETH.changeRate
                    case "클레이튼", "KLAY":
                        assetDetail.coinPrice = coin.data.KLAY.coinPrice
                        assetDetail.changeRate = coin.data.KLAY.changeRate
                    case "폴리곤", "MATIC":
                        assetDetail.coinPrice = coin.data.MATIC.coinPrice
                        assetDetail.changeRate = coin.data.MATIC.changeRate
                    case "솔라나", "SOL":
                        assetDetail.coinPrice = coin.data.SOL.coinPrice
                        assetDetail.changeRate = coin.data.SOL.changeRate
                    default:
                        break
                    }
                }
            }
        }
    }
    
    private func removeCell(at indexPath: IndexPath, to tableView: UITableView) {
        let realm = try! Realm()
        let savedAsset = realm.objects(AssetCategory.self)
        
        try! realm.write {
            self.totalAsset[indexPath.section].remove(at: indexPath.row)
            for assetDetail in savedAsset[indexPath.section].assetList[indexPath.row].assets {
                realm.delete(assetDetail)
            }
            realm.delete(savedAsset[indexPath.section].assetList[indexPath.row])
        }
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
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
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "AssetDetailViewController") as? AssetDetailViewController else { return }
        
        //viewController.assetDetailList = self.totalAsset[indexPath.section][indexPath.row].assets
        for assetDetail in self.totalAsset[indexPath.section][indexPath.row].assets {
            viewController.assetDetailList.append(assetDetail)
        }
        
        
        viewController.indexPath = indexPath
        viewController.delegate = self
        
//        self.show(viewController, sender: nil)
//        self.performSegue(withIdentifier: "showAssetDetail", sender: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.removeCell(at: indexPath, to: tableView)
        }
    }
}

extension AssetViewController: AddAssetDelegate {
    func didSelectAdd(asset: Asset, isNew: Bool, index: Int) {
        let realm = try! Realm()
        let savedAsset = realm.objects(AssetCategory.self)
        
        if isNew {
            

            try! realm.write {
                self.totalAsset[asset.categoryValue].append(asset)
                savedAsset[asset.categoryValue].assetList.append(asset)
            }
            
        } else {
            
//            try! realm.write {
//                self.totalAsset[asset.categoryValue][index] = asset
//                savedAsset[asset.categoryValue].assetList[index] = asset
//            }
        }
        
        self.tableView.reloadData()
    }
}

extension AssetViewController: AssetDetailDelegate {
    func sendAssetDetail(assetDetailList: [AssetDetail], indexPath: IndexPath, sum: Int) {
        //self.totalAsset[indexPath.section][indexPath.row].assets = assetDetailList
        let realm = try! Realm()
        let savedAsset = realm.objects(AssetCategory.self)
        try! realm.write {
            self.totalAsset[indexPath.section][indexPath.row].assets.removeAll()
            for assetDetail in assetDetailList {
                self.totalAsset[indexPath.section][indexPath.row].assets.append(assetDetail)
            }


            self.totalAsset[indexPath.section][indexPath.row].assetsSum = sum

            // 자산상세 페이지에서 모든항목 삭제 시 자산페이지의 전체자산 배열 요소 삭제
            if sum == 0 {
                realm.delete(savedAsset[indexPath.section].assetList[indexPath.row])
                
                self.totalAsset[indexPath.section].remove(at: indexPath.row)
            }
        }
        
        self.tableView.reloadData()
    }
}
