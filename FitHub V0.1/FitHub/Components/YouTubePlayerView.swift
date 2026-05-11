//
//  YouTubePlayerView.swift
//  FitHub
//
//  Created by Safiullah Noori on 23/4/2026.
//

import SwiftUI
import WebKit

//embed a youtube video in a web view
struct YouTubePlayerView: UIViewRepresentable {
    let videoURL: String
    @Binding var playerFailed: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    //configure the web view for inline playback
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        config.userContentController.add(context.coordinator, name: "ytEvent")

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1"
        webView.scrollView.isScrollEnabled = false
        webView.backgroundColor = .black
        webView.isOpaque = false
        return webView
    }

    //load the video html into the web view
    func updateUIView(_ webView: WKWebView, context: Context) {
        guard let videoId = extractVideoId(from: videoURL) else { return }
        webView.loadHTMLString(buildEmbedHTML(videoId: videoId),
                               baseURL: URL(string: "https://fithub.app"))
    }

    //listen for player errors from the iframe
    class Coordinator: NSObject, WKScriptMessageHandler {
        var parent: YouTubePlayerView

        init(_ parent: YouTubePlayerView) {
            self.parent = parent
        }

        func userContentController(_ userContentController: WKUserContentController,
                                   didReceive message: WKScriptMessage) {
            guard message.name == "ytEvent" else { return }
            // Any error from YouTube's player means the video can't play in-app
            DispatchQueue.main.async {
                self.parent.playerFailed = true
            }
        }
    }

    //pull the video id from the url
    private func extractVideoId(from link: String) -> String? {
        if link.contains("watch?v=") {
            return link.components(separatedBy: "watch?v=").last?
                .components(separatedBy: "&").first
        }
        if link.contains("youtu.be/") {
            return link.components(separatedBy: "youtu.be/").last?
                .components(separatedBy: "?").first
        }
        if link.contains("youtube.com/shorts/") {
            return link.components(separatedBy: "youtube.com/shorts/").last?
                .components(separatedBy: "?").first
        }
        if link.contains("youtube.com/embed/") {
            return link.components(separatedBy: "youtube.com/embed/").last?
                .components(separatedBy: "?").first
        }
        return nil
    }

    //build the html wrapper for the iframe
    private func buildEmbedHTML(videoId: String) -> String {
        """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
            <style>
                * { margin: 0; padding: 0; box-sizing: border-box; }
                html, body { width: 100%; height: 100%; background: #000; overflow: hidden; }
                iframe { width: 100%; height: 100%; border: 0; }
            </style>
        </head>
        <body>
            <iframe
                src="https://www.youtube.com/embed/\(videoId)?playsinline=1&enablejsapi=1&origin=https://fithub.app"
                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
                referrerpolicy="strict-origin-when-cross-origin"
                allowfullscreen>
            </iframe>
            <script>
                window.addEventListener('message', function(e) {
                    try {
                        var data = JSON.parse(e.data);
                        if (data.event === 'onError') {
                            window.webkit.messageHandlers.ytEvent.postMessage(data.info);
                        }
                    } catch(err) {}
                });
            </script>
        </body>
        </html>
        """
    }
}
