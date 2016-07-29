LoadLibrary("Renderer")
LoadLibrary("Sprite")
LoadLibrary("System")
LoadLibrary("Texture")
LoadLibrary("Asset")
LoadLibrary("Keyboard")


Asset.Run("Map.lua")
Asset.Run("Util.lua")
Asset.Run("small_room.lua")
Asset.Run("Entity.lua")

local gMap = Map:Create(CreateMap1())
gRenderer = Renderer:Create()

gMap:GotoTile(5, 5)

local heroDef = 
{
	texture = "walk_cycle.png",
	width          = 16,
	height         = 24,
	startFrame     = 9,
	tileX          = 10,
	tileY          = 2
}

gHero = Entity:Create(heroDef)

function Teleport(entity, map)
    local x, y = map:GetTileFoot(entity.mTileX, entity.mTileY)
	entity.mSprite:SetPosition(x, y + entity.mHeight / 2)
end
Teleport(gHero, gMap)

function update()
    gRenderer:Translate(-gMap.mCamX, -gMap.mCamY)
    gMap:Render(gRenderer)
    gRenderer:DrawSprite(gHero.mSprite)

    if Keyboard.JustPressed(KEY_LEFT) then
    	gHero.mTileX = gHero.mTileX - 1
    	Teleport(gHero, gMap)
    elseif Keyboard.JustPressed(KEY_RIGHT) then
    	gHero.mTileX = gHero.mTileX + 1
    	Teleport(gHero, gMap)
    end

    if Keyboard.JustPressed(KEY_UP) then
    	gHero.mTileY = gHero.mTileY - 1
    	Teleport(gHero, gMap)
    elseif Keyboard.JustPressed(KEY_DOWN) then
    	gHero.mTileY = gHero.mTileY + 1
    	Teleport(gHero, gMap)
    end



end