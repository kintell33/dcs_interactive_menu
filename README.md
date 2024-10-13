# DCS Dynamic Dialog Project

## Overview
This project is a dynamic dialog system for Digital Combat Simulator (DCS) designed to create a flexible, interactive user interface within the game environment. It utilizes Lua scripts, custom dialogs, and hotkeys to provide dynamic mission elements such as buying aircraft, event triggers, and user interaction controls. The implementation leverages both primary and secondary dialogs to manage the visibility and interactions without breaking the game flow.

## Key Features
- **Dynamic UI Elements**: The system includes dialogs that can be shown, hidden, and interacted with using configurable hotkeys.
- **Secondary Dialog for Hotkey Handling**: A secondary, minimal dialog is used to handle hotkey interactions, ensuring that the primary dialog can be hidden or shown effectively without breaking the hotkey functionality.
- **Event Triggering**: Includes functions for triggering specific game events, such as purchasing aircraft, with feedback logs for better debugging.

## Files
- **`main.lua`**: Main Lua script handling dialog creation, visibility toggling, event triggers, and hotkey management.
- **`TestUIDialog.dlg`**: Primary dialog definition that displays a user interface allowing players to interact (e.g., purchase aircraft).
- **`TestUIDialogHotKey.dlg`**: A secondary dialog with minimal visibility (1px by 1px) that is used exclusively to handle hotkey events.
- **`tiny_hidden_dialog.lua`**: Minimal dialog configuration to be used as a placeholder for background event handling.

## How to Use
1. **Setup Configuration**: The configuration file (`MenuBuyConfig.lua`) should be placed in the `Config` directory inside the DCS write directory (`Saved Games/DCS/Config`). This file includes settings for the default hotkey (`Ctrl+Shift+X`) which can be modified as per user preferences.
2. **Load the Scripts**: Place the Lua script (`main.lua`) and dialog files (`.dlg`) into the appropriate directories (`Scripts/`). Ensure the paths match those specified in the code.
3. **Run in DCS**: The script is designed to load upon mission start or game start, creating the dialogs and setting up the hotkey for toggling the visibility of the primary UI.

## Dialog System Explained
- **Primary Dialog (`TestUIDialog.dlg`)**: This is the main UI that the player interacts with. It contains buttons like "Comprar" to perform actions like buying an aircraft. It can be toggled using a hotkey.
- **Secondary Dialog (`TestUIDialogHotKey.dlg`)**: This dialog is used to maintain hotkey functionality even when the primary dialog is hidden. It has minimal impact on the UI, as it is only 1px by 1px and remains invisible.

## Code Highlights
- **Hotkey Management**: The hotkey functionality is implemented in `handleHotkey()` and is attached to the secondary dialog to ensure the hotkey remains active even when the main dialog is not visible.
- **Visibility Toggle**: Functions `showDialog()` and `hideDialog()` handle showing and hiding the main dialog. When hidden, the dialog uses a minimal skin to ensure it does not affect the game experience.
- **Error Handling and Logging**: The project includes extensive logging (`net.log()`) to track dialog visibility changes, button clicks, and any errors during the dialog loading process.

## Requirements
- **DCS World**: A working installation of DCS World is required.
- **Lua Scripting Knowledge**: Basic understanding of Lua scripting and DCS Mission Editor hooks.

## Troubleshooting
- **Dialog Not Showing**: Ensure that the `.dlg` files are correctly placed in the `Scripts` folder and that their paths in the script are accurate.
- **Hotkey Not Working**: Make sure the secondary dialog (`TestUIDialogHotKey.dlg`) is loaded successfully. Check the log output (`Saved Games/DCS/Logs/Scratchpad.log`) for error messages.
- **Cannot Hide Dialog**: If the dialog does not hide properly, verify that the skin changes and visibility toggle functions are being executed as expected.

## Customization
- **Hotkey Change**: Modify the default hotkey (`defaultHotkey`) in the script or the configuration file to suit user preferences.
- **Dialog Customization**: Modify the `.dlg` files to add more buttons or change their layout to accommodate other mission requirements or custom features.

## License
This project is open-source and free to use. Contributions are welcome to improve functionality or add new features.

## Author
This project was developed by Kintell33. Contributions and feedback are always welcome. Feel free to open issues or submit pull requests to enhance the system.

