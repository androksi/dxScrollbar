# dxScrollBar
Simple framework which allows you to create dx scrollbars easily.

# How to use
This is really simple. All you need is download the file ``dxScrollBar.lua`` and put inside your resource folder. Don't forget to add the file in the meta.xml file. Always load it before the other files.

# Functions & Events
## Functions
``new``
##### Create a new instance and a scrollbar.
```lua
DxScrollBar.new(x, y, width, height, horizontal)
```

``destroy``
##### Destroy the instance.
```lua
DxScrollBar:destroy()
```

``setVisible``
##### It makes the scrollbar visible or not.
```lua
DxScrollBar:setVisible(bool)
```

``setTrackColor``
##### This function changes the color of the scrollbar track.
```lua
DxScrollBar:setTrackColor(r, g, b, a)
```

``setSquareColor``
##### This function changes the color of the scrollbar square (where you click to drag).
```lua
DxScrollBar:setSquareColor(r, g, b, a)
```

``getTrackSize``
##### This function gets the width of the track.
```lua
DxScrollBar:getTrackSize()
```

``getSquarePosition``
##### This function gets the position where the scrollbar square is.
```lua
DxScrollBar:getSquarePosition()
```

``getElement``
##### This function gets the scrollbar's pseudo-element, which you will use to attach in events.
```lua
DxScrollBar:getElement()
```

## Events
``dxscrollbar:change``
##### This event will be triggered whenever the scrollbar square change its position. You can get the progress using the parameter. This is from 0 to 100.

# Usage
```lua
local hbar = DxScrollBar.new(500, 300, 200, 15, true) -- Create an instance
local vbar = DxScrollBar.new(500, 400, 100, 15, false) -- Create an instance

vbar:setVisible(false) -- Toggle the scrollbar - false will remove it from the screen

hbar:setTrackColor(20, 21, 22, 180) -- Set a new color for the hbar track
hbar:setSquareColor(59, 114, 224, 255) -- Set a new color for the hbar square

setTimer(function() -- Just a timer to test
    vbar:destroy() -- "vbar" will be completely destroyed after 8 seconds
    outputChatBox("vbar was removed.")
end, 8000, 1)

-- Here we are setting up the events, pay attention how you attach the scrollbar's pseudo-element
addEventHandler("dxscrollbar:change", hbar:getElement(), function(progress)
    outputChatBox("hbar progress: " .. progress)
end)

addEventHandler("dxscrollbar:change", vbar:getElement(), function(progress)
    outputChatBox("vbar progress: " .. progress)
end)
```

# License
#### You can use this framework in all your projects. Feel free to edit aswell!
