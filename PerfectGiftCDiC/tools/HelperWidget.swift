//
//  HelperWidget.swift
//  PerfectGiftCDiC
//
//  Created by pablo millan lopez on 10/2/22.
//

import Foundation
import SwiftUI
import WidgetKit
import CoreData

let appGroupName = "group.PABLOMILLANLOPEZ.perfectGift"

class HelperWidget{

    
    static var arrayFavoriteData = [FavoriteData]()
    
    //si no estan los 6 favoritos creados en usersdefautl, los crea.
static func cargarListaFavoritosDefaultUser(sortNumber: Int){
    //pasar imagen a data
    let imgFav = UIImage(imageLiteralResourceName: "logoPerfectgift")
    let imageData =  imgFav.jpegData(compressionQuality: 0.5)
    let data = try! JSONEncoder().encode(imageData)
    
    if let userDefaults = UserDefaults(suiteName: appGroupName) {
        
        let favorite: FavoriteData = FavoriteData(id: UUID().uuidString, nameProfileFav: "favorite \(String(sortNumber))", dateUpcomingEventFav: Date(), imgProfileFav: data, sortNumber: sortNumber, idProfileFav: "00000", deppUrlFav:  URL(string: "http://www.google.com")!)
        
        HelperWidget.appendArrayFavorites(favorite: favorite)
            
        userDefaults.setArray(HelperWidget.arrayFavoriteData, forKey: key.arrayFavoriteData.rawValue)
        userDefaults.synchronize()
        }
        
}
    
    
    //lee los 6 favoritos de usersdefaults
    static func leerListaFavoritos(){
        if let userDefaults = UserDefaults(suiteName: appGroupName) {
            HelperWidget.arrayFavoriteData = userDefaults.getArray(forKey: key.arrayFavoriteData.rawValue)!
            WidgetCenter.shared.reloadAllTimelines()
        }
        
    }

    static func appendArrayFavorites(favorite: FavoriteData){
        arrayFavoriteData.append(favorite)
    }

    //nombre del favorito
    static func getNombreFav(indFav: Int)->String{
        if let userDefault = UserDefaults(suiteName: appGroupName){
            let favorite = userDefault.getArray(forKey: key.arrayFavoriteData.rawValue)! as [FavoriteData]
            return favorite[indFav].nameProfileFav
        }
        return "no fav"
    }
    
    //id del favorito
    static func getIdFav(indFav: Int)->String{
        if let userDefault = UserDefaults(suiteName: appGroupName){
            let favorite = userDefault.getArray(forKey: key.arrayFavoriteData.rawValue)! as [FavoriteData]
            return favorite[indFav].id
        }
        return "0000"
    }
    
    static func getDateUpcomingFav(indFav: Int)->Date{
        if let userDefault = UserDefaults(suiteName: appGroupName){
            let favorite = userDefault.getArray(forKey: key.arrayFavoriteData.rawValue)! as [FavoriteData]
            return favorite[indFav].dateUpcomingEventFav
        }
        return Date()
    }
    
    static func getImageFav(indFav: Int)->UIImage{
        var imgFav = UIImage(imageLiteralResourceName: "logoPerfectgift")
        
        if let userDefault = UserDefaults(suiteName: appGroupName){
            let favorite = userDefault.getArray(forKey: key.arrayFavoriteData.rawValue)! as [FavoriteData]
            
            let data = try! JSONDecoder().decode(Data.self, from: favorite[indFav].imgProfileFav)
            imgFav = UIImage(data: data) ?? UIImage(imageLiteralResourceName: "logoPerfectgift")
            return imgFav
        }
        return imgFav
    }
    
    static func getSortNumberFav(indFav: Int)->Int{
        if let userDefault = UserDefaults(suiteName: appGroupName){
            let favorite = userDefault.getArray(forKey: key.arrayFavoriteData.rawValue)! as [FavoriteData]
            return favorite[indFav].sortNumber
        }
        return 0
    }
    
