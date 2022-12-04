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
    @IBOutlet weak var returnButton: UIButton!
    
    
    var codeTapped : Bool = false
    
    let session = AVCaptureSession()
    var previewLayer = AVCaptureVideoPreviewLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        codeTextField.keyboardType = .numberPad
        
        
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
            
            QRScannedAlert(title: "QR Scanned", message: readbleObject.stringValue! + " is that correct?")
            
            
        }
        
    }
    
    
    @IBAction func abcButtonTapped(_ sender: Any) {
        codeTapped = !codeTapped
        
        if(codeTapped){
            codeTextField.isUserInteractionEnabled = true
            returnButton.isUserInteractionEnabled = true
            self.view.bringSubviewToFront(codeTextField)
            self.view.bringSubviewToFront(returnButton)
        }
        else {
            codeTextField.isUserInteractionEnabled = false
            returnButton.isUserInteractionEnabled = false
            self.view.sendSubviewToBack(codeTextField)
            self.view.sendSubviewToBack(returnButton)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Dismiss the keyboard
        print("tapped")
 
        codeTextField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func returntapped(_ sender: Any) {
        print(codeTextField.text ?? "0")
    }
    
    func QRScannedAlert(title: String, message: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
            print("Yes button tapped")
            self.performSegue(withIdentifier: "toTabViewFromQR", sender: nil)
            
         })
        
        let retake = UIAlertAction(title: "Retake", style: .default, handler: { (action) -> Void in
            print("Retake button tapped")
            self.session.startRunning()
         })
        
        //Add OK button to a dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(retake)
        // Present Alert to
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
}
