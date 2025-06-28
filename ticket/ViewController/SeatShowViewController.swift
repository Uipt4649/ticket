//
//  SeatShowViewController.swift
//  ticket
//
//  Created by 渡邉羽唯 on 2025/04/27.
//

import UIKit

class SeatShowViewController: UIViewController {
    
    @IBOutlet var doorImageViewFront: UIImageView!
    @IBOutlet var doorImageViewBack: UIImageView!
    
    var seatMatrix: Seat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if seatMatrix.column <= threshold(line: seatMatrix.line) {
            //前のドアを赤く
            doorImageViewFront.tintColor = .red
            doorImageViewBack.tintColor = .clear //後ろはもとの色にもどす
        } else {
            //後ろのドアを赤く
            doorImageViewBack.tintColor = .red
            doorImageViewFront.tintColor = .clear  //前はもとの色にもどす
        }
    }
    
    @IBAction func completionButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func threshold(line: Seat.Line) -> Int {
        switch line {
        case .A:
            return 12
        case .B:
            return 12
        case .C:
            return 12
        case .D, .E, .F, .G, .H, .I, .J, .K, .L, .M, .N, .O:
            return 12
        case .P:
            return 10
        }
    }
}

struct Seat {
    let line: Line
    let column: Int

    enum Line {
        case A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P
    }
}

