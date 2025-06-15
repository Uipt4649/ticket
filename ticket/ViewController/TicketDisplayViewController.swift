//
//  TicketDisplayViewController.swift
//  ticket
//
//  Created by 渡邉羽唯 on 2025/04/27.
//

import UIKit

class TicketDisplayViewController: UIViewController {
    
    var lottery: ResultModel!
    var event: EventModel!
    
    @IBOutlet var performerLabel: UILabel!
    @IBOutlet var seatButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            do {
                event = try await supabase
                    .from("events")
                    .select()
                    .eq("id", value: lottery.event_id)
                    .execute()
                    .value
            } catch {
                dump(error)
            }
        }
        
        performerLabel.text = "\((lottery.seat_col?.first ?? "") + (lottery.seat_row?.first ?? ""))"
        seatButton.setTitle(for i in lottery.seat_col?.count {lottery.seat_col?[i] + lottery.seat_row?[i]}, for: .normal)
    }
    
    @IBAction func backBUttom() {
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
}



