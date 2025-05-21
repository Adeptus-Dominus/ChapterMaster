; CM Testing Framework (AutoHotkey v2)
; This framework provides the foundation for automated testing of the CM application

#Requires AutoHotkey v2.0
#SingleInstance Force

class CMTestingFramework {
    ; Configuration

    __New() {
        this.appPath := "D:\Documents\ChapterMaster\ChapterMaster.exe" ; Path to compiled ChapterMaster.exe file to run tests against
        this.screenshotDir := A_ScriptDir "\screenshots\" ; Not in use yet
        this.logDir := A_ScriptDir "\logs\" ; Stores all the framework logs and errors produced by the test runner
        this.resultDir := A_ScriptDir "\results\" ; Stores all test results
        this.appDataPath := "C:\Users\" . A_UserName . "\AppData\Local\ChapterMaster" ; The base path to CM user folder for saves, logs etc
        this.errorLogPath := this.appDataPath . "\Logs" ; ChapterMaster logs and error files
        this.savesPath := this.appDataPath . "\Save Files" ; ChapterMaster saves
        this.savesIniPath := this.appDataPath . "\saves.ini" ; ChapterMaster save stats
        this.gameStatsIniPath := this.appDataPath . "\gamestats.ini" ; Can be created by running the cheat code 'dumpstats' ingame, helpful for checking ingame values with the test runner
        this.testSettingsPath := this.appDataPath . "\testing_options.ini" ; Configuration for this CMTestingFramework app, use to override certain settings per-developer/tester
        
        this.mouseSpeed := 8  ; 1-10, with 10 being slowest (more human-like)
        this.keypressDelay := 50 ; number of milliseconds between keypresses when typing with .Send(text). 
        
        ; State tracking
        this.currentTest := ""
        this.testSteps := []
        this.testResult := ""
        this.testStartTime := 0
        this.testEndTime := 0
        ; Ensure directories exist
        DirCreate(this.screenshotDir)
        DirCreate(this.logDir)
        DirCreate(this.resultDir)


        if(FileExist(this.testSettingsPath)){
            prev_path := this.appPath
            this.appPath := IniRead(this.testSettingsPath, "Config", "app_path", prev_path)
        }

        ; UI Coordinate helpers
        this.UIMap := CMUIMap()

        ; Initialize error handling
        OnError(ObjBindMethod(this, "ErrorHandler"))
    }

    ; Start CM application
    LaunchApp() {
        try {
            Run(this.appPath)
            WinWait("ahk_exe " . this.appPath)
            this.LogStep("Application launched successfully")
            return true
        } catch as e {
            this.LogError("Failed to launch application: " . e.Message)
            return false
        }
    }

    CloseApp() {
        try {
            WinClose("ahk_exe " . this.appPath)
            if(WinWaitClose("ahk_exe " . this.appPath, , 5) == 1){
                return true
            } else {
                this.LogError("Timeout while waiting to close app")
                return false
            }
        } catch as e {
            this.LogError("Failed to properly close application: " . e.Message)
            return false
        }
    }

    ; Start a new test
    StartTest(testName) {
        this.currentTest := testName
        this.testSteps := []
        this.testResult := ""
        this.testStartTime := A_Now

        this.LogStep("Starting test: " . testName)
        return this
    }

    ; End current test and save results
    EndTest(status := "Success") {
        this.testEndTime := A_Now
        duration := DateDiff(this.testEndTime, this.testStartTime, "Seconds")

        this.LogStep("Test completed in " . duration . " seconds")

        ; Create test result report
        result := "# Test Report: " . this.currentTest . "`n"
        result .= "* Date: " . FormatTime(A_Now, "yyyy-MM-dd") . "`n"
        result .= "* Time: " . FormatTime(A_Now, "HH:mm:ss") . "`n"
        result .= "* Duration: " . duration . " seconds`n"
        result .= "* Status: " . status . "`n`n"
        result .= "## Test Steps:`n"

        for step in this.testSteps {
            result .= "* " . step . "`n"
        }

        ; Save test result to file
        fileName := this.resultDir . FormatTime(A_Now, "yyyyMMdd_HHmmss") . "_" . this.currentTest . ".md"
        try {
            f := FileOpen(fileName, "w").Write(result)
            f.Close()
            this.testResult := result
            this.CloseApp()
            return true
        } catch as e {
            this.LogError("Failed to save test results: " . e.Message)
            this.CloseApp()
            return false
        }

    }

