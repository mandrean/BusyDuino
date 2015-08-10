# BusyDuino
An Arduino-based Busylight for Lync.

## Wiring
![fritzing](https://raw.githubusercontent.com/mandrean/BusyDuino/master/Arduino/Fritzing.png)

## Installation
1. Wire up the Arduino
2. Upload the sketch
3. Open the Xcode project and set the correct config in __Info.plist__ (*SerialPath* and *SerialBaudRate*)
4. Build & Run
5. Use the buttons on the breadboard, or the desktop menu bar app, to set the busylight status
6. Allow access to "Assistive Devices" for /usr/bin/osascript. Read: http://bit.ly/1Ke5qLP

## Todo
* App Icon
* Skype integration

## Credits
* ORSSerialPort: [armadsen / ORSSerialPort](https://github.com/armadsen/ORSSerialPort)

## Feedback
All bugs, feature requests, pull requests, feedback, etc., are welcome. [Create an issue](https://github.com/mandrean/BusyDuino/issues).

## License
MIT License: http://mit-license.org/ or see [the `LICENSE` file](https://github.com/mandrean/BusyDuino/blob/master/LICENSE).
