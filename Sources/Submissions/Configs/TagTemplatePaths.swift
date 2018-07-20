/// Configuration for template paths used when rendering tags.
public struct TagTemplatePaths {
    /// Path to template for input of type "text"
    public let inputField: String
    public let selectField: String
    public let textField: String
    public let checkboxField: String

    /// Create a new TagTemplatePaths configuration value.
    ///
    /// - Parameters:
    ///   - textField: path to template for input of type "input"
    public init(
        inputField: String = "Submissions/Fields/input-field",
        selectField: String = "Submissions/Fields/select-field",
        textField: String = "Submissions/Fields/text-field",
        checkboxField: String = "Submissions/Fields/checkbox-field"
    ) {
        self.inputField = inputField
        self.selectField = selectField
        self.textField = textField
        self.checkboxField = checkboxField
    }
}
