# SUI 2.0 – Architektur-Vertrag

Dieses Dokument ist verbindlich für jeden Code in `Features/`. Wer ein Feature
baut, hält sich an diese Regeln. Der Kern (`Core/`, `Config/`, `Media/`) setzt
sie um.

## 1. Grundidee

- **Ein Code-Baum für alle Clients.** Mainline (Retail 12.x), Mists, TBC und
  Vanilla laden dieselben Dateien. Die vier TOC-Dateien unterscheiden sich nur
  in `## Interface` und im Lib-Loader.
- **Features beschreiben, der Kern entscheidet.** Ein Feature sagt, an welchem
  Schalter es hängt und für welche Clients es gilt. Ob es läuft, entscheidet
  `Core/Features.lua`. Kein Feature prüft seinen eigenen Schalter.
- **Einstellungen greifen live.** Jede Option geht über `SUI:Set`, der Kern ruft
  `OnEnable`, `OnDisable` oder `OnRefresh`. Reload nur, wo Blizzard-Frames sich
  nicht zurücksetzen lassen.
- **Performance ist eine Regel, kein Wunsch.** Siehe Abschnitt 9.

## 2. Load-Reihenfolge

```
Libs → Core/Load.xml → Media → Core/Load_Late.xml → Config → Features
```

Jede Kategorie hat einen Ordner mit eigener `Load.xml`:

```
Features/ActionBars/
  Load.xml        -- Defaults.lua zuerst, Options.lua zuletzt
  Defaults.lua    -- SUI:RegisterDefaults("actionbar", {...}) + Migrationen
  Range.lua       -- ein Feature pro Datei (oder eng verwandte Features)
  Options.lua     -- SUI.Config:RegisterLayout("Actionbar", {...})
```

In jeder Datei:

```lua
local _, ns = ...
local SUI = ns.SUI
```

## 3. Kategorien, Tabs, Reihenfolge

| Ordner | DB-Kategorie | Tab | order |
|---|---|---|---|
| General | `general` | General | 10 |
| UnitFrames | `unitframes` | Unitframes | 20 |
| RaidFrames | `raidframes` | Raidframes | 25 |
| NamePlates | `nameplates` | Nameplates | 30 |
| ActionBars | `actionbar` | Actionbar | 40 |
| CastBars | `castbars` | Castbars | 50 |
| Buffs | `buffs` | Buffs | 60 |
| Tooltip | `tooltip` | Tooltip | 70 |
| Maps | `maps` | Map | 80 |
| Chat | `chat` | Chat | 90 |
| Misc | `misc` | Misc | 100 |
| Skins | `skins` | Skins | 110 |

Der Kern belegt bereits: `general.theme`, `general.color`, `general.font`,
`general.texture` (Core/Theme.lua) und die Kategorie `movers`. Diese Schlüssel
nicht erneut registrieren. Die Tabs „Profiles“ (900) und „FAQ“ (1000) gehören
dem Kern.

**Schlüssel aus SUI 1.x behalten**, wo das Feature schon existierte (siehe
`_legacy/Core/Init.lua`). Wo ein Schlüssel umbenannt oder umstrukturiert wird,
gehört eine Migration dazu (Abschnitt 5).

## 4. Feature-API

```lua
local F = SUI:NewFeature("ActionBars.Range", {
    category  = "actionbar",          -- self.db = SUI.db.profile.actionbar
    toggle    = "buttons.range",      -- Pfad in der Kategorie ODER function(db) return bool end
                                      -- nil = läuft immer. Wert "Disabled" zählt als aus.
    clients   = { Mainline = true },  -- nil = alle; Schlüssel: Mainline, Mists, TBC, Vanilla, Classic (= alle drei)
    conflicts = { "Bartender4" },     -- läuft nicht, wenn eines dieser Add-ons geladen ist
    watch     = { "general" },        -- weitere Kategorien, deren Änderungen OnRefresh auslösen
    reload    = true,                 -- Ausschalten braucht Reload (Kern fragt nach)
})

function F:OnLoad() end               -- genau einmal vor dem ersten Enable: Frames bauen, Hooks setzen
function F:OnEnable() end             -- eingeschaltet: Events registrieren, Aussehen anwenden
function F:OnDisable() end            -- ausgeschaltet: sichtbare Änderungen zurücknehmen
function F:OnRefresh(key, value) end  -- eine Option der Kategorie hat sich geändert (Feature läuft)
function F:OnThemeChanged() end       -- Theme-Farbe hat sich geändert (Feature läuft)
```

