import ArgumentParser
import Foundation

enum AXCachePolicy: String, CaseIterable, ExpressibleByArgument {
    case perBatch
    case perStep
    case none
}

enum TypeSubmissionMode: String, CaseIterable, ExpressibleByArgument {
    case chunked
    case composite
}

@MainActor
final class BatchContext {
    let simulatorTarget: SimulatorTarget
    let axCachePolicy: AXCachePolicy
    let typeSubmissionMode: TypeSubmissionMode
    let typeChunkSize: Int
    let tapStyle: TapStyle
    let waitTimeout: TimeInterval
    let pollInterval: TimeInterval

    private var cachedRoots: [AccessibilityElement]?

    init(
        simulatorTarget: SimulatorTarget,
        axCachePolicy: AXCachePolicy,
        typeSubmissionMode: TypeSubmissionMode,
        typeChunkSize: Int,
        tapStyle: TapStyle = .automatic,
        waitTimeout: TimeInterval = 0,
        pollInterval: TimeInterval = 0.25
    ) {
        self.simulatorTarget = simulatorTarget
        self.axCachePolicy = axCachePolicy
        self.typeSubmissionMode = typeSubmissionMode
        self.typeChunkSize = typeChunkSize
        self.tapStyle = tapStyle
        self.waitTimeout = waitTimeout
        self.pollInterval = pollInterval
    }

    func accessibilityRoots(logger: AxeLogger, forceRefresh: Bool = false) async throws -> [AccessibilityElement] {
        switch axCachePolicy {
        case .none:
            return try await AccessibilityFetcher.fetchAccessibilityElements(for: simulatorTarget, logger: logger)
        case .perStep:
            return try await AccessibilityFetcher.fetchAccessibilityElements(for: simulatorTarget, logger: logger)
        case .perBatch:
            if !forceRefresh, let cachedRoots {
                return cachedRoots
            }
            let roots = try await AccessibilityFetcher.fetchAccessibilityElements(for: simulatorTarget, logger: logger)
            cachedRoots = roots
            return roots
        }
    }
}

