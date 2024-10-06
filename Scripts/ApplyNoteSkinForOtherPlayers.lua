local fmod = math.fmod or math.mod;

function ApplyNoteSkinForOtherPlayers()
	if GameState.GetCurrentNoteSkins and GameState.ApplyModifiers then
		local NoteSkins = GAMESTATE:GetCurrentNoteSkins();
		for pn = NUM_PLAYERS, 8 do
			local index = fmod(pn - 1, 2) + 1;
			if NoteSkins[index] then
				GAMESTATE:ApplyModifiers(NoteSkins[index], pn);
			end
		end
	end
end
