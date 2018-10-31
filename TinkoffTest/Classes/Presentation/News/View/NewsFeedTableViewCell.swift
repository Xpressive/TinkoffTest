//
//  NewsFeedTableViewCell.swift
//  TinkoffTest
//
//  Created by Alexey Kuznetsov on 30.10.2018.
//  Copyright © 2018 Alexey Kuznetsov. All rights reserved.
//

import UIKit

final class NewsFeedTableViewCell: UITableViewCell, NewsFeedCellView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        clear()
    }
    
    
    // MARK: - CellView
    
    func display(date: Date) {
        let dateForm = DateFormatter()
        dateForm.dateStyle = .short
        dateLabel.text = dateForm.string(from: date)
    }
    
    func display(title: String) {
        titleLabel.text = title
    }
    
    func display(counter: Int) {
        counterLabel.text = "\(counter)"
    }
    
    
    // MARK: - Private
    
    private func configure() {
        titleLabel.textColor = .black
        counterLabel.textColor = .black
    }
    
    private func clear() {
        titleLabel.text = nil
        counterLabel.text = nil
    }
    
}
