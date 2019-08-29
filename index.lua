--Vars
local UserInputService = game:GetService("UserInputService")
local Chars = game.workspace.Chars
local Camera = game.Workspace.Camera
local p = game:GetService("Players").LocalPlayer
local mouse = p:GetMouse()
local fov = 75
local WHB = game.ReplicatedStorage.SharedVars.Bomber.Value
local a = false
local b = false
local c = false
local d = false
local e = false
local f = false
local g = false
local j = false
local aa = false
--/Vars

--UI
local Settings={
	UIName='OS Beta';
	MainColor=Color3.fromRGB(245, 255, 100);
	ToggleKey='RightControl';
};

local Storage=Instance.new'ScreenGui';
Storage.Name = "BackFire"
Storage.Parent=game:GetService'RunService':IsStudio()and (wait(2/3)and game:GetService'Players'.LocalPlayer.PlayerGui or nil) or game:GetService'CoreGui';
local OptionsForColors={
	TEXT_='TextColor3';
	BACKGROUND='BackgroundColor3';
};
local function Colorize(I) -- Great var name!
	for i,v in next,OptionsForColors do
		if I.Name:find(i) and I[v]then
			I[v]=Settings.MainColor;
		else
			-- print(I.Name, 'noped', i);
		end;
	end;
	I.ChildAdded:Connect(Colorize);
end;
Storage.ChildAdded:Connect(Colorize);

local Main=Instance.new'Frame';Main.Name='MainFrame';
Main.BackgroundTransparency=1;Main.BorderSizePixel=0;
Main.Size=UDim2.new(1,0,1,0);
Main.Parent=Storage;Main.Visible=false;
local HUD=Main:Clone();
HUD.Name='HUD';
HUD.Parent=Storage;
HUD.Visible=true;

local UILabel=Instance.new'TextLabel';
UILabel.Name='TEXT_UILabel';
UILabel.BackgroundTransparency=1;UILabel.BorderSizePixel=0;
UILabel.Position=UDim2.new(0.05,0,0.85,0);
UILabel.Size=UDim2.new(0.15,0,0.1,0);
UILabel.Text=Settings.UIName;
UILabel.TextScaled=true;
UILabel.Font=Enum.Font.SourceSansLight;
UILabel.Parent=Main;

local Tabs={};
local Toggles={};
local ToggleSettings={};
local X=10;

local function UpdateArrayList()
	local Y=0;
	for i,v in ipairs(HUD:GetChildren())do
		if v.Name:find'ARR_' then
			v:Destroy();
		end;
	end;
	for i,v in ipairs(Main:GetDescendants())do
		if v.Name:find'TOGGLE_' then
			local P1,P2=v.Name:find'TOGGLE_';
			local Name=v.Name:sub(P2+1);
			v.TextColor3=Toggles[Name]and Settings.MainColor or Color3.new(1,1,1);
		end;
	end;
	for i,v in next,Toggles do
		if v then
			local Label=Instance.new'TextLabel';
			Label.Name='TEXT_ARR_'..i;
			Label.BackgroundTransparency=1;Label.BorderSizePixel=0;
			Label.Position=UDim2.new(0.1,-5,0,Y);
			Label.Size=UDim2.new(0.9,0,0,30);
			Label.Text=i;
			Label.TextScaled=true;
			Label.Font=Enum.Font.SourceSansLight;
			Label.TextXAlignment=Enum.TextXAlignment.Right;
			Label.Parent=HUD;
			Y=Y+30
		end;
	end;
end;

