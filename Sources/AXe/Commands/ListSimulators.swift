import ArgumentParser
import Foundation
import FBControlCore
import FBSimulatorControl

struct ListSimulators: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Lists all available simulators."
    )

    @Option(name: .customLong("device-set"), help: "A simulator device set other than the default.")
    var deviceSetPath: String?

    func run() async throws {
        let logger = AxeLogger()
        
        try await performGlobalSetup(logger: logger)

        let simulatorSet = try await getSimulatorSet(
            deviceSetPath: deviceSetPath,
            logger: logger,
            reporter: EmptyEventReporter.shared
        )
        
        let simulators = simulatorSet.allSimulators
        simulators.forEach { print($0.description) }
    }
} 
