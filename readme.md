## Context
This is a boiler plate project to make it easy to read data from the Omi and get start with hack projects.

## Usage
The RootVC shows off an example of how to use OmiManager to connect to the OmiDevice.

**Looking for a device**
```swift
func lookForDevice() {
    OmiManager.startScan { device, error in
        // connect to first found omi device
        if let device = device {
            print("got device ", device.id.uuidString)
            self.connectToOmiDevice(device: device)
            OmiManager.endScan()
        }
    }
}

func lookForSpecificDevice(device_id) {
    OmiManager.startScan { device, error in
        // connect to an omi device with a specific id
        if let device = device, device.id.uuidString == device_id {
            self.connectToOmiDevice(device: device)
        }
    }
}
```

**Connecting / Reconnect to a device**
```swift
func connectToOmiDevice(device: Friend) {
    OmiManager.connectToDevice(device: device)
    self.reconnectIfDisconnects()
}

func reconnectIfDisconnects() {
    OmiManager.connectionUpdated { connected in
        if connected == false {
            self.lookForDevice()
        }
    }
}
```

**Getting Live Data**
```swift
func getLiveTranscript() {
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
}

func getLiveAudioData() {
    OmiManager.getLiveAudio(device: device) { file_url in
        print("file_url: ", file_url?.absoluteString ?? "no url")
    }
}
```
## Note
The code within helpers is messy as was the output of a quick 8 hour hackathon. The goal of the OmiManager singleton is to provide a simple interface for hackers to build upon.