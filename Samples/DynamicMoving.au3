#include "../GEngin.au3"

#Region https://www.autoitscript.com/autoit3/docs/libfunctions/_IsPressed.htm
 Local Const $LEFT_ARROW = 25 
 Local Const $UP_ARROW = 26
 Local Const $RIGHT_ARROW = 27
 Local Const $DOWN_ARROW = 28
#EndRegion 

Global $scrW = 800, $scrH = 300
_GEng_Start("Dynamic Moving", $scrW, $scrH)

$oImageCar = _GEng_ImageLoad("./res/images/dynamic_moving/car.png")
$oSpriteCar = _GEng_Sprite_Create($oImageCar)
_GEng_Sprite_SizeSet($oSpriteCar, 100, 50)
_GEng_Sprite_PosSet($oSpriteCar, $scrW / 2, $scrH / 2)
_GEng_Sprite_OriginSetEx($oSpriteCar, $GEng_Origin_Mid)

#Region Sets for dynamic moving
 ;~ Assigns the maximum speed of movement and rotation of the sprite
 _GEng_Sprite_SpeedSet($oSpriteCar, 0, 0, 100) ;~ 100 pixels/s
 _GEng_Sprite_AngleSpeedSet($oSpriteCar, 0, 30) ;~ 30 Deg/s

 ;~ Defines inertia of the sprite object by influencing the stop action.
 ;~ The higher the value the faster the object will stop.
 _GEng_Sprite_InnertieSet($oSpriteCar, 100)
 _GEng_Sprite_AngleInnertieSet($oSpriteCar, 300)
#EndRegion

$sTextDisplay = "* Left Arrow => Move to back" & @CRLF _
              & "* Up Arrow => Turn counter-clockwise" & @CRLF _
              & "* Right Arrow => Move to front" & @CRLF _
              & "* Down Arrow => Turn clockwise"
$oFont = _GEng_Font_Create("Comic Sans MS", 18)
$oText = _GEng_Text_Create($oFont, $sTextDisplay, $GEng_Color_Navy, 0, 0, $scrW, $scrH)

Do
    _GEng_ScrFlush($GEng_Color_White)
    ;~ ---	

    Select
        Case _IsPressed($LEFT_ARROW)
            _GEng_Sprite_AccelSet($oSpriteCar, -100)
        Case _IsPressed($UP_ARROW)
            _GEng_Sprite_AngleAccelSet($oSpriteCar, -500)
        Case _IsPressed($RIGHT_ARROW)
            _GEng_Sprite_AccelSet($oSpriteCar, 100)
        Case _IsPressed($DOWN_ARROW)
            _GEng_Sprite_AngleAccelSet($oSpriteCar, +500)
        Case Else
            _GEng_Sprite_AccelSet($oSpriteCar, 0, 0)
            _GEng_Sprite_AngleAccelSet($oSpriteCar, 0)
    EndSelect

    ;~ Draw objects
    ;~ The last object drawn overlaps the previous one
    _GEng_Sprite_Draw($oSpriteCar)
    _GEng_Text_Draw($oText)

    ;~ ---
    _GEng_ScrUpdate()
Until GuiGetMsg() = $GUI_EVENT_CLOSE

_GEng_Text_Delete($oText)
_GEng_Font_Delete($oFont)
_GEng_Shutdown()