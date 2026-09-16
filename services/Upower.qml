pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Services.UPower

Singleton {
    id: root
    property var battery: UPower.displayDevice

    readonly property real energyCapacity: battery.energyCapacity
    readonly property real timeToEmpty: battery.timeToEmpty
    readonly property bool ready: battery.ready
    readonly property real timeToFull: battery.timeToFull
    readonly property bool powerSupply: battery.powerSupply
    readonly property bool isPresent: battery.isPresent
    readonly property var state: battery.state
    readonly property var type: battery.type
    readonly property string iconName: battery.iconName
    readonly property string model: battery.model
    readonly property real energy: battery.energy
    readonly property real changeRate: battery.changeRate
    readonly property real percentage: battery.percentage
    readonly property string nativePath: battery.nativePath
    readonly property bool healthSupported: battery.healthSupported
    readonly property real healthPercentage: battery.healthPercentage
    readonly property bool isLaptopBattery: battery.isLaptopBattery

    // function logAll() {
    //     console.log("energyCapacity:", energyCapacity);
    //     console.log("timeToEmpty:", timeToEmpty);
    //     console.log("ready:", ready);
    //     console.log("timeToFull:", timeToFull);
    //     console.log("powerSupply:", powerSupply);
    //     console.log("isPresent:", isPresent);
    //     console.log("state:", state);
    //     console.log("type:", type);
    //     console.log("iconName:", iconName);
    //     console.log("model:", model);
    //     console.log("energy:", energy);
    //     console.log("changeRate:", changeRate);
    //     console.log("percentage:", percentage);
    //     console.log("nativePath:", nativePath);
    //     console.log("healthSupported:", healthSupported);
    //     console.log("healthPercentage:", healthPercentage);
    //     console.log("isLaptopBattery:", isLaptopBattery);
    // }

    // Component.onCompleted: logAll()
}
