/**
 * This Arduino sketch contains the code for the serial I/O communication
 * with the BusyDuino desktop app.
 *
 * @file BusyDuino.ino
 * @author Sebastian Mandrean
 * @date 10 Aug 2015
 * @brief Arduino Sketch for the BusyDuino
 * @copyright Sebastian Mandrean 2015
 * @license MIT
 */


/**
 * 2-dimensional array containing the LED & button pin mappings
 * @type {int[]}
 */
int ledButtonPin[][2] = {
    { 12, A0 },
    { 11, 2 },
    { 10, 3 },
    { 9, 4 },
    { 8, 5 },
    { 7, 6 }
};

/**
 * The states for the different LEDs. 1 = ON, 0 = OFF
 * @type {int[]}
 */
int ledState[] = { 0, 0, 0, 0, 0, 0 };

/**
 * The states for the different buttons. 1 = ON, 0 = OFF
 * @type {int[]}
 */
int buttonState[] = { 0, 0, 0, 0, 0, 0 };

/**
 * The last states for the different buttons. 1 = ON, 0 = OFF
 * @type {int[]}
 */
int lastButtonState[] = { 0, 0, 0, 0, 0, 0 };

/**
 * The pin number of the currently active LED.
 * @type {int}
 */
int activeLed;

/**
 * The last time an output pin was toggled
 * @type {long[]}
 */
long lastDebounceTime[] = { 0, 0, 0, 0, 0, 0 };

/**
 * The debounce time. Increase if the output flickers
 * @type {long}
 */
long debounceDelay = 10;

/**
 * A string to hold incoming data
 * @type {string}
 */
string inputString = "";

/**
 * Whether the string is complete (newline reached)
 * @type {bool}
 */
bool stringComplete = false;

void resetLedButton(int mode);
void listenToButtonInput();
void listenToSerialInput();
void setLed(int ledPin, bool state);

#define PAIRS sizeof(ledButtonPin) / sizeof(ledButtonPin[0])

/**
 * Init
 */
void setup() {
    // Start the serial connection
    Serial.begin(9600);

    // Iterate through array and setup IO for LEDs and buttons
    for (int i = 0; i < PAIRS; i++) {
        pinMode(ledButtonPin[i][0], OUTPUT); // LED
        pinMode(ledButtonPin[i][1], INPUT); // Button

        digitalWrite(ledButtonPin[i][0], LOW);
        digitalWrite(ledButtonPin[i][1], LOW);
    }
}

/**
 * Main loop
 */
void loop() {
    listenToButtonInput();
    listenToSerialInput();
}

/**
 * Listen to button pushes. Output button pin number to serial
 */
void listenToButtonInput() {
    for (int i = 0; i < PAIRS; i++) {

        // Read the state of the current button (in the loop)
        // into a local variable
        int reading = digitalRead(ledButtonPin[i][1]);

        // If the button state changed, due to noise or pressing
        if (reading != lastButtonState[i]) {
          // Reset the debouncing timer
          lastDebounceTime[i] = millis();
        }

        // Debounce
        if ((millis() - lastDebounceTime[i]) > debounceDelay) {

          // If the button state has changed
          if (reading != buttonState[i]) {
            buttonState[i] = reading;

            // Only toggle the LED if the new button state is HIGH
            if (buttonState[i] == 1) {
              ledState[i] = !ledState[i];

              if (ledState[i] == 1) {
                  activeLed = i;

                  // Output pin number to serial
                  Serial.print(activeLed);

                  // Reset all LEDs and toggle the active one
                  resetLedButton(0);
                  digitalWrite(ledButtonPin[activeLed][0], 1);
              }
            }
          }

        }
        // Save the last button state for next iteration of the loop
        lastButtonState[i] = reading;
    }
}

/**
 * Listen to serial data. Used for setting the LEDs correctly when
 * setting the Busy status from the desktop app
 */
void listenToSerialInput() {
    // If a newline arrives
    if (stringComplete) {
        int statusCode = inputString.toInt();

        // Reset all LEDs and toggle the active one
        resetLedButton(0);
        setLed(statusCode, true);

        // Clear the buffer
        inputString = "";
        stringComplete = false;
    }
}

/**
 * Resets all LEDs and/or button states
 * @param {int} [mode=2] - 0 = LED, 1 = button, 2 = both
 */
void resetLedButton(int mode = 2) {
    for (int i = 0; i < PAIRS; i++) {
        if (mode == 0 || mode == 2) {
            digitalWrite(ledButtonPin[i][0], LOW);
        }
        if (mode == 1 || mode == 2) {
            digitalWrite(ledButtonPin[i][1], LOW);
        }
    }
}

/**
 * Set a LED state
 * @param {int} int ledPin - The LED pin number
 * @param {bool} state - The LED state (ON/OFF, TRUE/FALSE)
 */
void setLed(int ledPin, bool state) {
    digitalWrite(ledButtonPin[ledPin][0], state);
}

/**
 * SerialEvent occurs whenever a new data comes in the
 * hardware serial RX. This routine is run between each
 * time loop() runs, so using delay inside loop can delay
 * response. Multiple bytes of data may be available
 */
void serialEvent() {
  while (Serial.available()) {
    // Get the new byte
    char inChar = (char)Serial.read();

    // Add it to the inputString
    inputString += inChar;

    // If the incoming character is a newline, set a flag
    // so the main loop can do something about it
    if (inChar == '\n') {
      stringComplete = true;
    }
  }
}
