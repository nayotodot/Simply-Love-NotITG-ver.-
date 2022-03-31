-- ApplyNoteSkinForOtherPlayers.lua by Nayotodot.

-- [README.md]
-- Additional this code in `metrics.ini`.
--
-- ```ini
-- [ScreenBranchStage]
-- Fallback=Screen
-- Class=ScreenBranch
-- Fallback=ScreenBranch
-- Choices=1,2,3,4
-- Condition1=not GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentSong() == SONGMAN:FindSong("In The Groove/Training1/")
-- Condition2=GAMESTATE:IsCourseMode()
-- Condition3=GAMESTATE:IsEventMode()
-- Condition4=true
-- NextScreen1=mod,clearall;applydefaultoptions;screen,ScreenStage
-- NextScreen2=lua,ApplyNoteSkinForOtherPlayers;screen,ScreenStage;mod,FailImmediate
-- NextScreen3=lua,ApplyNoteSkinForOtherPlayers;screen,ScreenStage
-- NextScreen4=lua,ApplyNoteSkinForOtherPlayers;screen,ScreenStage
-- ```

function ApplyNoteSkinForOtherPlayers()
	if GameState.ApplyModifiers then
		for pn = 1,8 do
			GAMESTATE:ApplyModifiers( "Shaq", pn );
		end
	end
end