local function CreateTab(TabName)
	Tabs[TabName]={};
	Tabs[TabName].Toggles={};
	local Frame=Instance.new'TextLabel';
	Frame.Name='BACKGROUND_'..TabName;
	Frame.BorderSizePixel=0;
	Frame.Position=UDim2.new(0,X,0,10);
	Frame.Active=true;
	Frame.Draggable=true;
	Frame.Size=UDim2.new(0,250,0,30);
	Frame.TextColor3=Color3.fromRGB(84,84,84);
	Frame.TextSize=18;
	Frame.Font=Enum.Font.SourceSansLight;
	Frame.Text=TabName;
	Frame.Parent=Main;
	local Toggle=Instance.new'TextButton';
	Toggle.Name=TabName..'Toggle';
	Toggle.BackgroundTransparency=1;
	Toggle.BorderSizePixel=0;
	Toggle.Position=UDim2.new(0,220,0,0);
	Toggle.Size=UDim2.new(0,30,0,30);
	Toggle.TextColor3=Color3.fromRGB(84,84,84)
	Toggle.TextSize=16
	Toggle.Text='-';
	Toggle.Font=Enum.Font.SciFi;
	Toggle.Parent=Frame;
	local Y=0;
	local Frame2=Instance.new'Frame';
	Frame2.Name=TabName..'Dropdown';
	Frame2.BackgroundColor3=Color3.new(0,0,0);
	Frame2.BackgroundTransparency=0.5;
	Frame2.BorderSizePixel=0;
	Frame2.Position=UDim2.new(0,0,0,30);
	Frame2.Size=UDim2.new(0,250,0,0);
	Frame2.ClipsDescendants=true;
	Frame2.Parent=Frame;

	Tabs[TabName].OpenClose=function()
		if Frame2.Size==UDim2.new(0,250,0,Y)or Frame2.Size==UDim2.new(0,250,0,0)then
			Frame2:TweenSize(Toggle.Text=='+' and UDim2.new(0,250,0,Y)or UDim2.new(0,250,0,0), 'Out', 'Quad', 1/3);
			Toggle.Text=Toggle.Text=='-' and '+' or '-'
		end;
	end;Toggle.MouseButton1Click:Connect(Tabs[TabName].OpenClose);
	Tabs[TabName].AddToggle=function(ToggleName,Optional)
		if Tabs[TabName].ToggleName==nil then
			local Button=Instance.new'TextButton';
			Button.Name='TOGGLE_'..ToggleName
			Button.BackgroundTransparency=1;
			Button.BorderSizePixel=0;
			Button.Position=UDim2.new(0,5,0,Y);
			Y=Y+25;
			Frame2.Size=Frame2.Size+UDim2.new(0,0,0,25);
			Button.Size=UDim2.new(0,245,0,25);
			Button.Text='> '..ToggleName;
			Button.TextColor3=Color3.new(1,1,1);
			Button.TextSize=16;
			Button.Font=Enum.Font.SourceSansSemibold
			Button.TextXAlignment=Enum.TextXAlignment.Left;
			Button.Parent=Frame2;
			Toggles[ToggleName]=false;
			ToggleSettings[ToggleName]=Optional;
			Button.MouseButton1Click:Connect(function()
				Toggles[ToggleName]=not Toggles[ToggleName];
				UpdateArrayList();
			end);
			return Button;
		end;
	end;


	X = X + 300
end;

game:GetService'UserInputService'.InputBegan:Connect(function(IO,GPE)
	if IO.KeyCode==Enum.KeyCode[Settings.ToggleKey]then
		Main.Visible=not Main.Visible;
	end;
end);

--------------------------------------------------------------

CreateTab'OS_Beta';
Tabs.OS_Beta.AddToggle'ESP';
Tabs.OS_Beta.AddToggle'Aimbot';
Tabs.OS_Beta.AddToggle'ThirdPerson';
Tabs.OS_Beta.AddToggle'WallColl';
Tabs.OS_Beta.AddToggle'FovChanger';
CreateTab'Other';
Tabs.Other.AddToggle'Spawn_Switcher';
Tabs.Other.AddToggle'Bomb_Switcher';
Tabs.Other.AddToggle'PingSpoofer';

--/UI

--Aimbot
local safe = setmetatable({}, {   __index = function(_, k)
    return game:GetService(k)
end
})

