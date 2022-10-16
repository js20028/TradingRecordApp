//
//  WriteMemoViewController.swift
//  TradingRecordApp
//
//  Created by 곽재선 on 2022/10/16.
//

import UIKit

class WriteMemoViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var confirmButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureContentsTextView()
        
    }
    
    private func configureContentsTextView() {
        let borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        self.contentsTextView.layer.borderColor = borderColor.cgColor
        self.contentsTextView.layer.borderWidth = 0.5
        self.contentsTextView.layer.cornerRadius = 5.0
    }
    
    @IBAction func tapConfirmButton(_ sender: UIBarButtonItem) {
        
    }
}
