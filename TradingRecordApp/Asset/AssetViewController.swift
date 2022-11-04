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
    
    
    var totalAsset = [[Asset](), [Asset](), [Asset]()]
    
//    var exchanges: [Asset] = []
//    var wallets: [Asset] = []
//    var others: [Asset] = []
    var sections: [String] = ["거래소", "지갑", "기타"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let addAssetViewController = segue.destination as? AddAssetViewController else { return }
        addAssetViewController.delegate = self
        addAssetViewController.totalAsset = self.totalAsset
        
    }
    
//    private func makeTotalAsset() -> [[Asset]]{
//        let totalAsset = [self.exchanges, self.wallets, self.others]
//        return totalAsset
//    }
}

extension AssetViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "AssetListCell", for: indexPath) as? AssetListCell else { return UITableViewCell() }
        
        cell.assetNameLabel.text = self.totalAsset[indexPath.section][indexPath.row].categoryName
        
//        switch indexPath.section {
//        case 0:
//            cell.assetNameLabel.text = self.exchanges[indexPath.row].categoryName
//        case 1:
//            cell.assetNameLabel.text = self.wallets[indexPath.row].categoryName
//        case 2:
//            cell.assetNameLabel.text = self.others[indexPath.row].categoryName
//        default:
//            break
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return self.totalAsset[0].count
        case 1:
            return self.totalAsset[1].count
        case 2:
            return self.totalAsset[2].count
        default:
            return 0
        }
        
//        switch section {
//        case 0:
//            return self.exchanges.count
//        case 1:
//            return self.wallets.count
//        case 2:
//            return self.others.count
//        default:
//            return 0
//        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "AssetDetailViewController") as? AssetDetailViewController else { return }
        
        viewController.assetDetailList = self.totalAsset[indexPath.section][indexPath.row].assets
        
//        switch indexPath.section {
//        case 0:
//            viewController.assetDetailList = self.exchanges[indexPath.row].assets
//        case 1:
//            viewController.assetDetailList = self.wallets[indexPath.row].assets
//        case 2:
//            viewController.assetDetailList = self.others[indexPath.row].assets
//        default:
//            break
//        }
        
//        self.show(viewController, sender: nil)
//        self.performSegue(withIdentifier: "showAssetDetail", sender: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
    }
}

extension AssetViewController: AddAssetDelegate {
    func didSelectAdd(asset: Asset, isNew: Bool, index: Int) {
        
        if isNew {
            self.totalAsset[asset.categoryValue].append(asset)
        } else {
            self.totalAsset[asset.categoryValue][index] = asset
        }
        
        
        
//        switch asset.categoryValue {
//        case 0:
//            self.exchanges.append(asset)
//        case 1:
//            self.wallets.append(asset)
//        case 2:
//            self.others.append(asset)
//        default:
//            break
//        }
        
        self.tableView.reloadData()
    }
}
