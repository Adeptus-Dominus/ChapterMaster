# Tips

## Technicalities and Preparations

### Learn about Git, Source Control, GitHub and Contribution
There is no way around it.
- If you are new to Git, then it's recommended to read the [Pro Git](https://git-scm.com/book/en/v2) book. You only need to read the first 3 chapters to comfortably work with Git, optionally chapter 6 to get more info on GitHub.
- If you prefer a more comfortable, graphical user interface based approach to Git, instead of command line, then it's recommended to use one of the options below, both are free and popular:
   - [GitKraken](https://www.gitkraken.com/) + [Tutorials](https://www.gitkraken.com/learn/git/tutorials)
   - [SourceTree](https://www.sourcetreeapp.com/) + [Tutorials](https://confluence.atlassian.com/get-started-with-sourcetree)

### GameMaker vs VSCode+Stitch

There are generally two main ways of working with a **GameMaker** project: through **Visual Studio Code** or through **GameMaker IDE**.

- Working with the code through **GameMaker IDE** is not recommended for people used to normal IDEs. Use if you have to or like it.
- The preferred alternative is to use [Visual Studio Code](https://code.visualstudio.com/) with the [Stitch](https://github.com/bscotch/stitch) extension, that is available via the [Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=bscotch.bscotch-stitch-vscode).
- You can also use any other IDE to work with the code, but you'll have to use one of the above apps to build, as no other building method is available at the moment.
- Other IDEs have no extended support for **GML** and as such typically are not recommended, unless you know what you're doing.

Nonetheless, some things will have to be done through **GameMaker IDE**, even if you use other IDEs, including VSCode, such as:
- Most of the sprite management.
- Debugging with breakpoints, function steps and real-time debugging.
- Profiling.
- Room management.

### Setting up the Visual Studio Code

1. Get the Visual Studio Code (VSCode) installed, if not already.
   - (Optional) It's recommended to get the Insider version, as it's the most frequently updated one and gets all new features first.
   - (Optional) Get the hang of VSCode by reading some guides on the internet, installing some useful QoL extensions, configuring various settings, etc.
2. Add the project's folder that you've cloned to the workspace, wait for it to load.
3. Get the Stitch extension installed.
   - (Optional) Watch [this guide video](https://youtu.be/N0wnHauUQjA?si=GPQ22a_LyZq3Y9LP) that covers basic features of **Stitch**, made by its creator.
   - (Optional) Edit various **Stitch** specific settings, to improve your QoL.
   - (Optional) It's recommended to disable "Run in Terminal" **Stitch** option. This allows you to go to error lines that come up in the output window and custom color output lines. The explanation is in the "Stitch Runner Panel" section on [this page](https://marketplace.visualstudio.com/items?itemName=bscotch.bscotch-stitch-vscode).
4. Run the game by pressing F5 or finding the run button on the **Stitch** panel, wait for it to download the **GameMaker** version and build the game.
5. Ensure that the game launches and works, exit.

## Working with the code

- Read the code, modify it, test, repeat.
- Check some general [GML hints](https://github.com/Adeptus-Dominus/ChapterMaster/wiki/General-GML-hints-from-@sinthorion).
- Check the list of some [useful resources](https://github.com/Adeptus-Dominus/ChapterMaster/wiki/Useful-resources).
