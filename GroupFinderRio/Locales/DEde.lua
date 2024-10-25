local appName, GFIO = ...
local AceLocale = LibStub ('AceLocale-3.0')
local L = AceLocale:NewLocale(appName, "deDE")

if L then


-- LocalisationData[""] =
L["AccessOptionsMessage"] = "Zugriff auf die Optionen über /gfio"
L["addHighestDifficulty"] = "Höchste Schwierigkeit hinzufügen"
L["addHighestDifficultyDescription"] = "Die höchste abgeschlossene Schwierigkeit hinzufügen (entweder Schlüsselstufe oder Schlachtzugsfortschritt)"
L["addonOptions"] = "Addon-Optionen"
L["addScoreToGroup"] = "Punktzahl zur Gruppe hinzufügen"
L["addScoreToGroupDescription"] = "Die Punktzahl des Gruppenleiters zur Gruppenansicht hinzufügen"
L["applicantView"] = "Bewerberansicht"
L["Disable"] = "deaktiviert"
L["disableSpecSelector"] = "Spezifikationsauswahl deaktivieren"
L["disableSpecSelectorDescription"] = "Deaktiviert die Spezifikationsauswahl in der Bewerberansicht, die zur Priorisierung von Spezifikationen bei der Suche verwendet werden kann"
L["enableSpecPriority"] = "Spezifikationspriorität aktivieren"
L["fifteen"] = "15+"
L["five"] = "5+"
L["groupNameBeforeScore"] = "Gruppenname vor Punktzahl"
L["groupNameBeforeScoreDescription"] = "Zeigt den Gruppennamen vor der Punktzahl des Gruppenleiters an, anstatt danach"
L["groupView"] = "Gruppenansicht"
L["highest"] = "höchste"
L["oneClickSignup"] = "Schnell Anmeldung"
L["oneClickSignupDescription"] = "Mit einem Klick für eine Gruppe anmelden"
L["OneClickSignupNotAvailable"] = "Schnell Anmeldung ist nicht verfügbar wenn das Addon \"Premades Group Filter\" aktiviert ist, bitte deaktiviere die Option und nutze stattdessen die \"Premades Group Filters\" Einstellung"
--[[Translation missing --]]
L["resortGroupsConstantly"] = "Resort Groups Constantly"
--[[Translation missing --]]
L["resortGroupsConstantlyDescription"] = "Resort the groups every 3 Seconds to remove groups that are no longer available and update score if data becomes available later."
L["shortenActivityName"] = "Aktivitätsname verkürzen"
L["shortenActivityNameDescription"] = "Verkürzt den Aktivitätsnamen in der Gruppenansicht"
L["showCurrentScoreInGroup"] = "Aktuelle Punktzahl in der Gruppe anzeigen"
L["showCurrentScoreInGroupDescription"] = "Zeigt die aktuelle Punktzahl des Gruppenleiters in der Gruppenansicht an"
L["showInfoInActivityName"] = "Informationen im Aktivitätsnamen anzeigen"
L["showInfoInActivityNameDescription"] = "Zeigt Informationen im Aktivitätsnamen in der Gruppenansicht an"
L["showKeyLevel"] = "Schlüsselstufe anzeigen"
L["showKeyLevelApplicants"] = "Schlüsselstufe anzeigen"
L["showKeyLevelApplicantsDescription"] = "Zeigt die höchste abgeschlossene Schlüsselstufe des Bewerbers für den aktuellen Dungeon an"
L["showKeyLevelDescription"] = "Zeigt die höchste abgeschlossene Schlüsselstufe des Bewerbers für den aktuellen Dungeon an"
L["showKeyLevelLeader"] = "Schlüsselstufe anzeigen"
L["showKeyLevelLeaderDescription"] = "Zeigt die höchste abgeschlossene Schlüsselstufe des Gruppenleiters in der Gruppenansicht an"
L["showLanguage"] = "Sprache anzeigen"
L["showLanguageDescription"] = "Zeigt die Sprache der Bewerber und des Gruppenleiters an"
L["showNote"] = "Notiz anzeigen"
L["showNoteDescription"] = "Zeigt ein Symbol an, wenn ein Bewerber eine Notiz hinzugefügt hat"
L["showRaceIcon"] = "Rassen Symbol anzeigen lassen"
L["showRaceIconDescription"] = "Zeigt das Rassen Symbol neben dem Namen des sich anmeldenden Spielers an"
L["showTimedKeys"] = "Zeige zeitlich abgeschlossene Schlüsselsteine"
L["showTimedKeysDescription"] = "Zeige die Menge an zeitlich abgeschlossenen Schlüsselsteinen ab einer bestimmten Schwelle in der Anmeldungsanzeige an"
L["sortApplicants"] = "Bewerber sortieren"
L["sortApplicantsDescription"] = "Sortiert die Bewerber - Regel ist Spezifikationspriorität > (Haupt-) Punktzahl > Gegenstandsstufe"
L["sortAscending"] = "Aufsteigend sortieren"
L["sortAscendingDescription"] = "Sortiert die Liste in aufsteigender Reihenfolge anstatt absteigend"
L["sortGroupsByScore"] = "Gruppen nach Punktzahl sortieren"
L["sortGroupsByScoreDescription"] = "Sortiert die Gruppen nach der Punktzahl des Gruppenleiters"
L["ten"] = "10+"
L["twenty"] = "20+"
L["useMainInfo"] = "Hauptinformationen verwenden"
L["useMainInfoDescription"] = "Verwendet die Fortschritts- oder Punktzahlinformationen des Hauptcharakters anstatt der aktuellen Punktzahl zur Anzeige und Sortierung (falls verfügbar)"
L["useMainScore"] = "Hauptpunktzahl verwenden"
L["useMainScoreDescription"] = "Verwendet die Hauptpunktzahl anstatt der aktuellen Punktzahl zur Anzeige und Sortierung"
L["useOfWrongRoleHighlight"] = "Highlight falsche Rolle verwenden"
L["useOfWrongRoleHighlightDescription"] = "Hebt das Spezifikationssymbol in der Bewerberansicht hervor, wenn der Bewerber nicht die Rolle mit der höchsten Punktzahl verwendet"
L["wrongRoleScoreLimitForSorting"] = "Punktzahlgrenze für falsche Rollen bei der Sortierung"
L["wrongRoleScoreLimitForSortingDescription"] = "Die Punktzahlgrenze für die Sortierung von Nebenrollen hinter Hauptrollen. Wenn auf 0 gesetzt, wird immer die Hauptrolle vor der Nebenrolle sortiert. Wenn auf 5000 gesetzt, wird immer nur nach Punktzahl sortiert, unabhängig von Haupt- oder Nebenrolle"



GFIO.localisation = L
end