local movethemouse = mousemoverel or Input.MoveMouse --Mouse Move Function.
local leftclickme = nil --Auto Shoot Key Press Thingy.
local aimbotting = true -- Toggles.
local autoshoot = false
local teamcheck = true
local visiblecheck = true
_G.xaimoffset = 0 --_G.xaimoffset = -25
_G.maxdistfromcross = 100

local cam = safe.Workspace.CurrentCamera -- Current Camera
local lp = safe.Players.LocalPlayer -- Local Player
local lpc = safe.Players.LocalPlayer.Character -- Local Player Character

local wtos = function(v) -- World To Screen
return cam:WorldToScreenPoint(v)
end

local distFromCenter = function(x, y)
local vps = cam.ViewportSize -- Get ViewPortSize.
local vpsx = vps.X
local vpsy = vps.Y
local screencenterx = vpsx/2
local screencentery = vpsy/2
local xdist = (x - screencenterx) -- X Distance From Mid Screen.
local ydist = (y - screencentery) -- Y Distance From Mid Screen.
local Hypotenuse = math.sqrt(math.pow(xdist, 2) + math.pow(ydist, 2))
return Hypotenuse
end

local function inlos(p, ...) -- In line of site?
return #cam:GetPartsObscuringTarget({p}, {cam, lp.Character, ...}) == 0
end

local getclosestPlayer = function() -- Checks the closest player based on Hypotenuse.
local plrs, v = safe.Players:GetPlayers()
local maxdist = 75
local dist = math.huge
local plr = "none"
for i = 1, #plrs do
    v = plrs[i]
    if v ~= safe.Players.LocalPlayer then
        if v.Character then
            if v.TeamColor ~= safe.Players.LocalPlayer.TeamColor and teamcheck then
                local hpos = wtos(v.Character.Head.Position)
                local idist = distFromCenter(hpos.X, hpos.Y)
                if idist < dist and idist < _G.maxdistfromcross then
                    dist = idist
                    plr = v
                end
            elseif not teamcheck then
                local hpos = wtos(v.Character.Head.Position)
                local idist = distFromCenter(hpos.X, hpos.Y)
                if idist < dist and idist < _G.maxdistfromcross then
                    dist = idist
                    plr = v
                end
            end
        end
    end
end
return plr, dist
end

local AimAt = function(x, y)
local vps = cam.ViewportSize
local vpsx = vps.X
local vpsy = vps.Y
local screencenterx = vpsx/2
local screencentery = vpsy/2
local aimspeed = 5
local aimatx
local aimaty

if x ~= 0 then
    if x > screencenterx then
        aimatx = -(screencenterx - x)
        aimatx = aimatx/aimspeed
        if aimatx + screencenterx > screencenterx * 2 then
            aimatx = 0
        end
    end
    if x < screencenterx then
        aimatx = x - screencenterx
        aimatx = aimatx/aimspeed
        if aimatx + screencenterx < 0 then
            aimatx = 0
        end
    end
end

if y ~= 0 then
    if y > screencentery then
        aimaty = -(screencentery - y)
        aimaty = aimaty/aimspeed
        if aimaty + screencentery > screencentery * 2 then
            aimaty = 0
        end
    end
    if y < screencentery then
        aimaty = y - screencentery
        aimaty = aimaty/aimspeed
        if aimaty + screencentery < 0 then
            aimaty = 0
        end
    end
end
return aimatx, aimaty
end

