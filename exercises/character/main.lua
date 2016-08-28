LoadLibrary("Renderer")
LoadLibrary("Sprite")
LoadLibrary("System")
LoadLibrary("Texture")
LoadLibrary("Vector")
LoadLibrary("Asset")
LoadLibrary("Keyboard")

Asset.Run("Animation.lua")
Asset.Run("Map.lua")
Asset.Run("Util.lua")
Asset.Run("Entity.lua")
Asset.Run("StateMachine.lua")
Asset.Run("MoveState.lua")
Asset.Run("WaitState.lua")
Asset.Run("Tween.lua")
Asset.Run("small_room.lua")


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

local gHero
gHero = 
{
	mAnimUp =    {1,  2,  3,  4 },
	mAnimRight = {5,  6,  7,  8 },
	mAnimDown =  {9,  10, 11, 12},
	mAnimLeft =  {13, 14, 15, 16},
	mEntity = Entity:Create(heroDef),
	Init =
	function(self)
        self.mController = StateMachine:Create
        {
            ['wait'] = function() return self.mWaitState end,
            ['move'] = function() return self.mMoveState end,
        }
        self.mWaitState = WaitState:Create(self, gMap)
        self.mMoveState = MoveState:Create(self, gMap)
        self.mController:Change("wait")
    end
}
gHero:Init()

function Teleport(entity, map)
    local x, y = map:GetTileFoot(entity.mTileX, entity.mTileY)
	entity.mSprite:SetPosition(x, y + entity.mHeight / 2)
end
Teleport(gHero.mEntity, gMap)

function update()
    local dt = GetDeltaTime()

    local playerPos = gHero.mEntity.mSprite:GetPosition()
    gMap.mCamX = math.floor(playerPos:X())
    gMap.mCamY = math.floor(playerPos:Y())

    gRenderer:Translate(-gMap.mCamX, -gMap.mCamY)
    gMap:Render(gRenderer)
    gRenderer:DrawSprite(gHero.mEntity.mSprite)

    gHero.mController:Update(dt)
end