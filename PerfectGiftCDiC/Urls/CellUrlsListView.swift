//
//  CellUrlsListView.swift
//  PerfectGiftCDiC
//
//  Created by Pablo Millan on 27/7/21.
//

import SwiftUI

struct CellUrlsListView: View {
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.managedObjectContext) private var viewContext
    
    var url: UrlIdeas
    @State var thumbailUrl = UIImage(imageLiteralResourceName: "logoPerfectgift")
    @State private var openWebView = false
    @State private var openContextMenu = false
    @State private var openEditView = false
    var body: some View {
        
        VStack{
            HStack{
                Image(uiImage: thumbailUrl)
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 15, height: 15)
                    .padding(2)
                Text(url.titleUrl ?? "no title")
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                Spacer()
            }
            
            if openContextMenu{
                VStack{
                    ZStack{
                        NavigationLink(destination: AddUrlView(idea: viewModel.currentIdea, newUrl: false, urlIdea: url),isActive: $openEditView){EmptyView()}
                        Button(action:{
                            openEditView.toggle()
                        }) {
                            Text("edit")
                        }
                    }
                    
                    Button(action: {deleteUrl(url: url)}, label: {Text("Delete")})

                }
            }
        }
        .padding(1)
//        .onLongPressGesture {
//            openContextMenu = true
//        }
        .onAppear {
            if url.thumbailUrl == nil{
                thumbailUrl = UIImage(imageLiteralResourceName: "logoPerfectgift")
            }
            else{
                let imgData = url.thumbailUrl
                let data = try! JSONDecoder().decode(Data.self, from: imgData!)
                thumbailUrl = UIImage(data: data)!
            }
        }

    }
    private func deleteUrl(url: UrlIdeas){
        
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

struct CellUrlsListView_Previews: PreviewProvider {
    static var previews: some View {
        CellUrlsListView(url: UrlIdeas())
    }
}
