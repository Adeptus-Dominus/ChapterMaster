; Copy/paste this layout for easy test creation from scratch

#Requires AutoHotkey v2.0
#Include ..\CMTestingFramework.ahk

TestBoilerplate() {
    ; Initialize testing framework
    framework := CMTestingFramework()

    ; Start test
    framework.StartTest("StartGame")

    ; Launch CM application
    if (!framework.LaunchApp()) {
        MsgBox("Failed to launch application")
        return
    }

    ; Write steps here

    ; End test and save results
    framework.EndTest()
}

; Run the test
TestBoilerplate()
