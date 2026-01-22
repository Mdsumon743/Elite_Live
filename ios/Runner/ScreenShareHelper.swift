import UIKit
import Flutter
import ReplayKit
import ZegoExpressEngine

final class ScreenShareHelper: NSObject {

    static let shared = ScreenShareHelper()
    private override init() {}

    private let appGroupIdentifier = "group.com.elitelive.morgan.screenshare"

    // MARK: - Flutter Method Channel

    func setupMethodChannel(with controller: FlutterViewController) {
        let channel = FlutterMethodChannel(
            name: "com.elitelive.morgan/screenshare",
            binaryMessenger: controller.binaryMessenger
        )

        channel.setMethodCallHandler { [weak self] call, result in
            guard let self = self else { return }

            switch call.method {

            case "startScreenShare":
                guard
                    let args = call.arguments as? [String: Any],
                    let roomID = args["roomID"] as? String,
                    let streamID = args["streamID"] as? String
                else {
                    result(
                        FlutterError(
                            code: "INVALID_ARGS",
                            message: "Missing roomID or streamID",
                            details: nil
                        )
                    )
                    return
                }

                self.startScreenShare(
                    roomID: roomID,
                    streamID: streamID,
                    result: result
                )

            case "stopScreenShare":
                self.stopScreenShare(result: result)

            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }

    // MARK: - Screen Share Start

    private func startScreenShare(
        roomID: String,
        streamID: String,
        result: @escaping FlutterResult
    ) {

        // Save data to App Group for Broadcast Extension
        guard let userDefaults = UserDefaults(suiteName: appGroupIdentifier) else {
            result(
                FlutterError(
                    code: "APP_GROUP_ERROR",
                    message: "Failed to access App Group",
                    details: nil
                )
            )
            return
        }

        userDefaults.set(roomID, forKey: "zegoRoomID")
        userDefaults.set(streamID, forKey: "zegoStreamID")
        userDefaults.synchronize()

        print("✅ App Group saved — Room: \(roomID), Stream: \(streamID)")

        DispatchQueue.main.async {
            guard #available(iOS 12.0, *) else {
                result(
                    FlutterError(
                        code: "VERSION_ERROR",
                        message: "iOS 12 or higher is required",
                        details: nil
                    )
                )
                return
            }

            let picker = RPSystemBroadcastPickerView(
                frame: CGRect(x: 0, y: 0, width: 60, height: 60)
            )

            // ⚠️ MUST match Broadcast Upload Extension bundle ID
            picker.preferredExtension =
                "com.elitelive.morgan.mobileapp.ScreenShareExtension"

            picker.showsMicrophoneButton = false

            guard
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let window = windowScene.windows.first(where: { $0.isKeyWindow }),
                let rootVC = window.rootViewController
            else {
                result(
                    FlutterError(
                        code: "NO_ROOT_VC",
                        message: "Unable to find root view controller",
                        details: nil
                    )
                )
                return
            }

            rootVC.view.addSubview(picker)

            // Programmatically trigger the picker button
            for view in picker.subviews {
                if let button = view as? UIButton {
                    button.sendActions(for: .allTouchEvents)
                }
            }

            // Remove picker after triggering
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                picker.removeFromSuperview()
            }

            print("📺 Screen broadcast picker triggered")
            result(true)
        }
    }

    // MARK: - Screen Share Stop

    private func stopScreenShare(result: @escaping FlutterResult) {

        if let userDefaults = UserDefaults(suiteName: appGroupIdentifier) {
            userDefaults.removeObject(forKey: "zegoRoomID")
            userDefaults.removeObject(forKey: "zegoStreamID")
            userDefaults.synchronize()
        }

        print("🛑 Screen share stopped")
        result(true)
    }
}//
//  ScreenShareHelper.swift
//  Runner
//
//  Created by bdCalling on 21/1/26.
//

