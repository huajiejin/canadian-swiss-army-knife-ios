//
//  CameraViewController.swift
//  Canadian Swiss Army Knife
//
//  Created by Jin on 2022-12-04.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    private let session = AVCaptureSession()
    private var videoAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)

    @IBOutlet weak var cameraPreview: CameraPreviewView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if case .authorized = videoAuthorizationStatus {
            startRunningCamera()
        }
        else if case .notDetermined = videoAuthorizationStatus {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                if granted {
                    self.startRunningCamera()
                }
                self.videoAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
            })
        }
        else {
            let alert = UIAlertController(title: LocalizedStrings.DoNotHaveAccessToTheCamera, message: LocalizedStrings.PleaseTurnItOnInSettings, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: LocalizedStrings.Cancel, style: .cancel))
            alert.addAction(UIAlertAction(title: LocalizedStrings.OK, style: .default) {_ in
                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            })
            present(alert, animated: true)
        }
    }
    
    func startRunningCamera() {
        // Connect inputs and outputs to the session
        session.beginConfiguration()
        guard let videoDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice), session.canAddInput(videoDeviceInput) else { return }
        session.addInput(videoDeviceInput)
        let photoOutput = AVCapturePhotoOutput()
        guard session.canAddOutput(photoOutput) else { return }
        session.addOutput(photoOutput)
        session.commitConfiguration()

        // Connect preview to the session
        cameraPreview.session = session
        
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
        }
    }

}
