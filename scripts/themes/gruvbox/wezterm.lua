theme = {}

function theme.get_theme(appearance)
	if appearance:find "Dark" then
    return "Gruvbox dark, hard (base16)"
	else
    return "Gruvbox Light"
	end
end

return theme
