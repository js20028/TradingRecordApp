//
//  AddAssetViewController.swift
//  TradingRecordApp
//
//  Created by 곽재선 on 2022/10/26.
//

import UIKit

protocol AddAssetDelegate: AnyObject {
    func didSelectAdd(asset: Asset)
}

class AddAssetViewController: UIViewController {
    
    @IBOutlet weak var exchangeButton: UIButton!
    @IBOutlet weak var walletButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    
    @IBOutlet weak var categoryNameTextField: UITextField!
    @IBOutlet weak var coinNameTextField: UITextField!
    @IBOutlet weak var coinAmountTextField: UITextField!
    
    var categoryButtonValue: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    func configureView() {
        self.changeCategoryButton(value: self.categoryButtonValue)
    }
    
    @IBAction func tapAddButton(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func tapCategoryButton(_ sender: UIButton) {
        switch sender {
        case exchangeButton:
            self.changeCategoryButton(value: 0)
        case walletButton:
            self.changeCategoryButton(value: 1)
        case otherButton:
            self.changeCategoryButton(value: 2)
        default:
            break
        }
    }
    
    func changeCategoryButton(value: Int) {
        self.exchangeButton.alpha = value == 0 ? 1 : 0.2
        self.walletButton.alpha = value == 1 ? 1 : 0.2
        self.otherButton.alpha = value == 2 ? 1 : 0.2
    }
}
