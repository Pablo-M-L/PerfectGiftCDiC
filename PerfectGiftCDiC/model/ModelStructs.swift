//
//  ModelStructs.swift
//  PerfectGiftCDiC
//
//  Created by Pablo Millan on 29/7/21.
//

import Foundation
import UIKit

//datos favorite
struct FavoriteData: Identifiable, Hashable, Codable {
    var id = UUID().uuidString
    var nameProfileFav: String
    var dateUpcomingEventFav: Date
    var imgProfileFav: Data
    var sortNumber: Int
    var idProfileFav: String
    var deppUrlFav: URL
}


struct EventDateUpComing: Identifiable, Hashable, Codable{
    var id = UUID().uuidString
    var dateEvent: Date
    var titleEvent: String
    var idProfileFav: String
    var annualEvent: Bool
}

//modelo de datos de eventos con la fecha actualizada en el caso de los anuales.
struct eventUpcoming: Identifiable, Hashable{
    var id: UUID
    var profileParent: Profile
    var titleEvent: String
    var dateEvent: Date
    var annualEvent: Bool
    var typeEvent: String
    var observationEvent: String
}

//modelo de datos que se usa en la lista de eventos de un perfil. Se usa para poder ordenar los eventos de un perfil por fecha.
struct eventSortedDate: Identifiable,Hashable{
    var id: UUID
    var dateUpcoming: Date
    var event: Event
}

struct profileListItem: Identifiable, Hashable {
    var id: UUID
    var nameProfile: String
    var annotationsProfile: String
    var imageProfile: UIImage
    
}

//usersdefaults extension
typealias key = UserDefaults.Keys

extension UserDefaults {
    static let appGroup = UserDefaults(suiteName: "group.PABLOMILLANLOPEZ.perfectGift")!
}

extension UserDefaults {
    enum Keys: String {
        case nameFavorite
        case urlActive
        case fechaProximoEvento
        case arrayFavoriteData
        case arrayEvents
        case homeWebAddres
        case firstAppRun
        case favorite1
        case favorite2
        case favorite3
        case favorite4
        case favorite5
        case favorite6
        
    }
}

extension UserDefaults {
    func setArray<Element>(_ array: [Element], forKey key: String) where Element: Encodable {
        let data = try? JSONEncoder().encode(array)
        set(data, forKey: key)
    }

    func getArray<Element>(forKey key: String) -> [Element]? where Element: Decodable {
        guard let data = data(forKey: key) else { return nil }
        return try? JSONDecoder().decode([Element].self, from: data)
    }
}
