#include "../GEngin.au3"
#include <GUIConstantsEx.au3>
#Include <Misc.au3>

#Region https://www.autoitscript.com/autoit3/docs/libfunctions/_IsPressed.htm
 Local Const $SPACEBAR = 20
#EndRegion 

Global $scrW = 300, $scrH = 300
Global $x, $y

_GEng_Start("Collision With Elasticity", $scrW, $scrH)

$oImageBall = _GEng_ImageLoad("./res/images/collision-with-elasticity/ball.png")
$oImageStreet = _GEng_ImageLoad("./res/images/collision-with-elasticity/street.png")

$oSpriteBall = _GEng_Sprite_Create($oImageBall)
_GEng_Sprite_PosSet($oSpriteBall, $scrW / 2, $scrH - $scrH + 63)
_GEng_Sprite_OriginSetEx($oSpriteBall, $GEng_Origin_Mid)
_GEng_Sprite_SpeedSet($oSpriteBall, 0, 0, 200)
_GEng_Sprite_AccelSet($oSpriteBall, 0, 500)
#Region Sets to handle object collision
 _GEng_Sprite_MasseSet($oSpriteBall, 1)
 _GEng_Sprite_CollisionSet($oSpriteBall, 2) 
 _GEng_Sprite_InnertieSet($oSpriteBall, 20)
#EndRegion

$oSpriteStreet = _GEng_Sprite_Create($oImageStreet)
_GEng_Sprite_SizeSet($oSpriteStreet, $scrW, 30)
_GEng_Sprite_PosSet($oSpriteStreet, $scrW, $scrH)
_GEng_Sprite_OriginSetEx($oSpriteStreet, $GEng_Origin_BR)
#Region Sets to handle object collision 
 _GEng_Sprite_MasseSet($oSpriteStreet, 100)
 _GEng_Sprite_SizeGet($oSpriteStreet, $x, $y)
 _GEng_Sprite_CollisionSet($oSpriteStreet, 1, 0, 0, $x, $y)
;~  _GEng_Sprite_CollisionSet($oSpriteStreet, 1)
 _GEng_Sprite_InnertieSet($oSpriteStreet, 1000)
#EndRegion

Do
    _GEng_ScrFlush($GEng_Color_SkyBlue)
    ;~ ---	

    $IsColliding = _GEng_Sprite_Collision($oSpriteBall, $oSpriteStreet, 2, 1)
    ;### Debug CONSOLE ↓↓↓
    ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $IsColliding = ' & $IsColliding & @CRLF & '>Error code: ' & @error & @CRLF)

    ;~ _GEng_Sprite_CollisionScrBorders($oSpriteBall, 1)
    If (_GEng_Sprite_CollisionScrBorders($oSpriteStreet, 1) <> 0) Then
        _GEng_Sprite_PosSet($oSpriteStreet, $scrW, $scrH)
    EndIf
    
    If (_IsPressed($SPACEBAR)) Then
        _GEng_Sprite_PosSet($oSpriteBall, $scrW / 2, $scrH - $scrH + 63)
        _GEng_Sprite_AccelSet($oSpriteBall, 0, 500)
    EndIf   

    If ($IsColliding) Then
        _GEng_Sprite_AccelSet($oSpriteBall, 0, 0)
    EndIf

    _GEng_Sprite_Draw($oSpriteStreet)
    _GEng_Sprite_Draw($oSpriteBall)

    ;~ ---
    _GEng_ScrUpdate()
Until GuiGetMsg() = $GUI_EVENT_CLOSE

_GEng_Shutdown()