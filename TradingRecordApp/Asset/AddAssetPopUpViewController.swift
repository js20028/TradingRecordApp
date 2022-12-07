//
//  AddAssetPopUpViewController.swift
//  TradingRecordApp
//
//  Created by 곽재선 on 2022/11/06.
//

import UIKit

protocol AddAssetDetailPopupDelegate: AnyObject {
    func didSelectAddPopup(assetList: [AssetDetail])
}

class AddAssetPopUpViewController: UIViewController {

    @IBOutlet weak var coinNameTextField: UITextField!
    @IBOutlet weak var coinAmountTextField: UITextField!
    @IBOutlet weak var popupView: UIView!
    
    var assetDetailList = [AssetDetail]()
    weak var delegate: AddAssetDetailPopupDelegate?
    var coin: Coin!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getCoinData()
        
        self.popupView.layer.cornerRadius = 10
        
        
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
    
    private func matchCoinSymbol(coinName: String) -> String {
        switch coinName.uppercased() {
        case "이더리움", "ETH":
            return "ETH"
        case "클레이튼", "KLAY":
            return "KLAY"
        case "폴리곤", "MATIC":
            return "MATIC"
        case "솔라나", "SOL":
            return "SOL"
        default:
            return "ETH"
        }
    }
    
    @IBAction func tapCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func tapSaveButton(_ sender: UIButton) {
        guard let coinName = self.coinNameTextField.text else { return }
        guard let coinAmount = Double(self.coinAmountTextField.text ?? "0") else { return }
        
        let coinInfo = self.matchCoinInfoDetail(coinName: coinName, coin: self.coin)
        let coinSymbol = self.matchCoinSymbol(coinName: coinName)
        
        //--------------------------------------------------------------------------------
        
//        let assetDetail = AssetDetail(coinName: coinName, coinAmount: coinAmount, coinInfo: self.matchCoinInfoDetail(coinName: coinName, coin: self.coin))
        let assetDetail = AssetDetail(value: ["coinName": coinName, "coinSymbol": coinSymbol, "coinAmount": coinAmount, "coinPrice": coinInfo.coinPrice, "changeRate": coinInfo.changeRate])
        self.assetDetailList.append(assetDetail)
        
        self.delegate?.didSelectAddPopup(assetList: self.assetDetailList)
        self.dismiss(animated: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
