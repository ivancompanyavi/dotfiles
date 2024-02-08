theme = {}

function theme.get_theme(appearance)
	if appearance:find("Dark") then
		return "tokyonight"
	else
		return "tokyonight_day"
	end
end

return theme
