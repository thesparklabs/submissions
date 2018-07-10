import TemplateKit
import AnyCodable

final class SelectTag: TagRenderer {
    func render(tag: TagContext) throws -> Future<TemplateData> {
        let data = try tag.submissionsData()

        let config = try tag.container.make(SubmissionsConfig.self)
        let renderer = try tag.container.make(TemplateRenderer.self)

        let placeholder = tag.parameters[safe: 1]?.string
        let helpText = tag.parameters[safe: 2]?.string

        let viewData = InputData(
            key: data.key,
            type: "select",
            value: data.value,
            label: data.label,
            isRequired: data.isRequired,
            errors: data.errors,
            hasErrors: data.hasErrors,
            placeholder: placeholder,
            helpText: helpText,
            selectValues: data.selectValues
        )

        return renderer
            .render(config.tagTemplatePaths.selectField, viewData)
            .map { .data($0.data) }
    }
}
