//
//  FavoritesList.swift
//  PerfectGiftCDiC
//
//  Created by pablo millan lopez on 10/2/22.
//

import SwiftUI
import WidgetKit


struct FavoritesListView: View {

    @State private var refrescarLista = true
    
    var body: some View{
            VStack{
                if refrescarLista{
                    listaFavoritos()
                }else{
                    listaFavoritos()
                }
            }.onAppear {
                refrescarLista.toggle()
            }
    }
}

struct listaFavoritos: View{
    
    
    @State private var imgFav = UIImage(imageLiteralResourceName: "logoPerfectgift")
    @State var arrayFavorites = [FavoriteData]()
    var body: some View {
        VStack{
            Text(NSLocalizedString("favorites", comment: ""))
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
                            EmptyView()
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
                if let usersdefault = UserDefaults(suiteName: appGroupName), let arrayFav: [FavoriteData] = usersdefault.getArray(forKey: key.arrayFavoriteData.rawValue){
                    HelperWidget.arrayFavoriteData = arrayFav
                    arrayFavorites = arrayFav //para actualizar la lista
                    
                }
                else{
                    for i in 1...6{
                        HelperWidget.cargarListaFavoritosDefaultUser(sortNumber: Int(i))
                    }
                }
                
                HelperWidget.leerListaFavoritos()
            }
        }
        
    }
    
}

//struct FavoritesList_Previews: PreviewProvider {
//    static var previews: some View {
//        FavoritesList()
//    }
//}
