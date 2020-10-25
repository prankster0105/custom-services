
--Inject all types defined in the module
require(script.Parent.Misc.TypeDefinitions);

local Signal = require(script.Parent.Misc.Signal);

local Players = {};
Players.__index = Players;

local LocalPlayer = require(script.Parent.LocalPlayer);


Players.PlayerAdded = Signal.new("PlayerAdded");
Players.PlayerRemoving = Signal.new("PlayerRemoving");

game.Players.PlayerAdded:Connect(function(plr)
    Players.PlayerAdded:Fire(plr);
    Players.addPlayer(plr);
end)

game.Players.PlayerRemoving:Connect(function(plr)
    Players.PlayerRemoving:Fire(plr);

    Players.removePlayer(plr);
end)

function Players.addPlayer(player)
    local playerObj: User;

    local playerChar: Character = {
        Name = player.Character.Name;
        Player = playerObj;
        RootPart = player.Character.HumanoidRootPart;
        Humanoid = player.Character.Humanoid;
        Position = player.Character.HumanoidRootPart.Position;
        WalkSpeed = player.Character.Humanoid.WalkSpeed;
        CharacterAdded = Signal.new("CharacterAdded");
    }

    playerObj = {
        username = player.Name;
        userid = player.UserId;
        Character = playerChar;

    }

    Players[playerObj.username] = playerObj;

end

function Players.removePlayer(player)
    assert(Players[player.Name], "Could not find player to remove.");

    Players[player.Name] = nil;
end