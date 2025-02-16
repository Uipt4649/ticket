//
//  ViewController.swift
//  ticket
//
//  Created by 渡邉羽唯 on 2025/02/16.
//

import UIKit

class EventListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    var events: [EventModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        Task {
            do {
                events = try await supabase.from("events").select().execute().value
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
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = events[indexPath.row].name
        content.secondaryText = events[indexPath.row].detail
        cell.contentConfiguration = content
        return cell
    }
    
}

