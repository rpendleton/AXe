import Testing
@testable import AXe

@Suite("Simulator Target Tests")
struct SimulatorTargetTests {
    @Test("Commands accept the option beside --udid")
    func commandOption() throws {
        let tap = try Tap.parse(["--id", "ok", "--udid", "ABC", "--device-set", "/set"])
        let list = try ListSimulators.parse(["--device-set=/set"])

        #expect(tap.simulatorTarget.deviceSetPath == "/set")
        #expect(list.deviceSetPath == "/set")
    }

    @Test("The option is off by default")
    func noOption() throws {
        let tap = try Tap.parse(["--id", "ok", "--udid", "ABC"])

        #expect(tap.simulatorTarget.deviceSetPath == nil)
    }

    @Test("A missing value is rejected")
    func missingValue() {
        #expect(throws: (any Error).self) {
            try ListSimulators.parse(["--device-set"])
        }
    }

    @Test("Commands carry the device set with the simulator")
    func simulatorTarget() throws {
        let tap = try Tap.parse(["--id", "ok", "--udid", "ABC", "--device-set", "/set"])

        #expect(tap.simulatorTarget.udid == "ABC")
        #expect(tap.simulatorTarget.deviceSetPath == "/set")
    }

    @Test("simctl runs on the target's device set")
    func simctlArguments() {
        #expect(SimulatorTarget(udid: "ABC").simctlArguments == ["simctl"])
        #expect(
            SimulatorTarget(udid: "ABC", deviceSetPath: "/set").simctlArguments
                == ["simctl", "--set", "/set"]
        )
    }

    @Test("The HID broker gets the device set")
    func brokerArguments() {
        #expect(
            HIDBroker.brokerArguments(SimulatorTarget(udid: "ABC"))
                == ["hid-broker", "--udid", "ABC"]
        )
        #expect(
            HIDBroker.brokerArguments(SimulatorTarget(udid: "ABC", deviceSetPath: "/set"))
                == ["hid-broker", "--udid", "ABC", "--device-set", "/set"]
        )
    }
}