local MouseTests = function()
local player = safe.Players.LocalPlayer
local mouse = player:GetMouse()
local screensizex = mouse.ViewSizeX
local screensizey = mouse.ViewSizeY
local midx = screensizex/2
local midy = screensizey/2
local mousex = mouse.X
local mousey = mouse.Y
local moveamountx = midx - mousex
local moveamounty = midy - mousey
movethemouse(moveamountx, moveamounty)
local camera = safe.Workspace.Camera
local newmousex = safe.Players.LocalPlayer:GetMouse().X
local newmousey = safe.Players.LocalPlayer:GetMouse().Y
local closestplayer = getclosestPlayer()
if player.Character.Humanoid.Health > 0 then
    if closestplayer ~= "none" then
        if inlos(closestplayer.Character.Head.Position, closestplayer.Character) and visiblecheck then
            local closesthead = closestplayer.Character.Head
            local p = camera:WorldToScreenPoint(closesthead.Position)
            local xdistancetohead, ydistancetohead = AimAt(p.X + _G.xaimoffset, p.Y + 32)
            movethemouse(xdistancetohead, ydistancetohead)
            if autoshoot then
                movethemouse(xdistancetohead, ydistancetohead)
                wait(1)
                Input.LeftClick(MOUSE_DOWN)
                wait()
            end
elseif not visiblecheck then
local closesthead = closestplayer.Character.Head
            local p = camera:WorldToScreenPoint(closesthead.Position)
            local xdistancetohead, ydistancetohead = AimAt(p.X + _G.xaimoffset, p.Y + 32)
            movethemouse(xdistancetohead, ydistancetohead)
        end
    end
end
end

game:GetService('RunService').Stepped:connect(function()
if aimbotting then
--MouseTests()
end
end)


local plr = safe.Players.LocalPlayer
local mouse = plr:GetMouse()
mouse.KeyDown:connect(function(key)
if key == "t" then
    aimbotting = not aimbotting
    print("Aimbotting: " .. tostring(aimbotting))
    MouseTests()
end
if key == "o" then
    visiblecheck = not visiblecheck
    print("Visible Check: " .. tostring(visiblecheck))
end

if key == "m" then
    teamcheck = not teamcheck
    print("Team Check: " .. tostring(teamcheck))
end
end)

MB2Held = false

function onKeyPress(inputObject,gameProcessed)
if inputObject.UserInputType == Enum.UserInputType.MouseButton2 then
    MB2Held = true
    while MB2Held do
        if aimbotting then
            MouseTests()
        end
        wait()
    end
end
end

function onKeyRelease(inputObject,gameProcessed)
if inputObject.UserInputType == Enum.UserInputType.MouseButton2 then
    MB2Held = false
end
end

game:GetService("UserInputService").InputBegan:connect(onKeyPress)
game:GetService("UserInputService").InputEnded:connect(onKeyRelease)
--/Aimbot

--Esp
local gui = Instance.new("BillboardGui");
gui.Name = "";  
gui.AlwaysOnTop = true;
gui.LightInfluence = 0;
gui.Size = UDim2.new(2, 0, 2.5, 0);
local frame = Instance.new("Frame", gui);
frame.BackgroundColor3 = Color3.fromRGB(255, 51, 153);
frame.BackgroundTransparency = 0.75
frame.Size = UDim2.new(2, 0, 2.5, 0);
frame.BorderSizePixel = 1;
frame.BorderColor3 = Color3.fromRGB(0, 0, 0);
local gi = gui:Clone();
local body = frame:Clone();
body.Parent = gi;
body.BackgroundColor3 = Color3.fromRGB(0, 170, 170);
function esp()
	for i,l in pairs(game:GetService("Players"):GetChildren()) do
		if l ~= game:GetService("Players").LocalPlayer then
			if l.Team ~= game:GetService("Players").LocalPlayer.Team then
				local p = l.Name
					if Chars:FindFirstChild(p) then
						head = Chars:FindFirstChild(p).Head
						gui:Clone().Parent = head
					end
				end
			end
		end
	end
--/Esp

--rESP
function resp()
	for i,l in pairs(game:GetService("Players"):GetChildren()) do
		if l ~= game:GetService("Players").LocalPlayer then
			local p = l.Name
			if Chars:FindFirstChild(p) then
				head = Chars:FindFirstChild(p).Head
				for i,l in pairs(head:GetChildren()) do
					if l.ClassName == "BillboardGui" then
						l:Destroy()
					end
				end
			end
		end
	end
	end
