Map = {}
Map.__index = Map
function Map:Create(mapDef)
	local layer = mapDef.layers[1]
    local this = {
        mX = 0,
        mY = 0,

        mCamX = 0,
        mCamY = 0,

        mMapDef = mapDef,
        mTextureAtlas = Texture.Find(mapDef.tilesets[1].image),

        mTileSprite = Sprite.Create(),
        mLayer = layer,
        mWidth = layer.width,
        mHeight = layer.height,

        mTiles = layer.data,
        mTileWidth = mapDef.tilesets[1].tilewidth,
        mTileHeight = mapDef.tilesets[1].tileheight
    }
    
    this.mTileSprite:SetTexture(this.mTextureAtlas)

    this.mX = -System.ScreenWidth() / 2 + this.mTileWidth / 2
    this.mY = System.ScreenHeight() / 2 - this.mTileHeight / 2 

    this.mWidthPixel = this.mWidth * this.mTileWidth
    this.mHeightPixel = this.mHeight * this.mTileHeight
    this.mUVs = GenerateUVs(mapDef.tilesets[1].tilewidth,
    	                    mapDef.tilesets[1].tileheight,
    	                    this.mTextureAtlas)

    setmetatable(this, self)
    return this
end

function Map:PointToTile(x, y)

	x = x + self.mTileWidth/2 
	y = y - self.mTileHeight/2

	x = math.max(self.mX, x)
    y = math.min(self.mY, y)
    x = math.min(self.mX + self.mWidthPixel - 1, x)
    y = math.max(self.mY - self.mHeightPixel + 1, y)

    local tileX = math.floor((x - self.mX) / self.mTileWidth)
    local tileY = math.floor((self.mY - y) / self.mTileHeight)

    return tileX, tileY
end 

function Map:GetTile(x, y)
    x = x + 1 -- change from  1 -> rowsize
              -- to           0 -> rowsize - 1
    return self.mTiles[x + y * self.mWidth]
end

function Map:Goto(x, y)
	self.mCamX = x - System.ScreenWidth() / 2
	self.mCamY = -y + System.ScreenWidth() / 2
end

function Map:Render(renderer)

    local tileLeft, tileBottom = 
        self:PointToTile(self.mCamX - System.ScreenWidth() / 2,
        	             self.mCamY - System.ScreenHeight() / 2)

    local tileRight, tileTop = 
        self:PointToTile(self.mCamX + System.ScreenWidth() / 2,
        	             self.mCamY + System.ScreenHeight() / 2)

    for j = tileTop, tileBottom do
    	for i = tileLeft, tileRight do

    		local tile = self:GetTile(i, j)
    		local uvs = self.mUVs[tile]

    		self.mTileSprite:SetUVs(unpack(uvs))

    		self.mTileSprite:SetPosition(self.mX + i * self.mTileWidth,
    			                         self.mY - j * self.mTileHeight)

    		renderer:DrawSprite(self.mTileSprite)

    	end
    end
end

