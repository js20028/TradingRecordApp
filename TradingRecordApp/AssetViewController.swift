//
//  AssetViewController.swift
//  TradingRecordApp
//
//  Created by 곽재선 on 2022/10/05.
//

import UIKit

class AssetViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    var exchanges: [String] = ["빗썸","바이낸스","업비트"]
    var wallets: [String] = ["메타마스크", "카이카스"]
    var sections: [String] = ["거래소", "지갑", "기타"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
}

extension AssetViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
}
