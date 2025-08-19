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
    
    var peopleNumber : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("DEBUG: LotteryViewController viewDidLoad")
        print("DEBUG: event = \(event?.name ?? "nil")")
        
        // Do any additional setup after loading the view.
        if let event = self.event {
            name.text = event.name
            detail.text = event.detail
            print("DEBUG: UI updated with event name: \(event.name)")
        } else {
            print("DEBUG: event is nil, UI not updated")
        }
        
    }
    
    @IBAction func completionButton() {
            self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func aleat(_ senter: Any) {
        //これはー最初のアラートだよー
        let alert = UIAlertController(title: "自由人数選択", message: "鑑賞人数入力してください", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: {(textField) -> Void in
            textField.delegate = self
            textField.keyboardType = .numberPad
        })
        
        //追加ボタン
        alert.addAction(UIAlertAction(title: "追加", style: .default, handler: { (action) in
            if let textFields = alert.textFields, let inputText = textFields.first?.text {
                print("入力されたテキスト")
                
                if let peopleNumber = Int(inputText){
                    self.peopleNumber = peopleNumber
                    print(peopleNumber)
                }
            }
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
    }
    
    //ここから２つ目のアラートその他の時
    func showConfirmationAlert() {
        print("DEBUG: showConfirmationAlert called")
        print("DEBUG: self.event = \(self.event?.name ?? "nil")")
        
        // eventがnilの場合はエラーアラートを表示
        guard let event = self.event else {
            print("DEBUG: event is nil, showing error alert")
            let errorAlert = UIAlertController(title: "エラー", message: "イベント情報が取得できませんでした", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(errorAlert, animated: true, completion: nil)
            return
        }
        
        print("DEBUG: event is not nil, proceeding with confirmation")
        let reservationAlert = UIAlertController(title: "確認", message: "予約を確定しますか？", preferredStyle: .alert)
        //Yesボタン
        reservationAlert.addAction(
            UIAlertAction(title: "Yes",style: .default,handler: { (action) in
                let lottery = LotteryModel(people_number: self.peopleNumber, event_id: event.id, device_id:  DeviceIDManager().deviceId, seat_col: nil, seat_row: nil)
                
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
                //self.performSegue(withIdentifier: "ToNotificationSchedule", sender: nil)
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
    }
}

