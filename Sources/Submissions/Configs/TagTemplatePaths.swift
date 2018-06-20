/// Configuration for template paths used when rendering tags.
public struct TagTemplatePaths {
    /// Path to template for input of type "text"
    public let inputField: String

    /// Create a new TagTemplatePaths configuration value.
    ///
    /// - Parameters:
    ///   - textField: path to template for input of type "input"
    public init(
        inputField: String = "Submissions/Fields/input-field"
    ) {
        self.inputField = inputField
    }
}
