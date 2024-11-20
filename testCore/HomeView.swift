
import SwiftUI

struct HomeView: View {
    @State var inputEmail: String = ""
    @State var inputPassword: String = ""
    
    var body: some View {
            VStack(alignment: .center) {
                Text("Setuna")
                    .font(.system(size: 48,
                                  weight: .heavy))
                
                VStack(spacing: 24) {
                    TextField("Mail address", text: $inputEmail)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 280)
                
                    SecureField("Password", text: $inputPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 280)
                        
                }
                .frame(height: 200)
                                
                Button(action: {
                   print("Login処理")
                },
                label: {
                    Text("Login")
                        .fontWeight(.medium)
                        .frame(minWidth: 160)
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.accentColor)
                        .cornerRadius(8)
                })
                               
                Spacer()
            }
        }
    }

// login済みだったら初手マッチ画面とかでこの画面を非表示にせな
// firebaseUIを使用するっけ