    static func getDeepUrlFav(indFav: Int)->URL{
        if let userDefault = UserDefaults(suiteName: appGroupName){
            let favorite = userDefault.getArray(forKey: key.arrayFavoriteData.rawValue)! as [FavoriteData]
            return favorite[indFav].deppUrlFav
        }
        return URL(string: "https://google.com")!
    }
    
    static func getIdProfileFav(indFav: Int)->String{
        if let userDefault = UserDefaults(suiteName: appGroupName){
            let favorite = userDefault.getArray(forKey: key.arrayFavoriteData.rawValue)! as [FavoriteData]
            return favorite[indFav].idProfileFav
        }
        return "1000"
    }
    
    static func getFav(indFav: Int)->FavoriteData{
        //pasar imagen a data
        let imagenUIRedimensionada = UIImage(named: "logoPerfectgift")!
        let imageData =  imagenUIRedimensionada.jpegData(compressionQuality: 0.5)
        let data = try! JSONEncoder().encode(imageData)
        
        let fav: FavoriteData = FavoriteData(id: UUID().uuidString, nameProfileFav: "favorite \(String(indFav))", dateUpcomingEventFav: Date(), imgProfileFav: data, sortNumber: indFav, idProfileFav: "00000", deppUrlFav:  URL(string: "http://www.google.com")!)
       
        if let userDefault = UserDefaults(suiteName: appGroupName){
            let arrayfav = userDefault.getArray(forKey: key.arrayFavoriteData.rawValue)! as [FavoriteData]
            return arrayfav[indFav]
        }
        
        return fav
    }
    
    static func getUpcomingEventDate(idProfile: String)-> Date{
        
        var arrayEvents: [EventDateUpComing] = []
        
        if let usersdefault = UserDefaults(suiteName: appGroupName), var arrayEventsFav: [EventDateUpComing] = usersdefault.getArray(forKey: key.arrayEvents.rawValue){
            
            if arrayEventsFav.count > 0{
                
                if arrayEventsFav.count > 1{
                    
                    let arrayEventProfile = arrayEventsFav.filter{$0.idProfileFav == idProfile}
                    
                    if !arrayEventProfile.isEmpty{
                        
                        arrayEventProfile.forEach { event in
                            
                            let eventDateUpcoming = EventDateUpComing(dateEvent: event.annualEvent ? getNextDayEvent(date: event.dateEvent) : event.dateEvent,
                                                                     idProfileFav: event.idProfileFav,
                                                                     annualEvent: event.annualEvent)
                            
                            arrayEvents.append(eventDateUpcoming)

                        }
                        
                        var arrayEventsSorted = arrayEvents.sorted(by: { $0.dateEvent.compare($1.dateEvent) == ComparisonResult.orderedAscending})
                        

                        return arrayEventsSorted.first?.dateEvent ?? Date()
                    }
                }else{
                    if let firstEvent = arrayEventsFav.first{
                        let upcomingDate = firstEvent.annualEvent ? getNextDayEvent(date: firstEvent.dateEvent) : firstEvent.dateEvent
                        arrayEventsFav[0].dateEvent = upcomingDate
                    }
                    
                    return arrayEventsFav.first?.dateEvent ?? Date()
                }
            }

            
        }
        return Date()
        //event.annualEvent ? getNextDayEvent(date: event.dateEvent!) 
    }
    
    
    static func calcularDiasQueFaltanWidget(dateEvent: Date)-> Int{
        print("Fecha")
        print(dateEvent)
        let calendar = Calendar.current
        
        let dias = Set<Calendar.Component>([.day])
        print("dias")
        print(dias)
        let result = calendar.dateComponents(dias, from: dateEvent as   Date,  to: Date() as Date)
        print("resul")
        print(result)
        let resultado = (result.day ?? 0) * -1
        print("resultado")
        print(resultado)
        if resultado < 0 {
            return 0
        }
        else{
            return resultado
        }

    }

}
