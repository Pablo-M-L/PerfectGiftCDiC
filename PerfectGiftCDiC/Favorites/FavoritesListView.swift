//
//  FavoritesList.swift
//  PerfectGiftCDiC
//
//  Created by pablo millan lopez on 10/2/22.
//

import SwiftUI
import WidgetKit


struct FavoritesListView: View {

    
    @State private var imgFav = UIImage(imageLiteralResourceName: "logoPerfectgift")
    @State var arrayFavorites = [FavoriteData]()
    var body: some View {
        VStack{
            Text("FAVORITES")
                .foregroundColor(Color("colorTextoTitulo"))
                .font(.custom("marker Felt", size: 24))
                .padding(.top,10)
            
            Rectangle()
                .foregroundColor(.gray)
                .opacity(0.3)
                .frame(height: 5)
            
            List{
                ForEach(arrayFavorites){ favorite in
                    ZStack{
                        NavigationLink(destination: SelectFavListProfileView(sortNumer: favorite.sortNumber)) {
                            Text("favorites")
                        }.opacity(0)
                        CellFavoriteView(favorite: favorite)
                    }.background(Color("cellprofileBck"))
                        .cornerRadius(20)
                        .shadow(color: .gray, radius: 4, x: 3, y: 3)
                }
            }.listStyle(.inset)
             .padding(.top,15)
             .padding(.bottom,25)
             .onAppear {
                print("Appear")

                if let usersdefault = UserDefaults(suiteName: appGroupName), let arrayFav: [FavoriteData] = usersdefault.getArray(forKey: key.arrayFavoriteData.rawValue){
                    print("hay grupo")
                    HelperWidget.arrayFavoriteData = arrayFav
                    arrayFavorites = arrayFav //para actualizar la lista
                    
                }
                else{
                    for i in 1...6{
                        print("cargar lista array")
                        HelperWidget.cargarListaFavoritosDefaultUser(sortNumber: Int(i))
                    }
                }
                
                HelperWidget.leerListaFavoritos()
            }
        }
        
    }
    
    
    //si no hay 6 favoritos creados en coredata, los crea.
 //   private func cargarListaFavoritosPorDefecto(sortNumber: Int64){
//        withAnimation {
//            let newFavorite = Favorites(context: viewContext)
//            newFavorite.idProfileFav = UUID()
//            newFavorite.deepUrl = URL(string: "http://www.google.com")
//            newFavorite.sortNumber = sortNumber
//            newFavorite.nameProfileFav = "favorite \(String(sortNumber))"
//            newFavorite.fechaProxEventFav = Date()
//
//            let imagenUIRedimensionada = resizeImage(image: imgFav)
//            let imageData =  imagenUIRedimensionada.jpegData(compressionQuality: 0.5)
//            let data = try! JSONEncoder().encode(imageData)
//            newFavorite.imageProfileFav = data
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }




}

//struct FavoritesList_Previews: PreviewProvider {
//    static var previews: some View {
//        FavoritesList()
//    }
//}
