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
        self.placeHolderSetting()
    }
    
    private func configureContentsTextView() {
        let borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        self.contentsTextView.layer.borderColor = borderColor.cgColor
        self.contentsTextView.layer.borderWidth = 0.5
        self.contentsTextView.layer.cornerRadius = 5.0
    }
    
    func placeHolderSetting() {
        self.contentsTextView.delegate = self
        self.contentsTextView.text = "내용을 입력하세요"
        self.contentsTextView.textColor = UIColor.lightGray
    }

    @IBAction func tapConfirmButton(_ sender: UIBarButtonItem) {
        
    }
}

extension WriteMemoViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            self.contentsTextView.text = "내용을 입력하세요"
            self.contentsTextView.textColor = UIColor.lightGray
        }
    }
}
