//
//  ViewController.swift
//  scribehardware
//
//  Created by Ash Bhat on 9/28/24.
//

import UIKit

class RootVC: UIViewController {
    
    var full_transcript = Defaults.singleton.detailsForScribe() ?? ""
    
    let textView = UITextView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.lookForDevice()
   
    }
    
    func lookForDevice() {
        OmiManager.startScan { device, error in
            
            // look for a specific omi device
//            if let device = device, device.id.uuidString == "" {
//                self.connectToOmiDevice(device: device)
//            }
            
            // connect to first omi device
            if let device = device {
                print("got device ", device.id.uuidString)
                self.connectToOmiDevice(device: device)
                OmiManager.endScan()
            }
        }
    }
    
    func reconnectIfDisconnects() {
        OmiManager.connectionUpdated { connected in
            if connected == false {
                self.lookForDevice()
            }
        }
    }
    
    func connectToOmiDevice(device: Friend) {
        OmiManager.connectToDevice(device: device)
        OmiManager.getLiveTranscription(device: device) { transcription in

            self.full_transcript = self.full_transcript + "\(self.getFormattedTimestamp(for: Date())): " + (transcription ?? "" ) + "\n\n"

            DispatchQueue.main.async {
                self.textView.text = self.full_transcript
                if self.textView.text.count > 0 {
                    Defaults.singleton.setDetailsForScribe(details: self.full_transcript)
                }
                
                let range = NSMakeRange(self.textView.text.count - 1, 1)
                self.textView.scrollRangeToVisible(range)
            }
        }
//        OmiManager.getLiveAudio(device: device) { file_url in
//            print("file_url: ", file_url?.absoluteString ?? "no url")
//        }
        self.reconnectIfDisconnects()
    }
    
}

extension RootVC {
    func setupUI() {
        self.overrideUserInterfaceStyle = .dark
        let views = [textView]
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }

        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            textView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            textView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
        ])

        self.textView.font = UIFont.preferredFont(forTextStyle: .body)
        self.textView.isEditable = false
        self.textView.textColor = .systemGreen
        self.textView.text = Defaults.singleton.detailsForScribe()
        DispatchQueue.main.async {
            let range = NSMakeRange(self.textView.text.count - 1, 1)
            self.textView.scrollRangeToVisible(range)
        }
        
        self.textView.isUserInteractionEnabled = false
    }
    
    func getFormattedTimestamp(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mma"  // Format for 12-hour clock with am/pm
        dateFormatter.amSymbol = "am"
        dateFormatter.pmSymbol = "pm"
        
        let formattedTime = dateFormatter.string(from: date).lowercased()  // Lowercase to match the format
        return formattedTime
    }
}
