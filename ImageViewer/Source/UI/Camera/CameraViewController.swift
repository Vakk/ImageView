//
//  ViewController.swift
//  ImageViewer
//
//  Created by Valerii Kotsulym on 9/19/19.
//  Copyright © 2019 Valerii Kotsulym. All rights reserved.
//

import UIKit
import AVFoundation

import Firebase

class CameraViewController: UIViewController {
    
    @IBOutlet weak var cameraPreview: UIView!
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    private lazy var options: VisionFaceDetectorOptions = { [unowned self] in
        let options = VisionFaceDetectorOptions()
        options.contourMode = .all
        return options
        }()
    
    private lazy var vision: Vision = { return Vision.vision() }()
    
    private lazy var faceDetector : VisionFaceDetector = { [unowned self] in return self.vision.faceDetector(options: self.options) }()
    
    // MARK: View controller.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCameraSession()
        setupLivePreview()
        runCamera()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession.stopRunning()
    }
    
}

// MARK: Camera setup
extension CameraViewController {
    private func setupCameraSession() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
        guard let backCamera = getDevice(position: .front) else {
            print("Unable to access back camera!")
            return
        }
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            stillImageOutput = AVCapturePhotoOutput()
            
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
            }
        } catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
    }
    
    private func setupLivePreview() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspect
        videoPreviewLayer.frame = cameraPreview.bounds
        videoPreviewLayer.connection?.videoOrientation = getVideoOrientationAccording(to: UIDevice.current.orientation)
        cameraPreview.layer.sublayers?.removeAll()
        cameraPreview.layer.addSublayer(videoPreviewLayer)
    }
    
    private func getDevice(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        return AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: position)
    }
    
    private func runCamera() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.startRunning()
        }
    }
}

// MARK: Helpers.
extension CameraViewController {
    private func imageOrientation(deviceOrientation: UIDeviceOrientation, cameraPosition: AVCaptureDevice.Position) -> VisionDetectorImageOrientation {
        switch deviceOrientation {
        case .portrait:
            return cameraPosition == .front ? .leftTop : .rightTop
        case .landscapeLeft:
            return cameraPosition == .front ? .bottomLeft : .topLeft
        case .portraitUpsideDown:
            return cameraPosition == .front ? .rightBottom : .leftBottom
        case .landscapeRight:
            return cameraPosition == .front ? .topRight : .bottomRight
        case .faceDown, .faceUp, .unknown:
            return .leftTop
        default:
            return .leftTop
        }
    }
    
    private func getVideoOrientationAccording(to orientation: UIDeviceOrientation) -> AVCaptureVideoOrientation {
        switch orientation {
        case .landscapeLeft:
            return .landscapeLeft
        case .landscapeRight:
            return .landscapeRight
        case .portraitUpsideDown:
            return .portraitUpsideDown
        default:
            return .portrait
        }
    }
}
