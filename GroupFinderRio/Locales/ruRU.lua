local appName, GFIO = ...
local AceLocale = LibStub ('AceLocale-3.0')
local L = AceLocale:NewLocale(appName, "ruRU")

if L then


-- LocalisationData[""] =
L["AccessOptionsMessage"] = "Доступ к настройкам через /gfio"
L["addHighestDifficulty"] = "Добавить максимальную сложность"
L["addHighestDifficultyDescription"] = "Добавить наивысшую пройденную сложность (либо уровень ключа, либо рейдовый прогресс)"
L["addonOptions"] = "Настройки аддона"
L["addScoreToGroup"] = "Добавить наивысший рейтинг в группу"
L["addScoreToGroupDescription"] = "Добавить наивысший рейтинг лидера группы в просмотр групп. (Это может быть как основной, так и текущий рейтинг персонажа)."
L["applicantView"] = "Просмотр кандидата"
--[[Translation missing --]]
L["debugMode"] = "debugMode"
--[[Translation missing --]]
L["debugModeDescription"] = "debugModeDescription"
--[[Translation missing --]]
L["debugModeWarning"] = "debugModeWarning"
--[[Translation missing --]]
L["Disable"] = "Disable"
--[[Translation missing --]]
L["disableSpecSelector"] = "disableSpecSelector"
--[[Translation missing --]]
L["disableSpecSelectorDescription"] = "disableSpecSelectorDescription"
L["enableSpecPriority"] = "Включить приоритет специализации"
L["fifteen"] = "15+"
L["five"] = "5+"
L["groupNameBeforeScore"] = "Название группы перед рейтингом"
L["groupNameBeforeScoreDescription"] = "Показывать название группы перед рейтингом лидера группы, а не после него"
--[[Translation missing --]]
L["groupView"] = "groupView"
L["highest"] = "Самый высокий уровень ключа"
L["oneClickSignup"] = "Присоединение в один клик"
L["oneClickSignupDescription"] = "Присоединитесь к группе одним щелчком мыши"
--[[Translation missing --]]
L["OneClickSignupNotAvailable"] = "OneClickSignupNotAvailable"
--[[Translation missing --]]
L["resortGroupsConstantly"] = "resortGroupsConstantly"
--[[Translation missing --]]
L["resortGroupsConstantlyDescription"] = "resortGroupsConstantlyDescription"
--[[Translation missing --]]
L["shortenActivityName"] = "shortenActivityName"
--[[Translation missing --]]
L["shortenActivityNameDescription"] = "shortenActivityNameDescription"
L["showCurrentScoreInGroup"] = "Показать текущий рейтинг в группе"
L["showCurrentScoreInGroupDescription"] = "Показать текущий рейтинг лидера группы дополнение к наивысшему рейтингу (если отличается)"
--[[Translation missing --]]
L["showInfoInActivityName"] = "showInfoInActivityName"
--[[Translation missing --]]
L["showInfoInActivityNameDescription"] = "showInfoInActivityNameDescription"
L["showKeyLevel"] = "Показать уровень ключа"
L["showKeyLevelApplicants"] = "Показать уровень ключа кандидата"
L["showKeyLevelApplicantsDescription"] = "Показать наивысший пройденный уровень ключа кандидата для текущего подземелья"
L["showKeyLevelDescription"] = "Показать наивысший пройденный уровень ключа для текущего подземелья"
L["showKeyLevelLeader"] = "Показать уровень ключа лидера"
L["showKeyLevelLeaderDescription"] = "Показывать наивысший завершенный уровень ключа лидера группы в просмотре групп"
L["showLanguage"] = "Показывать язык"
L["showLanguageDescription"] = "Показать язык кандидатов и лидера группы"
L["showNote"] = "Показывать примечание"
L["showNoteDescription"] = "Показать значок, если кандидат добавил примечание"
L["showRaceIcon"] = "Показывать иконку расы"
L["showRaceIconDescription"] = "Показать иконку расы рядом с именем кандидата"
--[[Translation missing --]]
L["showTimedKeys"] = "showTimedKeys"
--[[Translation missing --]]
L["showTimedKeysDescription"] = "showTimedKeysDescription"
L["sortApplicants"] = "Сортировать кандидатов"
L["sortApplicantsDescription"] = "Сортировка кандидатов - правило: Приоритет специализации > (Основной) рейтинг > Уровень предметов"
L["sortAscending"] = "Сортировать по возрастанию"
L["sortAscendingDescription"] = "Сортировать список по возрастанию, а не по убыванию"
L["sortGroupsByScore"] = "Сортировать группы по рейтингу"
L["sortGroupsByScoreDescription"] = "Сортировка групп по рейтингу лидера группы"
L["ten"] = "10+"
L["twenty"] = "20+"
L["useMainInfo"] = "Использовать основную информацию"
--[[Translation missing --]]
L["useMainInfoDescription"] = "useMainInfoDescription"
L["useMainScore"] = "Использовать основной рейтинг"
L["useMainScoreDescription"] = "Использовать основной рейтинг вместо текущего для отображения и сортировки"
L["useOfWrongRoleHighlight"] = "Использовать выделение неправильной роли"
--[[Translation missing --]]
L["useOfWrongRoleHighlightDescription"] = "useOfWrongRoleHighlightDescription"
--[[Translation missing --]]
L["wrongRoleScoreLimitForSorting"] = "wrongRoleScoreLimitForSorting"
--[[Translation missing --]]
L["wrongRoleScoreLimitForSortingDescription"] = "wrongRoleScoreLimitForSortingDescription"



GFIO.localisation = L
end