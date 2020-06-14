//
//  ImageDetector.swift
//  Test Your Model
//
//  Created by Teddy Bérard on 16/12/2019.
//  Copyright © 2019 Teddy Bérard. All rights reserved.
//

import Foundation
import AVFoundation
import Vision
import UIKit

class ImageDetector {
    
    // MARK: - Properties
    
    private var maxConfidence: VNConfidence = 0.8
    
    func searchObjectLive(bufferSize: CGSize, detectionOverlay: CALayer) -> [VNCoreMLRequest] {
        guard let modelURL = Bundle.main.url(forResource: ObjectDetectorViewController.modelName, withExtension: "mlmodelc") else {
            print("Model file not found")
            return []
        }
        
        do {
            let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
            let objectRecognition = VNCoreMLRequest(model: visionModel, completionHandler: { (request, error) in
                DispatchQueue.main.async(execute: {
                    // perform all the UI updates on the main queue
                    if let results = request.results {
                        self.drawVisionRequestResults(results, size: bufferSize, detectionOverlay: detectionOverlay)
                    }
                })
            })
            return [objectRecognition]
        } catch let error as NSError {
            print("Model loading went wrong: \(error)")
        }
        
        return []
    }
    
    func searchObject(in image: CGImage, with orientation: CGImagePropertyOrientation, completion: @escaping ([PhotoObjectDetection]?) -> Void) {
        guard let modelURL = Bundle.main.url(forResource: "DoctorWhoDetector", withExtension: "mlmodelc") else {
            print("Model file not found")
            return
        }

        do {
            let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
            let objectRecognition = VNCoreMLRequest(model: visionModel, completionHandler: { (request, _) in
                DispatchQueue.main.async(execute: {
                    if let results = request.results,
                        results.count > 0 {
                        completion(self.detectObject(results, image: image))
                    } else {
                        print("No object found in image")
                    }
                })
            })
            let imageRequestHandler = VNImageRequestHandler(cgImage: image,
                                                            orientation: orientation,
                                                            options: [:])
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    try imageRequestHandler.perform([objectRecognition])
                } catch let error as NSError {
                    print("Failed to perform image request: \(error)")
                    return
                }
            }
        } catch let error as NSError {
            print("Failed to create VNCoreMLModel: \(error)")
            return
        }
    }
    
    private func detectObject(_ results: [Any], image: CGImage) -> [PhotoObjectDetection]? {
        var objects: [PhotoObjectDetection]? = []
        
        for observation in results where observation is VNRecognizedObjectObservation {
            guard let objectObservation = observation as? VNRecognizedObjectObservation,
                let confidence = objectObservation.labels.first?.confidence,
                confidence > self.maxConfidence else {
                    continue
            }
            
            objects?.append(PhotoObjectDetection(name: objectObservation.labels[0].identifier, confidence: confidence))
        }
        
        return objects
    }
    
    private func drawVisionRequestResults(_ results: [Any], size: CGSize, detectionOverlay: CALayer) {
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        detectionOverlay.sublayers = nil // remove all the old recognized objects
        for observation in results where observation is VNRecognizedObjectObservation {
            guard let objectObservation = observation as? VNRecognizedObjectObservation else {
                continue
            }
            // Select only the label with the highest confidence.
            let topLabelObservation = objectObservation.labels[0]
            let objectBounds = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(size.width), Int(size.height))
            
            let shapeLayer = self.createRoundedRectLayerWithBounds(objectBounds)
            
//            let textLayer = self.createTextSubLayerInBounds(objectBounds,
//                                                            identifier: topLabelObservation.identifier,
//                                                            confidence: topLabelObservation.confidence)
//            shapeLayer.addSublayer(textLayer)
            detectionOverlay.addSublayer(shapeLayer)
        }
        CATransaction.commit()
    }
    
    func updateLayerGeometry(imageView: UIImageView) {
        guard let image = imageView.image else { return }
        
        let bounds = imageView.bounds
        var scale: CGFloat
        
        let xScale: CGFloat = bounds.size.width / image.size.height
        let yScale: CGFloat = bounds.size.height / image.size.width
        
        scale = fmax(xScale, yScale)
        if scale.isInfinite {
            scale = 1.0
        }
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        
        // rotate the layer into screen orientation and scale and mirror
        imageView.layer.sublayers?.forEach({ $0.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(.pi / 2.0)).scaledBy(x: -scale, y: -scale)) })
        // center the layer
        imageView.layer.sublayers?.forEach({ $0.position = CGPoint(x: bounds.midX, y: bounds.midY) })
        
        CATransaction.commit()
        
    }
    
    private func createRoundedRectLayerWithBounds(_ bounds: CGRect) -> CALayer {
        let shapeLayer = CALayer()
        shapeLayer.bounds = bounds
        shapeLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        shapeLayer.name = "Found Object"
        shapeLayer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 0.2, 0.4])
        shapeLayer.cornerRadius = 7
        return shapeLayer
    }
    
    public func exifOrientationFromDeviceOrientation() -> CGImagePropertyOrientation {
        let curDeviceOrientation = UIDevice.current.orientation
        let exifOrientation: CGImagePropertyOrientation
        
        switch curDeviceOrientation {
        case UIDeviceOrientation.portraitUpsideDown:  // Device oriented vertically, home button on the top
            exifOrientation = .left
        case UIDeviceOrientation.landscapeLeft:       // Device oriented horizontally, home button on the right
            exifOrientation = .upMirrored
        case UIDeviceOrientation.landscapeRight:      // Device oriented horizontally, home button on the left
            exifOrientation = .down
        case UIDeviceOrientation.portrait:            // Device oriented vertically, home button on the bottom
            exifOrientation = .up
        default:
            exifOrientation = .up
        }
        return exifOrientation
    }
    
}
