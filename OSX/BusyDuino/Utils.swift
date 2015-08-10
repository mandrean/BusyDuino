/**
 * @module Utils
 * @author Sebastian Mandrean
 * @date 10 Aug 2015
 * @copyright Sebastian Mandrean 2015
 * @license MIT
 */

import Foundation

func shell(launchPath: String, arguments: [String]) -> String {
    let task = NSTask()
    task.launchPath = launchPath
    task.arguments = arguments

    let pipe = NSPipe()
    task.standardOutput = pipe
    task.launch()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output: String = NSString(data: data, encoding: NSUTF8StringEncoding)! as String

    return output
}
