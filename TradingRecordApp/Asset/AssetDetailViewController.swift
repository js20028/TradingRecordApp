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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let nibName = UINib(nibName: "AssetDetailListCell", bundle: nil)
        self.tableView.register(nibName, forCellReuseIdentifier: "AssetDetailListCell")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    @IBAction func tapAddAssetButton(_ sender: UIBarButtonItem) {
        guard let popupViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddAssetPopUpViewController") as? AddAssetPopUpViewController else { return }
        popupViewController.modalPresentationStyle = .overFullScreen
        popupViewController.assetDetailList = self.assetDetailList
        
        popupViewController.delegate = self
        
        self.present(popupViewController, animated: false, completion: nil)
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
