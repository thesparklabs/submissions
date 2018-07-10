import AnyCodable

/// A type-erased version of `Field`
public struct AnyField {
    var label: String?
    var value: String?
    var isRequired: Bool
    let selectValues: [[String:AnyEncodable]]

    init<S: Submission>(_ field: Field<S>) {
        self.label = field.label
        self.value = field.value
        self.isRequired = field.isRequired
        self.selectValues = field.selectValues
    }
}
