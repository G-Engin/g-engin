#include "GEngin.au3"
#include <GUIConstantsEx.au3>

;~ To use _IsPressed
#Include <Misc.au3>

;~ This is to get mouse position relatively to the window, not to the screen (by default)
Opt("MouseCoordMode", 2)

Global $scrW = 800, $scrH = 600
_GEng_Start("MyGame", $scrW, $scrH)

$Font = _GEng_Font_Create("Garamond", 20, 1, 0, 2)
$Text = _GEng_Text_Create($Font, "", $GEng_Color_Navy, $scrW - 100, 0, 100, 20)

Do
	_GEng_ScrFlush($GEng_Color_White)
	;~ ---	

	;~ ---
	$FPS = _GEng_FPS_Get()
	If $FPS <> -1 Then
		_GEng_Text_StringSet($Text, Round($FPS) & " FPS")
	EndIf
	_GEng_Text_Draw($Text)
	_GEng_ScrUpdate()
Until GuiGetMsg() = $GUI_EVENT_CLOSE

_GEng_Text_Delete($Text)
_GEng_Font_Delete($Font)
_GEng_Shutdown()