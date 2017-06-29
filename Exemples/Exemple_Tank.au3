#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         Matwachich

 Script Function:


#ce ----------------------------------------------------------------------------

#include "..\GEngin.au3"
#include <Misc.au3>
Opt("MouseCoordMode", 2)
Opt("GuiOnEventMode", 1)

$dll = DllOpen("user32.dll")
$continue = 1

Global $scrW = 800, $scrH = 600
;_GEng_SetDebug(1)
_GEng_Start("Exemple - Tank", $scrW, $scrH)
GuiSetOnEvent(-3, "_Exit")
;GUISetCursor(16)
Func _Exit()
	$continue = 0
EndFunc
; ---

Global $_Smokes[1] = [0], $_Obus[1] = [0], $_Balles[1] = [0], $_Muzzles[1] = [0]

$imgT = _GEng_ImageLoad("res\tanks\tank_j.png")
$imgMg = _GEng_ImageLoad("res\tanks\mg.png")

$imgObus = _GEng_ImageLoad("res\tanks\shot.png")
$imgBalle = _GEng_ImageLoad("res\tanks\balle.png")
$imgSmoke = _GEng_ImageLoad("res\tanks\smoke.png", 576/2, 24)
$imgMuz = _GEng_ImageLoad("res\tanks\muz.png", 18, 14)
; ---

$sprT = _GEng_Sprite_Create() ; tank
	_GEng_Sprite_ImageSet($sprT, $imgT, 0, 0, 55, 31)
	_GEng_Sprite_OriginSetEx($sprT, $GEng_Origin_Mid)
	_GEng_Sprite_PosSet($sprT, $scrW / 2, $scrH / 2)
	
	_GEng_Sprite_SpeedSet($sprT, 0, 0, 100)
	_GEng_Sprite_AngleSpeedSet($sprT, 0, 60)
	_GEng_Sprite_InnertieSet($sprT, 250)
	_GEng_Sprite_AngleInnertieSet($sprT, 60)

$sprTx = _GEng_Sprite_Create() ; tourelle
	_GEng_Sprite_ImageSet($sprTx, $imgT, 0, 31, 55, 31)
	_GEng_Sprite_OriginSet($sprTx, 18, 14)
	
$sprTm = _GEng_Sprite_Create($imgMg) ; mitrailleuse
	_GEng_Sprite_OriginSet($sprTm, 4, 4)
	
$sprMuz = _GEng_Sprite_Create($imgMuz) ; flame mitrailleuse
	_GEng_Sprite_OriginSet($sprMuz, 0, 7)
; ---

$animSmoke = _GEng_Anim_Create() ; animation fumée tire canon
	For $i = 0 To 11
		_GEng_Anim_FrameAdd($animSmoke, $imgSmoke, 75, 24 * $i, 0, 24, 24)
	Next
	
$animMuz = _GEng_Anim_Create() ; animation flame mitrailleuse
	_GEng_Anim_FrameAdd($animMuz, $imgMuz, 50, 0, 0, 18, 14)
	_GEng_Anim_FrameAdd($animMuz, $imgMuz, 50, 0, 14, 18, 14) ; image vide

; ---
$timerObus = 0
$timerBalle = 0

; ##############################################################

Global $x, $y, $tmp
While $continue
	_GEng_ScrFlush(0xFF666666)
	; ---
	_DrawTank()
	_AnimShots()
	_CheckMove()
	; ---
	If _IsPressed('01', $dll) And TimerDiff($timerObus) >= 500 Then
		_Shot(1)
		$timerObus = TimerInit()
	Else
	EndIf
	If _IsPressed('02', $dll) And TimerDiff($timerBalle) >= 50 Then
		_Shot(2)	
		$timerBalle = TimerInit()
	Else
		_GEng_Sprite_AnimRewind($sprMuz, 1)
	EndIf
	; ---
	_GEng_ScrUpdate()
	$t = _GEng_FPS_Get()
	If $t <> -1 Then _
		WinSetTitle($__GEng_hGui, "", "Exemple: Tank - FPS: " & Round($t) & " (" & @Extended & ")")
Wend

_GEng_Shutdown()
DllClose($dll)

; ---

Func _AnimMuz($mgAngle, $x, $y)
	_GEng_Sprite_AngleSet($sprMuz, $mgAngle)
	_GEng_Sprite_PosSet($sprMuz, $x, $y)
	_GEng_Sprite_Animate($sprMuz, $animMuz)
	_GEng_Sprite_Draw($sprMuz)
EndFunc

