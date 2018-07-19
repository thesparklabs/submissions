import TemplateKit
import AnyCodable

final class SelectTag: TagRenderer {
    func render(tag: TagContext) throws -> Future<TemplateData> {
        let data = try tag.submissionsData()

        let config = try tag.container.make(SubmissionsConfig.self)
        let renderer = try tag.container.make(TemplateRenderer.self)

        let placeholder = tag.parameters[safe: 1]?.string
        let helpText = tag.parameters[safe: 2]?.string
        let selectValues = tag.parameters[safe: 3]?.array //Overrides data if present

        var ss:[[String:AnyEncodable]] = []
        // hack [TemplateData] (which, ironically, isn't encodable) into our anyencodable array
        if let vals = selectValues {
            for v in vals {
                if let dd = v.dictionary {
                    var dict:[String:AnyEncodable] = [:]
                    for (key,val) in dd {
                        if let str = val.string {
                            dict[key] = AnyEncodable(str)
                        }
                    }
                    ss.append(dict)
                }
            }
        } else {
            ss = data.selectValues
        }

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
            selectValues: ss,
            attributeExtra: nil
        )

        return renderer
            .render(config.tagTemplatePaths.selectField, viewData)
            .map { .data($0.data) }
    }
}
