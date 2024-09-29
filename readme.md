## Context
This is a boiler plate project to make it easy to read data from an [Omi Friend device](https://docs.omi.me/assembly/Build_the_device/). The live transcription is powered by a tiny client side whisper model. All the code you see here runs on device.

## Usage
The core interface for interacting with the Omi device is the **OmiManager.swift**. The OmiManager abstracts things like scanning, connecting, and reading bluetooth data into a few simple function calls.

The RootVC shows off an example of how to use OmiManager to connect to the Omi Friend Device.

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

func lookForSpecificDevice(device_id: String) {
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
func getLiveTranscript(device: Friend) {
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

func getLiveAudioData(device: Friend) {
    OmiManager.getLiveAudio(device: device) { file_url in
        print("file_url: ", file_url?.absoluteString ?? "no url")
    }
}
```
## Note
The code that OmiManager abstracts is messy as it was the output of a quick 8 hour hackathon. The goal of the OmiManager singleton is to provide a simple interface for fellow hackers to build upon.