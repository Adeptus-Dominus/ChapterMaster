; This test case demonstrates how to use the CMTestingFramework

#Requires AutoHotkey v2.0
#Include ..\CMTestingFramework.ahk

TestStartGame() {
    ; Initialize testing framework
    framework := CMTestingFramework()

    ; Start test
    framework.StartTest("StartGame")

    ; Launch CM application
    if (!framework.LaunchApp()) {
        MsgBox("Failed to launch application")
        return
    }

    ; Wait for application to fully load
    framework.StartGameAs("DarkAngels")
    .ClickElement("GameScreen.ChapterManagement")
    .Wait(1000)
    .ClickElement("GameScreen.ChapterSettings")
    .Wait(1000)
    .ClickElement("GameScreen.Fleet")
    .Wait(2000)
    .ClickElement("GameScreen.Fleet")
    .Wait(1000)
    .ClickElement("GameScreen.EndTurn")
    .Wait(2000) ; waiting at the end checks for crashing

    ; End test and save results
    framework.EndTest()
}

; Run the test
TestStartGame()
