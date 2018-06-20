import TemplateKit

final class InputTag: TagRenderer {
    enum InputType: String {
        case email = "email"
        case password = "password"
        case text = "text"
    }

    struct InputData: Encodable {
        let key: String
        let type: String
        let value: String?
        let label: String?
        let isRequired: Bool
        let errors: [String]
        let hasErrors: Bool
        let placeholder: String?
        let helpText: String?
    }

    func render(tag: TagContext) throws -> Future<TemplateData> {
        let data = try tag.submissionsData()

        let config = try tag.container.make(SubmissionsConfig.self)
        let renderer = try tag.container.make(TemplateRenderer.self)

        let type = tag.parameters[safe: 1]?.string.flatMap(InputType.init(rawValue:)) ?? .text
        let placeholder = tag.parameters[safe: 2]?.string
        let helpText = tag.parameters[safe: 3]?.string

        //Don't pass back a value for password
        let value:String? = type != .password ? data.value : nil


        let viewData = InputData(
            key: data.key,
            type: type.rawValue,
            value: value,
            label: data.label,
            isRequired: data.isRequired,
            errors: data.errors,
            hasErrors: data.hasErrors,
            placeholder: placeholder,
            helpText: helpText
        )

        return renderer
            .render(config.tagTemplatePaths.inputField, viewData)
            .map { .data($0.data) }
    }
}
