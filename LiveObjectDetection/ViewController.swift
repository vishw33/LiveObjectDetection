//
//  ViewController.swift
//  LiveObjectDetection
//
//  Created by Vishwas on 17/07/18.
//  Copyright © 2018 Vishwas. All rights reserved.
//

import UIKit
import AVFoundation
import CoreML
import Vision

class ViewController: UIViewController {

    let liveSession = AVCaptureSession()
    let inceptionModel = Inceptionv3()
    var requests:[VNCoreMLRequest] = [VNCoreMLRequest]()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var resultText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpModel()
        setUpSession()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func setUpSession()
    {
        liveSession.sessionPreset = .photo
        let session = sessionModel.init(session: liveSession)
        session.addOutPut(forController: self)
        session.setPreviewLayer(forRect: imageView.bounds)
        session.previewLayer.bounds = imageView.bounds
        session.outputData.setSampleBufferDelegate(self , queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default))
        imageView.layer.addSublayer((session.previewLayer))
    }
    
    func setUpModel()
    {
        guard let model = try? VNCoreMLModel.init(for: inceptionModel.model) else
        {
            fatalError("Model is not ready")
        }
        
        let request = VNCoreMLRequest.init(model: model){ result , error in
            
            if error == nil
            {
                let observations = result.results as! [VNClassificationObservation]
                let classifications = observations.map { observation in
                    "\(observation.identifier) \(observation.confidence * 100.0)"
                }
                print(classifications)
                
                DispatchQueue.main.async {
                    self.resultText.text = classifications.joined(separator: "\n")
                }
            }
        }
        
        self.requests.append(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController:AVCaptureVideoDataOutputSampleBufferDelegate
{
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection)
    {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else
        {
            fatalError("Buffer error")
        }
        
        var requestOptions:[VNImageOption : Any] = [:]
        
        if let camData = CMGetAttachment(sampleBuffer, kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, nil) {
            requestOptions = [.cameraIntrinsics:camData]
        }
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: CGImagePropertyOrientation(rawValue: 6)!, options: requestOptions)
        
        do {
            try imageRequestHandler.perform(self.requests)
        } catch {
            print(error)
        }
    }
}
