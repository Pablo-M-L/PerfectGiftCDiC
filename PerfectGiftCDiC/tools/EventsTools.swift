//
//  EventsTools.swift
//  PerfectGiftCDiC
//
//  Created by Pablo Millan on 29/7/21.
//

import Foundation
import CoreData
import SwiftUI

class coredataHelper {
    
    
    func getProlfileList(profiles: FetchedResults<Profile>)->[profileListItem]{

        let arrayProfiles: [profileListItem] = []

        if !profiles.isEmpty{
//            profiles.forEach { event in
//                let profileItem = profileListItem(id: event.idProfile!,
//                                                  nameProfile: event.nameProfile!,
//                                                  annotationsProfile: event.annotationsProfile!,
//                                                  imageProfile: event.imageProfile!)
//                arrayProfiles.append(profileItem)
//            }
        }

        return arrayProfiles
    }
}



//obtiene array de eventos filtrados por perfil ordenados por fecha.
func getUpcomingEvent(eventsfitrados: [Event])-> eventUpcoming{
    var arrayEvents: [eventUpcoming] = []
    
    if !eventsfitrados.isEmpty{
        if eventsfitrados.count > 1{
            eventsfitrados.forEach { event in
                let eventUpcoming = eventUpcoming(id: event.idEvent!,
                                                  titleEvent: event.titleEvent!,
                                                  dateEvent: event.annualEvent ? getNextDayEvent(date: event.dateEvent!) : event.dateEvent!,
                                                  annualEvent: event.annualEvent,
                                                  observationEvent: event.observationsEvent!)
                arrayEvents.append(eventUpcoming)
            }
            arrayEvents =  arrayEvents.sorted(by: { $0.dateEvent.compare($1.dateEvent) == ComparisonResult.orderedAscending})
        }
        else{
            //si solo hay un evento no se puede hacer el sorted, da error, por eso se crea directamente el item si se le añade al array.
            let eventUpcoming = eventUpcoming(id: eventsfitrados[0].idEvent!,
                                              titleEvent: eventsfitrados[0].titleEvent!,
                                              dateEvent: eventsfitrados[0].annualEvent ? getNextDayEvent(date: eventsfitrados[0].dateEvent!) : eventsfitrados[0].dateEvent!,
                                              annualEvent: eventsfitrados[0].annualEvent,
                                              observationEvent: eventsfitrados[0].observationsEvent!)
            arrayEvents.append(eventUpcoming)
        }
    }
    return arrayEvents[0]
}
