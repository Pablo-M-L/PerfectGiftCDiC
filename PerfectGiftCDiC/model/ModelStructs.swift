//
//  ModelStructs.swift
//  PerfectGiftCDiC
//
//  Created by Pablo Millan on 29/7/21.
//

import Foundation
import UIKit


//modelo de datos de eventos con la fecha actualizada en el caso de los anuales.
struct eventUpcoming: Identifiable, Hashable{
    var id: UUID
    var titleEvent: String
    var dateEvent: Date
    var annualEvent: Bool
    var observationEvent: String
}

struct profileListItem: Identifiable, Hashable {
    var id: UUID
    var nameProfile: String
    var annotationsProfile: String
    var imageProfile: UIImage
    
}
