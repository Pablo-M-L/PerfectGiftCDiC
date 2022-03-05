//
//  EventsTools.swift
//  PerfectGiftCDiC
//
//  Created by Pablo Millan on 29/7/21.
//

import Foundation
import CoreData
import SwiftUI

class CoredataHelper {
    
    
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

func getDateUpcomingEvent(eventsfitrados: [Event])-> Date{
    let eventUpcoming = getUpcomingEvent(eventsfitrados: eventsfitrados)
    return eventUpcoming.dateEvent
}

//obtiene array de eventos filtrados por perfil ordenados por fecha y devuelve el mas cercano.
func getUpcomingEvent(eventsfitrados: [Event])-> eventUpcoming{
    print("getcomingevent")
    var arrayEvents: [eventUpcoming] = []

    if !eventsfitrados.isEmpty{
        if eventsfitrados.count > 1{
            eventsfitrados.forEach { event in

                let eventUpcoming = eventUpcoming(id: event.idEvent!,
                                                  profileParent: event.profileEventRelation!,
                                                  titleEvent: event.titleEvent!,
                                                  dateEvent: event.annualEvent ? getNextDayEvent(date: event.dateEvent!) : event.dateEvent!,
                                                  annualEvent: event.annualEvent,
                                                  typeEvent: event.typeEvent!,
                                                  observationEvent: event.observationsEvent!)
                arrayEvents.append(eventUpcoming)
            }
            arrayEvents =  arrayEvents.sorted(by: { $0.dateEvent.compare($1.dateEvent) == ComparisonResult.orderedAscending})
        }
        else{

            //si solo hay un evento no se puede hacer el sorted, da error, por eso se crea directamente el item si se le añade al array.
            let eventUpcoming = eventUpcoming(id: eventsfitrados[0].idEvent!, profileParent: eventsfitrados[0].profileEventRelation!,
                                              titleEvent: eventsfitrados[0].titleEvent!,
                                              dateEvent: eventsfitrados[0].annualEvent ? getNextDayEvent(date: eventsfitrados[0].dateEvent!) : eventsfitrados[0].dateEvent!,
                                              annualEvent: eventsfitrados[0].annualEvent, typeEvent: eventsfitrados[0].typeEvent!,
                                              observationEvent: eventsfitrados[0].observationsEvent!)
            arrayEvents.append(eventUpcoming)
        }
    }
    dump(arrayEvents)
    return arrayEvents[0]
}


//obtiene array de eventos (eventUpcoming) ordenados por fecha para mostrar en la lista de proximamente.
func getUpcomingEventSorted(eventsfitrados: [Event])-> [eventUpcoming]{
    var arrayEvents: [eventUpcoming] = []

    if !eventsfitrados.isEmpty{
        if eventsfitrados.count > 1{
            eventsfitrados.forEach { event in

                let eventUpcoming = eventUpcoming(id: event.idEvent!, profileParent: event.profileEventRelation!,
                                                  titleEvent: event.titleEvent!,
                                                  dateEvent: event.annualEvent ? getNextDayEvent(date: event.dateEvent!) : event.dateEvent!,
                                                  annualEvent: event.annualEvent, typeEvent: event.typeEvent!,
                                                  observationEvent: event.observationsEvent!)
                arrayEvents.append(eventUpcoming)
            }
            arrayEvents =  arrayEvents.sorted(by: { $0.dateEvent.compare($1.dateEvent) == ComparisonResult.orderedAscending})
        }
        else{

            //si solo hay un evento no se puede hacer el sorted, da error, por eso se crea directamente el item si se le añade al array.
            let eventUpcoming = eventUpcoming(id: eventsfitrados[0].idEvent!, profileParent: eventsfitrados[0].profileEventRelation!,
                                              titleEvent: eventsfitrados[0].titleEvent!,
                                              dateEvent: eventsfitrados[0].annualEvent ? getNextDayEvent(date: eventsfitrados[0].dateEvent!) : eventsfitrados[0].dateEvent!,
                                              annualEvent: eventsfitrados[0].annualEvent, typeEvent: eventsfitrados[0].typeEvent!,
                                              observationEvent: eventsfitrados[0].observationsEvent!)
            arrayEvents.append(eventUpcoming)
        }
    }
    return arrayEvents
}

//recive un evento de tipo eventUpcoming y devuelve un event, para pasarlo a eventDetailView desde upcomingView
func getEventFromEventUpcoming(evento: eventUpcoming, eventos: FetchedResults<Event>)->Event{
    return eventos.filter{$0.idEvent == evento.id}.first!
}

//en la vista de eventos, obtiene un array ordenado por fecha de proximidad.
func sortEventsProfile(eventos: FetchRequest<Event>)->[Event]{
    var arrayEventsSorted = [Event]()
    var arrayUpcomingEvent = [eventSortedDate]()
    
    for evento in eventos.wrappedValue{
        arrayUpcomingEvent.append(eventSortedDate(id: UUID(), dateUpcoming: evento.annualEvent ? getNextDayEvent(date: evento.dateEvent!) : evento.dateEvent!, event: evento))
    }
    
    arrayUpcomingEvent = arrayUpcomingEvent.sorted(by: {$0.dateUpcoming < $1.dateUpcoming})
    
    for eventsorted in arrayUpcomingEvent{
        arrayEventsSorted.append(eventsorted.event)
    }
    
    return arrayEventsSorted
}
