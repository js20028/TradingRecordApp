//
//  AssetDetailViewController.swift
//  TradingRecordApp
//
//  Created by 곽재선 on 2022/10/28.
//

import UIKit

class AssetDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var assetDetailList = [AssetDetail]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let nibName = UINib(nibName: "AssetDetailListCell", bundle: nil)
        self.tableView.register(nibName, forCellReuseIdentifier: "AssetDetailListCell")
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    @IBAction func tapAddAssetButton(_ sender: UIBarButtonItem) {
        guard let popupViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddAssetPopUpViewController") as? AddAssetPopUpViewController else { return }
        popupViewController.modalPresentationStyle = .overFullScreen
        popupViewController.assetDetailList = self.assetDetailList
        
        popupViewController.delegate = self
        
        self.present(popupViewController, animated: false, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "보유 자산 상세"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
}

extension AssetDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.assetDetailList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "AssetDetailListCell") as? AssetDetailListCell else { return UITableViewCell() }
        cell.coinNameDetail.text = self.assetDetailList[indexPath.row].coinName
        cell.coinAmountDetail.text = String(self.assetDetailList[indexPath.row].coinAmount)
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}

extension AssetDetailViewController: AddAssetDetailPopupDelegate {
    func didSelectAddPopup(assetList: [AssetDetail]) {
        self.assetDetailList = assetList
        self.tableView.reloadData()
    }
}
