//
//  IdeasListView.swift
//  PerfectGiftCDiC
//
//  Created by Pablo Millan on 26/7/21.
//

import SwiftUI

struct IdeasListView: View {
    @Environment(\.managedObjectContext) private var viewContext


    
    var ideas: FetchRequest<Ideas>
    var eventParent: Event
    
    init(filterProfile: String,  filterEvent: String, event: Event){
        ideas = FetchRequest<Ideas>(entity: Ideas.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Ideas.ideaTitle, ascending: true)], predicate: NSPredicate(format: "idProfileIdea MATCHES[dc] %@ AND idEventIdea MATCHES[dc] %@", filterProfile, filterEvent),animation: .default)

        eventParent = event

    }
    
    var body: some View {
        
        VStack{
            Text("lista de Ideas")
            
            List{
                ForEach(ideas.wrappedValue, id: \.self) { idea in
                    ZStack{
                        NavigationLink(destination: AddIdeaView(newIdea: false, idea: idea) ){
                            Text("idea")
                        }.opacity(0)
                        CellIdeaListView(idea: idea)
                    }.background(Color("cellprofileBck"))
                    .cornerRadius(20)
                     
                }
            }
        }
    }
}

//struct IdeasListView_Previews: PreviewProvider {
//    static var previews: some View {
//        IdeasListView(filterProfile: "pablo", filterEvent: "cumple")
//    }
//}
