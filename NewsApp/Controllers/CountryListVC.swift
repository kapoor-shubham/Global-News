//
//  CountryListVC.swift
//  NewsApp
//
//  Created by Shubham Kapoor on 10/02/20.
//  Copyright © 2020 Shubham Kapoor. All rights reserved.
//

import UIKit

class CountryListVC: UIViewController {

    @IBOutlet weak var tableViewCountryList: UITableView!
    
    var countryList: [CountryList]?
    let viewModel = CountryListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryList = viewModel.getCountryList()
        tableViewCountryList.reloadData()
    }
}

extension CountryListVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryListTableCell") as! CountryListTableCell
        if let code = countryList?[indexPath.row].countryCode, let name = countryList?[indexPath.row].countryName {
            let atttibutedText = "\(viewModel.emoji(countryCode: code)) \(name)"
            cell.textLabel?.text = atttibutedText
        }
        cell.selectionStyle = .none
        return cell
    }
}

extension CountryListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let countryCode = countryList?[indexPath.row].countryCode {
            viewModel.getSpecificCountryNews(countryCode: countryCode)
        }
    }
}

class CountryListTableCell: UITableViewCell {
    
}
