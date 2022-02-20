//
//  Helper.swift
//  PerfectGiftCDiC
//
//  Created by Pablo Millan on 30/7/21.
//

import Foundation
import UIKit
import SwiftUI

//para ocultar teclado
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    //para cerrar al pulsar fuera del textview
    /*
     .onTapGesture {
         UIApplication.shared.endEditing()
     }
     */
}



struct backToHomeButton: View{
    
    var body: some View{
        ZStack{
            Circle()
                .foregroundColor(Color("backgroundButton"))
            Image(systemName: "home")
                .resizable()
                .foregroundColor(.white)
                .background(Color("backgroundButton"))
                .aspectRatio(contentMode: .fit)
                .padding(8)
            
            
        }
        .frame(width: 50, height: 50)
        .padding()
    }
}


//crea un contenedor local asociado al app group.
//devuelve la url del archivo.
public enum AppGroup: String{
    case favoritesData = "group.PABLOMILLANLOPEZ.perfectGift"
    
    public var containerURL: URL{
        switch self{
        case .favoritesData:
            return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: self.rawValue)!
        }
    }
}

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


//usersdefaults extension
typealias key = UserDefaults.Keys

extension UserDefaults {
    static let appGroup = UserDefaults(suiteName: "group.PABLOMILLANLOPEZ.perfectGift")!
}


extension UserDefaults {
    enum Keys: String {
        case nameFavorite
        case fechaProximoEvento
        case arrayFavoriteData
        case arrayEvents
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
