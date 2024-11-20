import SwiftUI
import CoreMotion

class MotionViewModel: ObservableObject {
    private let motionManager = CMMotionManager()
    @Published var motionMessage: String = "加速度センサーのデータ待ち..."
    
    init() {
        startAccelerometer()
    }
    
    func startAccelerometer() {
        guard motionManager.isAccelerometerAvailable else {
            motionMessage = "加速度センサーが使用できません"
            return
        }
        
        motionManager.accelerometerUpdateInterval = 0.1 // 更新間隔
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] (data, error) in
            guard let data = data else { return }
            
            let x = data.acceleration.x
            let y = data.acceleration.y
            let z = data.acceleration.z
            
            print("x: \(x), y: \(y), z: \(z)")
            
            // デバイスの動きを判定してメッセージを更新
            if abs(x) > 0.5 {
                self?.motionMessage = "ふるふる"
            } else if abs(y) > 0.5 {
                self?.motionMessage = "ふりふり"
            } else {
                self?.motionMessage = "スマホを振って"
            }
        }
    }
    
    func stopAccelerometer() {
        if motionManager.isAccelerometerActive {
            motionManager.stopAccelerometerUpdates()
        }
    }
}
