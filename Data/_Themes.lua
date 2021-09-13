local Themes = SUI:NewModule('Data.Themes');

local Class = RAID_CLASS_COLORS[select(2,UnitClass("player"))]

Themes.data = {
  { value = nil, text = 'Blizzard' },
  { value = {.3, .3, .3}, text = 'Dark' },
  { value = {Class.r, Class.g, Class.b}, text = 'Class' },
  { value = 'Custom', text = 'Custom' }
}