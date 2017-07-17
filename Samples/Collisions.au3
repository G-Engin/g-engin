#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         Matwachich

 Script Function:


#ce ----------------------------------------------------------------------------

#include "..\GEngin.au3"

Opt("MouseCoordMode", 2)
Opt("GuiOnEventMode", 1)

Global $iWinX = 400, $iWinY = 400, $continue = 1
_GEng_SetDebug($GEng_Debug_Vectors)
_GEng_Start("Sand Box", $iWinX, $iWinY)
; ---
GuiSetOnEvent(-3, "Terminate")
Func Terminate()
	$continue = 0
EndFunc

$oFont = _GEng_Font_Create("Comic Sans MS", 20)
$oText = _GEng_Text_Create($oFont, "* Left mouse button => Move", $GEng_Color_Black, 0, 0, $iWinX, 60)

; ##############################################################

$img2 = _GEng_ImageLoad("res\images\collisions\viseur.png")

Global $nbr = 5
Global $spr[$nbr], $tmp

For $i = 0 To $nbr - 1
	$spr[$i] = _GEng_Sprite_Create($img2)
		_GEng_Sprite_OriginSetEx($spr[$i], $GEng_Origin_Mid)
		_GEng_Sprite_PosSet($spr[$i], Random(10, $iWinX - 10, 1), Random(10, $iWinY - 10, 1))
		_GEng_Sprite_CollisionSet($spr[$i], 2, 16, 16, 16)
		_GEng_Sprite_AngleSpeedSet($spr[$i], Random(1000, 1500, 1))
		_GEng_Sprite_MasseSet($spr[$i], Random(500, 1500, 1))
Next

$sprX = _GEng_Sprite_Create($img2)
	_GEng_Sprite_OriginSetEx($sprX, $GEng_Origin_Mid)
	_GEng_Sprite_PosSet($sprX, $iWinX / 2, $iWinY / 2)
	_GEng_Sprite_CollisionSet($sprX, 2, 16, 16, 16)
	_GEng_Sprite_MasseSet($sprX, Random(500, 1500, 1))

; ##############################################################
Global $x, $y, $t, $x2, $y2, $mos
While $continue
	_GEng_ScrFlush($GEng_Color_White)
	; ---
	_GEng_Sprite_CollisionScrBorders($sprX, 1)

	For $i = 0 To $nbr - 1
		_GEng_Sprite_CollisionScrBorders($spr[$i], 1)
		;~ _GEng_Sprite_Collision($sprX, $GEng_ScrBorder_Right, 100, 1)
		_GEng_Sprite_Collision($spr[$i], $sprX, 1, 10)
		; ---
		If $i < $nbr - 1 Then
			For $x = $i + 1 To $nbr - 1
				$t = TimerInit()
				If _GEng_Sprite_Collision($spr[$i], $spr[$x], 1, 10) Then _
				ConsoleWrite("Time: " & TimerDiff($t) & @CRLF)
			Next
		EndIf
		; ---
		_GEng_Sprite_Draw($spr[$i])
	Next
	_GEng_Sprite_Draw($sprX)
	; ---
	$mos = MouseGetPos()
	If _IsPressed('01') Then
		$mos = _GEng_SpriteToPoint_Vector($sprX, $mos[0], $mos[1])
		_GEng_Sprite_AccelSet($sprX, $mos[0], $mos[1])
	Else
		_GEng_Sprite_AccelSet($sprX, 0, 0)
	EndIf

	_GEng_Text_Draw($oText)
	; ---
	_GEng_ScrUpdate()
	$t = _GEng_FPS_Get(500)
	If $t <> -1 Then WinSetTitle($__GEng_hGui, "", "FPS: " & Round($t))
WEnd

_GEng_Shutdown()