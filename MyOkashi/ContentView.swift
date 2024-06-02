//
//  ContentView.swift
//  MyOkashi
//
//  Created by natsuko mizuno on 2024/04/22.
//

import SwiftUI

struct ContentView: View {
    // OkashiDataを参照する状態変数
    @StateObject var okashiDataList = OkashiData()
    // 入力された文字列を保持する状態変数
    @State var inputText = ""
    // SafariViewの表示有無を管理する変数
    @State var showSafari = false
    
    var body: some View {
       
        VStack {
            TextField("キーワード",
                      text: $inputText,
                      prompt: Text("キーワードを入力して下さい"))
            .onSubmit {
                okashiDataList.searchOkashi(keyword: inputText)
            }
            .submitLabel(.search)
            .padding()
            
            // リスト表示する
            List(okashiDataList.okashiList) { okashi in
                Button {
                    okashiDataList.okashiLink = okashi.link
                    showSafari.toggle()
                } label: {
                    HStack {
                        AsyncImage(url: okashi.image) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(height: 40)
                        } placeholder: {
                            ProgressView()
                        }
                        Text(okashi.name)
                    } // HStack閉じる
                } // Button閉じる
            } // List閉じる
            .sheet(isPresented: $showSafari, content: {
                //SafariViewを表示する
                SafariView(url: okashiDataList.okashiLink!)
                    .ignoresSafeArea(edges: [.bottom])
            }) //sheet閉じる
        } // VStack閉じる
    } // body閉じる
} // ContentView閉じる

#Preview {
    ContentView()
}
