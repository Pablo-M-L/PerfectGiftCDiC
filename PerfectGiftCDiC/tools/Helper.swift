//
//  Helper.swift
//  PerfectGiftCDiC
//
//  Created by Pablo Millan on 30/7/21.
//

import Foundation
import UIKit
import SwiftUI
import SafariServices

//para ocultar teclado
extension UIApplication {
    //para cerrar al pulsar fuera del textview
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    //ejemplo en codigo
    /*
     .onTapGesture {
         UIApplication.shared.endEditing()
     }
     */
}




//crea un contenedor local asociado al app group.
//devuelve la url del archivo.
public enum AppGroup: String{
    case favoritesData = "group.PABLOMILLANLOPEZ.perfectGift"
    
    public var containerURL: URL{
        switch self{
        case .favoritesData:
            return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: self.rawValue)!
        }
    }
}



struct SafariView: UIViewControllerRepresentable {

    let url: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        if let usersDefault = UserDefaults(suiteName: appGroupName){
            usersDefault.setValue(url.absoluteString, forKey: key.urlActive.rawValue)
        }
        
        return SFSafariViewController(url: url)
        
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
        
    
    }

}

func comprobarUrlIntroducida(url: String)-> String{
    if url.starts(with: "https://"){
        print(url)
        return url.trimmingCharacters(in: .whitespaces)
    }
    else if url.starts(with: "www."){
        return ("https://"+url).trimmingCharacters(in: .whitespaces)
    }
    return url.trimmingCharacters(in: .whitespaces)
}

func getTitleWeb(url: String)-> String{
    guard let url = URL(string:url) else { return "no title"}
    var webTitle = "no title web"
    DispatchQueue.global().async {
        if let content = try? String(contentsOf: url, encoding: .utf8) {
            print("content")
            DispatchQueue.main.async {
                print("asys")
                if let range = content.range(of: "<title>.*?</title>", options: .regularExpression, range: nil, locale: nil) {
                    let title = content[range].replacingOccurrences(of: "</?title>", with: "", options: .regularExpression, range: nil)
                    print("title")
                    print(title) // prints "ios - Get Title when input URL on UITextField on swift 4 - Stack Overflow"
                    webTitle = title
                }
            }
        }else{
            print("bnotry")
        }
    }
    
    return webTitle
}

func downloadthumbail(url: URL, completionImage: @escaping (UIImage)-> Void){
    
    URLSession.shared.dataTask(with: url){data, response, error in
        guard let data = data, let response = response as? HTTPURLResponse, error == nil else{
            if let error = error {
                print("error en la descarga de thumbail \(error)")
            }
            return
        }
        
        if response.statusCode == 200{
            if let image = UIImage(data: data){
                completionImage(image)
            }else{
                print("no es una imagen")
            }
        }
        else{
            print("error \(response.statusCode)")
        }
        
    }.resume()
    
}


