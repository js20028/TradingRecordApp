//
//  MemoDetailViewController.swift
//  TradingRecordApp
//
//  Created by 곽재선 on 2022/10/19.
//

import UIKit

protocol MemoDetailViewDelegate: AnyObject {
    func didSelectDelete(indexPath: IndexPath)
}

class MemoDetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentsTextView: UITextView!
    
    weak var delegate: MemoDetailViewDelegate?
    
    var memo: Memo?
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        self.configureContentsTextView()
    }
    
    private func configureView() {
        guard let memo = self.memo else { return }
        self.titleLabel.text = memo.title
        self.contentsTextView.text = memo.contents
    }
    
    private func configureContentsTextView() {
        let borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        self.contentsTextView.layer.borderColor = borderColor.cgColor
        self.contentsTextView.layer.borderWidth = 0.5
        self.contentsTextView.layer.cornerRadius = 5.0
    }
    
    @objc func editMemoNotification(_ notification: Notification) {
        guard let memo = notification.object as? Memo else { return }
//        guard let row = notification.userInfo?["indexPath.row"] as? Int else { return }
        self.memo = memo
        self.configureView()
    }
    
    @IBAction func tapEditButton(_ sender: UIButton) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WriteMemoViewController") as? WriteMemoViewController else { return }
        guard let indexPath = self.indexPath else { return }
        guard let memo = self.memo else { return }
        viewController.memoEditorMode = .edit(indexPath, memo)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(editMemoNotification(_:)),
            name: NSNotification.Name("editMemo"),
            object: nil
        )
        
        self.navigationController?.pushViewController(viewController, animated: true)
                
    }
    
    @IBAction func tapDeleteButton(_ sender: UIButton) {
        
        guard let indexPath = self.indexPath else { return }
        
        let alert = UIAlertController(title: "삭제", message: "정말로 삭제하시겠습니까?", preferredStyle: .alert)
        let registerButton = UIAlertAction(title: "삭제", style: .default, handler: {[weak self] _ in
            self?.delegate?.didSelectDelete(indexPath: indexPath)
            self?.navigationController?.popViewController(animated: true)
        })
        registerButton.setValue(UIColor.red, forKey: "titleTextColor")
        
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancelButton)
        alert.addAction(registerButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
