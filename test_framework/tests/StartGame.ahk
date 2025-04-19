; CM Application Test Case: Create New Customer Record
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
    framework.Wait(7000)
    .ClickElement("MainMenu.NewGame")  ; Click on "New Game" in the main menu
    .Wait(8500)
    .ClickElement("Creation.DarkAngels") ; Click Dark Angels
    .Wait(3000)
    .ClickElement("Creation.SkipArrow") 
    .Wait(5000)
    .Click(500, 400)
    .Click(500, 400)
    .Click(500, 400)
    .Click(500, 400)
    .Click(500, 400) ;skip intro sprawl
    .Wait(1000)
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

    MsgBox("Test completed. Results saved to: " . framework.resultDir)
}

; Run the test
TestStartGame()
