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
    
    var sections: [String] = ["","",""]
    var coin: Coin!
    let refreshCon = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 테이블 뷰 최상단 잘림 해결
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        self.makeRealmData()
        self.loadRealmData()
        self.refreshTable(refresh: self.refreshCon)
        
        self.initRefresh()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        self.configureNavigationBar()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.totalAssetWon.text = "₩ \(self.makeTotalAssetSum())"
        self.totalAssetDollar.text = "$ \(self.makeTotalAssetSum() / 1340)"
    }
    
    private func configureNavigationBar() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = UIColor(displayP3Red: 0/255, green: 128/255, blue: 255/255, alpha: 0.8)
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "NanumGothicBold", size: 20)!, NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        self.navigationController?.navigationBar.tintColor = .white
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
        if !savedAsset[0].assetList.isEmpty {
            self.sections[0] = "거래소"
        }
        if !savedAsset[1].assetList.isEmpty {
            self.sections[1] = "지갑"
        }
        if !savedAsset[2].assetList.isEmpty {
            self.sections[2] = "기타"
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
    
//    private func matchCoinInfoTotal(assets: [[Asset]], coin: Coin) {
//        for i in 0..<3 {
//            for asset in assets[i] {
//                for assetDetail in asset.assets {
//                    switch assetDetail.coinName.uppercased() {
//                    case "이더리움", "ETH":
//                        assetDetail.coinPrice = coin.data.ETH.coinPrice
//                        assetDetail.changeRate = coin.data.ETH.changeRate
//                    case "클레이튼", "KLAY":
//                        assetDetail.coinPrice = coin.data.KLAY.coinPrice
//                        assetDetail.changeRate = coin.data.KLAY.changeRate
//                    case "폴리곤", "MATIC":
//                        assetDetail.coinPrice = coin.data.MATIC.coinPrice
//                        assetDetail.changeRate = coin.data.MATIC.changeRate
//                    case "솔라나", "SOL":
//                        assetDetail.coinPrice = coin.data.SOL.coinPrice
//                        assetDetail.changeRate = coin.data.SOL.changeRate
//                    default:
//                        break
//                    }
//                }
//            }
//        }
//    }
    
    // 당겨서 새로고침 초기화
    private func initRefresh() {
        refreshCon.addTarget(self, action: #selector(refreshTable(refresh:)), for: .valueChanged)
        refreshCon.attributedTitle = NSAttributedString(string: "새로고침")
        
        self.tableView.refreshControl = refreshCon
    }
    
    // 새로고침 시 코인데이터를 다시 받아와 테이블뷰 갱신
    @objc func refreshTable(refresh: UIRefreshControl) {
        self.getCoinData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
            self.configureTotalView()
            
            self.totalAssetWon.text = "₩ \(self.makeTotalAssetSum())"
            self.totalAssetDollar.text = "$ \(self.makeTotalAssetSum() / 1340)"
            
            self.tableView.reloadData()
            refresh.endRefreshing()
        }
    }
    
    // 코인정보 새로받아서 토탈배열 및 테이블 뷰 갱신
    private func configureTotalView() {
        let realm = try! Realm()
        try! realm.write {
            for i in 0..<3 {
                for asset in self.totalAsset[i] {
                    var sum = 0
                    for detail in asset.assets {
                        switch detail.coinSymbol {
                        case "BTC":
                            detail.coinPrice = self.coin.data.BTC.coinPrice
                            detail.changeRate = self.coin.data.BTC.changeRate
                        case "ETH":
                            detail.coinPrice = self.coin.data.ETH.coinPrice
                            detail.changeRate = self.coin.data.ETH.changeRate
                        case "KLAY":
                            detail.coinPrice = self.coin.data.KLAY.coinPrice
                            detail.changeRate = self.coin.data.KLAY.changeRate
                        case "MATIC":
                            detail.coinPrice = self.coin.data.MATIC.coinPrice
                            detail.changeRate = self.coin.data.MATIC.changeRate
                        case "SOL":
                            detail.coinPrice = self.coin.data.SOL.coinPrice
                            detail.changeRate = self.coin.data.SOL.changeRate
                        case "BNB":
                            detail.coinPrice = self.coin.data.BNB.coinPrice
                            detail.changeRate = self.coin.data.BNB.changeRate
                        case "XRP":
                            detail.coinPrice = self.coin.data.XRP.coinPrice
                            detail.changeRate = self.coin.data.XRP.changeRate
                        case "TRX":
                            detail.coinPrice = self.coin.data.TRX.coinPrice
                            detail.changeRate = self.coin.data.TRX.changeRate
                        default:
                            break
                        }
                        sum += Int((Double(detail.coinPrice) ?? 0) * detail.coinAmount)
                    }
                    asset.assetsSum = sum
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
        //self.sections.remove(at: indexPath.section)
        self.sections[indexPath.section] = ""
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
        
        cell.layer.masksToBounds = false
        cell.layer.shadowOpacity = 0.8
        cell.layer.shadowOffset = CGSize(width: -2, height: 2)
        cell.layer.shadowRadius = 3
        
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
        
        viewController.title = self.totalAsset[indexPath.section][indexPath.row].categoryName
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
            let alert = UIAlertController(title: "삭제", message: "정말로 삭제하시겠습니까?", preferredStyle: .alert)
            let registerButton = UIAlertAction(title: "삭제", style: .default, handler: {[weak self] _ in
                self?.removeCell(at: indexPath, to: tableView)
                self?.tableView.reloadData()
            })
            registerButton.setValue(UIColor.red, forKey: "titleTextColor")
            
            let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(cancelButton)
            alert.addAction(registerButton)
            self.present(alert, animated: true, completion: nil)
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
            switch asset.categoryValue {
            case 0:
                self.sections[0] = "거래소"
            case 1:
                self.sections[1] = "지갑"
            case 2:
                self.sections[2] = "기타"
            default:
                break
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
                if self.totalAsset[indexPath.section].isEmpty {
                    //self.sections.remove(at: indexPath.section)
                    self.sections[indexPath.section] = ""
                }
            }
        }
        
        self.tableView.reloadData()
    }
}
