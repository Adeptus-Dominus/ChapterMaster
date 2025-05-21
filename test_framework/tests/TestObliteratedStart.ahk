; This test case launches a new custom chapter with the obliterated start

#Requires AutoHotkey v2.0
#Include ..\CMTestingFramework.ahk

TestObliteratedStart() {
    ; Initialize testing framework
    framework := CMTestingFramework()

    ; Start test
    framework.StartTest("ObliteratedStart")

    ; Launch CM application
    if (!framework.LaunchApp()) {
        MsgBox("Failed to launch application")
        return
    }

    ; Wait for application to fully load
    framework.Wait(7000)
    .ClickElement("MainMenu.NewGame")  ; Click on "New Game" in the main menu
    .Wait(8500)
    .ClickElement("Creation.CreateCustom") ; Click Create Custom Chapter
    .Wait(3000)
    .ClickElement("Creation.Homeworld")
    .ClickElement("Creation.PurityUp")
    .ClickElement("Creation.PurityUp")
    .ClickElement("Creation.PurityUp")
    .ClickElement("Creation.PurityUp")
    .ClickElement("Creation.PurityUp")
    .ClickElement("Creation.DisadvSlot1")
    .ClickElement("Creation.Obliterated")
    .ClickElement("Creation.NextArrow").WaitSeconds(2)
    .ClickElement("Creation.NextArrow").WaitSeconds(2)
    .ClickElement("Creation.NextArrow").WaitSeconds(2)
    .ClickElement("Creation.NextArrow").WaitSeconds(2)
    .ClickElement("Creation.NextArrow").WaitSeconds(3)
    .ClickElement("GameScreen.EndTurn")
    .ClickElement("GameScreen.EndTurn")
    .ClickElement("GameScreen.EndTurn")
    .ClickElement("GameScreen.EndTurn")
    .ClickElement("GameScreen.EndTurn")
    .ClickElement("GameScreen.EndTurn")
    .WaitSeconds(1)

    ; End test and save results
    framework.EndTest()
}

; Run the test
TestObliteratedStart()
