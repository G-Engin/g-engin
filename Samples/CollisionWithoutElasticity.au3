#include "../GEngin.au3"

#Region https://www.autoitscript.com/autoit3/docs/libfunctions/_IsPressed.htm
 Local Const $SPACEBAR = 20
#EndRegion 

Global $scrW = 800, $scrH = 300

_GEng_Start("Collision Without Elasticity", $scrW, $scrH)

$oImageBall = _GEng_ImageLoad("./res/images/collisions/ball.png")
$oImageBall2 = _GEng_ImageLoad("./res/images/collisions/ball2.png")

$oSpriteBall = _GEng_Sprite_Create($oImageBall)
_SetupSpriteBall($oSpriteBall, 63)

$oSpriteBall2 = _GEng_Sprite_Create($oImageBall2)
_SetupSpriteBall($oSpriteBall2, $scrW - 63)

$oFont = _GEng_Font_Create("Comic Sans MS", 18)
$oText = _GEng_Text_Create($oFont, "* Spacebar => Start Collision", $GEng_Color_Navy, 0, 0, $scrW, $scrH)

Do
    _GEng_ScrFlush($GEng_Color_White)
    ;~ ---	

    $IsColliding = _GEng_Sprite_Collision($oSpriteBall, $oSpriteBall2, 0, 10)

    If ($IsColliding) Then
        _GEng_Sprite_AccelSet($oSpriteBall, 0, 0)
        _GEng_Sprite_AccelSet($oSpriteBall2, 0, 0)
    EndIf 

    If (_IsPressed($SPACEBAR)) Then  
        _GEng_Sprite_AccelSet($oSpriteBall, 500, 0)
        _GEng_Sprite_AccelSet($oSpriteBall2, -500, 0)
    EndIf

    _GEng_Sprite_Draw($oSpriteBall)
    _GEng_Sprite_Draw($oSpriteBall2)
    _GEng_Text_Draw($oText)

    ;~ ---
    _GEng_ScrUpdate()
Until GuiGetMsg() = $GUI_EVENT_CLOSE

_GEng_Shutdown()


Func _SetupSpriteBall(ByRef $oSprBall, $PosX)
    _GEng_Sprite_PosSet($oSprBall, $PosX, $scrH / 2)
    _GEng_Sprite_OriginSetEx($oSprBall, $GEng_Origin_Mid)

    ;~ Inertia for elastic effect
    _GEng_Sprite_InnertieSet($oSprBall, 1000000)

    #Region Sets to handle object collision 
    _GEng_Sprite_MasseSet($oSprBall, 1)
    _GEng_Sprite_CollisionSet($oSprBall, 2, 63, 63, 63)
    #EndRegion

    Return $oSprBall
EndFunc