    ; Log a test step
    LogStep(description) {
        timestamp := FormatTime(A_Now, "HH:mm:ss")
        step := timestamp . " - " . description
        this.testSteps.Push(step)
        FileAppend(step . "`n", this.logDir . "test_log.txt")
        return this
    }

    ; Log an error
    LogError(errorMsg) {
        timestamp := FormatTime(A_Now, "HH:mm:ss")
        errorStep := timestamp . " - ERROR: " . errorMsg
        this.testSteps.Push(errorStep)
        FileAppend(errorStep . "`n", this.logDir . "error_log.txt")
        return this
    }

    ; Mouse Simulation Functions

    ; Move mouse in a human-like manner
    MoveMouse(x, y) {
        MouseMove(x, y, this.mouseSpeed)
        this.LogStep("Mouse moved to coordinates: " . x . ", " . y)
        return this
    }

    ; Click at current position or specified coordinates
    Click(x := "", y := "", button := "left") {
        if (x != "" && y != "") {
            this.MoveMouse(x, y)
            Sleep(100)
        }

        ; GameMaker behaves a lil funky with the instant clicks of AHK and sometimes they dont register
        Click(button, 'D')
        Sleep(30)
        Click(button, 'U')
        this.LogStep("Mouse " . button . "-clicked at current position")

        if (!this.CheckForCrash())
            return this

    }

    ; Double-click at current position or specified coordinates
    DoubleClick(x := "", y := "", button := "left") {
        if (x != "" && y != "") {
            this.MoveMouse(x, y)
        }

        Click(button " Double")
        this.LogStep("Mouse double-" . button . "-clicked at current position")

        if (!this.CheckForCrash())
            return this
    }

    ; Drag mouse from one position to another
    DragMouse(x1, y1, x2, y2, button := "left") {
        this.MoveMouse(x1, y1)
        MouseClickDrag(button, x1, y1, x2, y2, this.mouseSpeed)
        this.LogStep("Mouse dragged from " . x1 . ", " . y1 . " to " . x2 . ", " . y2)

        if (!this.CheckForCrash())
            return this
    }

    ; Keyboard Simulation Functions

    ; Send text (typing)
    SendText(text) {
        SetKeyDelay(this.keypressDelay)
        SendEvent(text)
        this.LogStep("Text sent: " . text)

        if (!this.CheckForCrash())
            return this
    }

    ; Send keyboard combo (like Ctrl+S)
    SendCombo(keys) {
        Send(keys)
        this.LogStep("Key combination sent: " . keys)

        if (!this.CheckForCrash())
            return this
    }

    ; Press and hold a key
    KeyDown(key) {
        Send("{" . key . " down}")
        this.LogStep("Key down: " . key)
        if (!this.CheckForCrash())
            return this
    }

    ; Release a key
    KeyUp(key) {
        Send("{" . key . " up}")
        this.LogStep("Key up: " . key)
        if (!this.CheckForCrash())
            return this
    }

    ; Wait for specified milliseconds
    Wait(ms) {
        Sleep(ms)
        this.LogStep("Waited for " . ms . " ms")
        if (!this.CheckForCrash())
            return this
    }

    ; Wait for specified seconds
    WaitSeconds(secs) {
        ms := secs * 1000
        return this.Wait(ms)
    }

    ; Screenshot Functions

    ; Take a screenshot of the current window
    ; !!! NOT IMPLEMENTED
    ; TakeScreenshot(description := "") {
    ;     if (description == "")
    ;         description := "screenshot"

    ;     ; Create filename with timestamp
    ;     filename := FormatTime(A_Now, "yyyyMMdd_HHmmss") . "_" . this.currentTest . "_" . description . ".png"
    ;     path := this.screenshotDir . filename

    ;     try {
    ;         ; Capture active window
    ;         WinGetPos(&x, &y, &w, &h, "A")
    ;         screenshot := Gui()
    ;         screenshot.Add("Picture", "w" . w . " h" . h, path)
    ;         WinCapture(x, y, w, h, path)

    ;         this.LogStep("Screenshot saved: " . filename)
    ;         return path
    ;     } catch as e {
    ;         this.LogError("Failed to take screenshot: " . e.Message)
    ;         return ""
    ;     }
    ; }

    ; Error Handling Functions

    ; Check if application is still running
    IsAppRunning() {
        return WinExist("ahk_exe " . this.appPath)
    }

