//
//  AssetViewController.swift
//  TradingRecordApp
//
//  Created by 곽재선 on 2022/10/05.
//

import UIKit

class AssetViewController: UIViewController {

    @IBOutlet weak var totalAssetWon: UILabel!
    @IBOutlet weak var totalAssetDollar: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    var exchanges: [String] = ["빗썸","바이낸스","업비트"]
    var wallets: [String] = ["메타마스크", "카이카스"]
    var others: [String] = ["기타1", "기타2", "기타3", "기타4", "기타5"]
    var sections: [String] = ["거래소", "지갑", "기타"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
}

extension AssetViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "AssetListCell", for: indexPath) as? AssetListCell else { return UITableViewCell() }
        
        switch indexPath.section {
        case 0:
            cell.assetNameLabel.text = self.exchanges[indexPath.row]
        case 1:
            cell.assetNameLabel.text = self.wallets[indexPath.row]
        case 2:
            cell.assetNameLabel.text = self.others[indexPath.row]
        default:
            cell.assetNameLabel.text = "없음"
            cell.holdingAssetLabel.text = "10000"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.exchanges.count
        case 1:
            return self.wallets.count
        case 2:
            return self.others.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
    }
}
