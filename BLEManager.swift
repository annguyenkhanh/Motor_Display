import Foundation
import CoreBluetooth

class BLEManager:NSObject,ObservableObject,CBCentralManagerDelegate,CBPeripheralDelegate{

    var manager:CBCentralManager!
    var device:CBPeripheral?
    var routeChar:CBCharacteristic?

    let serviceUUID = CBUUID(string:"4fafc201-1fb5-459e-8fcc-c5c9c331914b")
    let charUUID = CBUUID(string:"beb5483e-36e1-4688-b7f5-ea07361b26a8")

    override init(){

        super.init()

        manager = CBCentralManager(delegate:self, queue:nil)
    }

    func centralManagerDidUpdateState(_ central:CBCentralManager){

        if central.state == .poweredOn {

            manager.scanForPeripherals(withServices:[serviceUUID])
        }
    }

    func centralManager(_ central:CBCentralManager,
                        didDiscover peripheral:CBPeripheral,
                        advertisementData:[String:Any],
                        rssi RSSI:NSNumber){

        device = peripheral

        manager.stopScan()

        manager.connect(peripheral)
    }

    func centralManager(_ central:CBCentralManager,
                        didConnect peripheral:CBPeripheral){

        peripheral.delegate = self

        peripheral.discoverServices([serviceUUID])
    }

    func peripheral(_ peripheral:CBPeripheral,
                    didDiscoverServices error:Error?){

        guard let services = peripheral.services else { return }

        for s in services{

            peripheral.discoverCharacteristics([charUUID], for:s)
        }
    }

    func peripheral(_ peripheral:CBPeripheral,
                    didDiscoverCharacteristicsFor service:CBService,
                    error:Error?){

        guard let chars = service.characteristics else { return }

        for c in chars{

            if c.uuid == charUUID{

                routeChar = c
            }
        }
    }

    func sendRoute(points:[[Double]]){

        guard let device = device,
              let char = routeChar else { return }

        let json:[String:Any] = ["points":points]

        let data = try! JSONSerialization.data(withJSONObject:json)

        device.writeValue(data, for:char, type:.withoutResponse)
    }
}