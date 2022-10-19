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
    
    @IBAction func tapEditButton(_ sender: UIButton) {
    }
    @IBAction func tapDeleteButton(_ sender: UIButton) {
        guard let indexPath = self.indexPath else { return }
        self.delegate?.didSelectDelete(indexPath: indexPath)
        self.navigationController?.popViewController(animated: true)
    }
}
