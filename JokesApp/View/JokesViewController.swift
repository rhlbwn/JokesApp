//
//  ViewController.swift
//  JokesApp
//
//  Created by Rahul Bawane on 29/06/23.
//

import UIKit

class JokesViewController: UIViewController {

    let tableView = UITableView()
    var apiTimer = Timer()
    var displayTimer = Timer()
    var secondCounter = 0
    
    private let presenter = JokesPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(tableView)
        self.title = "Jokes"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        presenter.setViewDelegate(delegate: self)
        presenter.getLocalJokes()
        apiTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true, block: { _ in
            DispatchQueue.main.async {
                self.presenter.getJokes()
            }
        })
        secondCounter = 60
        displayTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.title = "New joke in: \(self.secondCounter)"
            self.secondCounter -= 1
            if self.secondCounter == 0 {
                self.secondCounter = 60
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        apiTimer.invalidate()
        displayTimer.invalidate()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

extension JokesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.presenter.getJoke(index: indexPath.row)
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.getRowCount()
    }
}

extension JokesViewController: JokesDelegate {    
    func reloadUI() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
