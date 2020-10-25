local LocalPlayer = {};
local client = {__index = LocalPlayer};

function LocalPlayer.create(userObj: User): User
    local clientObj: User = {
        Name = userObj.Name;
        Player = userObj.Player;
        Character = userObj.Character;
        RootPart = userObj.RootPart;
        Humanoid = userObj.Humanoid;
        WalkSpeed = userObj.WalkSpeed;
        CharacterAdded = userObj.CharacterAdded;
    }

    setmetatable(clientObj, client);
    return clientObj;
end



function LocalPlayer:GetPosition()
    return self.RootPart.Position;
end

function LocalPlayer:ToObjectSpace(object: Instance): CFrame
    return self.RootPart.CFrame:Inverse() * Instance.CFrame;
end

