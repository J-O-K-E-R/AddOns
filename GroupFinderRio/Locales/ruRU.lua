local appName, GFIO = ...
local AceLocale = LibStub ('AceLocale-3.0')
local L = AceLocale:NewLocale(appName, "ruRU")

if L then


-- LocalisationData[""] =
L["AccessOptionsMessage"] = "Доступ к настройкам через /gfio"
L["addHighestDifficulty"] = "Добавить максимальную сложность"
L["addHighestDifficultyDescription"] = "Добавить наивысшую пройденную сложность (либо уровень ключа, либо рейдовый прогресс)"
L["addonOptions"] = "Настройки аддона"
L["addScoreToGroup"] = "Добавить рейтинг в группу"
L["addScoreToGroupDescription"] = "Добавить рейтинг лидера группы в просмотр групп"
L["applicantView"] = "Просмотр кандидата"
--[[Translation missing --]]
L["Disable"] = "Disabled"
--[[Translation missing --]]
L["disableSpecSelector"] = "Disable Spec Selector"
--[[Translation missing --]]
L["disableSpecSelectorDescription"] = "Disable the Spec Selector in the Application view which can be used to prioritise specs in searching"
L["enableSpecPriority"] = "Включить приоритет специализации"
L["fifteen"] = "15+"
L["five"] = "5+"
--[[Translation missing --]]
L["groupNameBeforeScore"] = "Group Name before Score"
--[[Translation missing --]]
L["groupNameBeforeScoreDescription"] = "Show the Group Name before the Score of the GroupLeader instead of after"
--[[Translation missing --]]
L["groupView"] = "Group View"
--[[Translation missing --]]
L["highest"] = "Highest Keylevel"
--[[Translation missing --]]
L["oneClickSignup"] = "One Click Signup"
--[[Translation missing --]]
L["oneClickSignupDescription"] = "Sign up for a group with one click"
--[[Translation missing --]]
L["OneClickSignupNotAvailable"] = "One Click Signup is not available with Premades Group Filter enabled please disable the option and use Premades Group Filters setting instead"
--[[Translation missing --]]
L["resortGroupsConstantly"] = "Resort Groups Constantly"
--[[Translation missing --]]
L["resortGroupsConstantlyDescription"] = "Resort the groups every 3 Seconds to remove groups that are no longer available and update score if data becomes available later."
--[[Translation missing --]]
L["shortenActivityName"] = "Shorten Activity Name"
--[[Translation missing --]]
L["shortenActivityNameDescription"] = "Shorten the Activity Name in the Group View"
L["showCurrentScoreInGroup"] = "Показать текущий рейтинг в группе"
L["showCurrentScoreInGroupDescription"] = "Показать текущий рейтинг лидера группы в просмотре групп"
--[[Translation missing --]]
L["showInfoInActivityName"] = "Show Info in Activity Name"
--[[Translation missing --]]
L["showInfoInActivityNameDescription"] = "Show information in the Activity Name in the Group View"
L["showKeyLevel"] = "Показать уровень ключа"
L["showKeyLevelApplicants"] = "Показать уровень ключа кандидата"
L["showKeyLevelApplicantsDescription"] = "Показать наивысший пройденный уровень ключа кандидата для текущего подземелья"
L["showKeyLevelDescription"] = "Показать наивысший пройденный уровень ключа для текущего подземелья"
L["showKeyLevelLeader"] = "Показать уровень ключа лидера"
L["showKeyLevelLeaderDescription"] = "Показывать наивысший завершенный уровень ключа лидера группы в просмотре групп"
L["showLanguage"] = "Показать язык"
L["showLanguageDescription"] = "Показать язык кандидатов и лидера группы"
L["showNote"] = "Показать примечание"
L["showNoteDescription"] = "Показывать значок, если кандидат добавил примечание"
--[[Translation missing --]]
L["showRaceIcon"] = "Show race Icon"
--[[Translation missing --]]
L["showRaceIconDescription"] = "Show a race icon next to the name of the applicant"
--[[Translation missing --]]
L["showTimedKeys"] = "Show Timed Keys"
--[[Translation missing --]]
L["showTimedKeysDescription"] = "Show the amount of the timed keys above a certain threshold in the Applicant View"
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
L["useMainInfoDescription"] = "Use the Progress or Score info of the main instead of the current Score for display and sort (if available)"
L["useMainScore"] = "Использовать основной рейтинг"
L["useMainScoreDescription"] = "Использовать основной рейтинг вместо текущего для отображения и сортировки"
L["useOfWrongRoleHighlight"] = "Использовать выделение неправильной роли"
--[[Translation missing --]]
L["useOfWrongRoleHighlightDescription"] = "Highlights the Spec Icon in the Application View if the Applicant is not using the Role with the highest Score"
--[[Translation missing --]]
L["wrongRoleScoreLimitForSorting"] = "Wrong Role Score Limit for Sorting"
--[[Translation missing --]]
L["wrongRoleScoreLimitForSortingDescription"] = "The Score Limit for the Sorting Offroles behind mainroles. If set to 0 will always sort mainrole before offrole. If set to 5000 will always ignore main or offrole and only sort by score"



GFIO.localisation = L
end