//
//  ViewController.swift
//  Text Recognition in iOS
//
//  Created by Hamed on 7/2/1400 AP.
//

import UIKit
import Vision

class ViewController: UIViewController {
    
    private lazy var label: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var imageView: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "example4")
//        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 20
        image.layer.masksToBounds = true
        return image
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(label)
        view.addSubview(imageView)
        
        recognizeText(image: imageView.image)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(x: 20, y: view.safeAreaInsets.top+20, width: view.frame.size.width-40, height: 300)
        label.frame = CGRect(x: 20, y: view.safeAreaInsets.top+(view.frame.size.width-40)+10, width: view.frame.size.width-40, height: 100)
    }
    
    
    private func recognizeText(image: UIImage?){
        guard let cgImage = image?.cgImage else { return }
        
        // Handler
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        // Request
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
                return
            }
            
            let text = observations.compactMap({$0.topCandidates(1).first?.string}).joined(separator: ", ")
            
            DispatchQueue.main.async {
                self?.label.text = text
            }
        }
        
        // Process request
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }


}

