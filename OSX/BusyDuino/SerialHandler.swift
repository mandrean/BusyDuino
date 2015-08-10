/**
 * @module SerialHandler
 * @author Sebastian Mandrean
 * @date 10 Aug 2015
 * @copyright Sebastian Mandrean 2015
 * @license MIT
 */

import Foundation

class SerialHandler : NSObject, ORSSerialPortDelegate {

    let standardInputFileHandle = NSFileHandle.fileHandleWithStandardInput()
    var serialPort: ORSSerialPort?

    override init() {
        super.init()

        let serialPath = NSBundle.mainBundle().objectForInfoDictionaryKey("SerialPath") as! String
        let serialBaudRate = NSBundle.mainBundle().objectForInfoDictionaryKey("SerialBaudRate") as! Int

        self.serialPort = ORSSerialPort(path: serialPath)
        self.serialPort?.baudRate = serialBaudRate
        self.serialPort?.delegate = self
        serialPort?.open()
    }

    func runProcessingInput() {
        setbuf(stdout, nil)

        standardInputFileHandle.readabilityHandler = { (fileHandle: NSFileHandle!) in
            let data = fileHandle.availableData
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.handleUserInput(data)
            })
        }

        NSRunLoop.currentRunLoop().run() // loop
    }


    func handleUserInput(dataFromUser: NSData) {
        if let string = NSString(data: dataFromUser, encoding: NSUTF8StringEncoding) as? String {
            self.serialPort?.sendData(dataFromUser)
        }
    }

    // ORSSerialPortDelegate

    func serialPort(serialPort: ORSSerialPort, didReceiveData data: NSData) {
        if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
            Lync().setStatus(string as String)
        }
    }

    func serialPortWasRemovedFromSystem(serialPort: ORSSerialPort) {
        self.serialPort = nil
    }

    func serialPort(serialPort: ORSSerialPort, didEncounterError error: NSError) {
        print("Serial port (\(serialPort)) encountered error: \(error)")
    }

    func serialPortWasOpened(serialPort: ORSSerialPort) {
        print("Serial port \(serialPort) was opened")
    }
}
