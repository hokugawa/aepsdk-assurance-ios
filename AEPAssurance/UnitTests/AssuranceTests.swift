/*
 Copyright 2021 Adobe. All rights reserved.
 This file is licensed to you under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License. You may obtain a copy
 of the License at http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software distributed under
 the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
 OF ANY KIND, either express or implied. See the License for the specific language
 governing permissions and limitations under the License.
 */

@testable import AEPAssurance
@testable import AEPCore
@testable import AEPServices
import Foundation
import XCTest

class AssuranceTests: XCTestCase {

    let runtime = TestableExtensionRuntime()
    let mockUIService = MockUIService()
    let mockDataStore = MockDataStore()
    let mockMessage = MockFullscreenMessage()
    var assurance: Assurance!

    override func setUp() {
        ServiceProvider.shared.uiService = mockUIService
        ServiceProvider.shared.namedKeyValueService = mockDataStore
        mockUIService.fullscreenMessage = mockMessage
        assurance = Assurance(runtime: runtime)
        assurance.onRegistered()
    }

    override func tearDown() {
        runtime.reset()
    }

    /*--------------------------------------------------
     startSession
     --------------------------------------------------*/
    func test_startSession() throws {
        // setup
        let eventData = [AssuranceConstants.EventDataKey.START_SESSION_URL: "griffon://?adb_validation_sessionid=28f4a622-d34f-4036-c81a-d21352144b57&env=stage"]
        let event = Event(name: "Test Request Identifiers",
                          type: AssuranceConstants.SDKEventType.ASSURANCE,
                          source: EventSource.requestContent,
                          data: eventData)

        // test
        runtime.simulateComingEvent(event: event)

        // verify
        XCTAssertTrue(mockUIService.createFullscreenMessageCalled)
        XCTAssertTrue(mockMessage.showCalled)

        // verify that sessionID and environment are set in datastore
        XCTAssertEqual("28f4a622-d34f-4036-c81a-d21352144b57", mockDataStore.dict[AssuranceConstants.DataStoreKeys.SESSION_ID] as! String)
        XCTAssertEqual("stage", mockDataStore.dict[AssuranceConstants.DataStoreKeys.ENVIRONMENT] as! String)

        // verify the local variables
        XCTAssertEqual("28f4a622-d34f-4036-c81a-d21352144b57", assurance.sessionId)
        XCTAssertEqual(AssuranceEnvironment.stage, assurance.environment)
    }

    func test_startSession_withNonUUIDSessionID() throws {
        // setup
        let eventData = [AssuranceConstants.EventDataKey.START_SESSION_URL: "griffon://?adb_validation_sessionid=nonUUID&env=stage"]
        let event = Event(name: "Test Request Identifiers",
                          type: AssuranceConstants.SDKEventType.ASSURANCE,
                          source: EventSource.requestContent,
                          data: eventData)

        // test
        runtime.simulateComingEvent(event: event)

        // verify
        verify_PinCodeScreen_isNotShown()
        verify_sessionIdAndEnvironmentId_notSetInDatastore()
    }

    func test_startSession_withInvalidDeeplink() throws {
        // setup
        let eventData = [AssuranceConstants.EventDataKey.START_SESSION_URL: ""]
        let event = Event(name: "Test Request Identifiers",
                          type: AssuranceConstants.SDKEventType.ASSURANCE,
                          source: EventSource.requestContent,
                          data: eventData)

        // test
        runtime.simulateComingEvent(event: event)

        // verify
        verify_PinCodeScreen_isNotShown()
        verify_sessionIdAndEnvironmentId_notSetInDatastore()
    }

    func test_startSession_withNilEventData() throws {
        // setup
        let event = Event(name: "Test Request Identifiers",
                          type: AssuranceConstants.SDKEventType.ASSURANCE,
                          source: EventSource.requestContent,
                          data: nil)

        // test
        runtime.simulateComingEvent(event: event)

        // verify
        verify_PinCodeScreen_isNotShown()
        verify_sessionIdAndEnvironmentId_notSetInDatastore()
    }

    // MARK: Private methods
    private func verify_PinCodeScreen_isNotShown() {
        XCTAssertFalse(mockUIService.createFullscreenMessageCalled)
        XCTAssertFalse(mockMessage.showCalled)
    }

    private func verify_sessionIdAndEnvironmentId_notSetInDatastore() {
        // verify that sessionID and environment are set in datastore
        XCTAssertNil(mockDataStore.dict[AssuranceConstants.DataStoreKeys.SESSION_ID] ?? nil)
        XCTAssertNil(mockDataStore.dict[AssuranceConstants.DataStoreKeys.ENVIRONMENT] ?? nil)
    }
}