Func _Shot($type) ; 1 = obus
	Local $spr, $x, $y, $tmp
	Switch $type
		Case 1
			$spr = _GEng_Sprite_Create($imgObus)
			; collision
			_GEng_Sprite_CollisionSet($spr, 0, 4, 2)
			; masse
			_GEng_Sprite_MasseSet($spr, 50)
			; position
			_GEng_Sprite_PointGet($sprTx, 60, 14, $x, $y)
			_GEng_Sprite_PosSet($spr, $x, $y)
			; angle
			$tmp = _GEng_Sprite_AngleGet($sprTx)
			_GEng_Sprite_AngleSet($spr, $tmp)
			; vitesse
			$tmp = _GEng_AngleToVector($tmp, 1000) ; vitesse obus
			_GEng_Sprite_SpeedSet($spr, $tmp[0], $tmp[1])
			; ---
			_ArrayAdd($_Obus, $spr)
			$_Obus[0] += 1
			$spr = 0
			; ---
			$spr = _GEng_Sprite_Create()
			_GEng_Sprite_ColorMatrixTranslate($spr, 0, 0, 0, -0.4)
			_GEng_Sprite_OriginSet($spr, 12, 12)
			_GEng_Sprite_PosSet($spr, $x, $y)
			_GEng_Sprite_AngleSet($spr, Random(0, 359, 1))
			_ArrayAdd($_Smokes, $spr)
			$_Smokes[0] += 1
			$spr = 0
		; ---
		Case 2
			$spr = _GEng_Sprite_Create($imgBalle)
			_GEng_Sprite_OriginSet($spr, 4, 0)
			; Position
			_GEng_Sprite_PointGet($sprTm, 20, Random(3, 5, 1), $x, $y)
			_GEng_Sprite_PosSet($spr, $x, $y)
			; Angle
			$tmp = _GEng_Sprite_AngleGet($sprTm)
			$tmp = Random($tmp - 2, $tmp + 2, 1)
			_GEng_Sprite_AngleSet($spr, $tmp)
			; ---
			; Muzzle flash
			_AnimMuz($tmp, $x, $y)
			; Vitesse
			$tmp = _GEng_AngleToVector($tmp, 2000) ; vitesse balle
			_GEng_Sprite_SpeedSet($spr, $tmp[0], $tmp[1])
			; ---
			_ArrayAdd($_Balles, $spr)
			$_Balles[0] += 1
			$spr = 0
	EndSwitch
EndFunc

Func _AnimShots()
	Local $x, $y, $tmp
	; obus
	For $i = $_Obus[0] To 1 Step -1
		_GEng_Sprite_Draw($_Obus[$i])
		_GEng_Sprite_PosGet($_Obus[$i], $x, $y)
		If $x < 0 Or $x > $scrW Or $y < 0 Or $y > $scrH Then
			_GEng_Sprite_Delete($_Obus[$i])
			_ArrayDelete($_Obus, $i)
			$_Obus[0] -= 1
		EndIf
	Next
	; ---
	; smokes
	For $i = $_Smokes[0] To 1 Step -1
		_GEng_Sprite_Draw($_Smokes[$i])
		; ---
		If _GEng_Sprite_Animate($_Smokes[$i], $animSmoke, 1) = -1 Then
			_GEng_Sprite_Delete($_Smokes[$i])
			_ArrayDelete($_Smokes, $i)
			$_Smokes[0] -= 1
		EndIf
	Next
	; ---
	; Balles
	For $i = $_Balles[0] To 1 Step -1
		_GEng_Sprite_Draw($_Balles[$i])
		_GEng_Sprite_PosGet($_Balles[$i], $x, $y)
		If $x < 0 Or $x > $scrW Or $y < 0 Or $y > $scrH Then
			_GEng_Sprite_Delete($_Balles[$i])
			_ArrayDelete($_Balles, $i)
			$_Balles[0] -= 1
		EndIf
	Next
EndFunc

Func _DrawTank()
	Local $x, $y
	_GEng_Sprite_PointGet($sprT, 18, 14, $x, $y)
	_GEng_Sprite_PosSet($sprTx, $x, $y)
	; ---
	; position sur le chasis
	_GEng_Sprite_PointGet($sprT, 36, 8, $x, $y)
	_GEng_Sprite_PosSet($sprTm, $x, $y)
	; position sur la tourelle
	;_GEng_Sprite_PointGet($sprTx, 19, 10, $x, $y)
	;_GEng_Sprite_PosSet($sprTm, $x, $y)
	; ---
	_GEng_Sprite_Draw($sprT)
	; ne pas oublier d'inversé l'ordre d'affichage de la mitrailleurse et de la tourelle selon la position
	; de la mitrailleuse, sinon, la tourelle pourait cacher la mitrailleuse!
	_GEng_Sprite_Draw($sprTm, 0)
	_GEng_Sprite_Draw($sprTx, 0)
EndFunc

Func _CheckMove()
	Local $tmp = MouseGetPos()
	$tmp = _GEng_SpriteToPoint_Angle($sprTx, $tmp[0], $tmp[1])
	_GEng_Sprite_AngleSet($sprTx, $tmp)
	_GEng_Sprite_AngleSet($sprTm, $tmp)
	; ---
	$tmp = _GEng_Sprite_AngleGet($sprT)
	$tmp = _GEng_AngleToVector($tmp, 1)
	; ---
	If _IsPressed('5A', $dll) Then ; avant
		_GEng_Sprite_AccelSet($sprT, $tmp[0] * 1000, $tmp[1] * 1000)
	ElseIf _IsPressed('53', $dll) Then ; arrière
		_GEng_Sprite_AccelSet($sprT, $tmp[0] * -1000, $tmp[1] * -1000)
	Else
		_GEng_Sprite_AccelSet($sprT, 0, 0)
	EndIf
	; ---
	If _IsPressed('51', $dll) Then ; gauche
		_GEng_Sprite_AngleAccelSet($sprT, -500)
	ElseIf _IsPressed('44', $dll) Then ; droite
		_GEng_Sprite_AngleAccelSet($sprT, 500)
	Else
		_GEng_Sprite_AngleAccelSet($sprT, 0)
	EndIf
EndFunc
