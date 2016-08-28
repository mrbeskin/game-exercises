MoveState = {  mName = "move" }
MoveState.__index = MoveState
function MoveState:Create(character, map)
    local this =
    {
        mCharacter = character,
        mMap = map,
        mTileWidth = map.mTileWidth,
        mEntity = character.mEntity,
        mController = character.mController,
        mMoveX = 0,
        mMoveY = 0,
        mTween = Tween:Create(0, 0, 1),
        mMoveSpeed = 0.3
    }
    this.mAnim = Animation:Create({this.mEntity.mStartFrame})

    setmetatable(this, self)
    return this
end

function MoveState:Enter(data)

    local frames = nil

    if data.x == -1 then
    	frames = self.mCharacter.mAnimLeft
    elseif data.x == 1 then
    	frames = self.mCharacter.mAnimRight
    elseif data.y == -1 then
    	frames = self.mCharacter.mAnimUp
    elseif data.y == 1 then
    	frames = self.mCharacter.mAnimDown
    end

    self.mAnim:SetFrames(frames)

    self.mMoveX = data.x
    self.mMoveY = data.y
    local pixelPos = self.mEntity.mSprite:GetPosition()
    self.mPixelX = pixelPos:X()
    self.mPixelY = pixelPos:Y()
    self.mTween = Tween:Create(0, self.mTileWidth, self.mMoveSpeed)

    local targetX = self.mEntity.mTileX + data.x
    local targetY = self.mEntity.mTileY + data.y 

    if self.mMap:IsBlocked(1, targetX, targetY) then
    	self.mMoveX = 0
    	self.mMoveY = 0
    	self.mEntity:SetFrame(self.mAnim:Frame())
    	self.mController:Change("wait")
    end
end

function MoveState:Exit()

    self.mEntity.mTileX = self.mEntity.mTileX + self.mMoveX
    self.mEntity.mTileY = self.mEntity.mTileY + self.mMoveY
    Teleport(self.mEntity, self.mMap)

end
function MoveState:Render(renderer) end

function MoveState:Update(dt)

    self.mAnim:Update(dt)
    self.mEntity:SetFrame(self.mAnim:Frame())

    self.mTween:Update(dt)

    local value = self.mTween:Value()
    local x = self.mPixelX + (value * self.mMoveX)
    local y = self.mPixelY - (value * self.mMoveY)
    self.mEntity.mX = math.floor(x)
    self.mEntity.mY = math.floor(y)
    self.mEntity.mSprite:SetPosition(self.mEntity.mX , self.mEntity.mY)
    
    if self.mTween:IsFinished() then
        self.mController:Change("wait")
    end
end

