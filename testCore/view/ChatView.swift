import SwiftUI

struct ChatView: View {
    @State private var messages: [Message] = []
    @State private var morseInput: String = ""
    @State private var katakanaOutput: String = ""
    @State private var isInputting: Bool = false
    @State private var labelText: String = "nothing happens"
    @State private var isSending: Bool = false
    @State private var timer: Timer?
    private let morseConverter = MorseModel()

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(messages) { message in
                        HStack {
                            if message.isMine {
                                Spacer()
                                Text(message.text)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .frame(maxWidth: 250, alignment: .trailing)
                            } else {
                                Text(message.text)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                                    .frame(maxWidth: 250, alignment: .leading)
                                Spacer()
                            }
                        }
                    }
                }
                .padding()
            }

            Divider()

            VStack(spacing: 10) {
                Text("入力中: \(morseInput)")
                    .font(.title2)
                    .foregroundColor(.blue)
                if !isInputting {
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
                                .font(.headline)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
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
                
                Button(action: sendMessage) {
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
    }
    
    func startInput() {
        isInputting = true
        resetTimer()
    }
    
    func stopInput() {
        isInputting = false
        timer?.invalidate()
    }
    
    func resetTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
            morseInput += " "
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { _ in
            katakanaOutput = morseConverter.decode(morseInput)
            morseInput = ""
            stopInput()
        }
    }
    
    func sendMessage() {
        guard !katakanaOutput.isEmpty else { return }
        isSending = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            messages.append(Message(text: katakanaOutput, isMine: true))
            katakanaOutput = ""
            isSending = false
        }
    }
}

struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isMine: Bool
}
