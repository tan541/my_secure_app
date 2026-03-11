import Cocoa
import SystemExtensions

class AppDelegate: NSObject, NSApplicationDelegate, OSSystemExtensionRequestDelegate {

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSLog("Native Helper: App launched. Starting activation...")
        activateExtension()
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
