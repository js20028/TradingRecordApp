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
    
    
    
    var exchanges: [Asset] = []
    var wallets: [Asset] = []
    var others: [Asset] = []
    var sections: [String] = ["거래소", "지갑", "기타"]
//    var wallets: [String] = ["메타마스크", "카이카스"]
//    var others: [String] = ["기타1", "기타2", "기타3", "기타4", "기타5"]
//    var sections: [String] = ["거래소", "지갑", "기타"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let addAssetViewController = segue.destination as? AddAssetViewController else { return }
        addAssetViewController.delegate = self
    }
    
//    func makeSelectedAssetList(selectedList: [Asset], categoryName: String) -> [Asset] {
//        for asset in selectedList {
//
//        }
//    }
}

extension AssetViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "AssetListCell", for: indexPath) as? AssetListCell else { return UITableViewCell() }
        
        switch indexPath.section {
        case 0:
            cell.assetNameLabel.text = self.exchanges[indexPath.row].categoryName
        case 1:
            cell.assetNameLabel.text = self.wallets[indexPath.row].categoryName
        case 2:
            cell.assetNameLabel.text = self.others[indexPath.row].categoryName
        default:
            break
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "AssetDetailViewController") as? AssetDetailViewController else { return }
        
        switch indexPath.section {
        case 0:
            viewController.assetDetailList = self.exchanges[indexPath.row].assets
        case 1:
            viewController.assetDetailList = self.wallets[indexPath.row].assets
        case 2:
            viewController.assetDetailList = self.others[indexPath.row].assets
        default:
            break
        }
        
        self.performSegue(withIdentifier: "showAssetDetail", sender: nil)
//        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
    }
}

extension AssetViewController: AddAssetDelegate {
    func didSelectAdd(asset: Asset) {
        
        switch asset.categoryValue {
        case 0:
            self.exchanges.append(asset)
        case 1:
            self.wallets.append(asset)
        case 2:
            self.others.append(asset)
        default:
            break
        }
        
        self.tableView.reloadData()
    }
}
