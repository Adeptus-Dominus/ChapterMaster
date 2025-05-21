; Executes all test files in the /tests folder which start with "Test"

#Requires AutoHotkey v2.0
#SingleInstance Force

RunAllTests() {
    ; Get the script's directory
    scriptDir := A_ScriptDir

    ; Define the tests directory
    testsDir := scriptDir . "\tests"

    ; Check if the tests directory exists
    if (!DirExist(testsDir)) {
        MsgBox("Tests directory not found: " . testsDir)
        return
    }

    ; Array to hold test results
    testResults := []

    ; Find all .ahk files that begin with "Test"
    testFiles := []
    loop files, testsDir . "\Test*.ahk" {
        testFiles.Push(A_LoopFileFullPath)
    }

    ; Check if any test files were found
    if (testFiles.Length = 0) {
        MsgBox("No test files found starting with 'Test' in: " . testsDir)
        return
    }

    ; Display progress
    MsgBox("Found " . testFiles.Length . " test files. Running tests in sequence...")

    DirCreate(scriptDir . "\tests\results")
    ; Create a log file for results
    logFile := scriptDir . "\tests\results\TestSuiteResults_" . FormatTime(A_Now, "yyyyMMdd_HHmmss") . ".log"
    FileAppend("CM Test Suite Run - " . FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss") . "`n`n", logFile)

    ; Run each test file
    for testFile in testFiles {
        testName := GetFileNameWithoutExtension(testFile)

        FileAppend("Running test: " . testName . "...`n", logFile)

        ; Run the test and wait for it to complete
        RunWait('"' . A_AhkPath . '" "' . testFile . '"')

        ; Test completed
        FileAppend("Completed test: " . testName . "`n`n", logFile)
        testResults.Push({ name: testName, status: "Completed" })
    }

    ; Output summary
    summary := "Test Run Summary:`n"
    for testResult in testResults {
        summary .= testResult.name . ": " . testResult.status . "`n"
    }

    FileAppend("`n" . summary, logFile)
    ; MsgBox("All tests completed. Results saved to: " . logFile)
}

; Helper function to get file name without extension
GetFileNameWithoutExtension(filePath) {
    SplitPath(filePath, &fileName, ,)
    return StrReplace(fileName, ".ahk", "")
}

; Run the function
RunAllTests()