//
//  SafariView.swift
//  MyOkashi
//
//  Created by natsuko mizuno on 2024/05/05.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    // 表示するホームページのURLを受け取る変数
    let url: URL
    
    // 表示するViewを生成するときに実行
    func makeUIViewController(context: Context) -> SFSafariViewController {
        // safariを起動
        return SFSafariViewController(url: url)
    }
    
    // Viewが更新されたときに実行
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // 処置なし
    }
    
}

