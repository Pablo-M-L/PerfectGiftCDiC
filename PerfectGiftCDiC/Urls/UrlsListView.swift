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
    
    init(idea: Ideas){
        urls = FetchRequest<UrlIdeas>(entity: UrlIdeas.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \UrlIdeas.titleUrl, ascending: true)], predicate: NSPredicate(format: "idIdeaUrl MATCHES[dc] %@",idea.idIdeas?.uuidString ?? "00"),animation: .default)

        ideaParent = idea

    }
    var body: some View {
        VStack{
            ForEach(urls.wrappedValue, id: \.self) { url in
                    ZStack{
                        NavigationLink(destination: WebContainer(idea: ideaParent, urlRecived: url.webUrl!), label: {CellUrlsListView(url: url)})
                    }.contextMenu{
                        Button(action: {
                            deleteUrl(url: url)
                        }, label: {Text(NSLocalizedString("del", comment: ""))})
                    }

   
            }.padding(.horizontal,10)
        }
    }
    
    private func deleteUrl(url: UrlIdeas){
        withAnimation {
            viewContext.delete(url)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

//struct UrlsListView_Previews: PreviewProvider {
//    static var previews: some View {
//        UrlsListView()
//    }
//}
