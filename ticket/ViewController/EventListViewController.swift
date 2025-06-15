//
//  ViewController.swift
//  ticket
//
//  Created by 渡邉羽唯 on 2025/02/16.
//

import UIKit

class EventListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    var events: [EventModel] = []
    var searchResults:[EventModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self

        
        Task {
            do {
                events = try await supabase
                    .from("events")
                    .select()
                    .execute().value
                tableView.reloadData()
            } catch {
                dump(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLotteryView" {
            let row = tableView.indexPathForSelectedRow?.row
            let vc = segue.destination as! LotteryViewController
            vc.event = events[row!]
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBar.text != "" {
            return searchResults.count
        } else {
            return events.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
        )
        var content = cell.defaultContentConfiguration()
        if searchBar.text != "" {
            content.text = searchResults[indexPath.row].name
            content.secondaryText = searchResults[indexPath.row].detail
        } else {
            content.text = events[indexPath.row].name
            content.secondaryText = events[indexPath.row].detail
        }

        cell.contentConfiguration = content
        return cell
    }
    
    // 検索ボタンが押された時に呼ばれる
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        searchBar.showsCancelButton = true
        self.searchResults = events.filter{
            // 大文字と小文字を区別せずに検索
            $0.name.lowercased().contains(searchBar.text!.lowercased())
        }
        self.tableView.reloadData()
    }
    
    // キャンセルボタンが押された時に呼ばれる
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        self.view.endEditing(true)
        searchBar.text = ""
        self.tableView.reloadData()
    }
        
    
    // テキストフィールド入力開始前に呼ばれる
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
}

