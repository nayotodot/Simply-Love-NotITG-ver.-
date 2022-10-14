local _M = {};
local Enabled = false;
local FailedP1;
local FailedP2;

function _M:Setup()
	FailedP1 = FailedP1 or self:GetChild( "FailedP1" );
	FailedP2 = FailedP2 or self:GetChild( "FailedP2" );

	FailedP1:get():pan( GAMESTATE:GetNumPlayersEnabled() == 2 and -1 or 0 );
	FailedP2:get():pan( GAMESTATE:GetNumPlayersEnabled() == 2 and  1 or 0 );

	self:addcommand( "FailP1Message", function(self) if Enabled then self:cmd( "playcommand,FailedP1" ); end end );
	self:addcommand( "FailP2Message", function(self) if Enabled then self:cmd( "playcommand,FailedP2" ); end end );

	Enabled = false;
end

function _M:Prepare()
	Enabled = true;
end

return _M;
