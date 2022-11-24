//
//  AddAssetViewController.swift
//  TradingRecordApp
//
//  Created by 곽재선 on 2022/10/26.
//

import UIKit
import RealmSwift

protocol AddAssetDelegate: AnyObject {
    func didSelectAdd(asset: Asset, isNew: Bool, index: Int)
}

class AddAssetViewController: UIViewController {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var exchangeButton: UIButton!
    @IBOutlet weak var walletButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    
    @IBOutlet weak var categoryNameTextField: UITextField!
    @IBOutlet weak var coinNameTextField: UITextField!
    @IBOutlet weak var coinAmountTextField: UITextField!
    
    weak var delegate: AddAssetDelegate?
    var categoryButtonValue: Int = 0
    var coin: Coin!
    var totalAsset: [[Asset]]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addButton.isEnabled = false
        self.configureView()
        self.configureInputField()
        
        self.getCoinData()
        
        guard let totalAsset = totalAsset else { return }
        print(totalAsset)

    }
    
    private func configureView() {
        self.changeCategoryButton(value: self.categoryButtonValue)
    }
    
    private func configureInputField() {
        self.categoryNameTextField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
        self.coinNameTextField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
        self.coinAmountTextField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
    }
    
    @objc private func textFieldDidChanged(_ textField: UITextField) {
        self.validateInputField()
    }
    
    private func validateInputField() {
        self.addButton.isEnabled = !(self.categoryNameTextField.text?.isEmpty ?? true) && !(self.coinNameTextField.text?.isEmpty ?? true) && !(self.coinAmountTextField.text?.isEmpty ?? true)
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
        }.resume()
    }
    
    private func matchCoinInfoDetail(coinName: String, coin: Coin) -> CoinInfo {
        switch coinName.uppercased() {
        case "이더리움", "ETH":
            return coin.data.ETH
        case "클레이튼", "KLAY":
            return coin.data.KLAY
        case "폴리곤", "MATIC":
            return coin.data.MATIC
        case "솔라나", "SOL":
            return coin.data.SOL
        default:
            return coin.data.ETH
        }
    }
    
    @IBAction func tapAddButton(_ sender: UIBarButtonItem) {
        guard let categoryName = self.categoryNameTextField.text else { return }
        guard let coinName = self.coinNameTextField.text else { return }
        guard let coinAmount = Double(self.coinAmountTextField.text ?? "0") else { return }
        
        guard let totalAsset = totalAsset else { return }
        
        let coinInfo = self.matchCoinInfoDetail(coinName: coinName, coin: self.coin)
        
//        let assetDetail = AssetDetail(coinName: coinName, coinAmount: coinAmount, coinInfo: self.matchCoinInfoDetail(coinName: coinName, coin: self.coin))
        let assetDetail = AssetDetail(value: ["coinName": coinName, "coinAmount": coinAmount, "coinPrice": coinInfo.coinPrice, "changeRate": coinInfo.changeRate])
        
        let findValue = self.findAssetCategory(categoryName: categoryName, categoryValue: self.categoryButtonValue)
        
        if findValue != -1 {
//            let sum = Int(coinAmount * Double(assetDetail.coinInfo.coinPrice)!)
            let sum = Int(coinAmount * Double(assetDetail.coinPrice)!)
            
            let realm = try! Realm()
            try! realm.write {
                let asset = totalAsset[self.categoryButtonValue][findValue]
                asset.assets.append(assetDetail)
                asset.assetsSum += sum
                self.delegate?.didSelectAdd(asset: asset, isNew: false, index: findValue)
            }
            
            
        } else {
//            let sum = Int(coinAmount * Double(assetDetail.coinInfo.coinPrice)!)
            let sum = Int(coinAmount * Double(assetDetail.coinPrice)!)
            
//            let asset = Asset(categoryValue: self.categoryButtonValue, categoryName: categoryName, assetsSum: sum, assets: [assetDetail])
            let asset = Asset(value: ["categoryValue": self.categoryButtonValue, "categoryName": categoryName, "assetsSum": sum, "assets": [assetDetail]])
            
            self.delegate?.didSelectAdd(asset: asset, isNew: true, index: findValue)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapCategoryButton(_ sender: UIButton) {
        switch sender {
        case exchangeButton:
            self.changeCategoryButton(value: 0)
            self.categoryButtonValue = 0
        case walletButton:
            self.changeCategoryButton(value: 1)
            self.categoryButtonValue = 1
        case otherButton:
            self.changeCategoryButton(value: 2)
            self.categoryButtonValue = 2
        default:
            break
        }
    }
    
    private func changeCategoryButton(value: Int) {
        self.exchangeButton.alpha = value == 0 ? 1 : 0.2
        self.walletButton.alpha = value == 1 ? 1 : 0.2
        self.otherButton.alpha = value == 2 ? 1 : 0.2
    }
    
    private func findAssetCategory(categoryName: String, categoryValue: Int) -> Int {
        guard let totalAsset = self.totalAsset else { return -1 }
        
        for index in 0..<totalAsset[categoryValue].count {
            if totalAsset[categoryValue][index].categoryName == categoryName {
                return index
            }
        }
        return -1
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
