//
//  Date+Extension.swift
//  NotasCoreData
//
//  Created by Marco Alonso Rodriguez on 24/03/23.
//

import Foundation

//let date = Date()
//let format = date.getFormattedDate(format: "yyyy-MM-dd HH:mm:ss") // Set output format

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
