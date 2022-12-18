//
//  AddAssetPopUpViewController.swift
//  TradingRecordApp
//
//  Created by 곽재선 on 2022/11/06.
//

import UIKit
import DropDown

protocol AddAssetDetailPopupDelegate: AnyObject {
    func didSelectAddPopup(assetList: [AssetDetail])
}

class AddAssetPopUpViewController: UIViewController {

    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var coinNameTextField: UITextField!
    @IBOutlet weak var coinAmountTextField: UITextField!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var coinSelectButton: UIButton!
    @IBOutlet weak var coinPriceTextField: UITextField!
    @IBOutlet weak var coinPriceStackView: UIStackView!
    
    var assetDetailList = [AssetDetail]()
    weak var delegate: AddAssetDetailPopupDelegate?
    var coin: Coin!
    
    let dropDown = DropDown()
    let itemList = ["비트코인","이더리움","클레이튼", "폴리곤", "솔라나", "바이낸스코인", "리플", "트론", "직접입력"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addButton.isEnabled = false
        self.configureInputField()
        
        self.configureDropDownUI()
        self.setDropdown()
        
        self.getCoinData()
        
        self.popupView.layer.cornerRadius = 10
        
//        self.coinNameTextField.becomeFirstResponder()
        
    }
    
    private func configureInputField() {
        self.coinNameTextField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
        self.coinAmountTextField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
        self.coinPriceTextField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
    }
    
    @objc private func textFieldDidChanged(_ textField: UITextField) {
        // decimal 키보드일때 "." 의 중복 방지
        if textField.keyboardType.rawValue == 8 {
            if textField.text == "." {
                textField.text = "0."
            }
            if textField.text?.filter({ ($0) == "." }).count == 2 {
                textField.text?.removeLast()
            }
        }
        
        self.validateInputField()
    }
    
    private func validateInputField() {
        if self.coinPriceStackView.isHidden {
            self.addButton.isEnabled = !(self.coinNameTextField.text?.isEmpty ?? true) && !(self.coinAmountTextField.text?.isEmpty ?? true)
        } else {
            self.addButton.isEnabled = !(self.coinNameTextField.text?.isEmpty ?? true) && !(self.coinAmountTextField.text?.isEmpty ?? true) && !(self.coinPriceTextField.text?.isEmpty ?? true)
        }
    }
    
    private func configureDropDownUI() {
        // DropDown View의 배경
        DropDown.appearance().textColor = UIColor.black // 아이템 텍스트 색상
        DropDown.appearance().selectedTextColor = UIColor.red // 선택된 아이템 텍스트 색상
        DropDown.appearance().backgroundColor = UIColor.white // 아이템 팝업 배경 색상
        DropDown.appearance().selectionBackgroundColor = UIColor.lightGray // 선택한 아이템 배경 색상
        DropDown.appearance().setupCornerRadius(8)
        dropDown.dismissMode = .automatic // 팝업을 닫을 모드 설정
            
        self.coinNameTextField.placeholder = "코인을 선택하세요." // 힌트 텍스트
        self.coinNameTextField.isEnabled = false
    }
    
    private func setDropdown() {
        // dataSource로 ItemList를 연결
        dropDown.dataSource = itemList
        // anchorView를 통해 UI와 연결
        dropDown.anchorView = self.coinNameTextField
        
        // View를 갖리지 않고 View아래에 Item 팝업이 붙도록 설정
        dropDown.bottomOffset = CGPoint(x: 0, y: self.coinNameTextField.bounds.height)
        
        // Item 선택 시 처리
        dropDown.selectionAction = { [weak self] (index, item) in
            
            self!.coinSelectButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            
            //선택한 Item을 TextField에 넣어준다.
            if item == "직접입력" {
                self!.coinNameTextField.isEnabled = true
                self!.coinPriceStackView.isHidden = false
                self!.coinNameTextField.text = nil
                self!.coinNameTextField.placeholder = ""
                self!.coinNameTextField.becomeFirstResponder()
                self!.validateInputField()
                
            } else {
                self!.coinNameTextField.isEnabled = false
                self!.coinPriceStackView.isHidden = true
                self!.coinNameTextField.text = item
                self!.validateInputField()
//                self!.coinSelectButton.image = UIImage(systemName: "arrowtriangle.up.circle.fill")
            }
        }
        
        // 취소 시 처리
        dropDown.cancelAction = { [weak self] in
            //빈 화면 터치 시 DropDown이 사라지고 아이콘을 원래대로 변경
            self!.coinSelectButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        }
    }
    
    private func getCoinData() {
//        var run = true
        
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
            
//            run = false
            
        }.resume()
        
//        while run {
//            
//        }
    }
    
    private func matchCoinInfoDetail(coinName: String, coin: Coin) -> CoinInfo? {
        switch coinName.uppercased() {
        case "비트코인", "BTC":
            return coin.data.BTC
        case "이더리움", "ETH":
            return coin.data.ETH
        case "클레이튼", "KLAY":
            return coin.data.KLAY
        case "폴리곤", "MATIC":
            return coin.data.MATIC
        case "솔라나", "SOL":
            return coin.data.SOL
        case "바이낸스코인", "BNB":
            return coin.data.BNB
        case "리플", "XRP":
            return coin.data.XRP
        case "트론", "TRX":
            return coin.data.TRX
        default:
            return nil
        }
    }
    
    private func matchCoinSymbol(coinName: String) -> String {
        switch coinName.uppercased() {
        case "비트코인", "BTC":
            return "BTC"
        case "이더리움", "ETH":
            return "ETH"
        case "클레이튼", "KLAY":
            return "KLAY"
        case "폴리곤", "MATIC":
            return "MATIC"
        case "솔라나", "SOL":
            return "SOL"
        case "바이낸스코인", "BNB":
            return "BNB"
        case "리플", "XRP":
            return "XRP"
        case "트론", "TRX":
            return "TRX"
        default:
            return ""
        }
    }
    
    @IBAction func tapCoinSelectButton(_ sender: UIButton) {
        self.dropDown.show()
        self.coinSelectButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
    }
    
    @IBAction func tapCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func tapSaveButton(_ sender: UIButton) {
        guard let coinName = self.coinNameTextField.text else { return }
        guard let coinAmount = Double(self.coinAmountTextField.text ?? "0") else { return }
        
        let coinInfo = self.matchCoinInfoDetail(coinName: coinName, coin: self.coin)
        let coinSymbol = self.matchCoinSymbol(coinName: coinName)
        
        let assetDetail = AssetDetail(value: ["coinName": coinName, "coinSymbol": coinSymbol, "coinAmount": coinAmount, "coinPrice": coinInfo?.coinPrice ?? self.coinPriceTextField.text ?? "0", "changeRate": coinInfo?.changeRate ?? "0"])
        self.assetDetailList.append(assetDetail)
        
        self.delegate?.didSelectAddPopup(assetList: self.assetDetailList)
        self.dismiss(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
