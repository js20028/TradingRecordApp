//
//  AssetDetailViewController.swift
//  TradingRecordApp
//
//  Created by 곽재선 on 2022/10/28.
//

import UIKit

class AssetDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var assetDetailList = [Asset]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "보유 자산 상세"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
}

//extension AssetDetailViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        self.assetDetailList.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//    }
//
//
//}
