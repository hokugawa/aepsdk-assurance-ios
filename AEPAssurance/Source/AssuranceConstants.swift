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

import Foundation

enum AssuranceConstants {
    static let EXTENSION_NAME = "com.adobe.assurance"
    static let FRIENDLY_NAME = "Assurance"
    static let EXTENSION_VERSION = "2.0.0"
    static let LOG_TAG = FRIENDLY_NAME

    static let BASE_SOCKET_URL = "wss://connect%@.griffon.adobe.com/client/v1?sessionId=%@&token=%@&orgId=%@&clientId=%@"

    enum Deeplink {
        static let SESSIONID_KEY = "adb_validation_sessionid"
        static let ENVIRONMENT_KEY = "env"
    }

    enum SharedStateName {
        static let CONFIGURATION = "com.adobe.module.configuration"
    }

    enum Vendor {
        static let MOBILE = "com.adobe.griffon.mobile"
        static let SDK = "com.adobe.marketing.mobile.sdk"
    }

    enum SDKEventType {
        static let ASSURANCE = "com.adobe.eventType.assurance"
    }

    enum EventDataKey {
        static let START_SESSION_URL = "startSessionURL"
        static let CONFIG_ORG_ID = "experienceCloud.org"
    }

    enum DataStoreKeys {
        static let SESSION_ID = "assurance.session.Id"
        static let CLIENT_ID = "assurance.client.Id"
        static let ENVIRONMENT = "assurance.environment"
    }

    enum SharedStateKeys {
        static let CLIENT_ID = "sessionid"
        static let SESSION_ID = "clientid"
        static let INTEGRATION_ID = "integrationid"
    }

    enum EventType {
        static let GENERIC = "generic"
        static let LOG = "log"
        static let CONTROL = "control"
        static let CLIENT = "client"
        static let BLOB = "blob"
    }

    enum PayloadKey {
        static let SHAREDSTATE_DATA = "state.data"
        static let XDM_SHAREDSTATE_DATA = "xdm.state.data"
        static let METADATA = "metadata"
        static let TYPE = "type"
        static let DETAIL = "detail"
    }

    enum HTMLURLPath {
        static let CANCEL   = "cancel"
        static let CONFIRM  = "confirm"
    }

}

enum AssuranceSocketError {
    case GENERIC_ERROR
    case NO_ORGID
    case NO_SESSIONID
    case NO_PINCODE
    case ORGID_MISMATCH
    case CONNECTION_LIMIT
    case EVENT_LIMIT
    case CLIENT_ERROR

    var info: (name: String, description: String) {
        switch self {
        case .GENERIC_ERROR:
            return ("Connection Error",
                    "The connection may be failing due to a network issue or an incorrect PIN. Please verify internet connectivity or the PIN and try again.")
        case .NO_SESSIONID:
            return ("Invalid SessionID",
                    "Unable to extract valid Assurance sessionID from deeplink URL. Please retry to connect to session with a valid deeplink URL")
        case .NO_PINCODE:
            return ("HTML Error",
                    "Unable to extract the pincode entered.")
        case .NO_ORGID:
            return ("Invalid Launch & SDK Configuration",
                    "The Experience Cloud Org identifier is unavailable from SDK configuration. Please ensure the Launch mobile property is properly configured.")
        case .ORGID_MISMATCH:
            return ("Unauthorized Access",
                    "AEP Assurance sessions and Launch mobile properties must be created in the same organization.")
        case .CONNECTION_LIMIT:
            return ("Connection Limit Reached",
                    "You have reached the maximum number of connected device allowed to a session. Please disconnect few devices and retry.")
        case .EVENT_LIMIT:
            return ("Event Limit Reached",
                    "You have reached the maximum number of events that can be sent per minute.")
        case .CLIENT_ERROR:
            return ("Client Disconnected",
                    "This client has been disconnected due to an unexpected error. Error Code 4400.")
        }
    }
}
