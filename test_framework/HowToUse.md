# Creating Test Cases for CM Using AutoHotkey Testing Framework

This document provides guidance for CM developers on how to create automated test cases using our AutoHotkey v2 testing framework.

## Getting Started

1. **Install Prerequisites**
   - Install AutoHotkey v2 from [https://www.autohotkey.com/](https://www.autohotkey.com/)
   - Ensure you have access to the main CMTestingFramework.ahk file

2. **File Structure**
   - Place your test case scripts in the `tests` folder of the `test_framework` directory in the repo
   - Name your test scripts descriptively (e.g., `TestObliteratedCustomStart.ahk`, `TestMenuChecks.ahk`)
   - Tests file names need to start with `Test` in order to be picked up by the test suite runner that runs all tests together
   - Test filenames and test names and ahk function names dont have to line up, but its easier for everyone if they do
   - Test runner needs to be pointed at a compiled ChapterMaster.exe file, see `CMTestingFramework.appPath`
     - use `testing_options.ini` in the %LocalAppData%/ChapterMaster folder to override the path of the ChapterMaster.exe file for your machine if different

3. **Game Settings**
    - The test runner assumes you are running in **Windowed 720p** in order for pixels to line up.
    - Go to your %LocalAppData%\ChapterMaster folder and open `saves.ini` and look for the [Settings] section
    - If it says "fullscreen", run ChapterMaster and turn off Fullscreen in the options
    - Close ChapterMaster and open `saves.ini` again. You should see 4 numbers separated by `|` pipes. Edit the last 2 to be `1280|720`. The first 2 are just the x,y coordinates of the top left corner of the window on your monitor.

4. **Running Tests individually**
    - Open the repo, go to `test_framework/tests` and open the desired test
    - Easy Method:
        - Ensure you have installed the VSCode extension [AHK++ (AutoHotkey Plus Plus)](https://marketplace.visualstudio.com/items/?itemName=mark-wiemer.vscode-autohotkey-plus-plus)
        - Open the test case file in VSCode (not the framework)
        - Right-click anywhere in the file, select `AHK++ > Run AHK Script`
        - Using this method keeps you in the editor while you're working on your test case
    - AHK native method
        - In the file explorer, right-click your test case .ahk file and select "Run Script" (should be first option)
        - Better for running tests if you're not editing them
    - Results are stored in `test_framework/tests/results` and should be sorted by date
    - Errors caught by the test framework are stored in `test_framework/tests/logs/error_log.txt` which includes both game crashes and errors with the .ahk tests themselves

5. **Running all tests as a Suite**
    - Alongside CMTestingFramework.ahk should be a file **RunAllTests.ahk**. Running this file using the method above will execute all test files in the `tests` folder whose filenames start with "Test"
    - Proper stats on test suite pass/fail/error are wip

## Creating a Basic Test Case

Each test script follows this structure:

```autohotkey
; Test Name: [Test Name]
; Description: [Brief description of what this test does]
; Author: [Your Name]
; Date: [Creation/Last Modified Date]

#Requires AutoHotkey v2.0
#Include ..\CMTestingFramework.ahk

TestMyFeature() {
    ; Initialize framework
    framework := CMTestingFramework()
    
    ; Start test
    framework.StartTest("MyFeatureName")
    
    ; Launch CM application
    if (!framework.LaunchApp()) {
        MsgBox("Failed to launch application")
        return
    }
    
    ; [Your test steps here]
    
    ; End test and save results
    framework.EndTest()
}

; Run the test
TestMyFeature()
```

## Key Framework Methods

Here are the core methods to use in your test cases:

### Setup and Cleanup
- `framework.StartTest("TestName")` - Initialize a test with a name
- `framework.LaunchApp()` - Launch the CM application
- `framework.EndTest()` - Complete the test and save results
- `framework.CloseApp()` - Exit CM but keep the test running until `EndTest()` is called

### Mouse Interaction
The `Click`, `DoubleClick`, and `ClickElement` functions have a small builtin wait timer so that you dont have to call Wait explicitly after every click if you dont actually have to wait for something to happen before moving on.
The property `mouseSpeed` on CMTestingFramework controls how fast the mouse moves. Its default setting is pretty slow, high speeds can cause clicks to not register properly sometimes.
To edit the mouse speed for a single test, you can use the below snippet: 
```autohotkey
framework := CMTestingFramework()
framework.mouseSpeed := 2 ; 1 - 10, 10 being slowest
```
- `framework.Click(x, y, button="left")` - Moves Mouse to and left-Clicks at specific coordinates. 
- `framework.DoubleClick(x, y, button="left")` - Double-click at coordinates
- `framework.MoveMouse(x, y)` - Move mouse to coordinates
- `framework.DragMouse(x1, y1, x2, y2)` - Click and drag from one point to another
- `framework.ClickElement("Section.ElementName")` - Click on a named UI element
- `framework.MoveToElement("Section.ElementName")` - Move mouse to a named UI element

### Keyboard Interaction
The property `keypressDelay` on CMTestingFramework controls how fast each keystroke is sent. Its default setting is pretty average, at 50 milliseconds between keypresses. You can increase or decrease this per test.
`keypressDelay` only affects `SendText()`
To edit the keypress speed for a single test, you can use the below snippet: 
```autohotkey
framework := CMTestingFramework()
framework.keypressDelay := 10 ; number of milliseconds between keypresses when using .SendText()
```

- `framework.SendText("text")` - Type text
- `framework.SendCombo("{Ctrl down}{s}{Ctrl up}")` - Send key combinations
- `framework.KeyDown("key")` and `framework.KeyUp("key")` - Press and release keys

### Premade Step Sequences
- `framework.StartGameAs("ChapterName")` - Opens game, clicks New Game, selects ChapterName, Skips through Creation screen, dismisses intro sprawl
- `framework.SaveToSlot("1")` - Opens the ingame menu and saves the game to the slot specified. Only works for slots 1 - 3
- `framework.DumpGameStats()` - triggers an ingame cheatcode to export some game values to a file called `gamestats.ini` which can be read from to check that ingame values are matching expectations. 
- `framework.CopyGameStats()` - copies the `gamestats.ini` file into the test results folder, which can be handy if you want to manually inspect values after running a test

### Wait and Timing
- `framework.Wait(milliseconds)` - Pause execution for specified time in ms
- `framework.WaitSeconds(seconds)` - Pause execution for specified time in seconds

### Documentation
- `framework.LogStep("description")` - Record a test step with description
- `framework.LogError("description")` - Record a test step error with description. Builtin methods will do this if they fail to perform an action like clicking or if the game crashes.

### Error Handling
- `framework.CheckForCrash()` - Detect if application crashed
- `framework.CheckForCrashDialog()` - Automatically called by `CheckForCrash()`, this method specifically checks if the Crash popup window was created.
- `framework.RestartApp()` - Restart the application after a crash


## Using Named UI Elements

Instead of using raw coordinates, you can reference UI elements by name:

### Using ClickElement and MoveToElement

These methods allow you to interact with UI elements by name rather than remembering coordinates:

```autohotkey
; Click on a button using its name
framework.ClickElement("MainMenu.NewGame")

; Move to an element without clicking
framework.MoveToElement("GameScreen.SaveGame")
```

The format is always `"Section.ElementName"`, where:
- `Section` is a logical grouping of UI elements (e.g., MainMenu, GameScreen, Dialog)
- `ElementName` is the specific element within that section

### Benefits of Using Named Elements

- **Readability**: Tests are more descriptive and easier to understand
- **Maintainability**: If UI coordinates change, you only need to update the UI Map, not each test
- **Consistency**: Ensures the same element is always referenced the same way

### Example with Named Elements

```autohotkey
framework.StartTest("StartGameWithNamedElements")
    .LaunchApp()
    .Wait(7000)
    .ClickElement("MainMenu.NewGame")
    .Wait(8000)
    .ClickElement("Creation.DarkAngels")
    .Wait(3000)
    .ClickElement("Creation.SkipArrow")
    .Wait(2000)
    .EndTest()
```

## Discovering UI Element Coordinates

### Using the DiscoverUIElements Tool

The framework includes a tool to help identify and record UI element coordinates:

1. **Launch the Discovery Tool**
   - Open `DiscoverUIElements.ahk` and run with AHK++ or just run the script from windows explorer

2. **Using the Tool**
   - Position your mouse over a UI element in the CM application
   - Make sure the window is in focus, you can click in the game window to make sure it is
   - Press F7 to capture the current mouse coordinates
   - Enter a Section Name (e.g., "MainMenu")
   - Enter an Element Name (e.g., "NewGameButton")
   - Click "Save"

3. **Finding the Saved Coordinates**
   - The tool saves coordinates to `ui_elements.txt` in your script directory
   - Each entry is formatted for easy pasting into the `CMUIMap` class

4. **After Capturing Elements**
   - Copy the contents of `ui_elements.txt`
   - Add them to the `CMUIMap` class in the appropriate sections
   - Use your newly mapped elements in tests with `ClickElement()` and `MoveToElement()`
   - If you need to create a new Section, you need to update `CMTestingFramework.DiscoverUIElements` method and `CMUIMap` class in CMTestingFramework.ahk to add the section otherwise you will get .ahk compiler errors when running tests

### Manual Coordinate Finding

You can still use AutoHotkey's Window Spy as described below:

1. Use AutoHotkey's built-in Window Spy tool (right-click the AutoHotkey icon in the system tray and select "Window Spy")
2. Hover your mouse over the UI element you want to interact with
3. Note the "Mouse Position" coordinates shown in Window Spy. Use the `client` value which should say `default` next to it.

## Example Test Case Using Named Elements

Here's a complete example test case using named UI elements:

```autohotkey
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
    .TakeScreenshot("Main_Menu")
    
    framework.ClickElement("MainMenu.NewGame")  ; Click on "New Game" using named element
    .Wait(8000)
    .TakeScreenshot("Creation")

    framework.ClickElement("Creation.DarkAngels") ; Click Dark Angels by name
    .Wait(3000)
    .ClickElement("Creation.NextArrow") ; Click Next button
    .Wait(2000)
    .ClickElement("Creation.NextArrow") ; Click Next button again
    .Wait(2000)
    .ClickElement("Creation.NextArrow") ; Click Next button again
    .Wait(2000)
    .ClickElement("Creation.NextArrow") ; Click Next button again
    .Wait(2000)
    .ClickElement("Creation.NextArrow") ; Click Next button again
    .Wait(2000)
    .ClickElement("Creation.NextArrow") ; Click Next button again
    .Wait(2000)
    .TakeScreenshot("Game_Started")

    ; End test and save results
    framework.EndTest()

    MsgBox("Test completed. Results saved to: " . framework.resultDir)
}

; Run the test
TestStartGame()
```

## Best Practices

1. **Use Named Elements**: Prefer `ClickElement()` over raw coordinates when possible

2. **Map New Elements**: When encountering a new UI element, add it to the UI Map

3. **Start Simple**: Begin with basic workflows before attempting complex scenarios

4. **Add Delays**: Include sufficient wait times between actions (use `framework.Wait()`)

5. **Handle Errors**: The framework will report hard errors and crashes, but you can use `framework.LogStep()` and `framework.LogError()` to write your own output to the test file at any point during a test to clarify what went right/wrong

6. **Organize by Workflow**: Create separate test files for different functional areas

7. **Comment Your Code**: Include clear comments explaining the purpose of each step

8. **Use Consistent Naming**: Name your tests and files with clear, descriptive names

9. **Test One Thing**: Each test should focus on a single feature or workflow

## Troubleshooting

- **Coordinate Issues**: If clicks aren't hitting the right spots, first make sure you're running in **Windowed 720p**, see Getting Started section 3. Verify coordinates in Window Spy or use the DiscoverUIElements tool if still having issues
- **Timing Problems**: Increase wait times if actions seem to execute before the app is ready. You can slow down the mouse speed and keyboard typing speed too if needed on a per-test basis. See Mouse Interaction and Keyboard Interaction sections
- **Application Not Found**: Check the application path in CMTestingFramework.ahk. You can overwrite this value with an `testing_options.ini` file in you %LocalAppData%/ChapterMaster folder
- **Element Not Found Error**: Verify the element path is correct (e.g., "MainMenu.NewGame")

## Getting Help

If you encounter issues creating test cases, contact @VanWeapon in the discord.
