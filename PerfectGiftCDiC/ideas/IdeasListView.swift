//
//  IdeasListView.swift
//  PerfectGiftCDiC
//
//  Created by Pablo Millan on 26/7/21.
//

import SwiftUI

struct IdeasListView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var showSheetMode = false
    @State private var showAddEvent = false
    @State private var ideasListEmpty = false
    var profile: Profile
    var ideas: FetchRequest<Ideas>
 //   var eventParent: Event
    
//    init(filterProfile: String,  filterEvent: String, event: Event){
//        ideas = FetchRequest<Ideas>(entity: Ideas.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Ideas.ideaTitle, ascending: true)], predicate: NSPredicate(format: "idProfileIdea MATCHES[dc] %@ AND idEventIdea MATCHES[dc] %@", filterProfile, filterEvent),animation: .default)
        


  //      eventParent = event

  //  }
    
    init(profile: Profile){
        ideas = FetchRequest<Ideas>(entity: Ideas.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Ideas.ideaTitle, ascending: true)], predicate: NSPredicate(format: "idProfileIdea MATCHES[dc] %@ AND regalado == %@", argumentArray: [profile.idProfile?.uuidString ?? "nadie",false] ),animation: .default)
        
        self.profile = profile
    }
    
    var body: some View {
        
        ZStack{
            
            List{
                ForEach(ideas.wrappedValue, id: \.self) { idea in
                    ZStack{
                        NavigationLink(destination: DetailIdeaView(idea: idea) ){
                            Text("ideas")
                        }.opacity(0)
                        CellIdeaListView(idea: idea)
                    }.background(Color("cellprofileBck"))
                     .cornerRadius(20)

                }
            }.listStyle(.inset)
            

                VStack{
                    if ideasListEmpty{
                    
                    HStack{
                        Spacer()
                        
                            NavigationLink(destination: AddIdeaView(profile: profile), isActive: $showSheetMode){
                                EmptyView()
                            }
                        
                        Button(action:{
                            showSheetMode = true
                            
                        }, label:{
                            ZStack{
                                Image("addIdeaIcon")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(Color("backgroundButton"))
                                    .offset(x: -65, y: 70)
                            }
                            .frame(width: 150, height: 150)
                            .shadow(color: .gray, radius: 2, x: 2, y: 2)
                            .padding()
                        })

                    }
                     .padding(.trailing, UIScreen.main.bounds.width / 3.6)
                    
                }
                 
            }.onAppear {
                //comprobar si el fetchrequest está vacio
                if ideas.wrappedValue.isEmpty{
                    ideasListEmpty = true
                }else{
                    ideasListEmpty = false
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
