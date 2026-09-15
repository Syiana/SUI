# SUI 2.0 – In-Game-Testliste

SUI 2.0 ist mit LuaJIT-Syntaxprüfung, luacheck und einem Smoke-Test in einer
nachgebauten WoW-Umgebung geprüft (`tools/check.sh`, `tools/smoke/run.lua`).
Das ersetzt keinen Test im Spiel. Diese Liste sammelt alle Annahmen, die beim
Bau nicht verifiziert werden konnten. Abhaken pro Client: **R** = Retail,
**M** = Mists, **T** = TBC, **V** = Vanilla/Era.

## 0. Grundlagen (alle Clients)

- [ ] Addon lädt ohne Lua-Fehler (BugSack/BugGrabber aktiv) – R M T V
- [ ] 1.x-Profil wird übernommen: Einstellungen stimmen nach dem Update – R
- [ ] 1.x-Export-String lässt sich importieren – R
- [ ] Options-Fenster: alle Tabs öffnen, Suche findet Optionen, abhängige Optionen blenden sich ein/aus, „Reset <Tab>“ – R M T V
- [ ] Profile anlegen, kopieren, wechseln, löschen; Einstellungen greifen sofort – R M T V
- [ ] Theme Dark → Class → Custom → Blizzard wechselt live ohne Reload – R M T V
- [ ] Mover: Retail über Edit Mode (Stats, Queue-Icon, Minimap-Buttonleiste), Classic über `/sui unlock` – R M T V
- [ ] Performance: `/run UpdateAddOnCPUUsage()` bzw. Profiler im Raid/M+ – SUI ohne auffällige Spitzen – R

## 1. General / Automation

- [ ] Fonts: Wechsel der Schrift greift live und lässt sich zurücksetzen – R M T V
- [ ] Delete-Popup füllt „DELETE“ (12.x-Popups: `GetEditBox`) – R M T V
- [ ] Role Check wird angenommen – R M
- [ ] Quests/Gossip: Classic nutzt `C_GossipInfo.GetOptions`; Belohnungsauswahl – R M T V
- [ ] Cinematics überspringen (`MovieFrame:StopMovie`), Strg hält sie – R M T V
- [ ] AFK-Screen blendet Party/Raid mit aus und schließt bei Popup/Kampf – R M T V
- [ ] Queue-Icon an Halter, Edit Mode verschiebt ihn – R
- [ ] Itemlevel mit zwei Nachkommastellen, Enchant/Sockel-Hinweise (nur Retail-Daten) – R
- [ ] Bag-Itemlevel: Mists-Container-Hook (`UpdateItems` oder `ContainerFrame_Update`) – M
- [ ] Talking Head ausblenden – R

## 2. Actionbars / Castbars

- [ ] Range-Farbe: Retail über `ACTION_RANGE_CHECK_UPDATE`, Classic 0,2 s – R M T V
- [ ] Classic-Buttons haben `Update`/`UpdateUsable` oder Fallback greift – M T V
- [ ] Mouseover-Fade per `SetAlpha` auch im Kampf – R M T V
- [ ] Classic-Art-Namen (MainMenuBar, End Caps, Exp/Rep-Bar) werden gefunden – M T V
- [ ] Proc Glow: Custom/Hide; Retail `ActionButtonSpellAlertManager`, Classic `ActionButton_ShowOverlayGlow` – R M T V
- [ ] Castbar „On Top“ inkl. 12.1-Aura-Container; Classic-Offset (25, -12) – R M T V
- [ ] Boss-Castbars `Boss1-5TargetFrameSpellBar` – R M
- [ ] Timer bleibt leer, wenn Werte secret sind – R (Instanz)

## 3. Unitframes / Buffs

- [ ] Retail-Aura-Filter „Purgeable“ `HELPFUL|DISPELLABLE` und `HELPFUL|!DISPELLABLE` – R
- [ ] Aura-Setter nach Blizzard-Konfiguration ohne Taint – R
- [ ] Klassen-/Reaktionsfarbe und Overshields mit Secret Values in Instanzen – R
- [ ] Buffs.Layout überschreibt nach Blizzard, Edit-Mode-Rahmen bleibt Blizzard-Größe – R M T V
- [ ] Größen-Override nach Edit Mode, Zurück auf 1 ruft `UpdateSystemSettingFrameSize` – R M T V
- [ ] Classic-Style: Overlay verdeckt keine Auren – R
- [ ] Totem-/Klassenleiste ausblenden – R M

## 4. Raidframes

- [ ] Dispel-Hervorhebung und Defensives: Filter `HARMFUL|RAID_PLAYER_DISPELLABLE`, `BIG_DEFENSIVE`, `EXTERNAL_DEFENSIVE` – R
- [ ] Buff-/Debuff-Container: Setter `SetAuraGroupFilterString` u.a., CVars `raidFramesDisplayBuffs/Debuffs` – R
- [ ] Classic-Auren: `CompactUnitFrame_UpdateAuras`, Templates `CompactBuffTemplate/CompactDebuffTemplate`, Tooltips – M T V
- [ ] Party-Skalierung auf Retail nicht doppelt – R
- [ ] Custom Size auf Vanilla (Frames `CompactRaidFrameN`?) – V
- [ ] Mouseover-Highlight über der Healthbar – R M T V
- [ ] Rollen-Icons/Namen ausschalten ohne Taint – R

## 5. Nameplates

