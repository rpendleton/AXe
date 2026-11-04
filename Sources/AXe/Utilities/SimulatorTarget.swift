import ArgumentParser

/// A simulator and the device set it lives in, for simulators outside the default set
/// (those created with `xcrun simctl --set <path>`). A nil path is the default set.
struct SimulatorTarget: ParsableArguments {
    @Option(name: .customLong("udid"), help: "The UDID of the simulator.")
    var udid: String

    @Option(name: .customLong("device-set"), help: "A simulator device set other than the default.")
    var deviceSetPath: String?

    init() {}

    init(udid: String, deviceSetPath: String? = nil) {
        self.udid = udid
        self.deviceSetPath = deviceSetPath
    }

    /// `simctl`, on this simulator's device set.
    var simctlArguments: [String] {
        ["simctl"] + (deviceSetPath.map { ["--set", $0] } ?? [])
    }
}
