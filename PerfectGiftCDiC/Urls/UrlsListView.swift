//
//  UrlsListView.swift
//  PerfectGiftCDiC
//
//  Created by Pablo Millan on 27/7/21.
//

import SwiftUI

struct UrlsListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext


    
    var urls: FetchRequest<UrlIdeas>
    var ideaParent: Ideas
    
    init(filterUrl: String, idea: Ideas){
        urls = FetchRequest<UrlIdeas>(entity: UrlIdeas.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \UrlIdeas.titleUrl, ascending: true)], predicate: NSPredicate(format: "idIdeaUrl MATCHES[dc] %@",filterUrl),animation: .default)

        ideaParent = idea

    }
    var body: some View {
        VStack{
            Text("paginas de interes")

            List{
                ForEach(urls.wrappedValue, id: \.self) { url in
                    ZStack{
                        NavigationLink(destination: AddUrlView(idea: ideaParent, newUrl: false, urlIdea: url)){
                            Text("url")
                        }.opacity(0)
                        CellUrlsListView(url: url)
                    }.background(Color("cellprofileBck"))
                    .cornerRadius(20)
                    .frame(height:80)
                    .buttonStyle(BorderlessButtonStyle())
                     
                }
            }
        }
    }
}

//struct UrlsListView_Previews: PreviewProvider {
//    static var previews: some View {
//        UrlsListView()
//    }
//}
