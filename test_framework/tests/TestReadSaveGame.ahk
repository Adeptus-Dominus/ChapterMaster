; This test case demonstrates how to use the CMTestingFramework

#Requires AutoHotkey v2.0
#Include ..\CMTestingFramework.ahk

TestSaveGame() {
    ; Initialize testing framework
    framework := CMTestingFramework()
    framework.StartTest("LamentersStartStats")
    status := "Success"

    ; Launch CM application
    if (!framework.LaunchApp()) {
        MsgBox("Failed to launch application")
        return
    }
    
    framework.StartGameAs("Lamenters")
    .DumpGameStats()
    .Wait(1000)

    requisition := IniRead(framework.gameStatsIniPath, "Resources", "requisition")

    if (Integer(requisition) > 500) {
        framework.LogStep("Step Failed: Requisition should be 500 for Lamenters")
        status := "Failure"
    } else {
        framework.LogStep("Requisition matched expected value")
    }

    coy_5_marines := IniRead(framework.gameStatsIniPath, "Marines.Coy5", "total")

    if (Integer(coy_5_marines) > 0) {
        framework.LogStep("Step Failed: Lamenters should not have any marines in company 5")
        status := "Failure"
    } else {
        framework.LogStep("Coy 5 marines matched expected value")
    }

    if(status == "Failure"){
        framework.CopyGameStats()
    }

    ; End test and save results
    framework.EndTest(status)
}

; Run the test
TestSaveGame()