#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         RonildoSouza

 Script Function:
	

#ce ----------------------------------------------------------------------------

#include "../../../GEngin.au3"
#include "Includes.au3"

_GEng_Start($sGAME_NAME, $scrW, $scrH)

_BackgroundCreate()
_ChickenAnimationCreate()
_ChickenCreate()
_FenceCreate()

;~ _GEng_SetDebug($GEng_Debug_Sprites)

$oFontScore = _GEng_Font_Create("Arial", 20, 1)
$oTextScore = _GEng_Text_Create($oFontScore, "", $GEng_Color_White, $scrW - 120, 20, 200, 40)

Do
	_GEng_ScrFlush($GEng_Color_White)
	;~ ---

	_BackgroundDraw()

	_FenceMove()
	_GEng_Text_StringSet($oTextScore, _FenceGetScore() & " Points")

	_ChickenFly()

	_ChickenDraw()
	_FenceDraw()
	_GEng_Text_Draw($oTextScore)

	If ($bCollision) Then		
		Sleep(1500)
		__RestartGame()
	EndIf

	;~ ---
	_GEng_ScrUpdate()
Until GUIGetMsg() = $GUI_EVENT_CLOSE

_GEng_Font_Delete($oFontScore)
_GEng_Text_Delete($oTextScore)
_GEng_Shutdown()


#cs
	Private Functions
#ce

Func __RestartGame()
	$bGamePlaying = False
	$bCollision = False
	_FenceRestartScore()
	_ChickenAnimationCreate()
	_ChickenCreate()
	_FenceCreate()
EndFunc   ;==>__RestartGame
