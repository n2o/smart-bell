@_cdecl("app_main")
func main() {
  print("Hello from Swift on ESP32-C6-Zero!")

  let delayMs: UInt32 = 1000
  let ledStrip = LedStrip(gpioPin: 8, maxLeds: 1)
  ledStrip.clear()
  ledStrip.setPixel(index: 0, color: .green)
  ledStrip.refresh()

  let speaker = Speaker(pin: 0)
  speaker.playScale()

  // print("Testing speaker with simple beep...")
  // speaker.beep(durationMs: 500)  // 500ms beep for testing

  // vTaskDelay(1000 / (1000 / UInt32(configTICK_RATE_HZ)))  // 1 second pause

  // print("Playing scale...")

  // while true {
  //   vTaskDelay(delayMs / (1000 / UInt32(configTICK_RATE_HZ)))
  // }
}
