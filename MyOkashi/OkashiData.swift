//
//  OkashiData.swift
//  MyOkashi
//
//  Created by natsuko mizuno on 2024/04/22.
//

import Foundation

struct OkashiItem: Identifiable {
    let id = UUID()
    let name: String
    let link: URL
    let image: URL
}
// お菓子データ検索用クラス
class OkashiData: ObservableObject {
    
    struct ResultJson: Codable {
        struct Item: Codable {
            // お菓子の名前
            let name: String?
            // 掲載URL
            let url: URL?
            // 画像URL
            let image: URL?
        }
        // 複数要素
        let item: [Item]?
    }
    
    //お菓子リスト（Identifiableプロトコル）
    @Published var okashiList: [OkashiItem] = []
    // クリックされたWebページのURL情報
    var okashiLink: URL?
    
    func searchOkashi(keyword: String) {
        print("searchOkashiメソッドで受け取った値：\(keyword)")
        
        Task {
            await search(keyword: keyword)
        } // Task閉じる
    } // searchOkashi閉じる
    
    // 非同期でお菓子データを取得
    // @MainActorを使いメインスレッドで更新する
    @MainActor
    private func search(keyword: String) async {
        // お菓子の検索キーワードをURLエンコードする
        guard let keyword_encode = keyword.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)
        else {
            return
        }
        
        // リクエストURLの組み立て
        guard let req_url = URL(string: "https://sysbird.jp/toriko/api/?apikey=guest&format=json&keyword=\(keyword_encode)&max=10&order=r")
        else {
            return
        }
        
        print(req_url)
        
        do {
            //リクエストURLからダウンロード
            let (data , _) = try await URLSession.shared.data(from: req_url)
            //JSONDecoderのインスタンス取得
            let decoder = JSONDecoder()
            // 受け取ったJSONデータをパースして格納
            let json = try decoder.decode(ResultJson.self, from: data)
            
            // お菓子の情報が取得できているか確認
            guard let items = json.item else { return }
            
            // お菓子のリストを初期化
            self.okashiList.removeAll()
            
            // 取得しているお菓子の数だけ処理
            for item in items {
                // お菓子の名称、掲載URL、画像URLをアンラップ
                if let name = item.name,
                   let link = item.url,
                   let image = item.image {
                    // 一つのお菓子情報を構造体でまとめて管理
                    let okashi = OkashiItem(name: name, link: link, image: image)
                    //　配列へ追加
                    self.okashiList.append(okashi)
                }
            }
            print(self.okashiList)
            
        } catch {
            print("エラーが発生しました。")
        } //do閉じる
    } // search閉じる
} // OkashiData閉じる
