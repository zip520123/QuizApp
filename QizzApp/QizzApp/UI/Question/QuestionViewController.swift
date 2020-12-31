//
//  QuestionViewController.swift
//  QizzApp
//
//  Created by zip520123 on 13/11/2020.
//  Copyright © 2020 zip520123. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerLabel: UILabel!
    private(set) var question : String = ""
    private(set) var options: [String] = []
    private(set) var allowsMultipleSelection = false
    private var selection: (([String])-> Void)?
    private let reuseIdentifier = "Cell"
    
    convenience init(question: String, options: [String], allowsMultipleSelection: Bool, selection: @escaping (([String])->Void)) {
        self.init()
        self.question = question
        self.options = options
        self.selection = selection
        self.allowsMultipleSelection = allowsMultipleSelection
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerLabel.text = question
        tableView.allowsMultipleSelection = allowsMultipleSelection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueCell(in: tableView)
        cell.textLabel?.text = options[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selection?(selectOptions(in: tableView))
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.allowsMultipleSelection {
            selection?(selectOptions(in: tableView))
        }
        
    }
    
    private func selectOptions(in tableView: UITableView) -> [String] {
        guard let indexPaths = tableView.indexPathsForSelectedRows else {return []}
        
        return indexPaths.map{options[$0.row]}
    }
    
    private func dequeueCell(in tableView: UITableView) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) {
            return cell
        }
        return UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
    }
}
