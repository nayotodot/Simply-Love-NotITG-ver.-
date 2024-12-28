-- ToDo: Trail bug fixed
local format = string.format;
local gsub   = string.gsub;

local concat = table.concat;
local insert = table.insert;

function GetResumedScreen()
	Trace("GetResumedScreen()");
	if FUCK_EXE and GAMESTATE:IsEventMode() then
		local Profile = PROFILEMAN:GetMachineProfile():GetSaved();
		if Profile.Resumed and Profile.Resumed.Use then
			local Resumed = Profile.Resumed;
			if Resumed then
				local ResumedScreen           = Resumed.Screen or "";
				local ResumedPlayModeName     = Resumed.PlayModeName or "";
				local ResumedCurStyleName     = Resumed.CurStyleName or "none";
				local ResumedPlayerNumber     = Resumed.PlayerNumber;
				local ResumedGameName         = Resumed.GameName;
				local ResumedSongDir          = Resumed.SongDir;
				local ResumedDifficulty       = Resumed.Difficulty;
				local ResumedCourseTitle      = Resumed.CourseTitle;
				if ResumedScreen ~= "" then
					local t = {};
					if ResumedPlayModeName ~= "" then
						insert(t, "PlayMode," .. ResumedPlayModeName);
					end
					if ResumedCurStyleName ~= "none" then
						insert(t, "Style," .. ResumedCurStyleName);
					end
					if ResumedGameName then
						insert(t, "Game," .. ResumedGameName);
					end
					if ResumedSongDir and ResumedDifficulty then
						local Song = SONGMAN:FindSong(ResumedSongDir);
						if Song then
							GAMESTATE:SetCurrentSong(Song);
							local Steps = Song:GetAllSteps();
							for i = 1, #Steps do
								if DifficultyToThemedString(Steps[i]:GetDifficulty()) == ResumedDifficulty then
									GAMESTATE:SetCurrentSteps(PLAYER_1, Steps[i]);
									GAMESTATE:SetCurrentSteps(PLAYER_2, Steps[i]);
									break;
								end
							end
						elseif ResumedScreen == "ScreenEdit" then
							ResumedScreen = "ScreenEditMenu";
						end
					elseif ResumedCourseTitle then
						local Course = SONGMAN:FindCourse(ResumedCourseTitle);
						if Course then
							GAMESTATE:SetCurrentCourse(Course);
						end
					end
					if ResumedPlayerNumber then
						GAMESTATE:JoinPlayer(ResumedPlayerNumber);
					end
					GAMESTATE:ApplyGameCommand(concat(t, ";"));
					return ResumedScreen;
				end
			end
		end
	end
	return THEME:GetMetric("Common", "FirstAttractScreen");
end

local function Rename(name)
	if name == "ScreenGameplay" then
		return GAMESTATE:IsCourseMode() and "ScreenSelectMusicCourse" or "ScreenSelectMusic";
	end
	return name;
end

local PrevScreen = "";

function SetResumedScreen(self)
	Trace("SetResumedScreen()");
	if FUCK_EXE and GAMESTATE:IsEventMode() then
		local name = self:GetName();
		if name == PrevScreen then
			Trace(format("SetResumedScreen(): `%s` is duplicate load.", name));
			return;
		end
		PrevScreen = name;
		if name == "ScreenEdit"
		or name == "ScreenEditMenu"
		or name == "ScreenGameplay"
		or name == "ScreenLove"
		or name == "ScreenSelectMusic"
		or name == "ScreenSelectMusicCourse"
		or name == "ScreenTitleMenu" then
			local MasterPlayerNumber = GAMESTATE:GetMasterPlayerNumber();
			local Game = GAMESTATE:GetCurrentGame();
			local Song = GAMESTATE:GetCurrentSong();
			local Steps = GAMESTATE:GetCurrentSteps(MasterPlayerNumber);
			local Course = GAMESTATE:GetCurrentCourse();
			local Profile = PROFILEMAN:GetMachineProfile():GetSaved();
			if not Profile.Resumed then
				Profile.Resumed = {};
			end
			Profile.Resumed.Screen = Rename(name);
			Profile.Resumed.PlayModeName = PlayModeName();
			Profile.Resumed.CurStyleName = CurStyleName();
			Profile.Resumed.PlayerNumber = MasterPlayerNumber;
			Profile.Resumed.GameName = Game:GetName();
			Profile.Resumed.SongDir = Song and gsub(Song:GetSongDir(), "/Songs/", "");
			local Difficulty = Steps and Steps:GetDifficulty();
			Profile.Resumed.Difficulty = Difficulty and (Difficulty == DIFFICULTY_EDIT and Steps:GetDescription() or DifficultyToThemedString(Difficulty));
			Profile.Resumed.CourseTitle = Course and Course:GetDisplayFullTitle();
			SCREENMAN:OverlayMessage("Please Wait...");
			PROFILEMAN:SaveMachineProfile();
			SCREENMAN:HideOverlayMessage();
		end
	end
end