--/rESP

--MainLoop
local Move = game.Workspace.Map
spawn(function()
	repeat wait(.5);

		if Toggles.PingSpoofer then
			if aa ==false then
				local rep = game.ReplicatedStorage
				local wfc = game.WaitForChild
				local gm = wfc(rep, "GlobalModules")
				local function requireGm(name)
    			return require(wfc(gm, name))
				end
				local rf = wfc(wfc(rep, "Events"), "PingRf")
				function rf.OnClientInvoke()
    				wait(10)
    				return true
				end
				aa = true
			end
		else
			if aa == true then
				local rep = game.ReplicatedStorage
				local wfc = game.WaitForChild
				local gm = wfc(rep, "GlobalModules")
				local function requireGm(name)
    			return require(wfc(gm, name))
				end
				local rf = wfc(wfc(rep, "Events"), "PingRf")
				function rf.OnClientInvoke()
    				return true
				end
				aa = false
			end
		end

		if Toggles.Bomb_Switcher then
			if j == false then
				local cs = game.workspace.Bombsites:FindFirstChild("Y").Position
				local p = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
				pos = CFrame.new(cs + Vector3.new(0,2.5,0))
				p.CFrame = pos
				--code
				j = true
			end
		else
			if j == true then
				local cs = game.workspace.Bombsites	:FindFirstChild("X").Position
				local p = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
				pos = CFrame.new(cs + Vector3.new(0,2.5,0))
				p.CFrame = pos
				--code
				j = false
			end
		end

		if Toggles.Spawn_Switcher then
			if g == false then
				local cs = game.workspace.Spawns.Atk:FindFirstChild("SpawnLocation").Position
				local p = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
				pos = CFrame.new(cs + Vector3.new(0,2.5,0))
				p.CFrame = pos
				g = true
			end
		else
			if g == true then
				local cs = game.workspace.Spawns.Def:FindFirstChild("SpawnLocation").Position
				local p = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
				pos = CFrame.new(cs + Vector3.new(0,2.5,0))
				p.CFrame = pos
				g = false
			end
		end

		if Toggles.WallColl then
			if f == false then
				Move.Parent = ReplicatedStorage
				p.Character.HumanoidRootPart.Anchored = true
				f = true
			end
		else
			if f == true then
				Move.Parent = game.Workspace
				p.Character.HumanoidRootPart.Anchored = false
				f = false
			end
		end

		if Toggles.ThirdPerson then
			if e == false then
				Camera.CameraSubject = p.Character.Head
				Camera.CameraType = "Follow"
				e = true
			end
		else
			if e == true then
				Camera.CameraSubject = p.Character.Humanoid
				Camera.CameraType = "Scriptable"
				e = false
			end
		end

		if Toggles.ESP then
			if d == false then
				esp()
				d = true
			end
		else
			if d == true then
				resp()
				d = false
			end
		end


		if Toggles.Aimbot then
			if c == false then
				aimbotting = not aimbotting
				c = true
			end
		else
			if c == true then
				aimbotting = not aimbotting
				c = false
			end
        end

		if Toggles.FovChanger then
			if b == false then
				fov = 120
				b = true
			end
		else
			if b == true then
			fov = 90
			b = false
			end
		end

		game:GetService("RunService").RenderStepped:connect(function()
			workspace.CurrentCamera.FieldOfView = fov
		end)

    until nil;
end)
--/MainLoop

--Notif
game:GetService('StarterGui'):SetCore("SendNotification", {Title = "OS_Beta", Text = "OS_Beta Loaded"})
game:GetService('StarterGui'):SetCore("SendNotification", {Title = "OS_Beta", Text = "Use right 'Ctrl' key to toggle gui"})
--/Notif
