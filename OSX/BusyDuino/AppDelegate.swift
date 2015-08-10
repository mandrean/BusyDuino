/**
 * @module AppDelegate
 * @author Sebastian Mandrean
 * @date 10 Aug 2015
 * @copyright Sebastian Mandrean 2015
 * @license MIT
 */

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var statusMenu: NSMenu!

    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    var busyDuino = BusyDuino()

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        let icon = NSImage(named: "statusIcon")
        icon!.setTemplate(true)

        statusItem.image = icon
        statusItem.menu = statusMenu
    }

    @IBAction func clickedMenu(sender: NSMenuItem) {
        busyDuino.setStatus(String(sender.tag))
    }

}
