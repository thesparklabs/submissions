import Submissions
import Vapor
import XCTest

final class Todo: Submittable {
    var title: String

    init(_ create: Create) {
        title = create.title
    }

    func update(_ update: Submission) {
        if let title = update.title {
            self.title = title
        }
    }

    struct Submission: SubmissionType {
        var title: String?

    }

    struct Create: Codable {
        var title: String
    }
}

extension Todo.Submission {
    init(_ submittable: Todo?) {
        title = submittable?.title
    }

    func fieldEntries() throws -> [FieldEntry] {
        return try [makeFieldEntry(keyPath: \.title)]
    }
}

final class SubmissionsTests: XCTestCase {
    func testCreateValid() throws {
        let container = BasicContainer(
            config: .init(),
            environment: .testing,
            services: .default(),
            on: EmbeddedEventLoop()
        )
        let req = Request(using: container)
        let create = Todo.Create(title: "title")
        try req.content.encode(create, as: .json)
        let todo = try req.content.decode(Todo.Submission.self).createValid(on: req).wait()
        XCTAssertEqual(todo.title, create.title)
    }
}
