//
//  LotteryViewController.swift
//  ticket
//
//  Created by 渡邉羽唯 on 2025/02/16.
//

import UIKit

class LotteryViewController: UIViewController {
    @IBOutlet var name: UILabel!
    @IBOutlet var detail: UITextView!
    
    var event: EventModel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        name.text = event.name
        detail.text = event.detail
    }
    
    @IBAction func submit() {
        let lottery = LotteryModel(people_number: 3, event_id: event.id, device_id: "123")
        
        Task {
            do {
                try await supabase
                    .from("lottery")
                    .insert(lottery)
                    .execute()
            } catch {
                dump(error)
            }
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
