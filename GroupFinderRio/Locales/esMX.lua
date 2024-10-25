local appName, GFIO = ...
local AceLocale = LibStub ('AceLocale-3.0')
local L = AceLocale:NewLocale(appName, "esMX")

if L then


-- LocalisationData[""] =
--[[Translation missing --]]
L["AccessOptionsMessage"] = "Access the options via /gfio"
--[[Translation missing --]]
L["addHighestDifficulty"] = "Add Highest Difficulty"
--[[Translation missing --]]
L["addHighestDifficultyDescription"] = "Add the highest completed difficulty (Either keylevel or Raidprogress)"
--[[Translation missing --]]
L["addonOptions"] = "Addon Options"
--[[Translation missing --]]
L["addScoreToGroup"] = "Add highest Score to Group"
--[[Translation missing --]]
L["addScoreToGroupDescription"] = "Add the highest Score of the GroupLeader to the Group View. (This can be both main and current character score)"
--[[Translation missing --]]
L["applicantView"] = "Applicant View"
--[[Translation missing --]]
L["Disable"] = "Disabled"
--[[Translation missing --]]
L["disableSpecSelector"] = "Disable Spec Selector"
--[[Translation missing --]]
L["disableSpecSelectorDescription"] = "Disable the Spec Selector in the Application view which can be used to prioritise specs in searching"
--[[Translation missing --]]
L["enableSpecPriority"] = "Enable Spec Priority"
--[[Translation missing --]]
L["fifteen"] = "15+"
--[[Translation missing --]]
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
--[[Translation missing --]]
L["showCurrentScoreInGroup"] = "Show Current Score in Group"
--[[Translation missing --]]
L["showCurrentScoreInGroupDescription"] = "Show the current Score of the GroupLeader in addition to the highest score (if different)"
--[[Translation missing --]]
L["showInfoInActivityName"] = "Show Info in Activity Name"
--[[Translation missing --]]
L["showInfoInActivityNameDescription"] = "Show information in the Activity Name in the Group View"
--[[Translation missing --]]
L["showKeyLevel"] = "Show Key Level"
--[[Translation missing --]]
L["showKeyLevelApplicants"] = "Show Key Level"
--[[Translation missing --]]
L["showKeyLevelApplicantsDescription"] = "Show the highest completed Key Level of the Applicant for the current Dungeon"
--[[Translation missing --]]
L["showKeyLevelDescription"] = "Show the highest completed Key Level of the Applicant for the current Dungeon"
--[[Translation missing --]]
L["showKeyLevelLeader"] = "Show Key Level"
--[[Translation missing --]]
L["showKeyLevelLeaderDescription"] = "Show the highest completed Key Level of the GroupLeader in the Group View"
--[[Translation missing --]]
L["showLanguage"] = "Show Language"
--[[Translation missing --]]
L["showLanguageDescription"] = "Show the Language of Applicants and the GroupLeader"
--[[Translation missing --]]
L["showNote"] = "Show Note"
--[[Translation missing --]]
L["showNoteDescription"] = "Show an icon if an Applicant has added a Note"
--[[Translation missing --]]
L["showRaceIcon"] = "Show race Icon"
--[[Translation missing --]]
L["showRaceIconDescription"] = "Show a race icon next to the name of the applicant"
--[[Translation missing --]]
L["showTimedKeys"] = "Show Timed Keys"
--[[Translation missing --]]
L["showTimedKeysDescription"] = "Show the amount of the timed keys above a certain threshold in the Applicant View"
--[[Translation missing --]]
L["sortApplicants"] = "Sort Applicants"
--[[Translation missing --]]
L["sortApplicantsDescription"] = "Sort the Applicants - rule is Spec Priority > (Main) Score > Item Level"
--[[Translation missing --]]
L["sortAscending"] = "Sort Ascending"
--[[Translation missing --]]
L["sortAscendingDescription"] = "Sort the list in Ascending order instead of descending"
--[[Translation missing --]]
L["sortGroupsByScore"] = "Sort Groups by Score"
--[[Translation missing --]]
L["sortGroupsByScoreDescription"] = "Sort the Groups by the Score of the GroupLeader"
--[[Translation missing --]]
L["ten"] = "10+"
--[[Translation missing --]]
L["twenty"] = "20+"
--[[Translation missing --]]
L["useMainInfo"] = "Use Main Info"
--[[Translation missing --]]
L["useMainInfoDescription"] = "Use the Progress or Score info of the main instead of the current Score for display and sort (if available)"
--[[Translation missing --]]
L["useMainScore"] = "Use Main Score"
--[[Translation missing --]]
L["useMainScoreDescription"] = "Use the Main Score instead of the current Score for display and sort"
--[[Translation missing --]]
L["useOfWrongRoleHighlight"] = "Use Wrong Role Highlight"
--[[Translation missing --]]
L["useOfWrongRoleHighlightDescription"] = "Highlights the Spec Icon in the Application View if the Applicant is not using the Role with the highest Score"
--[[Translation missing --]]
L["wrongRoleScoreLimitForSorting"] = "Wrong Role Score Limit for Sorting"
--[[Translation missing --]]
L["wrongRoleScoreLimitForSortingDescription"] = "The Score Limit for the Sorting Offroles behind mainroles. If set to 0 will always sort mainrole before offrole. If set to 5000 will always ignore main or offrole and only sort by score"



GFIO.localisation = L
end