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
    
    @IBOutlet var numberlabel : UILabel!
    var peopleNumber : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        name.text = event.name
//        detail.text = event.detail
    }
    
    @IBAction func onePeopleButton () {
        peopleNumber = 1
        
    }
    @IBAction func twoPeopleButton () {
        peopleNumber = 2
       
    }
    @IBAction func threePeopleButton () {
        peopleNumber = 3
       
    }
    @IBAction func foruPeopleButton () {
        peopleNumber = 4
        
    }
    @IBAction func fivePeopleButton () {
        peopleNumber = 5
       
    }
    
    
    
    @IBAction func submit() {
        let lottery = LotteryModel(people_number: peopleNumber, event_id: event.id, device_id: DeviceIDManager().deviceId)
        
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
    
}
