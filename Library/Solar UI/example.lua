-- Load the Library
local Solar = loadstring(game:HttpGet("https://raw.githubusercontent.com/sikewhich/sikewhich/refs/heads/main/Library/Solar%20UI/main.lua"))()

-- 1. Create a new Window
local Window = Solar:Window("Solar UI Example")

-- 2. Create the first tab (e.g., "Main")
local MainTab = Window:Tab("Main", "rbxassetid://3944680095") -- Icon ID is optional

-- Adding a Button
MainTab:Button("Print Hello to Console", function()
    print("Hello, World!")
    Solar:Notify("Button Clicked!", 2)
end)

-- Adding a Toggle
MainTab:Toggle("Infinite Jump", function(state)
    print("Infinite Jump is now:", state)
    if state then
        Solar:Notify("Infinite Jump Enabled", 2)
    else
        Solar:Notify("Infinite Jump Disabled", 2)
    end
end)

-- Adding a Slider
MainTab:Slider("Walk Speed", 16, 100, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)

-- Adding a Label
MainTab:Label("This is a static text label.")

-- Adding a Dropdown
local Options = {"Option A", "Option B", "Option C", "Option D"}
MainTab:Dropdown("Select Option", Options, function(selected)
    print("Selected:", selected)
    Solar:Notify("You selected: " .. selected, 2)
end)

-- Adding an Input
MainTab:Input("Type something here...", function(text, entered)
    if entered then -- If user pressed Enter
        print("Input submitted:", text)
        Solar:Notify("Submitted: " .. text, 2)
    end
end)

-- Adding a Keybind
MainTab:Keybind("Toggle UI Keybind", function(key)
    print("Key pressed:", key.Name)
    Solar:Notify("Key pressed: " .. key.Name, 1)
end)


-- 3. Create a second tab (e.g., "Settings")
local SettingsTab = Window:Tab("Settings", "rbxassetid://3944679416")

-- Adding an Expander (The library calls this 'Expander', it functions like a toggle/slider hybrid)
SettingsTab:Expander("Master Switch", function(state)
    print("Master Switch state:", state)
    if state then
        Solar:Notify("Systems Online", 2)
    else
        Solar:Notify("Systems Offline", 2)
    end
end)

SettingsTab:Button("Destroy UI", function()
    Solar:Notify("Destroying UI in 1 second...", 1)
    wait(1)
    -- You would typically handle cleanup specific to your script here.
    -- The Red X button on the window handles the actual GUI destruction.
end)

-- 4. Initial Notification
Solar:Notify("Solar UI Loaded Successfully!", 3)