Hilfen am Feature (alles wird beim Disable automatisch aufgeräumt):

| Aufruf | Zweck |
|---|---|
| `self.db` | Tabelle der Kategorie, nach Profilwechsel neu gebunden. Nie in Upvalues cachen. |
| `self.enabled` | Läuft das Feature gerade |
| `self:RegisterEvent(event, fn)` | `fn(self, event, ...)`; `fn` darf ein Methodenname sein |
| `self:RegisterUnitEvent(event, fn, unit1, unit2)` | wie oben, gefiltert auf Units |
| `self:UnregisterEvent(event)` | |
| `self:Hook("GlobalFunc", fn)` / `self:Hook(obj, "Method", fn)` | `hooksecurefunc`, feuert nur wenn `enabled`. **Nur in OnLoad.** |
| `self:HookScript(frame, "OnShow", fn)` | wie oben für Scripts. **Nur in OnLoad.** |
| `self:After(sec, fn)` | Timer, feuert nur wenn `enabled` |
| `self:NewTicker(sec, fn)` | Ticker, wird beim Disable gestoppt |
| `self:StartUpdate(fn, interval)` / `self:StopUpdate()` | gedrosselte Update-Schleife, `fn(elapsed)` |

Kern-Hilfen:

| Aufruf | Zweck |
|---|---|
| `SUI:Get("actionbar.buttons.size")` / `SUI:Set(path, value)` | Einstellungen lesen/schreiben (Set wendet live an) |
| `SUI:RunAfterCombat(fn)` | Sofort oder nach dem Kampf (geschützte Frames) |
| `SUI:OnAddonLoaded("Blizzard_X", fn)` | Sofort oder sobald das Add-on lädt |
| `SUI:RequestReload(reason)` | Reload-Hinweis im Options-Fenster |
| `SUI:SupportsClient(clients)` | |
| `SUI.IsRetail`, `SUI.IsClassic`, `SUI.IsMists`, `SUI.IsTBC`, `SUI.IsVanilla`, `SUI.Client`, `SUI.HasEditMode` | Einmal gesetzte Flags |
| `SUI.callbacks.RegisterCallback(owner, "SettingChanged"/"ThemeChanged"/"ProfileChanged"/"Ready", fn)` | Querschnitt-Ereignisse |
| `SUI:Print(...)`, `SUI:Debug(...)` | Ausgabe |

Beispiel:

```lua
local F = SUI:NewFeature("General.Repair", {
    category = "general",
    toggle = "automation.repair",   -- "Default" | "Guild" | "Disabled"
})

function F:OnEnable()
    self:RegisterEvent("MERCHANT_SHOW", "Repair")
end

function F:Repair()
    if not CanMerchantRepair() then return end
    local cost = GetRepairAllCost()
    if cost <= 0 then return end
    local guild = self.db.automation.repair == "Guild" and CanGuildBankRepair and CanGuildBankRepair()
    RepairAllItems(guild)
end
```

## 5. Defaults und Migrationen

```lua
SUI:RegisterDefaults("actionbar", { buttons = { range = true, size = 12 } })
SUI:RegisterDefaults("actionbar", { menu = {...} })   -- mehrere Dateien dürfen beitragen, Schlüssel dürfen nicht kollidieren
SUI:RegisterDefaults("chat", {...}, "char")           -- Scope "char" oder "global" möglich

SUI:RegisterMigration("chat-1x-style", function(profile, db)
    local chat = rawget(profile, "chat")
    if type(chat) == "table" and (chat.style == "Custom" or chat.style == "SUI") then
        chat.style = "Modern"
    end
end)
```

- Migrationen haben **eindeutige Namen** mit Kategorie-Präfix, laufen einmal pro
  Profil und müssen **idempotent** sein. Sie laufen auch auf importierten
  1.x-Profilen.
- AceDB kopiert Defaults in das Profil. Alte 1.x-Schlüssel, die nicht mehr in den
  Defaults stehen, sind echte Nutzerdaten und per `rawget` erkennbar.
