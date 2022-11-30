//
//  AssetDetailViewController.swift
//  TradingRecordApp
//
//  Created by 곽재선 on 2022/10/28.
//

import UIKit
import RealmSwift

protocol AssetDetailDelegate: AnyObject {
    func sendAssetDetail(assetDetailList: [AssetDetail], indexPath: IndexPath, sum: Int)
}

class AssetDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var assetDetailList = [AssetDetail]()
    var indexPath: IndexPath?
    weak var delegate: AssetDetailDelegate?
    
    let refreshCon = UIRefreshControl()
    var coin: Coin!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let nibName = UINib(nibName: "AssetDetailListCell", bundle: nil)
        self.tableView.register(nibName, forCellReuseIdentifier: "AssetDetailListCell")
        self.getCoinData()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.initRefresh()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "보유 자산 상세"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let indexPath = self.indexPath else { return }
        
        let assetSum = self.makeAssetSum()

        self.delegate?.sendAssetDetail(assetDetailList: self.assetDetailList, indexPath: indexPath, sum: assetSum)
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    @IBAction func tapAddAssetButton(_ sender: UIBarButtonItem) {
        guard let popupViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddAssetPopUpViewController") as? AddAssetPopUpViewController else { return }
        popupViewController.modalPresentationStyle = .overFullScreen
        popupViewController.assetDetailList = self.assetDetailList
        
        popupViewController.delegate = self
        
        self.present(popupViewController, animated: false, completion: nil)
    }
    
    private func makeAssetSum() -> Int {
        var sum: Double = 0
        for assetDetail in self.assetDetailList {
            sum += assetDetail.coinAmount * (Double(assetDetail.coinPrice) ?? 0)
        }
        
        return Int(sum)
    }
    
    // 문자열 일부분 색상 변경 함수
    private func changeRatingColor(rating: String) -> NSMutableAttributedString {
        let ratingString = "전일대비 \(rating)%"
        let attributedString = NSMutableAttributedString(string: ratingString)
        attributedString.addAttributes([.foregroundColor: UIColor.red],
                                       range: NSRange(location: 5, length: attributedString.length - 5))
        
        if Double(rating)! >= 0 {
            attributedString.addAttributes([.foregroundColor: UIColor.red],
                                           range: NSRange(location: 5, length: attributedString.length - 5))
        } else {
            attributedString.addAttributes([.foregroundColor: UIColor.blue],
                                           range: NSRange(location: 5, length: attributedString.length - 5))
        }
        
        return attributedString
    }
    
    private func removeCell(at indexPath: IndexPath, to tableView: UITableView) {
        guard let indexPathFromVC = self.indexPath else { return }
        let realm = try! Realm()
        let savedAsset = realm.objects(AssetCategory.self)
        try! realm.write {
            realm.delete(savedAsset[indexPathFromVC.section].assetList[indexPathFromVC.row].assets[indexPath.row])
        }
        
        self.assetDetailList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
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
            print(self.coin!)
            
        }.resume()
    }
    
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
            let realm = try! Realm()
            try! realm.write {
                for asset in self.assetDetailList {
                    switch asset.coinSymbol {
                    case "ETH":
                        asset.coinPrice = self.coin.data.ETH.coinPrice
                        asset.changeRate = self.coin.data.ETH.changeRate
                    case "KLAY":
                        asset.coinPrice = self.coin.data.KLAY.coinPrice
                        asset.changeRate = self.coin.data.KLAY.changeRate
                    case "MATIC":
                        asset.coinPrice = self.coin.data.MATIC.coinPrice
                        asset.changeRate = self.coin.data.MATIC.changeRate
                    case "SOL":
                        asset.coinPrice = self.coin.data.SOL.coinPrice
                        asset.changeRate = self.coin.data.SOL.changeRate
                    default:
                        break
                    }
                }
            }
            self.tableView.reloadData()
            refresh.endRefreshing()
        }
    }
}

extension AssetDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.assetDetailList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "AssetDetailListCell") as? AssetDetailListCell else { return UITableViewCell() }
        
        let coinPriceDouble = Double(self.assetDetailList[indexPath.row].coinPrice)
        let evalPrice = Int(self.assetDetailList[indexPath.row].coinAmount * coinPriceDouble!)
        
        cell.coinNameDetail.text = self.assetDetailList[indexPath.row].coinName
        cell.coinSymbolDetail.text = self.assetDetailList[indexPath.row].coinSymbol
        
        cell.coinPriceDetail.text = "\(self.assetDetailList[indexPath.row].coinPrice) 원"
        cell.changeRateDetail.attributedText = self.changeRatingColor(rating: self.assetDetailList[indexPath.row].changeRate)
        
        cell.coinAmountDetail.text = "\(self.assetDetailList[indexPath.row].coinAmount) \(self.assetDetailList[indexPath.row].coinSymbol)"
        cell.evaluatedPrice.text = "\(evalPrice) 원"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.removeCell(at: indexPath, to: tableView)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}

extension AssetDetailViewController: AddAssetDetailPopupDelegate {
    func didSelectAddPopup(assetList: [AssetDetail]) {
        
        self.assetDetailList = assetList
        self.tableView.reloadData()
    }
}