    ; Check for application crash
    CheckForCrash() {
        if (!this.IsAppRunning()) {
            this.LogError("Application crashed during " . this.currentTest)
            this.ReadErrorLogs()
            this.EndTest("Failure")
            return true
        } else if(this.CheckForCrashDialog()) {
            this.LogError("Crash dialog detected via window class")
            this.ReadErrorLogs()
            this.CloseDialog()
            this.EndTest("Failure")
            return true
        }
        return false
    }

    CheckForCrashDialog() {
        ; Check if any dialog from the app exists with specific window class
        if (WinExist("ahk_exe " . this.appPath . " ahk_class #32770")) {  ; #32770 is common for dialogs
            return true
        }
        return false
    }

    CloseDialog() {
        ; Check if any dialog from the app exists with specific window class
        if (WinExist("ahk_exe " . this.appPath . " ahk_class #32770")) {  ; #32770 is common for dialogs
            WinClose("ahk_exe " . this.appPath . " ahk_class #32770")
            WinWaitClose("ahk_exe " . this.appPath . " ahk_class #32770")
        }
        return 
    }

    ; Read error logs after crash
    ReadErrorLogs() {
        try {
            ; Find the most recent error log
            ; errorLogFiles := []
            
            latestFile := {path: "", time: 0}
            loop files, this.errorLogPath . "\*_error.log" {
                if(latestFile.time < A_LoopFileTimeModified){
                    latestFile.path := A_LoopFileFullPath
                    latestFile.time := A_LoopFileTimeModified
                }
            }

            if (latestFile.time > 0) {
                latestLog := latestFile.path
                logContent := FileRead(latestLog)

                ; Extract relevant information
                this.LogStep("Error log found: " . latestLog)
                this.LogError("Error log content: " . SubStr(logContent, 1, 1000) . (StrLen(logContent) > 1000 ? "..." :
                    ""))

                ; Save error log with test results
                FileCopy(latestLog, this.resultDir . FormatTime(A_Now, "yyyyMMdd_HHmmss") . "_error.log")
            } else {
                this.LogError("No error logs found in " . this.errorLogPath)
            }
        } catch as e {
            this.LogError("Failed to read error logs: " . e.Message)
        }
    }

    ; !NOT IMPLEMENTED
    ; ReadSaveFile(slot := 1) {
    ;     saveFile := this.savesPath . "\save" . slot . ".json"
    ;     saveFileString := FileRead(saveFile)

    ;     FileCopy(saveFile, this.resultDir . FormatTime(A_Now, "yyyyMMdd_HHmmss") . "_savefile.json")
    ;     saveObject := JSON.parse(saveFileString, false, false)
    ;     return saveObject.Save
    ; }

    ; General error handler
    ErrorHandler(exception, mode) {
        this.LogError("Framework error: " . exception.Message)
        ; this.TakeScreenshot("framework_error")
        return true  ; Continue running
    }

    ; Restart the application
    RestartApp() {
        if (this.IsAppRunning()) {
            WinClose("ahk_exe " . this.appPath)
            WinWaitClose("ahk_exe " . this.appPath, , 5)
        }

        return this.LaunchApp()
    }


    ; Click on an element based on its name in CMUIMap
    ; framework.ClickElement("MainMenu.NewGame")
    ClickElement(elementPath) {
        element := this.UIMap.GetElement(elementPath)
        if (element) {
            this.Click(element.x, element.y)
            this.LogStep("Clicked element: " . elementPath)
            return this
        } else {
            this.LogError("Element not found: " . elementPath)
            return this
        }
    }

    MoveToElement(elementPath) {
        element := this.UIMap.GetElement(elementPath)
        if (element) {
            this.MoveMouse(element.x, element.y)
            this.LogStep("Moved to element: " . elementPath)
            return this
        } else {
            this.LogError("Element not found: " . elementPath)
            return this
        }
    }

