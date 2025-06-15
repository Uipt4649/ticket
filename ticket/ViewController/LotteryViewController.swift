//
//  LotteryViewController.swift
//  ticket
//
//  Created by 渡邉羽唯 on 2025/02/16.
//

import UIKit
import SwiftUICore

class LotteryViewController: UIViewController, UITextFieldDelegate {
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
    
    @IBAction func completionButton() {
            self.dismiss(animated: true, completion: nil)
    }
    
    
//    @IBAction func submit() {
//        //let lottery = LotteryModel(people_number: peopleNumber, event_id: event.id, device_id: DeviceIDManager().deviceId)
//        
//        guard let eventId = event?.id else {
//            print("Error: event.id is nil")
//            return
//        }
//        let deviceId = DeviceIDManager().deviceId
//        
//        //guard let eventId = event?.id, let deviceId = DeviceIDManager().deviceId else {
//        //print("Error: event.id or deviceId is nil")
//        //return
//        //}
//        var text: String = ""
//        var _: String? = text
//        
//        let lottery = LotteryModel(people_number: peopleNumber, event_id: event.id, device_id:  DeviceIDManager().deviceId)
//        
//        
//        Task {
//            do {
//                try await supabase
//                    .from("lottery")
//                    .insert(lottery)
//                    .execute()
//            } catch {
//                dump(error)
//            }
//        }
//    }
    
    @IBAction func aleat(_ senter: Any) {
        //これはー最初のアラートだよー
        let alert = UIAlertController(title: "自由人数選択", message: "鑑賞人数入力してください", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: {(textField) -> Void in
            textField.delegate = self
        })
        
        
        //追加ボタン
        alert.addAction(UIAlertAction(title: "追加", style: .default, handler: { (action) in
            if let textFields = alert.textFields, let inputText = textFields.first?.text {
                print("入力されたテキスト")
                let _: String = String()
                
                if let peopleNumber = Int(inputText){
                    print(peopleNumber)
                }
            }
//            let action: String? = nil
//            guard action != nil else { return }
            self.showConfirmationAlert()
            
        })
        )
        

        
        //キャンセルボタン
        alert.addAction(
            UIAlertAction(
                title:"キャンセル",
                style: .cancel,
                handler: {(action) -> Void in
                    
                    
                })
        )
        //アラートが表示されるところにprint
        self.present(
            alert,
            animated: true,
            completion: {
                print("アラートが表示された")
            })
        
        //最初のアラートが追加を押されたら１つめのアラートを閉じて２つ目のアラートが出現
        self.present(alert, animated: true, completion: {
            print("人数選択アラートが表示された")
        })
    }
    
    
    var reservationAlert: UIAlertController!
    
    @IBAction func reservationAler(_ peopleNumber: Int) {
        
        
    }
    
    
    
    
    //ここから２つ目のアラートその他の時
    func showConfirmationAlert() {
        
        let reservationAlert = UIAlertController(title: "確認", message: "予約を確定しますか？", preferredStyle: .alert)
        
        //alert.addTextField(configurationHandler: {(textField) -> Void in
        //textField.delegate = self
        // })
        
        
        //Yesボタン
        reservationAlert.addAction(
            
            
            UIAlertAction(title: "Yes",style: .default,handler: { (action) in
                self.performSegue(withIdentifier: "ToNotificationSchedule", sender: nil)
            })
        )
        
        //Noボタン
        reservationAlert.addAction(
            UIAlertAction(
                title:"No",
                style: .cancel,
                handler: {(action) -> Void in
                    
                }
            )
        )
        //アラートが表示されるところにprint
        self.present(
            reservationAlert,
            animated: true,
            completion: {
                print("アラートが表示された")
            })
        
        
        func alert(_ msg:Int){
            print(msg)
        }
    }
}

