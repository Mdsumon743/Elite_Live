import ReplayKit
import ZegoExpressEngine

class SampleHandler: RPBroadcastSampleHandler {

    var isEngineInitialized = false
    let appGroupIdentifier = "group.com.elitelive.morgan.screenshare"

    override func broadcastStarted(withSetupInfo setupInfo: [String : NSObject]?) {
        // Initialize engine in extension
        let profile = ZegoEngineProfile()
        profile.appID = 1071350787
        profile.appSign = "657d70a56532ec960b9fc671ff05d44b498910b5668a1b3f1f1241bede47af71"
        profile.scenario = .broadcast

        ZegoExpressEngine.createEngine(with: profile, eventHandler: nil)

        // Get stream configuration from App Group
        if let userDefaults = UserDefaults(suiteName: appGroupIdentifier) {
            if let roomID = userDefaults.string(forKey: "zegoRoomID"),
               let streamID = userDefaults.string(forKey: "zegoStreamID") {

                // Configure screen capture
                let config = ZegoScreenCaptureConfig()
                config.captureVideo = true
                config.captureAudio = true

                ZegoExpressEngine.shared().startScreenCapture(with: config)
                isEngineInitialized = true

                NSLog("✅ Screen sharing started - Room: \(roomID), Stream: \(streamID)")
            }
        }
    }

    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        guard isEngineInitialized else { return }

        switch sampleBufferType {
        case .video:
            ZegoExpressEngine.shared().sendScreenCaptureVideo(sampleBuffer)
        case .audioApp:
            ZegoExpressEngine.shared().sendScreenCaptureAudio(sampleBuffer, type: .app)
        case .audioMic:
            ZegoExpressEngine.shared().sendScreenCaptureAudio(sampleBuffer, type: .mic)
        @unknown default:
            break
        }
    }

    override func broadcastFinished() {
        ZegoExpressEngine.shared().stopScreenCapture()
        ZegoExpressEngine.destroy(nil)
        isEngineInitialized = false

        // Clear App Group data
        if let userDefaults = UserDefaults(suiteName: appGroupIdentifier) {
            userDefaults.removeObject(forKey: "zegoRoomID")
            userDefaults.removeObject(forKey: "zegoStreamID")
        }

        NSLog("🛑 Screen sharing stopped")
    }
}