#if os(Linux)

import XCTest
@testable import SubmissionsTests

// sourcery:inline:auto:LinuxMain

extension SubmissionsTests {
    static var allTests = [
        ("testCreateValid", testCreateValid),
    ]
}

XCTMain([
    testCase(SubmissionsTests.allTests),
])

// sourcery:end
#endif