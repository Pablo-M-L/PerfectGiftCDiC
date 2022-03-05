//
//  SearchGiftWeb.swift
//  PerfectGiftCDiC
//
//  Created by pablo millan lopez on 22/2/22.
//

import SwiftUI
import WebKit

struct SearchGiftWeb: UIViewRepresentable {
    typealias UIViewType = WKWebView
    
    @ObservedObject var webModel: WebViewModel
    
    let webView: WKWebView
    let urlRecived: String
    let request = URLRequest(url: URL(string: UserDefaults.standard.value(forKey: key.homeWebAddres.rawValue) as? String ?? "https://google.com")!)
    
    func makeUIView(context: Context) -> WKWebView {
        
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        
        self.webView.navigationDelegate = context.coordinator
        self.webView.allowsBackForwardNavigationGestures = true
        self.webView.allowsLinkPreview = true
        self.webView.configuration.defaultWebpagePreferences = prefs
        
        return self.webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<SearchGiftWeb>) {
        //uiView.load(request)
        return
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        private var viewModel: WebViewModel

        init(_ viewModel: WebViewModel) {
            self.viewModel = viewModel
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            self.viewModel.didFinishLoading = true
            if let usersDefault = UserDefaults(suiteName: appGroupName){
                usersDefault.setValue(webView.url?.absoluteString, forKey: key.urlActive.rawValue)
            }
            
        }
    }

    func makeCoordinator() -> SearchGiftWeb.Coordinator {
        Coordinator(webModel)
    }
}