- **Listen, die der Nutzer bearbeitet** (z.B. NPC-Farben), nicht in die Defaults.
  AceDB würde gelöschte Einträge wieder auffüllen. Stattdessen beim ersten Start
  im Feature befüllen und ein Flag setzen.

## 6. Options-Tabs

```lua
SUI.Config:RegisterLayout("Actionbar", {
    order = 40,
    category = "actionbar",
    rows = function()
        return {
            { header = { type = "header", label = "Buttons" } },
            {
                range = { key = "buttons.range", type = "checkbox", label = "Range Color",
                          tooltip = "Color buttons red when out of range", column = 4, order = 1 },
                size  = { key = "buttons.size", type = "slider", label = "Font Size",
                          min = 6, max = 24, step = 1, column = 4, order = 2 },
                style = { key = "style", type = "dropdown", label = "Style", column = 4, order = 3,
                          options = { { value = "Default", text = "Default" }, { value = "Custom", text = "Custom" } } },
            },
            {
                gryphons = { key = "gryphons", type = "checkbox", label = "Hide Gryphons",
                             clients = { Classic = true }, column = 4, order = 1 },
            },
        }
    end,
})
```

- Elementtypen: `header`, `label`, `checkbox`, `dropdown` (`options = {{value,text}}`),
  `slider` (`min`, `max`, `step`), `editBox`, `color` (Wert `{r,g,b,a}`), `button`
  (`text`, `onClick`), `custom` (`createFunction(frame)`), `scroll`.
- `column` ist ein 12er-Raster. Zeilen sind Tabellen, Reihenfolge per `order`.
- `key` ist relativ zur `category`. Ohne `category` ist der Schlüssel absolut.
- Zusatzfelder: `clients`, `hidden = function(info) end`, `reload = true`,
  `onChange = function(self, value) end` (nur für Aktionen, die kein Feature abdeckt).
- **Kein `onChange`, um Features zu aktualisieren.** Das macht `SUI:Set` → `OnRefresh`.
- Dropdowns mit Medien: `SUI.Media:Options("statusbar")`, `SUI.Media:Options("font")`,
  `SUI.Media:Options("sound")`.
- Labels und Tooltips auf Englisch (wie 1.x).

## 7. Clients und Compat

- Feature gilt nur für einige Clients → `clients` im Spec. Die Datei wird trotzdem
  geladen; darin darf beim Laden **kein** Client-spezifischer Global dereferenziert
  werden (nur innerhalb von Funktionen).
- Unterschiedliche Umsetzung pro Client → zwei Features mit gleichem Schalter und
  unterschiedlichem `clients`, z.B. `NamePlates.Health` (Mainline) und
  `NamePlates.HealthClassic` (Classic).
- API-Unterschiede, die mehrere Kategorien brauchen, stehen in `SUI.Compat`
  (`Core/Compat.lua`): `CanAccess`, `IsSecret`, `IsAddOnLoaded`, `LoadAddOn`,
  `GetAddOnMetadata`, `GetSpellInfo` (→ name, icon, id), `GetSpellTexture`,
  `GetItemInfo`, `GetItemQualityColor`, `GetDetailedItemLevelInfo`,
  `GetContainerNumSlots`, `GetContainerItemLink`, `GetContainerItem` (→ quality,
  link, noValue, count), `UseContainerItem`, `GetClassColor` (→ r, g, b),
  `ForEachAura(unit, filter, fn)`, `IsActionInRange`, `IsUsableAction`, `HasAction`,
  `HasRangeEvents`, `GetMouseFocus`, `GetSpecialization`, `OnTooltipUnit(fn)`,
  `OnTooltipItem(fn)`, `OnTooltipSpell(fn)`, `SetCVar`, `GetCVar`, `GetCVarBool`,
  `IsRestrictedContext`.
- Unterschiede, die nur eine Kategorie betrifft, bleiben lokal in deren Ordner
  (z.B. `Features/UnitFrames/Compat.lua`). `Core/Compat.lua` wird von Feature-
  Autoren nicht geändert; Bedarf im Abschlussbericht melden.

## 8. Theme, Skins, Movers

