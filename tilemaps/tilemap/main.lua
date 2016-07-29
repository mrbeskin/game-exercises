LoadLibrary("Renderer")
LoadLibrary("Sprite")
LoadLibrary("System")
LoadLibrary("Texture")
LoadLibrary("Asset")
LoadLibrary("Keyboard")

Asset.Run("Util.lua")
Asset.Run("Map.lua")
Asset.Run("larger_map.lua")

local gMap = Map:Create(CreateMap1())
gRenderer = Renderer:Create()

function update()
    gRenderer:Translate(-gMap.mCamX, -gMap.mCamY)
    gMap:Render(gRenderer)

    if Keyboard.Held(KEY_LEFT) then
        gMap.mCamX = gMap.mCamX - 1
    elseif Keyboard.Held(KEY_RIGHT) then
        gMap.mCamX = gMap.mCamX + 1
    end

    if Keyboard.Held(KEY_UP) then
        gMap.mCamY = gMap.mCamY + 1
    elseif Keyboard.Held(KEY_DOWN) then
        gMap.mCamY = gMap.mCamY -1
    end
end