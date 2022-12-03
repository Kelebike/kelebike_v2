//
//  QRScannerViewController.swift
//  kelebike
//
//  Created by Berkay Baygut on 26.11.2022.
//

import UIKit
import AVFoundation

class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    var codeTapped : Bool = false
    
    let session = AVCaptureSession()
    var previewLayer = AVCaptureVideoPreviewLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)

        do{
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
            
        }catch{
            print("err")
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.layer.bounds
        view.layer.addSublayer(previewLayer)
        imageView.layer.borderWidth = 4
        imageView.layer.borderColor = UIColor.orange.cgColor
        self.view.bringSubviewToFront(imageView)
        
        session.startRunning()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //session.stopRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if let metadataObject = metadataObjects.first {
            guard let readbleObject = metadataObject as?
                    AVMetadataMachineReadableCodeObject else {return}
            
            print(readbleObject.stringValue!)
            session.stopRunning()
        }
        
    }
    
    
    @IBAction func abcButtonTapped(_ sender: Any) {
        codeTapped = !codeTapped
        
        if(codeTapped){
            codeTextField.isUserInteractionEnabled = true
            self.view.bringSubviewToFront(codeTextField)
        }
        else {
            codeTextField.isUserInteractionEnabled = false
            self.view.sendSubviewToBack(codeTextField)
        }
    }
    
    @IBAction func flaslightTapped(_ sender: Any) {
        toggleFlash()
    }
    
    func toggleFlash() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { return }

        do {
            try device.lockForConfiguration()

            if (device.torchMode == AVCaptureDevice.TorchMode.on) {
                device.torchMode = AVCaptureDevice.TorchMode.off
            } else {
                do {
                    try device.setTorchModeOn(level: 1.0)
                } catch {
                    print(error)
                }
            }

            device.unlockForConfiguration()
        } catch {
            print(error)
        }
    }
}
