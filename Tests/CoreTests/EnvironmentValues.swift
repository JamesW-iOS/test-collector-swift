@testable import Core
import XCTest

final class EnvironmentValuesTests: XCTestCase {
  func testValueDefinitionPrecedence() {
    let values = ["ONE": "VALUES"]
    let processEnvironment = ["ONE": "ENVIRONMENT", "TWO": "ENVIRONMENT"]
    let infoPlist = ["ONE": "INFO PLIST", "TWO": "INFO PLIST", "THREE": "INFO PLIST"]
    let environmentPlist = ["ONE": "ENVIRONMENT PLIST", "TWO": "ENVIRONMENT PLIST", "THREE": "ENVIRONMENT PLIST", "FOUR" : "ENVIRONMENT PLIST"]
    let environment = EnvironmentValues(
      values: values,
      getFromEnvironment: { processEnvironment[$0] },
      getFromInfoDictionary: { infoPlist[$0] },
      getEnvironmentInfoDictionary: { environmentPlist[$0] }
    )
    XCTAssertNil(environment.string(for: "ZERO"))
    XCTAssertEqual(environment.string(for: "ONE"), "VALUES")
    XCTAssertEqual(environment.string(for: "TWO"), "ENVIRONMENT")
    XCTAssertEqual(environment.string(for: "THREE"), "INFO PLIST")
    XCTAssertEqual(environment.string(for: "FOUR"), "ENVIRONMENT PLIST")
  }
}
