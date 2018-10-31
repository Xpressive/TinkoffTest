//
//  NewsFeedTableViewController.swift
//  TinkoffTest
//
//  Created by Alexey Kuznetsov on 30.10.2018.
//  Copyright © 2018 Alexey Kuznetsov. All rights reserved.
//

import UIKit

final class NewsFeedTableViewController: UITableViewController {
    
    
    var configurator = NewsFeedConfiguratorImpl()
    var presenter: NewsFeedPresenter!
    
    
    // MARK: - Constants
    
    private enum Constants {
        static let cellIdentifier = String(describing: NewsFeedTableViewCell.self)
    }
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(newsFeedTableViewController: self)
        configureUI()
        presenter.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.router.prepare(for: segue, sender: sender)
    }
    
    
    // MARK: - Private Methods
    
    private func configureUI() {
        self.navigationItem.title = "Тинькофф Новости"
        self.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(onPullToRefresh), for: .valueChanged)
        tableView.register(UINib(nibName: Constants.cellIdentifier, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
    }
    
    @objc private func onPullToRefresh() {
        self.refreshControl?.beginRefreshing()
        presenter.refreshTable()
    }
    
    
    // MARK: - Table view delegate/datasource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! NewsFeedTableViewCell
        presenter.configure(cell: cell, forRow: indexPath.row)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfNews
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            self.presenter.loadMoreNews()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? NewsFeedTableViewCell {
            presenter.didSelect(cell: cell, row: indexPath.row)
        }
    }
}

extension NewsFeedTableViewController: NewsFeedView {
    
    func updateView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
}
