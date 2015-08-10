/**
 * @module BusyDuino
 * @author Sebastian Mandrean
 * @date 10 Aug 2015
 * @copyright Sebastian Mandrean 2015
 * @license MIT
 */

import Foundation

class BusyDuino : NSObject {

    var serial = SerialHandler()

    override init() {
        super.init()

        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
            self.serial.runProcessingInput()
        })
    }

    func setStatus(statusCode: String) {
        if !statusCode.isEmpty {
            var statusString = statusCode
            statusString.append(Character(UnicodeScalar(10)))
            serial.serialPort?.sendData(statusString.dataUsingEncoding(NSUTF8StringEncoding)!)
            Lync().setStatus(statusCode)
        }
    }

}
