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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.popupView.layer.cornerRadius = 10
        
        
    }
    
    @IBAction func tapCancelButton(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
    
    @IBAction func tapSaveButton(_ sender: UIButton) {
        guard let coinName = self.coinNameTextField.text else { return }
        guard let coinAmount = Double(self.coinAmountTextField.text ?? "0") else { return }
        
        let assetDetail = AssetDetail(coinName: coinName, coinAmount: coinAmount)
        self.assetDetailList.append(assetDetail)
        
        self.delegate?.didSelectAddPopup(assetList: self.assetDetailList)
        self.dismiss(animated: false)
    }
}
