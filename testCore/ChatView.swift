import SwiftUI

struct ChatView: View {
    @State private var morseInput: String = ""
    @State private var katakanaOutput: String = ""
    @State private var Inputter: Bool = false
    @State private var labelText: String = "nothing happens"
    @State private var isSending: Bool = false
    @State private var timer: Timer?
    private let morseConverter = MorseViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("モールス信号→カタカナ")
                .font(.largeTitle)
                .bold()
            
            Text("入力中: \(morseInput)")
                .font(.title2)
                .foregroundColor(.blue)
            
            if !Inputter {
                Button(action: startInput) {
                    Text("入力開始")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            } else {
                VStack {
                    LongPressableButton(tapAction: {
                        labelText = "トン"
                        morseInput += "."
                        resetTimer()
                    }, longPressAction: {
                        labelText = "ツー"
                        morseInput += "-"
                        resetTimer()
                    }, label: {
                        Text("5秒経つと入力終わるよ！")
                    })
                    .buttonStyle(.bordered)
                    .padding()
                    
                    Text(labelText)
                        .padding()
                }
            }
            
            Text("結果: \(katakanaOutput)")
                .font(.title)
                .foregroundColor(.green)
            
            Button(action: sendToBackend) {
                Text("送信")
                    .font(.headline)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(isSending)
            
            if isSending {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
        .padding()
    }
    
    func startInput() {
        Inputter = true
        resetTimer()
    }
    
    func stopInput() {
        Inputter = false
        timer?.invalidate()
    }
    
    func resetTimer() {
        timer?.invalidate()
//        ここの秒数に２倍の時間つけると終了時に二つスペースついてきしょい
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
            morseInput += " "
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { _ in
            katakanaOutput = morseConverter.decode(morseInput)
            morseInput = ""
            stopInput()
        }
    }
    
    func sendToBackend() {
        guard !katakanaOutput.isEmpty else { return }
        
        isSending = true
        let url = URL(string: "通信用のurlを貼るやで")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = ["decodedText": katakanaOutput]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isSending = false
                if let error = error {
                    print("送信エラー: \(error.localizedDescription)")
                } else {
                    print("送信成功")
                }
            }
        }.resume()
    }
}
