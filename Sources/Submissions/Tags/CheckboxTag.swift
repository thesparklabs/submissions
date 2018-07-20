import TemplateKit
import AnyCodable

final class CheckboxTag: TagRenderer {
    func render(tag: TagContext) throws -> Future<TemplateData> {
        let data = try tag.submissionsData()

        let config = try tag.container.make(SubmissionsConfig.self)
        let renderer = try tag.container.make(TemplateRenderer.self)

        let placeholder = tag.parameters[safe: 1]?.string
        let helpText = tag.parameters[safe: 2]?.string
        let attributeExtra = tag.parameters[safe: 3]?.string

        let viewData = InputData(
            key: data.key,
            type: "checkbox",
            value: data.value,
            label: data.label,
            isRequired: data.isRequired,
            errors: data.errors,
            hasErrors: data.hasErrors,
            placeholder: placeholder,
            helpText: helpText,
            selectValues: data.selectValues,
            attributeExtra: attributeExtra
        )

        return renderer
            .render(config.tagTemplatePaths.checkboxField, viewData)
            .map { .data($0.data) }
    }
}
