//
//  QRScannerViewController.swift
//  kelebike
//
//  Created by Berkay Baygut on 26.11.2022.
//

import UIKit
import AVFoundation
import FirebaseFirestore
import FirebaseAuth


class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var returnButton: UIButton!
    
    
    var codeTapped : Bool = false
    let db = Firestore.firestore()
    
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
            var message = ""
            guard let readbleObject = metadataObject as?
                    AVMetadataMachineReadableCodeObject else {return}
            
            print(readbleObject.stringValue!)
            session.stopRunning()
            var id : String = ""
            Task { @MainActor in
                id = await getDocument(code: readbleObject.stringValue!)
                print(id)
                if id == "NOT_FOUND" {
                    message = "Bike couldn't found."
                } else {
                    message = readbleObject.stringValue! + " is that correct?"
                }
                QRScannedAlert(title: "QR Scanned", message: message, id: id, flag: false)
            }
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
        var message = ""
        var id = ""
        
        Task { @MainActor in
            id = await getDocument(code: codeTextField.text ?? "0")
            print(id)
            if id == "NOT_FOUND" {
                message = "Bike couldn't found."
            } else {
                message = "\(codeTextField.text ?? "0") is that correct?"
            }
            QRScannedAlert(title: "Code Entered", message: message, id: id, flag: true)
        }
        
        print(codeTextField.text ?? "0")
    }
    
    func QRScannedAlert(title: String, message: String, id: String, flag: Bool) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Create YES button with action handler
        let yes = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
            
            self.yesPressed(id: id)
         })
        
        var word = "Retake"
        if flag {
            word = "Re-enter"
        }
        
        let retake = UIAlertAction(title: word, style: .default, handler: { (action) -> Void in
            print("re-enter or retake button tapped")
            self.session.startRunning()
         })
        
        //Add yes button to a dialog message
        if message != "Bike couldn't found." {
                dialogMessage.addAction(yes)
        }
        dialogMessage.addAction(retake)
        // Present Alert to
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func bikeCodeAlert(id: String, lock: String,title: String, message: String){
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { (action) -> Void in
            print("cancel button tapped")
         })
        
        
        dialogMessage.addTextField { (textField) in
            textField.placeholder = "Text here"
        }

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned dialogMessage] _ in
            let answer = dialogMessage.textFields![0]
            if (answer.text! == lock) {
                self.db.collection("Bike").document(id).updateData(["owner" : (Auth.auth().currentUser?.email)!])
                self.performSegue(withIdentifier: "toTabViewFromQR", sender: nil)
            }
            else {
                self.bikeCodeAlert(id: id, lock: lock, title: "Bike Lock Wrong", message: "")
            }
        }
        
        dialogMessage.addAction(submitAction)
        dialogMessage.addAction(cancel)
        // Present Alert to
        
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func yesPressed(id: String) {
        self.db.collection("Bike").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    if (document.documentID == id) {
                        let owner = (document.data()["owner"] as? String)!
                        let lock = (document.data()["lock"] as? String)!
                        
                        if(owner == "nontaken"){
                            print("Yes button tapped")
                            self.db.collection("Bike").document(id).updateData(["status" : "waiting", "issued": "pending", "owner" : (Auth.auth().currentUser?.email)!])
                            self.performSegue(withIdentifier: "toTabViewFromQR", sender: nil)
                        }
                        else {
                            self.bikeCodeAlert(id: id, lock: lock, title: "Bike Has Owner", message: "Enter the the bike lock combination to transfer ownership")
                        }
                    }
                }
            }
        }
    }
    
    private func getDocument(code : String) async -> String {
        var docID : String = "NOT_FOUND"
        
        do {
          docID = try await db.collection("Bike").whereField("code", isEqualTo: code)
                    .getDocuments().documents.first?.documentID ?? "NOT_FOUND"
        } catch {
                print("Error find the document")
        }
        return docID
    }
    
}