- [ ] Midnight-APIs: `UnitHealthPercent`, `UnitCastingDuration`, `C_Spell.GetSpellCooldownDuration`, `C_CurveUtil.EvaluateColorValueFromBoolean` – R
- [ ] Health-Textur wird nur über `SetStatusBarTexture` zurückgesetzt – R M T V
- [ ] Classic-Nameplates haben eine Castbar – M T V
- [ ] Größen-CVars `NamePlateVerticalScale/HorizontalScale`, Stacking-Bitmaske – R
- [ ] Totem-/Interrupt-IDs auf Mists und Classic – M T V
- [ ] Personal Resource Bar auf Classic (gepoolte Plate) – M T V
- [ ] NPC-Farben-Editor: hinzufügen, ändern, löschen; bleibt nach Reload gelöscht – R

## 6. Tooltip / Map

- [ ] Qualitätsrahmen und Backdrop (Aufrufreihenfolge, `NineSlice:SetCenterColor` auf Classic) – R M T V
- [ ] Inspect: `C_PaperDollInfo.GetInspectItemLevel` (Mists), PvP-Rating-Felder – R M
- [ ] Koordinaten unter 12.1 (secret/nil → „-“) – R
- [ ] `MinimapCluster` ausblenden vs. Edit Mode – R
- [ ] Classic-Minimap-Namen (`MiniMapTracking`, `MinimapZoneTextButton`, `MinimapBorderTop`) – M T V
- [ ] Square-Minimap: Masken zurück, LibDBIcon-Buttons sitzen richtig – R M T V
- [ ] Button-Leiste: sammelt Addon-Buttons, keine Blizzard-Buttons; Drawer-Position – R M T V

## 7. Chat

- [ ] URL-Links über `garrmission:` + `SetItemRef`-Hook, kein „Unknown link type“ – R M T V
- [ ] Modern auf Classic: Tab-Texturen, `ButtonFrameUp/Down/BottomButton` – M T V
- [ ] Dock-Fade nach 3,5 s über Enter/Leave – R M T V
- [ ] Freundesliste Classic (`FriendsFrameFriendsScrollFrame.buttons`) – M T V
- [ ] Kanalnamen kürzen: kein Taint (Tab-Flash, letztes Flüstern) – R, sonst M T V
- [ ] Pixel-Scrolling: `FontStringContainer`, kein Sprung am Start – R

## 8. PvP / Group / Misc

- [ ] Game-Menü-Button: `GameMenuFrame:InitButtons` auf allen Clients – R M T V
- [ ] Safe Queue: `PVPReadyDialog`-Felder, `GetBattlefieldPortExpiration` in Sekunden – R M T V
- [ ] LFG Declined und Group-Finder-Links: „Sign Up“ und Einladen funktionieren weiter (Taint) – R
- [ ] Menü-Tags `MENU_LFG_FRAME_SEARCH_ENTRY`, `MENU_LFG_FRAME_MEMBER_APPLY` – R
- [ ] Player Links: Realm-Slugs (russische/Akzent-Realms), Classic-WarcraftLogs-Subdomains – R M T V
- [ ] Achievement-IDs der aktuellen Saison – R M
- [ ] Loss of Control: Regionen `blackBg`/`RedLineTop`/`RedLineBottom` – R M T V

## 9. Skins

- [ ] Load-on-demand-Namen: `Blizzard_Communities`, `Blizzard_Transmog` (Mists), `Blizzard_GroupFinder_VanillaStyle`, `Blizzard_ArenaUI`, `Blizzard_DamageMeter` – R M T V
- [ ] Geschützte Regionen auf Classic (`FriendsFrame#19`, `MacroFrame#18`, `SpellBookFrame#1/#3`, `BankFrame#15`) zeigen Portrait/Pergament – M T V
- [ ] Skyriding-Widget `UIWidgetPowerBarContainerFrame:ProcessWidget` – R
- [ ] Details-Skin inkl. Augmentation-Leiste, Bartender-Statusleisten – R M T V

## 10. Nach dem 1.x-Abgleich (neu prüfen)

- [ ] Keine Taint-Fehler `Backdrop.lua … secret number` bei Casts (Castbar-, Target-Aura-, Nameplate-, Raid-Aura-Icons mit Schatten) – R
- [ ] Keine Taint-Fehler `FrameUtil.lua … startAlpha` bei Chat-Tab-Fades – R
- [ ] Options-, Install-, Import/Export-Fenster blenden mit SUI-Fade, Escape während des Einblendens bleibt geschlossen – R M T V
- [ ] Buffs: Schatten hinter jedem Icon, Dark-Theme dunkler Gloss-Rahmen, andere Themes eingefärbt – R M T V
- [ ] Target/Focus-Auren: eigene SUI-Container (`CustomAuraContainerTemplate`), Blizzards Container bleibt leer ohne Flackern; Castbar sitzt unter den Auren – R
- [ ] Raid-Auren: Buffs/Debuffs/Defensives wie 1.x, Haupt-Debuff ×1.3, Aura-CVars werden beim Ausschalten zurückgegeben – R
- [ ] Party-Skalierung aus 1.x-Profil sieht gleich aus (Migration quadriert den Wert) – R
- [ ] Chat: Seitenbuttons wie 1.x gestapelt, inaktive Tabs 50 %, URL-Klick füllt die Eingabe – R
- [ ] Tooltip: Zeilenfarben, NPC-Titel lila, Rahmen gewöhnlicher Items dunkler – R
- [ ] Schrift-Globals (`STANDARD_TEXT_FONT` usw.) ohne „blocked action“-Fehler – R
- [ ] Update-Hinweis erscheint nicht wegen 1.x-Spielern (12.1.x) in Gruppe/Gilde – R
- [ ] Dampening-Anzeige in der Arena (Mists: Fallback ohne Widget-Vorlage) – R M
- [ ] Bags: Farben ohne Entsättigung, untere Ecken schwarz 78 % – R