    ; Element Discovery Tool
    DiscoverUIElements() {
        ; Create a GUI
        discoveryGui := Gui(, "UI Element Discovery Tool")
        discoveryGui.Add("Text", , "Press F7 to capture mouse position")
        discoveryGui.Add("Text", "vCoordinates w200 h20", "X: 0, Y: 0")
        discoveryGui.Add("Text", , "Section Name:")
        ; Should match CMUIMap top level sections
        discoveryGui.Add("DropDownList", "vSectionName w150", ["MainMenu", "Creation", "GameScreen", "InGameMenu", "SaveMenu", "LoadMenu", "Apothecarium", "Armamentarium", "Fleet", "Diplomacy"])
        discoveryGui.Add("Text", , "Element Name:")
        discoveryGui.Add("Edit", "vElementName w150")
        discoveryGui.Add("Button", "Default", "Save").OnEvent("Click", SavePosition)
        discoveryGui.Show()

        ; Set up hotkey
        Hotkey("F7", CapturePosition)

        CapturePosition(*) {
            MouseGetPos(&x, &y)
            discoveryGui["Coordinates"].Value := "{x: " . x . ", y: " . y . "}"
        }

        SavePosition(*) {
            ; MouseGetPos(&x, &y)
            sectionName := discoveryGui["SectionName"].Value
            elementName := discoveryGui["ElementName"].Value

            if (sectionName && elementName) {
                ; Append to UI map file
                FileAppend("this." . sectionName . "." . elementName . " := " . discoveryGui["Coordinates"].Value . "`n",
                    A_ScriptDir . "\ui_elements.txt")
                MsgBox("Saved " . sectionName . "." . elementName . " at " . discoveryGui["Coordinates"].Value)
            } else {
                MsgBox("Please enter both section and element names")
            }
        }
    }

    ;;; This section contains some snippets of common things to quickly get a test running

    ; Quick start new game as given chapter
    ; chapterName must have coords registered in CMUIMap already
    StartGameAs(chapterName := ""){
        if(chapterName == ""){
            this.LogError("No chapter name provided to StartGameAs")
            return false
        }

        this.Wait(7000)
        .ClickElement("MainMenu.NewGame")  
        .Wait(8500)
        .ClickElement("Creation." . chapterName)  
        .Wait(3000)
        .ClickElement("Creation.SkipArrow")
        .Wait(4000)
        .Click(500, 400)
        .Click(500, 400)
        .Click(500, 400)
        .Click(500, 400)
        .Click(500, 400)
        .Wait(1000)
        return this
    }

    ; Need to make sure save slots 1 2 and 3 are registered in CMUIMap
    SaveGameToSlot(slotNum := "1"){
        this.ClickElement("GameScreen.Menu")
        .ClickElement("InGameMenu.Save")
        .ClickElement("SaveMenu.SaveSlot" . slotNum)
        return this
    }

    ; must be called from the normal game screen
    DumpGameStats(){
        this.SendText("p")
        .WaitSeconds(1)
        .SendText("dumpstats")
        .WaitSeconds(1)
        .SendCombo("{enter}")

        return this
    }

    ; Copy gamestats.ini to the test results folder so that they can be inspected upon failure
    CopyGameStats(){
        FileCopy(this.gameStatsIniPath, this.resultDir . FormatTime(A_Now, "yyyyMMdd_HHmmss") . "_gamestats.ini")
    }
}

; This class stores xy coordinates for common game elements and buttons
; All coordinates assume a game size of 1280x720
class CMUIMap {
    ; Add to this list when a new category of ui elements is wanted
    __Init(){
        this.MainMenu := {}
        this.Creation := {}
        this.GameScreen := {}
        this.InGameMenu := {}
        this.SaveMenu := {}
        this.LoadMenu := {}
        this.ChapterManagement := {}
        this.Apothecarium := {}
        this.Armamentarium := {}
        this.Fleet := {}
        this.Diplomacy := {}
    }

