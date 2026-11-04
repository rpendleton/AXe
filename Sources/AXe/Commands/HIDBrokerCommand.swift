import ArgumentParser
import Darwin
import FBControlCore

struct HIDBrokerCommand: AsyncParsableCommand {
    // This hidden command is the process entry point used by AXe's HID client. It is an internal
    // implementation detail rather than a supported public CLI command.
    static let configuration = CommandConfiguration(
        commandName: "hid-broker",
        shouldDisplay: false
    )

    @OptionGroup var simulatorTarget: SimulatorTarget

    func run() async throws {
        let endpoint = try HIDBroker.endpointPath(simulatorUDID: simulatorTarget.udid)
        let lifetimeLock = try HIDBroker.acquireLifetimeLock(endpoint: endpoint)
        defer {
            _ = flock(lifetimeLock, LOCK_UN)
            Darwin.close(lifetimeLock)
        }
        let logger = AxeLogger()
        try await setup(logger: logger)
        try await performGlobalSetup(logger: logger)
        try await HIDBroker.serve(simulatorTarget: simulatorTarget, logger: logger)
    }
}
