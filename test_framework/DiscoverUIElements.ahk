; UI Element Discovery Tool
; This test case demonstrates how to use the CMTestingFramework
#Requires AutoHotkey v2.0
#Include CMTestingFramework.ahk

DiscoverUIElementsRunner() {
    ; Initialize testing framework
    framework := CMTestingFramework()

    ; Launch CM application
    if (!framework.LaunchApp()) {
        MsgBox("Failed to launch application")
        return
    }

    framework.DiscoverUIElements()

}

; Run the test
DiscoverUIElementsRunner()
