import Vapor

public protocol Submittable: Decodable {
    associatedtype Submission: SubmissionType where Submission.S == Self
    associatedtype Create: Decodable

    /// Create a new instance from a value of the associated `Create` type.
    ///
    /// - Parameter create: The value with which to create a new instance.
    init(_ create: Create) throws

    /// Updates an existing instance from a value of the associated `Update` type.
    ///
    /// - Parameter update: The value with which to update this instance.
    mutating func update(_ update: Submission) throws
}

extension Future where T: SubmissionType {
    /// Creates a new submittable value based on the submission payload after it is validated.
    ///
    /// - Parameter req: The current `Request`.
    /// - Returns: A `Future` of the submittable value created from the submission payload.
    public func createValid(on req: Request) -> Future<T.S> {
        return validate(inContext: .create, on: req)
            .flatMap { _ in
                try req.content.decode(T.S.Create.self)
            }
            .map(T.S.init)
    }
}

extension Future where T: Submittable {
    /// Updated a submittable value based on the submission payload after it is validated.
    ///
    /// - Parameter req: The current `Request`.
    /// - Returns: A `Future` of the updated submittable value.
    public func updateValid(on req: Request) -> Future<T> {
        return flatMap(to: T.self) { submittable in
            try req.content.decode(T.Submission.self)
                .validate(inContext: .update, on: req)
                .map { submission in
                    var mutableInstance = submittable
                    try mutableInstance.update(submission)
                    return mutableInstance
            }
        }
    }

    /// Convenience for populating the field cache with fields based on the submittable value
    /// produced by this future.
    ///
    /// - Parameter req: The current `Request`.
    /// - Returns: The unchanged submittable value.
    public func populateFields(on req: Request) -> Future<T> {
        return map(to: T.self) { submittable in
            try req.populateFields(with: T.Submission(submittable).makeFields().mapValues(AnyField.init))
            return submittable
        }
    }
}
extension Array {
    public subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
