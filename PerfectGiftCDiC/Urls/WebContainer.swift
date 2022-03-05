//
//  WebContainer.swift
//  PerfectGiftCDiC
//
//  Created by pablo millan lopez on 23/2/22.
//

import SwiftUI

struct WebContainer: View {
    
    var urls: FetchRequest<UrlIdeas>
    var urlRecived: String
    init(idea: Ideas, urlRecived: String){
        urls = FetchRequest<UrlIdeas>(entity: UrlIdeas.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \UrlIdeas.titleUrl, ascending: true)], predicate: NSPredicate(format: "idIdeaUrl MATCHES[dc] %@",idea.idIdeas?.uuidString ?? "00"),animation: .default)

        self.urlRecived = urlRecived

    }
    
    @Environment(\.presentationMode) private var presentationMode
    
    
    @StateObject var model = WebViewModel()
    @State private var showAlertBookmark = false
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var viewModel: ViewModel
    @State private var titleString = ""
    @State private var homeWebAddres = "https://google.com"
    @State private var showBookmarkList = false
    @State private var showAlertHomeAdrres = false
    @State private var openEditView = false
    @State private var openAddView = false
    @State private var urlSeleccionada: UrlIdeas?
    
    var defaultUrlThumbail = URL(string: "https://www.google.com/s2/favicons?domain=www.google.com")
    
    
    var body: some View {
        ZStack{
            
            HStack{
                //muestra la lista de direcciones guardadas
                if showBookmarkList{
                    withAnimation {
                        VStack{
                            
                            HStack{
                                Image(systemName: "book")
                                    .frame(width: 50, height: 50)
                            
                                Spacer()
                                ZStack{
                                    NavigationLink(destination: AddUrlView(idea: viewModel.currentIdea, newUrl: true),isActive: $openAddView){EmptyView()}
                                    Button(action:{
                                        openAddView = true
                                    }) {
                                        Image(systemName: "plus.circle")
                                            .frame(width: 30, height: 30)
                                    }
                                }
                                
                                Button(action:{
                                    withAnimation {
                                        showBookmarkList.toggle()
                                    }
                                    
                                }) {
                                    Image(systemName: "xmark")
                                        .frame(width: 30, height: 30)
                                }
                                
                                
                            }.padding(10)
                            
                            NavigationLink(destination: AddUrlView(idea: viewModel.currentIdea, newUrl: false, urlIdea: urlSeleccionada), isActive: $openEditView){EmptyView()}
                            
                            List{
                                ForEach(urls.wrappedValue, id: \.self) { url in
                                    CellUrlsListView(url: url)
                                        .onTapGesture {
                                            urlSeleccionada = url
                                            model.urlString = url.webUrl ?? "https://google.com"
                                            model.loadUrl()
                                            
                                        }.contextMenu{
                                            Button(action:{
                                                urlSeleccionada = url
                                                openEditView = true
                                            },label: {Text("Edit")})
                                            
                                            Button(action: {
                                                urlSeleccionada = url
                                                deleteUrl(url: urlSeleccionada!)
                                            }, label: {Text("Delete")})
                                        }
                                }
                            }.listStyle(.inset)
                        }.frame(width: UIDevice.current.localizedModel == "iPhone" ? UIScreen.main.bounds.width / 2 : UIScreen.main.bounds.width / 4)
                    }

                    Divider()
                    
                }
                
                SearchGiftWeb(webModel: model, webView: model.webView, urlRecived: urlRecived)
                    .navigationBarItems(
                        leading:
                            HStack{
                                Button(action:{
                                            presentationMode.wrappedValue.dismiss()
                                            },
                                       label:{
                                            Image(systemName: "chevron.backward")
                                            }
                                        )
                                HStack{
                                    TextField("web",text: $model.urlString)
                                        .foregroundColor(.blue)
                                        .padding(10)
                                }
                            },
                        trailing:
                            Button("Go", action: {
                                model.loadUrl()
                            })
                            )
                    .navigationBarBackButtonHidden(true)
                    .toolbar {
                        ToolbarItemGroup(placement: .bottomBar) {
                            HStack(alignment: .center, spacing: 10){
                                Button(action: {
                                    print("goback")
                                    model.goBack()
                                }, label: {
                                    Image(systemName: "arrowshape.turn.up.backward")
                                })
                                //.disabled(!model.canGoBack)
                            
                                Button(action: {
                                    model.urlString = UserDefaults.standard.value(forKey: key.homeWebAddres.rawValue) as? String ?? "https://google.com"
                                    model.loadUrl()
                                }, label: {
                                    Image(systemName: "house")
                                }).contextMenu{
                                    Button(action:{
                                        showAlertHomeAdrres = true
                                    },label: {Text("Change Home Web Addres")})
                                }
                                
                                Button(action: {
                                    withAnimation {
                                        showBookmarkList.toggle()
                                    }
                                    
                                }, label: {
                                    Image(systemName: showBookmarkList ? "book.fill" : "book")
                                })
                                
                                Button(action: {
                                    if let link = URL(string: model.urlString) {
                                        UIApplication.shared.open(link)
                                    }
                                }, label: {
                                    Image(systemName: "safari")
                                })
                                
                                Button(action:{
                                            showAlertBookmark = true
                                        },
                                       label:{
                                           Image(systemName: "bookmark")
                                        }
                                      )
                                
                                Button(action: {
                                    model.goForward()
                                }, label: {
                                    Image(systemName: "arrowshape.turn.up.right")
                                })
                                //.disabled(!model.canGoForward)
                                
                            }.padding(.horizontal,5)
                        }
                    }
            }
            
            //ventana que aparece al pulsar en el boton de añadir marcador.
            if showAlertBookmark{
                VStack{
                    Text("Enter bookmark title")
                        .foregroundColor(Color("colorTextoTitulo"))
                        .font(.custom("marker Felt", size: 28))
                        .lineLimit(1)
                        .minimumScaleFactor(0.3)
                    TextField("Enter title",text: $titleString)
                        .foregroundColor(.black)
                        .font(.custom("Marker Felt", size: 18))
                        .lineLimit(1)
                        .padding(.top,10)
                        .padding(.bottom, 20)

                    HStack(alignment: .center){
                        
                        Button(action:{
                            showAlertBookmark = false
                        },label:{
                            Text("Cancel")
                                .font(.custom("Marker Felt", size: 18))
                                .foregroundColor(.blue)
                                .lineLimit(1)
                                .minimumScaleFactor(0.3)
                                .padding(.vertical,5)
                                .padding(.horizontal, 10)
                                .background(Color.orange)
                                .cornerRadius(25)
                                .shadow(color: .gray, radius: 2, x: 2, y: 2)
                        })
                        
                        Spacer()
                        
                        Button(action:{
                            if model.didFinishLoading{
                                addUrlBookmark(title: titleString)
                                showAlertBookmark = false
                            }else{
                                showAlertBookmark = false
                            }
                        },label:{
                            Text("Accept")
                                .font(.custom("Marker Felt", size: 18))
                                .foregroundColor(.blue)
                                .lineLimit(1)
                                .minimumScaleFactor(0.3)
                                .padding(.vertical,5)
                                .padding(.horizontal, 10)
                                .background(Color.orange)
                                .cornerRadius(25)
                                .shadow(color: .gray, radius: 2, x: 2, y: 2)
                        })
                    }
                }.onAppear(perform: {
                    titleString = "Web-\(urls.wrappedValue.count)"
                })
                .frame(width: 250, height: 150)
                .padding()
                .background(Color("background2"))
                .cornerRadius(20)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(.purple, lineWidth: 3))
                
                
            }
            
            //ventana que aparece cuando se da una pulsacion larga en el boton de home, para cambiar direccion web.
            if showAlertHomeAdrres{
                VStack{
                    Text("Enter the new web address")
                        .foregroundColor(Color("colorTextoTitulo"))
                        .font(.custom("marker Felt", size: 28))
                        .lineLimit(1)
                        .minimumScaleFactor(0.3)
                    TextField("Enter title",text: $homeWebAddres)
                        .foregroundColor(.black)
                        .font(.custom("Marker Felt", size: 18))
                        .autocapitalization(UITextAutocapitalizationType.none)
                        .lineLimit(1)
                        .padding(.top,10)
                        .padding(.bottom, 20)

                    HStack(alignment: .center){
                        
                        Button(action:{
                            showAlertHomeAdrres = false
                        },label:{
                            Text("Cancel")
                                .font(.custom("Marker Felt", size: 18))
                                .foregroundColor(.blue)
                                .lineLimit(1)
                                .minimumScaleFactor(0.3)
                                .padding(.vertical,5)
                                .padding(.horizontal, 10)
                                .background(Color.orange)
                                .cornerRadius(25)
                                .shadow(color: .gray, radius: 2, x: 2, y: 2)
                        })
                        
                        Spacer()
                        
                        Button(action:{
                            let addresChecked = comprobarUrlIntroducida(url: homeWebAddres)
                            UserDefaults.standard.setValue(addresChecked, forKey: key.homeWebAddres.rawValue)
                            UserDefaults.standard.synchronize()
                            showAlertHomeAdrres = false
                        },label:{
                            Text("Accept")
                                .font(.custom("Marker Felt", size: 18))
                                .foregroundColor(.blue)
                                .lineLimit(1)
                                .minimumScaleFactor(0.3)
                                .padding(.vertical,5)
                                .padding(.horizontal, 10)
                                .background(Color.orange)
                                .cornerRadius(25)
                                .shadow(color: .gray, radius: 2, x: 2, y: 2)
                        })
                    }
                }.onAppear(perform: {
                    titleString = "Web-\(urls.wrappedValue.count)"
                })
                .frame(width: 250, height: 150)
                .padding()
                .background(Color("background2"))
                .cornerRadius(20)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(.purple, lineWidth: 3))
                
                
            }
            
        }.onAppear {
            model.urlString = urlRecived
            model.loadUrl()
            if let homeWeb = UserDefaults.standard.value(forKey: key.homeWebAddres.rawValue) as? String {
                homeWebAddres =  homeWeb }
            else{ homeWebAddres = "https://google.com"}
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
    
    private func addUrlBookmark(title: String) {
        withAnimation {
            if let userDefault = UserDefaults(suiteName: appGroupName){
                let thumbailImage = UIImage(imageLiteralResourceName: "logoPerfectgift").jpegData(compressionQuality: 0.5)
                let thumbailImageData = try! JSONEncoder().encode(thumbailImage)
                let webUrlActive = comprobarUrlIntroducida(url: userDefault.value(forKey: key.urlActive.rawValue) as! String)
                let idea = viewModel.currentIdea
                let newUrl = UrlIdeas(context: viewContext)
                
                newUrl.idUrl = UUID()
                newUrl.webUrl = webUrlActive
                newUrl.titleUrl = title
                newUrl.idIdeaUrl = idea.idIdeas?.uuidString
                newUrl.ideaUrlRelation = idea
                
                newUrl.thumbailUrl = thumbailImageData
                
                downloadthumbail(url: (URL(string: ("https://www.google.com/s2/favicons?domain=" + webUrlActive)) ?? defaultUrlThumbail!)) { UIImage in
                    let imageData =  UIImage.jpegData(compressionQuality: 1)
                    let data = try! JSONEncoder().encode(imageData)
                    newUrl.thumbailUrl = data
                }
                
                do {
                    try viewContext.save()
                    print("url guardada")
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
            
        }
        
        
    }
}


