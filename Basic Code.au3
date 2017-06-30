#include <GEngin.au3>

Global $iW = 800, $iH = 600

_GEng_Start("MyGame", $iW, $iH)
$Font = _GEng_Font_Create("Garamond", 20, 1, 0, 2)
$Text = _GEng_Text_Create($Font, "", 0xFF004080, $iW - 100, 0, 100, 20)
; ---

Do
	_GEng_ScrFlush(0xFFFFFFFF)
	; ---

	; ---
	$FPS = _GEng_FPS_Get()
	If $FPS <> -1 Then _GEng_Text_StringSet($Text, Round($FPS) & " FPS")
	_GEng_Text_Draw($Text)
	_GEng_ScrUpdate()
Until GUIGetMsg() = -3

_GEng_Text_Delete($Text)
_GEng_Font_Delete($Font)
_GEng_Shutdown()