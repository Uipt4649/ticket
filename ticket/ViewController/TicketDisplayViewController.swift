//
//  TicketDisplayViewController.swift
//  ticket
//
//  Created by 渡邉羽唯 on 2025/04/27.
//

import UIKit

class TicketDisplayViewController: UIViewController {
    
    var lottery: ResultModel!
    
    @IBOutlet var performerLabel: UILabel!
    @IBOutlet var seatButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performerLabel.text = lottery.events?.name
        
        // 座席情報を安全にアンラップして表示
        if let seatCol = lottery.seat_col, let seatRow = lottery.seat_row,
           !seatCol.isEmpty, !seatRow.isEmpty {
            let firstCol = seatCol.first ?? ""
            let firstRow = seatRow.first ?? ""
            let lastCol = seatCol.last ?? ""
            let lastRow = seatRow.last ?? ""
            
            let seatText: String
            if firstCol == lastCol {
                // 同じ列の場合は A1-A5 のような形式
                seatText = "\(firstCol)\(firstRow)-\(lastRow)"
            } else {
                // 異なる列の場合は A1-B5 のような形式
                seatText = "\(firstCol)\(firstRow)-\(lastCol)\(lastRow)"
            }
            
            seatButton.setTitle(seatText, for: .normal)
            print("座席情報: \(seatText)")
        } else {
            // 座席情報が取得できない場合
            seatButton.setTitle("座席未確定", for: .normal)
            print("座席情報が取得できませんでした")
        }
    }
    
    @IBAction func seatButtonTapped(_ sender: UIButton) {
        // 座席ボタンが押された時の処理
        performSegue(withIdentifier: "toSeatShowView", sender: self)
    }
    
    @IBAction func backBUttom() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSeatShowView" {
            let vc = segue.destination as! SeatShowViewController
            
            // 座席データを適切に変換して渡す
            if let seatCol = lottery.seat_col, let seatRow = lottery.seat_row,
               !seatCol.isEmpty, !seatRow.isEmpty {
                let firstCol = seatCol.first ?? "A"
                let firstRow = seatRow.first ?? "1"
                
                // 列をSeat.Lineに変換
                let line: Seat.Line
                switch firstCol {
                case "A": line = .A
                case "B": line = .B
                case "C": line = .C
                case "D": line = .D
                case "E": line = .E
                case "F": line = .F
                case "G": line = .G
                case "H": line = .H
                case "I": line = .I
                case "J": line = .J
                case "K": line = .K
                case "L": line = .L
                case "M": line = .M
                case "N": line = .N
                case "O": line = .O
                case "P": line = .P
                default: line = .A
                }
                
                // 行をIntに変換
                let column = Int(firstRow) ?? 1
                
                vc.seatMatrix = Seat(line: line, column: column)
            }
        }
    }
    
}



