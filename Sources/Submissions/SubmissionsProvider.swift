import Leaf
import Service
import Vapor

/// A provider that registers a FieldCache.
public final class SubmissionsProvider: Provider {
    public let config: SubmissionsConfig

    /// Create a new `SubmissionsProvider`.
    public init(config: SubmissionsConfig = .default) {
        self.config = config
    }
    
    /// See `Provider`
    public func register(_ services: inout Services) throws {
        services.register(config)
        services.register { _ in FieldCache() }
    }

    /// See `Provider`
    public func didBoot(_ container: Container) throws -> Future<Void> {
        return .done(on: container)
    }
}

public extension LeafTagConfig {
    public mutating func useSubmissionsLeafTags(on container: Container) throws {
        let config: SubmissionsConfig = try container.make()
        let paths = config.tagTemplatePaths

        use(InputTag(), as: "submissions:input")
        use(SelectTag(), as: "submissions:select")
        use(TextTag(), as: "submissions:text")
        use(CheckboxTag(), as: "submissions:checkbox")
    }
}
