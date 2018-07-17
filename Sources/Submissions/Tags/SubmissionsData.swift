import TemplateKit
import AnyCodable

public extension TagContext {
    /// Encapsulates relevant submissions data that can be used for validation output.
    /// For example when rendering the form.
    public struct SubmissionsData {
        let key: String
        let value: String?
        let label: String?
        let isRequired: Bool
        let errors: [String]
        let hasErrors: Bool
        let selectValues: [[String:AnyEncodable]]
    }

    /// Pulls out any relevant submissions data for the given field using the `FieldCache`.
    ///
    /// - Returns: The submission data related to the given field.
    /// - Throws: When the name of the field is missing.
    public func submissionsData() throws -> SubmissionsData {
        let fieldCache = try container.make(FieldCache.self)

        guard let key = parameters[safe: 0]?.string else {
            throw error(reason: "Invalid parameter type.")
        }

        let field = fieldCache[valueFor: key]
        let errors = fieldCache[errorsFor: key]

        return SubmissionsData(
            key: key,
            value: field?.value,
            label: field?.label,
            isRequired: field?.isRequired ?? false,
            errors: errors,
            hasErrors: errors.count > 0,
            selectValues: field?.selectValues ?? []
        )
    }
}
internal struct InputData: Encodable {
    let key: String
    let type: String
    let value: String?
    let label: String?
    let isRequired: Bool
    let errors: [String]
    let hasErrors: Bool
    let placeholder: String?
    let helpText: String?
    let selectValues: [[String:AnyEncodable]]
    let attributeExtra: String?
}

// I don't think this will be required
/*extension AnyCodable: TemplateDataRepresentable {
    public func convertToTemplateData() throws -> TemplateData {
        return .string(description)
    }
}*/
extension Dictionary: TemplateDataRepresentable {
    public func convertToTemplateData() throws -> TemplateData {
        // From swift
        // warning: Swift runtime does not yet support dynamically querying conditional conformance ('Swift.Dictionary<Swift.String, AnyCodable.AnyCodable>': 'TemplateKit.TemplateDataRepresentable')

        // For now, just return an empty dictionary to avoid an error
        return .dictionary([:])
    }
}