/// Grove Speaker driver for ESP32
/// Generates tones by toggling a GPIO pin at specific frequencies
struct Speaker {
  let pin: Int32

  // Bass frequencies 1-7 (delay values in microseconds)
  let bassTab: [UInt32] = [1911, 1702, 1516, 1431, 1275, 1136, 1012]

  init(pin: Int32) {
    self.pin = pin
    setupPin()
  }

  /// Initialize the GPIO pin as output
  private func setupPin() {
    let gpioNum = gpio_num_t(rawValue: pin)

    // Reset GPIO pin
    gpio_reset_pin(gpioNum)

    // Configure as output
    gpio_set_direction(gpioNum, GPIO_MODE_OUTPUT)

    // Disable pull-up/pull-down
    gpio_set_pull_mode(gpioNum, GPIO_FLOATING)

    // Set initial state to LOW
    gpio_set_level(gpioNum, 0)
  }

  /// Play a tone by toggling the pin
  /// - Parameter noteIndex: Index of the note in bassTab (0-6 for bass 1-7)
  /// - Parameter duration: Duration in milliseconds (default: 200ms)
  func sound(noteIndex: Int, duration: UInt32 = 200) {
    guard noteIndex >= 0 && noteIndex < bassTab.count else {
      print("Invalid note index: \(noteIndex)")
      return
    }

    let delay = bassTab[noteIndex]
    let gpioNum = gpio_num_t(rawValue: pin)

    // Calculate number of toggles based on duration
    // Each toggle cycle = 2 * delay microseconds
    let cycleTime = delay * 2
    let toggles = (duration * 1000) / cycleTime

    // Toggle pin to generate the tone
    for _ in 0..<toggles {
      gpio_set_level(gpioNum, 1)  // HIGH
      ets_delay_us(delay)
      gpio_set_level(gpioNum, 0)  // LOW
      ets_delay_us(delay)
    }
  }

  /// Simple beep for testing
  func beep(durationMs: UInt32 = 100) {
    let gpioNum = gpio_num_t(rawValue: pin)
    let delay: UInt32 = 1000  // 1000us = ~500Hz

    let toggles = (durationMs * 1000) / (delay * 2)

    for _ in 0..<toggles {
      gpio_set_level(gpioNum, 1)
      ets_delay_us(delay)
      gpio_set_level(gpioNum, 0)
      ets_delay_us(delay)
    }
  }

  /// Play all bass notes in sequence
  func playScale() {
    for noteIndex in 0..<7 {
      sound(noteIndex: noteIndex)
      vTaskDelay(500 / (1000 / UInt32(configTICK_RATE_HZ)))  // 500ms delay
    }
  }
}
