//
//  AddAssetPopUpViewController.swift
//  TradingRecordApp
//
//  Created by 곽재선 on 2022/11/06.
//

import UIKit

class AddAssetPopUpViewController: UIViewController {

    @IBOutlet weak var coinNameTextField: UITextField!
    @IBOutlet weak var coinAmountTextField: UITextField!
    @IBOutlet weak var popupView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.popupView.layer.cornerRadius = 10
        
        
    }
    @IBAction func tapCancelButton(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
    @IBAction func tapSaveButton(_ sender: UIButton) {
    }
}
