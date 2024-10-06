-- ToDo: Trail bug fixed
local format = string.format;
local gsub   = string.gsub;

local concat = table.concat;
local insert = table.insert;

function GetResumedScreen()
	Trace("GetResumedScreen()");
	if FUCK_EXE and GAMESTATE:IsEventMode() then
		local Profile = PROFILEMAN:GetMachineProfile():GetSaved();
		if Profile.Resumed then
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
				-- local ResumedCourseDifficulty = Resumed.CourseDifficulty;
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
						insert(t, "Song," .. ResumedSongDir);
						insert(t, "Steps," .. ResumedDifficulty);
					elseif ResumedCourseTitle --[[ and ResumedCourseDifficulty ]] then
						insert(t, "Course," .. ResumedCourseTitle);
						-- insert(t, "Trail," .. ResumedCourseDifficulty);
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
	if FUCK_EXE then
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
			-- local Trail = GAMESTATE:GetCurrentTrail(MasterPlayerNumber);
			local Profile = PROFILEMAN:GetMachineProfile():GetSaved();
			Profile.Resumed = {
				Screen = Rename(name),
				PlayModeName = PlayModeName(),
				CurStyleName = CurStyleName(),
				PlayerNumber = MasterPlayerNumber,
			};
			if Game then
				Profile.Resumed.GameName = Game:GetName();
			end
			if Song then
				Profile.Resumed.SongDir = gsub(Song:GetSongDir(), "/Songs/", "");
				if Steps then
					local Difficulty = Steps:GetDifficulty();
					Profile.Resumed.Difficulty = Difficulty == DIFFICULTY_EDIT and Steps:GetDescription() or DifficultyToThemedString(Difficulty);
				end
			end
			if Course then
				Profile.Resumed.CourseTitle = Course:GetDisplayFullTitle();
				-- if Trail then
				-- 	Profile.Resumed.CourseDifficulty = CourseDifficultyToThemedString(Trail:GetDifficulty());
				-- end
			end
			SCREENMAN:OverlayMessage("Please Wait...");
			PROFILEMAN:SaveMachineProfile();
			SCREENMAN:HideOverlayMessage();
		end
	end
end
