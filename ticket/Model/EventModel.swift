//
//  EventModel.swift
//  ticket
//
//  Created by 渡邉羽唯 on 2025/02/16.
//

import Foundation

struct EventModel: Decodable, Identifiable, Encodable {
    let id: Int
    let name: String
    let detail: String
    let event_start_date: Date
    let event_open_date: Date
    let event_closing_date: Date
    let image_url: String
}
