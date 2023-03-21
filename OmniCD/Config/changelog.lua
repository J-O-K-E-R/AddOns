local E, L, C = select(2, ...):unpack()

if E.isClassic then E.changelog = [=[
v1.14.3.2744
	version update

v1.14.3.2724
	Fixed sync for cross realm group members

Full list of changes can be found in the CHANGELOG file
]=]
elseif E.isBCC then E.changelog = [=[
v2.5.4.2722
	Fixed sync for cross realm group members

Full list of changes can be found in the CHANGELOG file
]=]
elseif E.isWOTLKC then E.changelog = [=[
v3.4.1.2744
	minor bug fixes

v3.4.1.2743
	Cooldowns will reset when an encounter ends
	Fixed nil error
	Jan 31, 2023 Hotfixes

Full list of changes can be found in the CHANGELOG file
]=]
else E.changelog = [=[
v10.0.5.2744
	Fixed Celestial Alignment (Incarnation) with Orbital Strike talented
	minor bug fixes

v10.0.5.2743
	Fixed Army of the Damned CDR by Epidemic
	Fixed Blessing of Santuary CD
	Fixed Kleptomania icon texture
	Feb 6, 2023 Hotfixes

Full list of changes can be found in the CHANGELOG file
]=]
end
