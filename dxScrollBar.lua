addEvent("dxscrollbar:change")

-- Tiny optimisations
local floor = math.floor
local min = math.min
local max = math.max

-- Class
DxScrollBar = {instances = {}, hoverSelf = false}

-- Local variables
local screen = Vector2(guiGetScreenSize())

-- Local functions
local function getn(t)
    local c = 0
    for _ in pairs(t) do
        c = c + 1
    end
    return c
end

local function isHover(x, y, w, h)
    if not isCursorShowing() then
        return false
    end

    local cursor = Vector2(getCursorPosition())
    local cursorX, cursorY = screen.x * cursor.x, screen.y * cursor.y

    if cursorX >= x and cursorX <= x + w and cursorY >= y and cursorY <= y + h then
        return true
    end
    return false
end

local function render()
    for self in pairs(DxScrollBar.instances) do
        if self.visible then
            if self.horizontal then
                dxDrawRectangle(self.x, self.y + (self.height / 2 - 5 / 2), self.width, 5, tocolor(unpack(self.trackColor)), false)
                dxDrawRectangle(self.x + self.offset, self.y, self.height, self.height, tocolor(unpack(self.squareColor)), false)

                if isHover(self.x + self.offset, self.y, self.height, self.height) then
                    DxScrollBar.hoverSelf = self
                end
            else
                dxDrawRectangle(self.x + (self.height / 2 - 5 / 2), self.y, 5, self.width, tocolor(unpack(self.trackColor)), false)
                dxDrawRectangle(self.x, self.y + self.offset, self.height, self.height, tocolor(unpack(self.squareColor)), false)

                if isHover(self.x, self.y + self.offset, self.height, self.height) then
                    DxScrollBar.hoverSelf = self
                end
            end

            if self.clicked then
                local cursor = Vector2(getCursorPosition())
                local cursorX, cursorY = screen.x * cursor.x, screen.y * cursor.y
                local currentX = (cursorX - self.x) - self.height / 2
                local currentY = (cursorY - self.y) - self.height / 2

                if self.horizontal then
                    self.offset = min(self.width - self.height, max(0, currentX))
                else
                    self.offset = min(self.width - self.height, max(0, currentY))
                end

                self.progress = floor(self.offset / (self.width - self.height) * 100)
                triggerEvent("dxscrollbar:change", self.element, self.progress)
            end
        end
    end
end

local function clicks(button, state)
    local isLeft = button == "left"
    local isUp = state == "up"

    local self = DxScrollBar.hoverSelf
    if self == false then
        return false
    end

    if isLeft and not isUp then
        local hover = self.horizontal and isHover(self.x + self.offset, self.y, self.height, self.height) or isHover(self.x, self.y + self.offset, self.height, self.height)
        if hover then
            self.clicked = true
        end
    elseif isLeft and isUp then
        self.clicked = false
        DxScrollBar.hoverSelf = false
    end
end

-- Global functions
function DxScrollBar.new(x, y, width, height, horizontal)
    assert(type(x) == "number", "[DxScrollBar] Expected number at argument 1, got " .. type(x))
    assert(type(y) == "number", "[DxScrollBar] Expected number at argument 1, got " .. type(y))
    assert(type(width) == "number", "[DxScrollBar] Expected number at argument 1, got " .. type(width))
    assert(type(height) == "number", "[DxScrollBar] Expected number at argument 1, got " .. type(height))
    assert(type(horizontal) == "boolean", "[DxScrollBar] Expected boolean at argument 1, got " .. type(horizontal))

    local data = {
        -- Parameters
        x = x,
        y = y,
        width = width,
        height = height,
        horizontal = horizontal,
        -- Assets
        element = createElement("dx-scrollbar"),
        visible = true,
        clicked = false,
        offset = 0,
        progress = 0,
        trackColor = {20, 21, 22, 180},
        squareColor = {240, 240, 240, 255}
    }
    setmetatable(data, {__index = DxScrollBar})
    DxScrollBar.instances[data] = true

    if getn(DxScrollBar.instances) == 1 then
        addEventHandler("onClientClick", root, clicks)
        addEventHandler("onClientRender", root, render)
    end
    return data
end

function DxScrollBar:destroy()
    if not self:isValidInstance() then
        return false
    end

    destroyElement(self.element)
    DxScrollBar.instances[self] = nil
    if getn(DxScrollBar.instances) == 0 then
        removeEventHandler("onClientClick", root, clicks)
        removeEventHandler("onClientRender", root, render)
    end
end

function DxScrollBar:isValidInstance()
    return DxScrollBar.instances[self]
end

function DxScrollBar:setVisible(bool)
    if not self:isValidInstance() then
        return false
    end
        
    assert(type(bool) == "boolean", "[DxScrollBar] Expected boolean at argument 1, got " .. type(bool))
    self.visible = bool
end

function DxScrollBar:setTrackColor(r, g, b, a)
    assert(r and g and b, "[DxScrollBar] Please, fill up the three initial parameters.")
    self.trackColor = {r, g, b, a or 255}
end

function DxScrollBar:setSquareColor(r, g, b, a)
    assert(r and g and b, "[DxScrollBar] Please, fill up the three initial parameters.")
    self.squareColor = {r, g, b, a or 255}
end

function DxScrollBar:getTrackSize()
    if not self:isValidInstance() then
        return false
    end
    return self.width
end

function DxScrollBar:getSquarePosition()
    if not self:isValidInstance() then
        return false
    end
    return self.horizontal and self.x + self.offset or self.y + self.offset
end

function DxScrollBar:getElement()
    if not self:isValidInstance() then
        return false
    end
    return self.element
end