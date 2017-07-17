#include "../GEngin.au3"

#Region https://www.autoitscript.com/autoit3/docs/libfunctions/_IsPressed.htm
 Local Const $LEFT_ARROW = 25 
 Local Const $UP_ARROW = 26
 Local Const $RIGHT_ARROW = 27
 Local Const $DOWN_ARROW = 28
#EndRegion 

Global $scrW = 300, $scrH = 300
_GEng_Start("Collision With Screen Border", $scrW, $scrH)

$oImageBall = _GEng_ImageLoad("./res/images/collisions/ball.png")
$oSpriteBall = _GEng_Sprite_Create($oImageBall)
_GEng_Sprite_PosSet($oSpriteBall, $scrW / 2, $scrH / 2)
_GEng_Sprite_OriginSetEx($oSpriteBall, $GEng_Origin_Mid)
_GEng_Sprite_SpeedSet($oSpriteBall, 0, 0, 200)

;~ Sets initial acceleration
_GEng_Sprite_AccelSet($oSpriteBall, 500, 500)

#Region Sets to handle object collision
 _GEng_Sprite_MasseSet($oSpriteBall, 500)
 _GEng_Sprite_CollisionSet($oSpriteBall, 2, 63, 63, 63)
#EndRegion

Do
    _GEng_ScrFlush($GEng_Color_SkyBlue)
    ;~ ---	
    
    $iBorderCollison = _GEng_Sprite_CollisionScrBorders($oSpriteBall, True)

    ;~ Checks on which edge of the screen the collision occurred
    Switch ($iBorderCollison)
        Case $GEng_ScrBorder_Left
            _GEng_Sprite_AccelSet($oSpriteBall, 500)
        Case $GEng_ScrBorder_Top
            _GEng_Sprite_AccelSet($oSpriteBall, 0, 500)
        Case $GEng_ScrBorder_Right
            _GEng_Sprite_AccelSet($oSpriteBall, -500)
        Case $GEng_ScrBorder_Bot
            _GEng_Sprite_AccelSet($oSpriteBall, 0, -500)
    EndSwitch    

    _GEng_Sprite_Draw($oSpriteBall)

    ;~ ---
    _GEng_ScrUpdate()
Until GuiGetMsg() = $GUI_EVENT_CLOSE

_GEng_Shutdown()