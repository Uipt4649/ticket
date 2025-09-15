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
        
        let deviceId = UIDevice.current.identifierForVendor!.uuidString
        print(deviceId)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        Task {
            do {
                let results: [ResultModel] = try await supabase.from("lottery")
                    .select("*, events(id, name, detail, event_start_date, event_open_date, event_closing_date, image_url)")
                    .eq("device_id", value: DeviceIDManager().deviceId)
                    .execute()
                    .value
                self.results = results
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
            let _ = tableView.indexPathForSelectedRow?.row
            let _ = segue.destination as! LoseViewController
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if results[indexPath.row].is_win {
            // 当選の時
            performSegue(withIdentifier: "toWinView", sender: self)
        } else {
            // 落選の時
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
            content.text = results[indexPath.row].events?.name ?? "イベント名なし"
            cell.contentConfiguration = content
            return cell
        }
    }