```lua
SUI.Theme.enabled                 -- false beim Theme "Blizzard"
SUI.Theme:Color(0.15)             -- r, g, b (drei Zahlen, keine Tabelle)
SUI.Theme:Paint(texture, true)    -- mit Theme-Farbe tönen; wird bei Theme-Wechsel automatisch neu gemalt
SUI.Skin:Frame(frameOrPath, true) -- alle Textur-Regionen eines Frames tönen
SUI.Skin:Apply({ "MacroFrame", "MacroFrame.NineSlice" }, true)
SUI.Skin:Register("Blizzard_MacroUI", { ... } | function(Skin) end)
SUI.Skin:Protect(region)          -- Region nie tönen
SUI.Movers:Add(frame, "statsframe", { point = "BOTTOMLEFT", x = 5, y = 3 }, { label = "Stats" })
```

Getönte Texturen nicht in `OnUpdate` neu färben. Wenn Blizzard eine Textur
zurücksetzt, per Hook auf genau diese Methode nachziehen.

## 9. Performance-Regeln (hart)

1. **Kein dauerhaftes `OnUpdate`.** Update-Schleifen starten bei Bedarf
   (`self:StartUpdate`), drosseln nach Zeit und stoppen sich selbst.
2. **Keine Tabellen oder Closures in Hot Paths** (Nameplate-, Unitframe-, Aura-,
   Castbar-, Tooltip-, Chat-Nachrichten-Hooks). Farben als Zahlen, Puffer
   wiederverwenden, Closures einmal in OnLoad bauen.
3. **Einmal stylen.** Fonts, Texturen, Anker beim Erzeugen setzen. Nachziehen nur
   per Hook auf die Methode, die sie zurücksetzt, mit Vergleich gegen den
   letzten gesetzten Wert.
4. **Unit-Events gezielt** mit `RegisterUnitEvent`.
5. **Hot-Path-Dateien cachen API-Globals als Locals** am Dateianfang.
6. **Keine Versionsprüfung im Hot Path.** Unterschiede über `clients` oder Compat.
7. **Keine `pcall`-Wrapper in Hot Paths.** Secret-Values mit `SUI.Compat.CanAccess`
   prüfen.
8. **Keine neuen Globals.** Ausnahmen nur, wo Blizzard einen Namen verlangt
   (`StaticPopupDialogs`, Keybinding-Header, `UISpecialFrames`), dann mit
   Präfix `SUI`.
9. **Blizzard-Scripts nie ersetzen** (`SetScript` auf Blizzard-Frames ist
   verboten), nur `HookScript` / `hooksecurefunc`.

## 10. Midnight (Retail 12.x) und Taint

- Viele Unit-Werte (Gesundheit, Namen, Auren anderer Einheiten) können in
  Instanzen „secret“ sein. Secrets nie vergleichen, rechnen, als Tabellenschlüssel
  nutzen oder mit `..` verketten. `FontString:SetText` und
  `StatusBar:SetValue` akzeptieren sie. Vorher `SUI.Compat.CanAccess(v)`.
- Der 1.x-Code auf `update_patch` (in `_legacy/`) läuft auf 12.1. Seine
  Midnight-Workarounds sind die Referenz dafür, was funktioniert.
- Verbotene Frames (`frame:IsForbidden()`, z.B. freundliche Nameplates in
  Instanzen) nicht anfassen.
- Keine Änderungen an geschützten Frames im Kampf: `SUI:RunAfterCombat`.
- Keine Add-on-Nachrichten, wenn `SUI.Compat.IsRestrictedContext()` wahr ist.
- `ToggleGameMenu()` und ähnliche Aufrufe aus Add-on-Code tainten; siehe 1.x
  Config (`HideUIPanel(GameMenuFrame)`).

## 11. Stil

- Kommentare und UI-Texte auf Englisch, 4 Leerzeichen Einrückung.
- Dateikopf: `--[[ SUI 2.0 - Features/<Ordner>/<Datei> ... ]]` mit zwei bis vier
  Sätzen, was die Datei tut.
- Feature-IDs: `Kategorie.Name` in PascalCase (`NamePlates.Health`).
- Kein Code aus muleyoUI kopieren (proprietäre Lizenz). muleyoUI darf gelesen
  werden, um Features und API-Unterschiede zu verstehen; die Umsetzung ist eigen.

## 12. Qualitäts-Tor

```bash
tools/check.sh Features/<Ordner>
```

muss ohne Fehler durchlaufen (LuaJIT-Syntax, luacheck, Tippfehler-Globals).
Nicht im Spiel testbare Annahmen werden im Abschlussbericht aufgelistet.
