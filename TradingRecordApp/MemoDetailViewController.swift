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
    }
    
    private func configureView() {
        guard let memo = self.memo else { return }
        self.titleLabel.text = memo.title
        self.contentsTextView.text = memo.contents
    }
    
    @objc func editMemoNotification(_ notification: Notification) {
        guard let memo = notification.object as? Memo else { return }
        guard let row = notification.userInfo?["indexPath.row"] as? Int else { return }
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
        self.delegate?.didSelectDelete(indexPath: indexPath)
        self.navigationController?.popViewController(animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