    ; To populate new coords, use DiscoverUIElements.ahk, see HowToUse.md for instructions
    __New() {
        this.MainMenu.NewGame := { x: 629, y: 422 }
        this.MainMenu.LoadGame := { x: 625, y: 452 }
        this.MainMenu.Options := { x: 634, y: 487 }
        this.MainMenu.Exit := { x: 634, y: 522 }
        this.Creation.DarkAngels := { x: 371, y: 155 }
        this.Creation.BlackTemplars := { x: 388, y: 248 }
        this.Creation.CustomSlot1 := { x: 373, y: 422 }
        this.Creation.Deathwatch := { x: 539, y: 517 }
        this.Creation.Lamenters := { x: 546, y: 249 }
        this.Creation.AngryMarines := { x: 373, y: 524 }
        this.Creation.CreateCustom := { x: 625, y: 519 }
        this.Creation.CreateRandom := { x: 679, y: 521 }
        this.Creation.NextArrow := { x: 760, y: 631 }
        this.Creation.BackArrow := { x: 523, y: 639 }
        this.Creation.SkipArrow := { x: 822, y: 635 }
        this.Creation.AdvSlot1 := { x: 369, y: 479 }
        this.Creation.DisadvSlot1 := { x: 680, y: 481 }
        this.Creation.Homeworld := { x: 430, y: 203 }
        this.Creation.FleetBased := { x: 630, y: 202 }
        this.Creation.Penitent := { x: 778, y: 201 }
        this.Creation.Leader := { x: 388, y: 581 }
        this.Creation.Champion := { x: 584, y: 583 }
        this.Creation.Psyker := { x: 775, y: 582 }
        this.Creation.StrengthUp := { x: 388, y: 273 }
        this.Creation.StrengthDown := { x: 363, y: 276 }
        this.Creation.CooperationUp := { x: 391, y: 321 }
        this.Creation.CooperationDown := { x: 359, y: 321 }
        this.Creation.PurityUp := { x: 390, y: 367 }
        this.Creation.PurityDown := { x: 356, y: 364 }
        this.Creation.StabilityUp := { x: 388, y: 405 }
        this.Creation.StabilityDown := { x: 367, y: 407 }
        this.Creation.Obliterated := { x: 384, y: 416 }
        this.GameScreen.ChapterManagement := { x: 95, y: 686 }
        this.GameScreen.ChapterSettings := { x: 197, y: 687 }
        this.GameScreen.Apothecarium := { x: 342, y: 688 }
        this.GameScreen.Reclusium := { x: 414, y: 690 }
        this.GameScreen.Librarium := { x: 518, y: 690 }
        this.GameScreen.Armamentarium := { x: 610, y: 693 }
        this.GameScreen.Recruitment := { x: 705, y: 689 }
        this.GameScreen.Fleet := { x: 792, y: 692 }
        this.GameScreen.Diplomacy := { x: 952, y: 691 }
        this.GameScreen.EventLog := { x: 1075, y: 683 }
        this.GameScreen.EndTurn := { x: 1190, y: 690 }
        this.GameScreen.Help := { x: 1139, y: 27 }
        this.GameScreen.Menu := { x: 1226, y: 25 }
        this.InGameMenu.Save := { x: 745, y: 231 }
        this.InGameMenu.Load := { x: 753, y: 298 }
        this.InGameMenu.Options := { x: 750, y: 363 }
        this.InGameMenu.Exit := { x: 749, y: 422 }
        this.InGameMenu.Return := { x: 746, y: 551 }
        this.SaveMenu.SaveSlot1 := { x: 1109, y: 362 }
        this.LoadMenu.LoadSlot1 := { x: 1109, y: 362 }
        this.LoadMenu.LoadAutosave := { x: 1127, y: 241 }
        this.ChapterManagement.Headquarters := { x: 632, y: 173 }
        this.ChapterManagement.Company1 := { x: 79, y: 419 }
        this.ChapterManagement.Company10 := { x: 1189, y: 362 }
        this.ChapterManagement.Company5 := { x: 575, y: 378 }
        this.ChapterManagement.SquadView := { x: 862, y: 137 }
        this.ChapterManagement.ShowProfile := { x: 979, y: 134 }
        this.ChapterManagement.SelectAll := { x: 870, y: 502 }
        this.Apothecarium.AddTestSlave := { x: 370, y: 642 }
        this.Armamentarium.EnterForge := { x: 495, y: 322 }
        this.Armamentarium.Equipment := { x: 816, y: 67 }
        this.Armamentarium.Armour := { x: 898, y: 64 }
        this.Armamentarium.Vehicles := { x: 1002, y: 72 }
        this.Armamentarium.Ships := { x: 1218, y: 70 }
        this.Fleet.ShipSlot1 := { x: 882, y: 93 }
        this.Diplomacy.ImperiumAudience := { x: 244, y: 275 }
        this.Diplomacy.MechanicusAudience := { x: 235, y: 385 }
        this.Diplomacy.MeetChaosEmmisary := { x: 691, y: 189 }


        ; Add more sections and elements as needed
    }

    ; Get element coordinates by path (e.g., "MainMenu.NewGame")
    GetElement(path) {
        parts := StrSplit(path, ".")
        if (parts.Length != 2)
            return false

        section := parts[1]
        element := parts[2]

        if (this.HasOwnProp(section)) {
            sectionObj := this.%section%
            if (sectionObj.HasOwnProp(element))
                return sectionObj.%element%
        }
        return false
    }
}
