import UIKit
import AVFoundation

class ConversationView: UIView {
    
    private let captureSession = AVCaptureSession()
    private let previewLayer = AVCaptureVideoPreviewLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCamera()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupCamera()
    }
    
    private func setupCamera() {
        guard let device = AVCaptureDevice.default(for: .video) else {
            print("Failed to access camera.")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            captureSession.addInput(input)
            
            previewLayer.session = captureSession
            previewLayer.videoGravity = .resizeAspectFill
            layer.addSublayer(previewLayer)
            
            captureSession.startRunning()
        } catch {
            print("Error setting up camera input: \(error.localizedDescription)")
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer.frame = bounds
    }
    
}
