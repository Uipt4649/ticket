//
//  ResultModel.swift
//  ticket
//
//  Created by 渡邉羽唯 on 2025/05/18.
//

import Foundation

struct ResultModel: Decodable, Identifiable, Encodable {
    let id: Int
    let device_id: String
    let people_number: Int
    let event_id: Int
    let is_win: Bool
    var seat_col: [String]?
    var seat_row: [String]?
}
