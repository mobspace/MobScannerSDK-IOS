//
//  ViewController.swift
//  MSSample
//
//  Created by Bharat H on 01/01/21.
//  Copyright © 2021 TechVariable. All rights reserved.
//

import UIKit
import MobScannerSDK
import Photos
import PDFKit

class ViewController: UIViewController, InputImagePickerDelegate, DocumentReadyDelegate,SDKInitDelegate{
    func onInputImagePicked(images: [String]) {
        
        let cropView = self.storyboard?.instantiateViewController(withIdentifier: "CropViewController") as! CropViewController
               cropView.documentReadyDelegate = self
               cropView.imgFiles = images
               self.navigationController?.pushViewController(cropView, animated: true);
    }
    
    
    func onInitSuccess() {
        
    }
    
    func onInitError(message: String) {
        
        print(message)
    }
    
    func onDocumentReady(outputImgFiles: [String]) {
        
        Img2Pdf.createPDF(jpegFiles: outputImgFiles, outputFileName: "test.pdf", callback: {(pdfUrl) -> () in
            
            let pdfView = PDFView(frame: self.view.bounds)
            self.view.addSubview(pdfView)
            
            // Fit content in PDFView.
            pdfView.autoScales = true
            
            // Load pdf file.
            pdfView.document = PDFDocument(url: pdfUrl!!)
            
            print(FileManager.default.fileExists(atPath: pdfUrl!!.path) )
            
        })
        
    }
    
    @IBAction func galleryClicked(_ sender: Any) {
        
        let deviceImagePicker = DeviceImagerPicker()
        deviceImagePicker.inputImagePickerDelegate = self
        self.present(deviceImagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func onCameraClicked(_ sender: Any) {
        
        let cameraView = self.storyboard?.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        cameraView.inputImagePickerDelegate = self
        cameraView.showCapture = true
        self.navigationController?.pushViewController(cameraView, animated: true);
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MobScannerSDK.initialize(uuid: "32937f98-6e8e-451d-a932-fd64b9c7635e",apiKey: "0922c2075ed349eee0b54d610848aad1de285e36",initCallBack: self)
        
        MobScannerSDK.setTheme(theme: TestColor())
    }
    
    private class TestColor: SDKColors{
        var navBackgroundColor: UIColor {
            
            if #available(iOS 13.0, *) {
                return .systemBackground
            } else {
                return .white
            }
        }
        
        public var primaryColor: UIColor = {
            if #available(iOS 13.0, *) {
                return .link
            } else {
                return .blue
            }
        }()
        
        public let label: UIColor = {
            if #available(iOS 13.0, *) {
                return .label
            } else {
                return .black
            }
        }()
        
    }
    
}
