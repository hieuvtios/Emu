//
//  RotationTests.swift
//  GameEmulatorUITests
//
//  Created by Claude Code
//  Tests device rotation during gameplay to verify rendering stability
//

import XCTest

final class RotationTests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()

        // Wait for app to load
        _ = app.wait(for: .runningForeground, timeout: 5)
    }

    override func tearDownWithError() throws {
        app.terminate()
        app = nil
    }

    func testDeviceRotationDuringGameplay() throws {
        // Wait for game to start rendering
        Thread.sleep(forTimeInterval: 2.0)

        // Get initial orientation
        let device = XCUIDevice.shared
        let initialOrientation = device.orientation

        // Test rotation sequence: Portrait -> Landscape -> Portrait
        let orientations: [UIDeviceOrientation] = [
            .portrait,
            .landscapeLeft,
            .landscapeRight,
            .portrait
        ]

        for orientation in orientations {
            // Rotate device
            device.orientation = orientation

            // Wait for rotation animation to complete
            Thread.sleep(forTimeInterval: 1.0)

            // Verify app is still running and responsive
            XCTAssertTrue(app.state == .runningForeground,
                         "App should remain in foreground after rotation to \(orientation)")

            // Wait a bit to ensure rendering continues
            Thread.sleep(forTimeInterval: 0.5)
        }

        // Restore original orientation
        device.orientation = initialOrientation

        // Final verification - app should still be running
        XCTAssertTrue(app.state == .runningForeground,
                     "App should still be running after rotation tests")
    }

    func testMultipleRapidRotations() throws {
        // Wait for game to start
        Thread.sleep(forTimeInterval: 1.0)

        let device = XCUIDevice.shared

        // Perform rapid rotations to stress test
        for _ in 0..<3 {
            device.orientation = .landscapeLeft
            Thread.sleep(forTimeInterval: 0.3)

            device.orientation = .portrait
            Thread.sleep(forTimeInterval: 0.3)

            device.orientation = .landscapeRight
            Thread.sleep(forTimeInterval: 0.3)

            device.orientation = .portrait
            Thread.sleep(forTimeInterval: 0.3)
        }

        // Verify app is still stable
        XCTAssertTrue(app.state == .runningForeground,
                     "App should handle rapid rotations without crashing")
    }

    func testRotationWithMenuOpen() throws {
        // Wait for game to start
        Thread.sleep(forTimeInterval: 1.0)

        // Open menu if available
        let menuButton = app.buttons["Menu"]
        if menuButton.exists {
            menuButton.tap()
            Thread.sleep(forTimeInterval: 0.5)
        }

        let device = XCUIDevice.shared

        // Rotate while menu is open
        device.orientation = .landscapeLeft
        Thread.sleep(forTimeInterval: 1.0)

        device.orientation = .portrait
        Thread.sleep(forTimeInterval: 1.0)

        // App should remain stable
        XCTAssertTrue(app.state == .runningForeground,
                     "App should handle rotation with menu open")
    }
}
