//
//  AddAssetViewController.swift
//  TradingRecordApp
//
//  Created by 곽재선 on 2022/10/26.
//

import UIKit

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
    
    var totalAsset: [[Asset]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addButton.isEnabled = false
        self.configureView()
        self.configureInputField()
        
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
    
    @IBAction func tapAddButton(_ sender: UIBarButtonItem) {
        guard let categoryName = self.categoryNameTextField.text else { return }
        guard let coinName = self.coinNameTextField.text else { return }
        guard let coinAmount = Double(self.coinAmountTextField.text ?? "0") else { return }
        guard let totalAsset = totalAsset else { return }
        
        let assetDetail = AssetDetail(coinName: coinName, coinAmount: coinAmount)
        
        let findValue = self.findAssetCategory(categoryName: categoryName, categoryValue: self.categoryButtonValue)
        
        if findValue != -1 {
            var asset = totalAsset[self.categoryButtonValue][findValue]
            asset.assets.append(assetDetail)
            self.delegate?.didSelectAdd(asset: asset, isNew: false, index: findValue)
            
        } else {
            let asset = Asset(categoryValue: self.categoryButtonValue, categoryName: categoryName, assets: [assetDetail])
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
