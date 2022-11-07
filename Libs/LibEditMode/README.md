# LibEditMode

Modify anchors and settings of frames controlled by edit mode _without_
triggering taint issues or requiring a `/reload`.

```lua
local LibEditMode = LibStub("LibEditMode-1.0")
LibEditMode:LoadLayouts()
LibEditMode:ReanchorFrame(MainMenuBar, "TOP", UIParent)
LibEditMode:ApplyChanges()
```

# Usage

## Initialization and saving
### `LibEditMode:LoadLayouts()`

Required to call before using any other functions in this library. Queries and saves from
the Blizzard API last saved edit mode frame settings and positions. You **will**
need to call this again if the edit mode UI updates the layouts.

### `LibEditMode:AreLayoutsLoaded()`

Has `LibEditMode:LoadLayouts()` been called at some point?

### `LibEditMode:ApplyChanges()`

Save any changes made and apply any layout changes to the frames. Does not work
during combat.

### `LibEditMode:SaveOnly()`

Save any changes made. Works during combat.

## Frame configuration

### `LibEditMode:ReanchorFrame(frame, ...)`

For a frame that is managed by edit mode change the default anchor. Uses the
same parameters as a `frame:SetPoint(...)` call for the anchor.

### `LibEditMode:SetFrameSetting(frame, setting, value)`

Set an edit mode setting on an edit mode managed frame. Use the enumerations
found in the Blizzard Lua dumps for the setting parameter.

### `LibEditMode:SetGlobalSetting(setting, value)`

Set an edit mode account-wide setting. This is just an alias for
`C_EditMode.SetAccountSetting`

### `LibEditMode:HasEditModeSettings(frame)`

Does this frame have edit mode settings available?

### `LibEditMode:GetFrameSetting(frame, setting)`

Get a specific an edit mode setting on an edit mode managed frame. Use the
enumerations found in the Blizzard Lua dumps for the setting parameter.

## Layout management

### `LibEditMode:AddLayout(layoutName)`

Create a new layout called `layoutName`. This name must not already be in use.

### `LibEditMode:DeleteLayout(layoutName)`

Delete a layout named `layoutName`. This layout must exist.

### `LibEditMode:SetActiveLayout(layoutName)`

Change the active layout to `layoutName`. This name must exist. You need to call
`LibEditMode:ApplyChanges` or similar for  this to take effect and persist.


### `LibEditMode:DoesLayoutExist(layoutName)`

Does a layout with the name `layoutName` exist?

### `LibEditMode:GetPresetLayoutNames(layoutName)`

Returns a table of the names of all preset non-editable layouts.

### `LibEditMode:GetEditableLayoutNames(layoutName)`

Returns a table of the names of all editable layouts.
