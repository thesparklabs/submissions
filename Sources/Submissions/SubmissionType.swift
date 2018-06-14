import Vapor

/// Extension to submission to allow for easy linking between Vapor Models
public protocol SubmissionType: Submission {
    associatedtype S: Submittable

    /// Create a submission value based on an optional `Submittable` value.
    /// Supply a non-nil value when editing an entity to populate a form with its values
    /// Supply `nil` when creating a new entity so only only the fields' labels will be used.
    ///
    /// - Parameter submittable: The value to read the properties from, or nil
    init(_ submittable: S?)
}