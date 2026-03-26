import Cocoa
import SystemExtensions

class AppDelegate: NSObject, NSApplicationDelegate, OSSystemExtensionRequestDelegate {
    var extensionBundleID = "com.uney.shieldnetdefense.Extension"

    func applicationDidFinishLaunching(_ notification: Notification) {
        parseCommandLineArguments()
        NSLog("Native Helper: App launched. Starting activation...")
        activateExtension()
    }
    
    private func parseCommandLineArguments() {
        let arguments = ProcessInfo.processInfo.arguments
        
        for i in 0..<arguments.count {
            if arguments[i] == "--extension-id", i+1 < arguments.count {
                extensionBundleID = arguments[i+1]
            }
            
            if arguments[i] == "--user-id", i+1 < arguments.count {
                NSLog("Native Helper: Received user-id = %@", arguments[i+1])
                // Store it, write to file, or use it later
            }
            
            if arguments[i] == "--config", i+1 < arguments.count {
                if let data = arguments[i+1].data(using: .utf8),
                   let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    NSLog("Native Helper: Received config: %@", json)
                    // You can store this dictionary for later use
                }
            }
        }
    }

    func activateExtension() {
        // 1. Define the Bundle ID of your Extension target
        let extensionBundleID = "com.uney.shieldnetdefense.Extension"
        
        // 2. Create the activation request
        let request = OSSystemExtensionRequest.activationRequest(forExtensionWithIdentifier: extensionBundleID, queue: .main)
        request.delegate = self
        
        // 3. Submit the request to macOS
        OSSystemExtensionManager.shared.submitRequest(request)
        NSLog("Native Helper: Request submitted for %@", extensionBundleID)
    }

    // MARK: - OSSystemExtensionRequestDelegate

    // This handles upgrades/reinstalls automatically
    func request(_ request: OSSystemExtensionRequest, actionForReplacingExtension existing: OSSystemExtensionProperties, withExtension extension: OSSystemExtensionProperties) -> OSSystemExtensionRequest.ReplacementAction {
        return .replace
    }

    // Called when the user needs to go to System Settings > Privacy & Security
    func requestNeedsUserApproval(_ request: OSSystemExtensionRequest) {
        NSLog("Native Helper: Awaiting user approval in System Settings.")
        // Since the request is now in the OS's hands, we can stay open or
        // let the Electron app handle the "Waiting" UI.
    }

    func request(_ request: OSSystemExtensionRequest, didFinishWithResult result: OSSystemExtensionRequest.Result) {
        NSLog("Native Helper: Extension activated successfully!")
        // Optional: Signal to your Electron app (via a file or socket) that we are done.
        NSApp.terminate(nil)
    }

    func request(_ request: OSSystemExtensionRequest, didFailWithError error: Error) {
        NSLog("Native Helper: Activation failed: \(error.localizedDescription)")
        // Optional: Handle specific error codes (e.g. signature mismatch)
        NSApp.terminate(nil)
    }
}
