//
//  PlayGIF.swift
//  Vocabee
//
//  Created by Adam Daris Ryadhi on 04/10/24.
//

import SwiftUI
import WebKit

struct PlayGIF: UIViewRepresentable {
    private let name: String
    init(_ name: String) {
        self.name = name
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webview = WKWebView()
        let url = Bundle.main.url(forResource: name, withExtension: "gif")!
        let data = try! Data(contentsOf: url)
        
        webview.isOpaque = false
        webview.backgroundColor = .clear
        webview.scrollView.backgroundColor = .clear
        
        webview.load(data, mimeType: "image/gif", characterEncodingName: "UTF-8", baseURL: url.deletingLastPathComponent())
        
        // Set the content mode and scaling
        webview.scrollView.isScrollEnabled = false
        webview.scrollView.bounces = false
        //        webview.contentMode = .scaleAspectFit
        //        webview.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
        return webview
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.reload()
    }
}
