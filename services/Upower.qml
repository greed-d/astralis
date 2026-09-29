pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Services.UPower

Singleton {
    id: root
    // Battery
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
    readonly property string stateString: UPowerDeviceState.toString(state)

    // PowerProfile
    property bool hasPerformanceProfile: PowerProfiles.hasPerformanceProfile
    property string degradationReason: PerformanceDegradationReason.toString(PowerProfiles.degradationReason)
    property int currentProfile: PowerProfiles.profile
    property string currentProfileString: PowerProfile.toString(currentProfile)

    readonly property var availableProfiles: {
        const list = [PowerProfile.PowerSaver, PowerProfile.Balanced];
        if (hasPerformanceProfile)
            list.push(PowerProfile.Performance);
        return list;
    }

    readonly property var availableProfileStrings: availableProfiles.map(p => PowerProfile.toString(p))

    function logAll() {
        console.log("battery", battery);
        console.log("energyCapacity:", energyCapacity);
        console.log("timeToEmpty:", timeToEmpty);
        console.log("ready:", ready);
        console.log("timeToFull:", timeToFull);
        console.log("powerSupply:", powerSupply);
        console.log("isPresent:", isPresent);
        console.log("state:", state);
        console.log("type:", type);
        console.log("iconName:", iconName);
        console.log("model:", model);
        console.log("energy:", energy);
        console.log("changeRate:", changeRate);
        console.log("percentage:", percentage);
        console.log("nativePath:", nativePath);
        console.log("healthSupported:", healthSupported);
        console.log("healthPercentage:", healthPercentage);
        console.log("isLaptopBattery:", isLaptopBattery);
        console.log("Has Performance profile:", hasPerformanceProfile);
        console.log("Degradation Reason:", degradationReason);
        console.log("currentProfileString:", currentProfileString);
        console.log("Available Profiles:", availableProfileStrings);
    }

    Component.onCompleted: logAll()

    function setProfile(value) {
        if (value === PowerProfile.Performance && !hasPerformanceProfile) {
            return;
        }
        PowerProfiles.profile = value;
    }
}
