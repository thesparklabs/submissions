import Vapor

/// A payload containing fields to use when creating or updating an entity.
public protocol Submission: Decodable, Reflectable {

    /// The field entries (fields with associated keys).
    func fieldEntries() throws -> [FieldEntry<Self>]

    /// An empty initialiser is required for creating the form by type
    init()
}
extension Submission {
    /// Make a field entry corresponding to a key path.
    ///
    /// - Parameters:
    ///   - label: A label describing this field.
    ///   - value: The value for this field.
    ///   - validators: The validators to use when validating the value.
    ///   - asyncValidators: A closure to perform any additional validation that requires async.
    ///     Takes an optional value, a validation context, and a request. See `Field.Validate`.
    ///   - isRequired: Whether or not the value is allowed to be absent.
    ///   - absentValueStrategy: Determines which (string) values to treat as absent.
    ///   - errorOnAbsense: The error to be thrown in the `create` context when value is absent as
    ///     determined by `absentValueStrategy` and `isRequired` is `true`.
    public func makeFieldEntry<T: CustomStringConvertible>(
        keyPath: KeyPath<Self, T>,
        label: String? = nil,
        validators: [Validator<T>] = [],
        asyncValidators: [Field<Self>.Validate<T>] = [],
        isRequired: Bool = true,
        absentValueStrategy: AbsentValueStrategy = .equal(""),
        errorOnAbsense: ValidationError = ValidationError.onEmpty
    ) throws -> FieldEntry<Self> {
        return try .init(
            keyPath: keyPath,
            field: Field(
                label: label,
                value: self[keyPath: keyPath],
                validators: validators,
                asyncValidators: asyncValidators,
                isRequired: isRequired,
                absentValueStrategy: absentValueStrategy,
                errorOnAbsense: errorOnAbsense
            )
        )
    }

    /// Make a field entry corresponding to a key path with an optional value.
    ///
    /// - Parameters:
    ///   - label: A label describing this field.
    ///   - value: The value for this field.
    ///   - validators: The validators to use when validating the value.
    ///   - asyncValidators: A closure to perform any additional validation that requires async.
    ///     Takes an optional value, a validation context, and a request. See `Field.Validate`.
    ///   - isRequired: Whether or not the value is allowed to be absent.
    ///   - absentValueStrategy: Determines which (string) values to treat as absent.
    ///   - errorOnAbsense: The error to be thrown in the `create` context when value is absent as
    ///     determined by `absentValueStrategy` and `isRequired` is `true`.
    public func makeFieldEntry<T: CustomStringConvertible>(
        keyPath: KeyPath<Self, T?>,
        label: String? = nil,
        validators: [Validator<T>] = [],
        asyncValidators: [Field<Self>.Validate<T>] = [],
        isRequired: Bool = true,
        absentValueStrategy: AbsentValueStrategy = .equal(""),
        errorOnAbsense: ValidationError = ValidationError.onEmpty
    ) throws -> FieldEntry<Self> {
        return try .init(
            keyPath: keyPath,
            field: Field(
                label: label,
                value: self[keyPath: keyPath],
                validators: validators,
                asyncValidators: asyncValidators,
                isRequired: isRequired,
                absentValueStrategy: absentValueStrategy,
                errorOnAbsense: errorOnAbsense
            )
        )
    }

    /// Transforms the field entries into a map of keys to fields.
    ///
    /// - Returns: The fields keyed by their corresponding paths
    /// - Throws: When creating the field entries fails.
    func makeFields() throws -> [String: Field<Self>] {
        return try Dictionary(fieldEntries().map { ($0.key, $0.field) }) { $1 }
    }

    /// Validates the fields with their current values using their validators.
    /// When a `SubmissionValidationError` occurs the container is populated with the underlying
    /// validation errors and the fields.
    ///
    /// - Parameters:
    ///   - context: The context (update/create) to respect when validating.
    ///   - submittable: An optional existing related submittable for reference when validating.
    ///   - req: The `Request` with the event loop to validate on and the field cache to store
    ///     any validation errors.
    /// - Returns: A `Future` of `Self`
    /// - Throws: any non-validation related errors that may occur.
    public func validate(
        inContext context: ValidationContext,
        on req: Request
    ) throws -> Future<Self> {
        let fields = try makeFields()

        return try fields
            .compactMap { key, field in
                try field
                    .validate(inContext: context, with: self, on: req)
                    .map { errors in
                        (key, errors)
                    }
            }
            .flatten(on: req)
            .map { errors in
                errors.filter { _, value in !value.isEmpty }
            }
            .map { errors in
                let validationErrors = [String: [ValidationError]](uniqueKeysWithValues: errors)
                if !validationErrors.isEmpty {
                    try req.populateFields(
                        with: fields.mapValues(AnyField.init),
                        andErrors: validationErrors
                    )
                    throw SubmissionValidationError()
                }
                return self
            }
    }

    public func populateFields(on req: Request) throws {
        try req.populateFields(with: self.makeFields().mapValues(AnyField.init))
    }
}

extension ValidationError {
     /// The default error to throw when a value is empty when that is not valid.
     public static var onEmpty: ValidationError {
        return .init("This field is required")
    }
}

extension Future where T: Submission {
    /// Convenience for calling `validate` on submissions produced by this `Future`.
    ///
    /// - Parameters:
    ///   - context: The context (update/create) to respect when validating
    ///   - submittable: An optional existing related submittable for reference when validating.
    ///   - req: The `Request` with the event loop to validate on and the field cache to store
    ///     any validation errors.
    /// - Returns: A `Future` of the `SubmissionType` value.
    public func validate(
        inContext context: ValidationContext,
        on req: Request
    ) -> Future<T> {
        return flatMap { submission in
            try submission.validate(inContext: context, on: req)
        }
    }
}