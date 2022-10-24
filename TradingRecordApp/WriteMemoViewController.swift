//
//  WriteMemoViewController.swift
//  TradingRecordApp
//
//  Created by 곽재선 on 2022/10/16.
//

import UIKit

enum MemoEditorMode {
    case new
    case edit(IndexPath, Memo)
}

protocol WriteMemoDelegate: AnyObject {
    func didSelectRegister(memo: Memo)
}

class WriteMemoViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var confirmButton: UIBarButtonItem!
    
    private var memoDate: Date?
    weak var delegate: WriteMemoDelegate?
    var memoEditorMode: MemoEditorMode = .new
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureContentsTextView()
        self.placeHolderSetting()
        self.confirmButton.isEnabled = false
        self.configureEditMode()
        self.configureInputField()
    }
    
    private func configureInputField() {
        self.contentsTextView.delegate = self
        self.titleTextField.addTarget(self, action: #selector(titleTextFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func configureEditMode() {
        switch self.memoEditorMode {
        case let .edit(_, memo):
            self.titleTextField.text = memo.title
            self.contentsTextView.text = memo.contents
            self.confirmButton.title = "수정"
            
        default:
            break
        }
    }
    
    private func configureContentsTextView() {
        let borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        self.contentsTextView.layer.borderColor = borderColor.cgColor
        self.contentsTextView.layer.borderWidth = 0.5
        self.contentsTextView.layer.cornerRadius = 5.0
    }
    
    @objc private func titleTextFieldDidChange(_ textField: UITextField) {
        self.validateInputField()
    }
    
    func placeHolderSetting() {
        self.contentsTextView.delegate = self
        self.contentsTextView.text = "내용을 입력하세요"
        self.contentsTextView.textColor = UIColor.lightGray
    }

    @IBAction func tapConfirmButton(_ sender: UIBarButtonItem) {
        guard let title = self.titleTextField.text else { return }
        guard let contents = self.contentsTextView.text else { return }
        let date = Date()
        let memo = Memo(title: title, contents: contents, date: date)
        
        switch self.memoEditorMode {
        case .new:
            self.delegate?.didSelectRegister(memo: memo)
            
        case let .edit(indexPath, _):
            NotificationCenter.default.post(
                name: NSNotification.Name("editMemo"),
                object: memo,
                userInfo: [
                    "indexPath.row": indexPath.row
                ]
            )
        }
        
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    private func validateInputField() {
        self.confirmButton.isEnabled = !(self.titleTextField.text?.isEmpty ?? true)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
