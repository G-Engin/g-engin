#include "../GEngin.au3"
#include <GUIConstantsEx.au3>

;~ To use _IsPressed
#Include <Misc.au3>

;~ To use _WinAPI_GetMousePosX and _WinAPI_GetMousePosY
#include <WinAPI.au3>

;~ This is to get mouse position relatively to the window, not to the screen (by default)
Opt("MouseCoordMode", 2)

#Region https://www.autoitscript.com/autoit3/docs/libfunctions/_IsPressed.htm
 Local Const $LEFT_MOUSE_BUTTON = 01
 Local Const $RIGHT_MOUSE_BUTTON = 02
#EndRegion 

Local $iOriginAxisX
Local $iOriginAxisY

Global $scrW = 800, $scrH = 600
_GEng_Start("Basic", $scrW, $scrH)

$oImageLogo = _GEng_ImageLoad("./res/images/basic/GEngin.png")

#Region Create the sprite object with the loaded image
 $oSpriteLogo = _GEng_Sprite_Create($oImageLogo)
 ;~                 OR
 ;~ $oSpriteLogo = _GEng_Sprite_Create($oImageLogo)
 ;~ _GEng_Sprite_ImageSet($oSpriteLogo, $oImageLogo)

_GEng_Sprite_OriginSetEx($oSpriteLogo, $GEng_Origin_Mid) ;~ Set the axis origin
_GEng_Sprite_PosSet($oSpriteLogo, $scrW / 2, $scrH / 2) ;~ Set position of the object sprite
#EndRegion 

$sTextDisplay = "* Left mouse button => Move" & @CRLF & "* Right mouse button => Turns"
$oFont = _GEng_Font_Create("Comic Sans MS", 20)
$oText = _GEng_Text_Create($oFont, $sTextDisplay, $GEng_Color_Black, 0, 0, $scrW, 60)

;~ Loop of the game
Do
    _GEng_ScrFlush($GEng_Color_White)
    ;~ ---	

    If (_IsPressed($LEFT_MOUSE_BUTTON)) Then
        _GEng_Sprite_OriginGet($oSpriteLogo, $iOriginAxisX, $iOriginAxisY)
        _GEng_Sprite_PosSet($oSpriteLogo, _WinAPI_GetMousePosX() - $iOriginAxisX, _WinAPI_GetMousePosY() - ($iOriginAxisY / 4))
    ElseIf (_IsPressed($RIGHT_MOUSE_BUTTON)) Then
        _GEng_Sprite_AngleAdd($oSpriteLogo, 5)
    EndIf

    ;~ Draw objects
    ;~ The last object drawn overlaps the previous one
    _GEng_Sprite_Draw($oSpriteLogo)
    _GEng_Text_Draw($oText)

    ;~ ---
    _GEng_ScrUpdate()
Until GuiGetMsg() = $GUI_EVENT_CLOSE

_GEng_Text_Delete($oText)
_GEng_Font_Delete($oFont)
_GEng_Shutdown()