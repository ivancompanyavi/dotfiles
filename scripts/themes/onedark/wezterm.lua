theme = {}

function theme.get_theme(appearance)
	if appearance:find("Dark") then
		return "One Dark (Gogh)"
	else
		return "One Light (Gogh)"
	end
end

return theme
