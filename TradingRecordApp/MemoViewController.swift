//
//  MemoViewController.swift
//  TradingRecordApp
//
//  Created by 곽재선 on 2022/09/27.
//

import UIKit

class MemoViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var memoList = [Memo]() {
        didSet {
            self.saveMemoList()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        self.loadMemoList()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(editMemoNotification(_:)),
            name: NSNotification.Name("editMemo"),
            object: nil
        )
    }
    
    private func configureCollectionView() {
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    @objc func editMemoNotification(_ notification: Notification) {
        guard let memo = notification.object as? Memo else { return }
        guard let row = notification.userInfo?["indexPath.row"] as? Int else { return }
        self.memoList[row] = memo
        self.memoList = self.memoList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
        self.collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let writeMemoViewController = segue.destination as? WriteMemoViewController {
            writeMemoViewController.delegate = self
        }
    }
    
    private func saveMemoList() {
        let data = self.memoList.map {
            [
                "title": $0.title,
                "contents": $0.contents,
                "date": $0.date
            ]
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "memoList")
    }
    
    private func loadMemoList() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "memoList") as? [[String: Any]] else { return }
        self.memoList = data.compactMap {
            guard let title = $0["title"] as? String else { return nil }
            guard let contents = $0["contents"] as? String else { return nil }
            guard let date = $0["date"] as? Date else { return nil}
            return Memo(title: title, contents: contents, date: date)
        }
        self.memoList = self.memoList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
    }
}

extension MemoViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memoList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemoCell", for: indexPath) as? MemoCell else { return UICollectionViewCell() }
        
        let memo = self.memoList[indexPath.row]
        cell.titleLabel.text = memo.title
        cell.contentsLabel.text = memo.contents
        
        return cell
    }
}

extension MemoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MemoDetailViewController") as? MemoDetailViewController else { return }
        let memo = self.memoList[indexPath.row]
        viewController.memo = memo
        viewController.indexPath = indexPath
        viewController.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
     }
}

extension MemoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width / 2) - 20, height: 200)
    }
}

extension MemoViewController: WriteMemoDelegate {
    func didSelectEdit(indexPath: IndexPath, memo: Memo) {
        
    }
    
    func didSelectRegister(memo: Memo) {
        self.memoList.append(memo)
        self.memoList = self.memoList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
        self.collectionView.reloadData()
    }
}

extension MemoViewController: MemoDetailViewDelegate {
    func didSelectDelete(indexPath: IndexPath) {
        self.memoList.remove(at: indexPath.row)
        self.collectionView.deleteItems(at: [indexPath])
    }
}
