//
//  ResultViewController.swift
//  ticket
//
//  Created by 渡邉羽唯 on 2025/05/18.
//

import UIKit

class ResultViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet var tableView: UITableView!
    var results: [ResultModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        Task {
            do {
                results = try await
                supabase.from("lottery")
                    .select()
                    .eq("device_id", value: DeviceIDManager().deviceId)
                    .execute()
                    .value
                tableView.reloadData()
            } catch {
                dump(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWinView" {
            let row = tableView.indexPathForSelectedRow?.row
            let vc = segue.destination as! TicketDisplayViewController
            vc.lottery = results[row!]
        }
        if segue.identifier == "toFalseView" {
            let row = tableView.indexPathForSelectedRow?.row
            let vc = segue.destination as! LoseViewController
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if results[indexPath.row].is_win {
            // 当選の時
            performSegue(withIdentifier: "toWinView", sender: self)
        } else {
            //落選の時
            performSegue(withIdentifier: "toFalseView", sender: self)
        }
    }
        
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return results.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell: UITableViewCell =
            tableView
                .dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            var content =
            cell.defaultContentConfiguration()
            content.text =
            results[indexPath.row].device_id
            content.secondaryText = String(results[indexPath.row].is_win)
            cell.contentConfiguration = content
            return cell
        }
    }
