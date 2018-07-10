/// Configuration for template paths used when rendering tags.
public struct TagTemplatePaths {
    /// Path to template for input of type "text"
    public let inputField: String
    public let selectField: String

    /// Create a new TagTemplatePaths configuration value.
    ///
    /// - Parameters:
    ///   - textField: path to template for input of type "input"
    public init(
        inputField: String = "Submissions/Fields/input-field",
        selectField: String = "Submissions/Fields/select-field"
    ) {
        self.inputField = inputField
        self.selectField = selectField
    }
}
