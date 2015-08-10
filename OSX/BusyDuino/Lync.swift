/**
 * @module Lync
 * @author Sebastian Mandrean
 * @date 10 Aug 2015
 * @copyright Sebastian Mandrean 2015
 * @license MIT
 */

import Foundation

class Lync : NSObject {

    var statusText : String = ""

    func setStatus(statusCode: String) {
        switch statusCode {
            case "0":
                self.statusText = "Appear Away"
            case "1":
                self.statusText = "Off Work"
            case "2":
                self.statusText = "Be Right Back"
            case "3":
                self.statusText = "Do Not Disturb"
            case "4":
                self.statusText = "Busy"
            case "5":
                self.statusText = "Available"
            default:
                self.statusText = "Ava dilable"
        }

        if let LyncSetStatusScript = NSBundle.mainBundle().URLForResource("LyncSetStatus", withExtension: "scpt"){
            if let path : String = LyncSetStatusScript.path {
                shell("/usr/bin/osascript", [path, statusText]);
            }
        }
    }

    func getStatus() {

    }

}
