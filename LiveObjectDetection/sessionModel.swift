//
//  sessionModel.swift
//  Live_Video
//
//  Created by vishwas ng on 30/09/17.
//  Copyright © 2017 vishwas ng. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation

class sessionModel: NSObject {
    
    var captureSession:AVCaptureSession
    var outputData:AVCaptureVideoDataOutput = AVCaptureVideoDataOutput()
    var previewLayer:AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer()
    
    
    init(session:AVCaptureSession)
    {
        self.captureSession = session
    }
    
    
    func addOutPut(forController controller:UIViewController)
    {
        self.captureSession.beginConfiguration() // 1
        let captureDevice = AVCaptureDevice.default(for: .video)
        guard let lcaptureDevice = captureDevice else
        {
            let alert = UIAlertController.init(title: "This is bad", message: "because its not real device", preferredStyle: .alert)
            let alerAction = UIAlertAction.init(title: "OK", style: .cancel, handler: {(UIAlertAction) in
                alert.dismiss(animated: true, completion: nil)
                controller.navigationController?.popViewController(animated: true)
            })
            alert.addAction(alerAction)
            controller.present(alert, animated: true, completion: nil)
            return
        }
        
        let deviceInput = try? AVCaptureDeviceInput.init(device: lcaptureDevice)
        if (deviceInput == nil)
        {
            
            let alert = UIAlertController.init(title: "This is bad", message: "because its not real device", preferredStyle: .alert)
            let alerAction = UIAlertAction.init(title: "OK", style: .cancel, handler: {(UIAlertAction) in
                alert.dismiss(animated: true, completion: nil)
                controller.navigationController?.popViewController(animated: true)
            })
            alert.addAction(alerAction)
            controller.present(alert, animated: true, completion: nil)
        }
        else
        {
            self.captureSession.addInput(deviceInput!)
        }
       
        self.outputData = AVCaptureVideoDataOutput.init()
        self.captureSession.addOutput(self.outputData)
        self.outputData.videoSettings = [((kCVPixelBufferPixelFormatTypeKey as NSString) as String): NSNumber(value: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange as UInt32)]
        self.captureSession.commitConfiguration()
        
         self.captureSession.startRunning()
    }
    
    func setPreviewLayer(forRect frame:CGRect)
    {
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer.frame = frame
        self.previewLayer.videoGravity = .resizeAspectFill
    }
 
}
