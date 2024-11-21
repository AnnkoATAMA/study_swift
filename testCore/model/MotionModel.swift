import SwiftUI
import CoreMotion

class MotionModel: ObservableObject {
    private let motionManager = CMMotionManager()
    @Published var motionMessage: String = "加速度センサーのデータ待ち..."
    
    func startAccelerometer() {
        guard motionManager.isAccelerometerAvailable else {
            motionMessage = "加速度センサーが使用できません"
            return
        }
        motionManager.accelerometerUpdateInterval = 0.3 // 更新間隔
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] (data, error) in
            guard let data = data else { return }
            
            let x = data.acceleration.x
            let y = data.acceleration.y
            let z = data.acceleration.z
            
            print("x: \(x), y: \(y), z: \(z)")
            
            if abs(x) > 1.0 {
                self?.motionMessage = "ふるふる"
            } else if abs(y) > 1.0 {
                self?.motionMessage = "ふりふり"
            } else if abs(z) > 1.0 {
                self?.motionMessage = "ふらふら"
            } else {
                self?.motionMessage = "静止"
            }
        }
    }
    
    func stopAccelerometer() {
        if motionManager.isAccelerometerActive {
            motionManager.stopAccelerometerUpdates()
        }
    }
}
