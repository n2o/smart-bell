//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift open source project
//
// Copyright (c) 2024 Apple Inc. and the Swift project authors.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
//
//===----------------------------------------------------------------------===//

// The code will test different colors on the WS2812 RGB LED on GPIO8
@_cdecl("app_main")
func main() {
  print("Hello from Swift on ESP32-C6-Zero!")
  print("Starting LED color test...")

  let delayMs: UInt32 = 2000  // 2 seconds per color
  let ledStrip = LedStrip(gpioPin: 8, maxLeds: 1)
  ledStrip.clear()

  let testColors: [(String, LedStrip.Color)] = [
    ("OFF", .off),
    ("RED (r:16, g:0, b:0)", .red),
    ("GREEN (r:0, g:16, b:0)", .green),
    ("BLUE (r:0, g:0, b:16)", .blue),
    ("WHITE (r:16, g:16, b:16)", .lightWhite),
    ("YELLOW (r:16, g:16, b:0)", LedStrip.Color(r: 16, g: 16, b: 0)),
    ("CYAN (r:0, g:16, b:16)", LedStrip.Color(r: 0, g: 16, b: 16)),
    ("MAGENTA (r:16, g:0, b:16)", LedStrip.Color(r: 16, g: 0, b: 16)),
  ]

  var colorIndex = 0

  while true {
    let (colorName, color) = testColors[colorIndex]
    print(">>> Testing: \(colorName)")

    ledStrip.setPixel(index: 0, color: color)
    ledStrip.refresh()

    colorIndex = (colorIndex + 1) % testColors.count
    vTaskDelay(delayMs / (1000 / UInt32(configTICK_RATE_HZ)))
  }
}
