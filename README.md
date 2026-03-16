# 🗺️ Smart BLE Navigation Display

A DIY **motorbike navigation display system** that connects an iPhone app to an ESP32 device via Bluetooth Low Energy (BLE).
The phone calculates routes and navigation instructions, then sends a **compressed route + turn-by-turn instructions** to a small embedded display mounted on a motorbike.

The device renders the route line and navigation cues in real time — similar to minimalist navigation devices like the Beeline Moto.

---

# ✨ Features

### 📍 Smart Location Search

* Search locations like a typical map app.
* Powered by Apple MapKit location services.

### 🗺 Interactive Map

* Touch-enabled map
* Zoom / pan gestures
* Visual route preview

### 🛣 Multiple Route Options

* Calculates **up to 3 alternative routes**
* Tap a route directly on the map to select it.

### 🧭 Turn-by-Turn Navigation

* Extracts navigation steps automatically
* Converts them into simple instructions:

```
LEFT
RIGHT
STRAIGHT
UTURN
```

### 📡 BLE Route Transfer

Routes are compressed and transmitted to the ESP32 device via Bluetooth Low Energy.

### ⚡ Route Compression

Raw routes may contain thousands of points.

This project compresses them before sending:

```
5000 GPS points → ~80 points
```

Result:

* faster BLE transmission
* lower memory usage
* smoother rendering on embedded devices

### 📺 Embedded Display Rendering

The ESP32 device:

* receives route + turn instructions
* projects GPS coordinates into screen space
* renders the route line
* displays the next turn arrow

---

# 🏗 System Architecture

```
┌────────────────────────┐
│       iPhone App       │
│                        │
│  MapKit Navigation     │
│  Route Calculation     │
│  Turn Detection        │
│  Route Compression     │
│                        │
└───────────┬────────────┘
            │
            │ BLE
            ▼
┌────────────────────────┐
│       ESP32 Device     │
│                        │
│  BLE Receiver          │
│  JSON Route Parser     │
│  Coordinate Projection │
│  Vector Route Renderer │
│                        │
└───────────┬────────────┘
            │
            ▼
     Small TFT Display
```

---

# 📦 Project Structure

```
smart-navigation-display
│
├── ios-app
│   ├── ContentView.swift
│   ├── MapView.swift
│   ├── RouteService.swift
│   ├── LocationSearch.swift
│   ├── TurnExtractor.swift
│   ├── RouteCompressor.swift
│   └── BLEManager.swift
│
├── esp32-device
│   ├── main.cpp
│   ├── ble_receiver.cpp
│   ├── map_projection.cpp
│   └── renderer.cpp
│
└── README.md
```

---

# 📡 BLE Route Format

The phone sends compressed navigation data as JSON.

Example:

```json
{
  "route":[
    [10.7821,106.6981],
    [10.7832,106.6995],
    [10.7840,106.7002]
  ],
  "turns":[
    {"lat":10.7832,"lon":106.6995,"type":"left"},
    {"lat":10.7840,"lon":106.7002,"type":"right"}
  ]
}
```

---

# 📱 iOS App

The iOS app is built using:

* SwiftUI
* MapKit
* CoreBluetooth

Capabilities:

* search locations
* calculate routes
* choose alternative routes
* send navigation data via BLE

---

# 🔧 ESP32 Device

Responsibilities:

1. Receive BLE data
2. Parse JSON payload
3. Convert GPS coordinates to screen coordinates
4. Render route lines
5. Display upcoming turns

---

# 🖥 Coordinate Projection

GPS coordinates are projected into screen coordinates using a simple projection model.

```
x = (lon - centerLon) * scale
y = (centerLat - lat) * scale
```

This allows the route to be rendered on small displays.

---

# 🎯 Goal of the Project

Create a **minimalist navigation display for motorbikes** that:

* avoids mounting a phone on the handlebar
* reduces distraction while riding
* provides essential navigation cues only

---

# 🧪 Current Status

✔ Route calculation
✔ Route alternatives
✔ Tap-to-select route
✔ Turn detection
✔ Route compression
✔ BLE transmission
✔ ESP32 rendering

Next improvements:

* turn distance indicator
* dynamic zoom
* automatic rerouting
* offline routing support

---

# 🚀 Future Ideas

Possible upgrades:

* offline map routing
* speed-based zoom
* compass-based orientation
* OTA firmware updates
* battery powered device
* waterproof enclosure

---

# 🛠 Hardware Used

Example setup:

* ESP32-S3
* TFT SPI display
* GPS module
* BLE connection to phone

---

# 🤝 Contributions

This is a personal experimental project.
Ideas, improvements, and discussions are always welcome.

---

# 📜 License

MIT License
