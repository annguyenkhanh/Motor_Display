import Foundation
import CoreBluetooth

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {

    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral?
    var routeCharacteristic: CBCharacteristic?

    let serviceUUID = CBUUID(string: "4fafc201-1fb5-459e-8fcc-c5c9c331914b")
    let charUUID = CBUUID(string: "beb5483e-36e1-4688-b7f5-ea07361b26a8")

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {

        if central.state == .poweredOn {

            print("Bluetooth ON → scanning")

            centralManager.scanForPeripherals(withServices: [serviceUUID])
        }
    }

    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {

        print("Found device:", peripheral.name ?? "unknown")

        self.peripheral = peripheral

        centralManager.stopScan()

        centralManager.connect(peripheral)
    }

    func centralManager(_ central: CBCentralManager,
                        didConnect peripheral: CBPeripheral) {

        print("Connected")

        peripheral.delegate = self

        peripheral.discoverServices([serviceUUID])
    }

    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverServices error: Error?) {

        guard let services = peripheral.services else { return }

        for service in services {

            if service.uuid == serviceUUID {

                peripheral.discoverCharacteristics([charUUID], for: service)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {

        guard let characteristics = service.characteristics else { return }

        for char in characteristics {

            if char.uuid == charUUID {

                routeCharacteristic = char

                print("Route characteristic ready")
            }
        }
    }

    func sendRoute(points: [[Double]]) {

        guard let peripheral = peripheral,
              let characteristic = routeCharacteristic else {
            print("BLE not ready")
            return
        }

        let payload: [String: Any] = [
            "points": points
        ]

        do {

            let data = try JSONSerialization.data(withJSONObject: payload)

            peripheral.writeValue(data,
                                  for: characteristic,
                                  type: .withoutResponse)

            print("Route sent")

        } catch {

            print("JSON error")
        }
    }
}