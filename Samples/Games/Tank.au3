#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         Matwachich

 Script Function:


#ce ----------------------------------------------------------------------------

#include "../../GEngin.au3"
#include <Misc.au3>
Opt("MouseCoordMode", 2)
Opt("GuiOnEventMode", 1)

$dll = DllOpen("user32.dll")
$continue = 1

Global $scrW = 800, $scrH = 600

_GEng_Start("Tank Game", $scrW, $scrH)

GuiSetOnEvent(-3, "_Exit")


GUISetCursor(16, 1)

Func _Exit()
	$continue = 0
EndFunc
; ---

Global $_Smokes[1] = [0], $_Obus[1] = [0], $_Balles[1] = [0], $_Muzzles[1] = [0], $_ExpSm[1] = [0], $_ExpBg[1] = [0], $_Mine[1] = [0], $Enemies[1] = [0], $_Blood[1] = [0], $ShotTimers[1] = [0], $_Rocket[1] = [0], $ShotTimersR[1] = [0]

Global $LastX, $LastY, $XSave = -409

Global $MineCount = 5, $Health = 100, $Kills = 0

$imgB = _GEng_ImageLoad("res\tanks\Level1.png")
$imgT = _GEng_ImageLoad("res\tanks\tank_v.png")
$imgMg = _GEng_ImageLoad("res\tanks\mg.png")
$imgObus = _GEng_ImageLoad("res\tanks\shot.png")
$imgBalle = _GEng_ImageLoad("res\tanks\balle.png")
$imgSmoke = _GEng_ImageLoad("res\tanks\smoke.png", 576/2, 24)
$imgMuz = _GEng_ImageLoad("res\tanks\muz.png", 18, 14)
$imgExpSm = _GEng_ImageLoad("res\tanks\expSmall.png")
$imgExpBg = _GEng_ImageLoad("res\tanks\expBig.png")
$imgBlood = _GEng_ImageLoad("res\tanks\Blood.png")
$imgMine = _GEng_ImageLoad("res\tanks\Mine.png")
$imgCrosshair = _GEng_ImageLoad("res\tanks\Crosshair.png")
$imgMarine = _GEng_ImageLoad("res\tanks\Enemy.png")
$imgRocket = _GEng_ImageLoad("res\tanks\EnemyRocket.png")
$imgHealthbarBack = _GEng_ImageLoad("res\tanks\HealthbarBack.png")
$imgHealthbar = _GEng_ImageLoad("res\tanks\Healthbar.png")
$imgHealthbarNeg = _GEng_ImageLoad("res\tanks\HealthbarNeg.png")
$imgMenuBar = _GEng_ImageLoad("res\tanks\BottomMenu.png")
; ---

$sprB = _GEng_Sprite_Create() ; Background
	_GEng_Sprite_ImageSet($sprB, $imgB, 0, 0, 800, 600)

$sprT = _GEng_Sprite_Create() ; tank
	_GEng_Sprite_ImageSet($sprT, $imgT, 0, 0, 55, 31)
	_GEng_Sprite_OriginSetEx($sprT, $GEng_Origin_Mid)
	_GEng_Sprite_PosSet($sprT, $scrW / 2, $scrH / 2)
	_GEng_Sprite_SpeedSet($sprT, 0, 0, 100)
	_GEng_Sprite_InnertieSet($sprT, 250)
	_GEng_Sprite_AngleInnertieSet($sprT, 60)
	_GEng_Sprite_CollisionSet($sprT, 1, 0, 0, 55, 31)

$sprTx = _GEng_Sprite_Create() ; tourelle
	_GEng_Sprite_ImageSet($sprTx, $imgT, 0, 31, 55, 31)
	_GEng_Sprite_OriginSet($sprTx, 18, 14)

$sprTm = _GEng_Sprite_Create($imgMg)
	_GEng_Sprite_OriginSet($sprTm, 4, 4)

$sprMuz = _GEng_Sprite_Create($imgMuz)
	_GEng_Sprite_OriginSet($sprMuz, 0, 7)

$sprMenuBar = _GEng_Sprite_Create()
_GEng_Sprite_ImageSet($sprMenuBar, $imgMenuBar)
_GEng_Sprite_PosSet($sprMenuBar, 0, $scrH - 40)

$sprCrosshair = _GEng_Sprite_Create($imgCrosshair)
	_GEng_Sprite_OriginSet($sprCrosshair, 7.5, 7.5)

$sprHealthBarBack = _GEng_Sprite_Create($imgHealthbarBack)
	_GEng_Sprite_PosSet($sprHealthbarBack, 10, $scrH - 32 )

$sprHealthbarNeg = _GEng_Sprite_Create($imgHealthbarNeg)
	_GEng_Sprite_PosSet($sprHealthbarNeg, 11, $scrH - 31 )

$sprHealthbar = _GEng_Sprite_Create()
	_GEng_Sprite_ImageSet($sprHealthbar, $imgHealthbar)
	_GEng_Sprite_PosSet($sprHealthbar, 11, $scrH - 31)

$hFont = _GEng_Font_Create("Arial", 10, 1, 0)
$txtHealth = _GEng_Text_Create($hFont, $Health&" %", 0xFF000000, 11 + 140, $scrH - 28, 50, 20)

$hFont = _GEng_Font_Create("Arial", 14, 1, 0)
$txtKills = _GEng_Text_Create($hFont, "Kills: 0", 0xFF9a0000, 11 + 320, $scrH - 28, 100, 20)

; ---

$animSmoke = _GEng_Anim_Create()
	For $i = 0 To 11
		_GEng_Anim_FrameAdd($animSmoke, $imgSmoke, 75, 24 * $i, 0, 24, 24)
	Next

$animExplosionSmall = _GEng_Anim_Create()
	For $i = 0 To 7
		_GEng_Anim_FrameAdd($animExplosionSmall, $imgExpSm, 75, 20 * $i, 0, 20, 21)
	Next

$animExplosionBig = _GEng_Anim_Create()
	For $i = 0 To 13
		_GEng_Anim_FrameAdd($animExplosionBig, $imgExpBg, 75, 40 * $i, 0, 40, 40)
	Next

$animBlood = _GEng_Anim_Create()
	For $i = 0 To 8
		_GEng_Anim_FrameAdd($animBlood, $imgBlood, 75, 22 * $i, 0, 22, 21)
	Next

$animMine = _GEng_Anim_Create()
	For $i = 0 To 11
		_GEng_Anim_FrameAdd($animMine, $imgMine, 125, 10 * $i, 0, 10, 10)
	Next

$animMuz = _GEng_Anim_Create()
	_GEng_Anim_FrameAdd($animMuz, $imgMuz, 50, 0, 0, 18, 14)
	_GEng_Anim_FrameAdd($animMuz, $imgMuz, 50, 0, 14, 18, 14) ; image vide

; ---
$timerObus = 0
$timerBalle = 0
$timerMine = 0

$Timer = TimerInit()

; ##############################################################

Global $x, $y, $tmp
While $continue
	_GEng_ScrFlush(0xFF666666)
	; ---

	_DrawBackground()
	_DrawTank()
	_AnimShots()
	_CheckMove()
	_DrawCrosshair()
	_GEng_Sprite_Draw($sprMenuBar)
	_GEng_Sprite_Draw($sprHealthBarBack)
	_GEng_Sprite_Draw($sprHealthBarNeg)
	_GEng_Sprite_Draw($sprHealthbar)
	_GEng_Text_Draw($txtHealth)
	_GEng_Text_Draw($txtKills)


	; ---
	If _IsPressed('01') And TimerDiff($timerObus) >= 500 Then
		_Shot(1)
		$timerObus = TimerInit()
	Else
		_GEng_Sprite_AnimRewind($sprMuz, 1)
	EndIf
	If _IsPressed('02') And TimerDiff($timerBalle) >= 75 Then
		_Shot(2)
		$timerBalle = TimerInit()
	EndIf
	If _IsPressed('20') And TimerDiff($timerMine) >= 5000 And $MineCount <> 0 Then
		$MineCount -= 1
		_Mine()
		$timerMine = TimerInit()
	EndIf
	If TimerDiff($Timer) > 2000 Then
		_CreateEnemies()
		$Timer = TimerInit()
	EndIf

	For $i = $Enemies[0] to 1 Step -1
		If TimerDiff($ShotTimers[$i]) > 5000 Then
			_EnemyShot()
		EndIf
	Next
	For $i = $_Rocket[0] to 1 Step -1
		If TimerDiff($ShotTimersR[$i]) > 15000 Then
			_EnemyShotRocket()
		EndIf
	Next
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

Func _DrawCrosshair()
	Local $tmp = MouseGetPos()
	_GEng_Sprite_PosSet($sprCrosshair, $tmp[0], $tmp[1])
	_GEng_Sprite_Draw($sprCrosshair)
EndFunc

Func _Mine()
	Local $spr, $x, $y, $tmp
	_GEng_Sprite_PosGet($sprT, $x, $y)

	$spr = _GEng_Sprite_Create()
	_GEng_Sprite_ImageSet($spr, $imgMine, 0, 0, 10, 10)
	_GEng_Sprite_OriginSet($spr, 5, 5)
	_GEng_Sprite_CollisionSet($spr, 2, 5, 5, 5 )
	_GEng_Sprite_PosSet($spr, $x, $y)
	_ArrayAdd($_Mine, $spr)
	$_Mine[0] += 1
	$spr = 0
EndFunc

Func _EnemyShot()
	$spr = _GEng_Sprite_Create($imgBalle)
	_GEng_Sprite_OriginSet($spr, 4, 0)
	_GEng_Sprite_PosGet($Enemies[$i], $x, $y)
	; Position
	_GEng_Sprite_PointGet($Enemies[$i], -2, 0, $x, $y)
	_GEng_Sprite_PosSet($spr, $x, $y)
	; Angle
	$tmp = _GEng_Sprite_AngleGet($Enemies[$i])
	$tmp = Random($tmp - 2, $tmp + 2, 1) - 90
	_GEng_Sprite_AngleSet($spr, $tmp)
	; ---
	; Muzzle flash
	_AnimMuz($tmp, $x, $y)
	; Vitesse
	$tmp = _GEng_AngleToVector($tmp, 350) ; vitesse balle
	_GEng_Sprite_SpeedSet($spr, $tmp[0], $tmp[1])
	; ---
	_ArrayAdd($_Balles, $spr)
	$_Balles[0] += 1
	$spr = 0
	$ShotTimers[$i] = TimerInit()
EndFunc

Func _EnemyShotRocket()
	$spr = _GEng_Sprite_Create($imgObus)
	_GEng_Sprite_OriginSet($spr, 4, 0)
	_GEng_Sprite_PosGet($_Rocket[$i], $x, $y)
	; Position
	_GEng_Sprite_PointGet($_Rocket[$i], 7, 0, $x, $y)
	_GEng_Sprite_PosSet($spr, $x, $y)
	; Angle
	$tmp = _GEng_Sprite_AngleGet($_Rocket[$i])
	$tmp = Random($tmp - 2, $tmp + 2, 1) - 90
	_GEng_Sprite_AngleSet($spr, $tmp)

	; Vitesse
	$tmp = _GEng_AngleToVector($tmp, 500) ; vitesse balle
	_GEng_Sprite_SpeedSet($spr, $tmp[0], $tmp[1])
	; ---
	_ArrayAdd($_Obus, $spr)
	$_Obus[0] += 1
	$spr = 0
	$ShotTimersR[$i] = TimerInit()

	$spr = _GEng_Sprite_Create()
	_GEng_Sprite_OriginSet($spr, 10, 10)
	_GEng_Sprite_PosSet($spr, $x, $y)
	_ArrayAdd($_Smokes, $spr)
	$_Smokes[0] += 1
	$spr = 0
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
			$tmp = _GEng_AngleToVector($tmp, 500) ; vitesse obus
			_GEng_Sprite_SpeedSet($spr, $tmp[0], $tmp[1])
			; ---
			_ArrayAdd($_Obus, $spr)
			$_Obus[0] += 1
			$spr = 0
			; ---
			$spr = _GEng_Sprite_Create()
			_GEng_Sprite_ColorMatrixTranslate($spr, 0, 0, 0, -0.4)
			_GEng_Sprite_OriginSet($spr, 10, 10)
			_GEng_Sprite_PosSet($spr, $x, $y)
			_ArrayAdd($_Smokes, $spr)
			$_Smokes[0] += 1
			$spr = 0
		; ---
		Case 2
			$spr = _GEng_Sprite_Create($imgBalle)
			_GEng_Sprite_OriginSet($spr, 4, 0)
			; Position
			_GEng_Sprite_PointGet($sprTm, 45, Random(3, 5, 1), $x, $y)
			_GEng_Sprite_PosSet($spr, $x, $y)
			; Angle
			$tmp = _GEng_Sprite_AngleGet($sprTm)
			$tmp = Random($tmp - 2, $tmp + 2, 1)
			_GEng_Sprite_AngleSet($spr, $tmp)
			; ---
			; Muzzle flash
			_GEng_Sprite_PointGet($sprTm, 20, Random(3, 5, 1), $x, $y)
			_AnimMuz($tmp, $x, $y)
			; Vitesse
			$tmp = _GEng_AngleToVector($tmp, 350) ; vitesse balle
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
		If _GEng_Sprite_Collision( $_Obus[$i], $sprT ) Then

			$spr = _GEng_Sprite_Create()
			_GEng_Sprite_ColorMatrixTranslate($spr, 0, 0, 0, -0.4)
			_GEng_Sprite_OriginSet($spr, 20, 20)
			_GEng_Sprite_PosSet($spr, $x, $y)
			_ArrayAdd($_ExpBg, $spr)
			$_ExpBg[0] += 1
			$spr = 0

			$Health -= 15
			If $Health = 0 Then
				MsgBox( 0, "Game Over", "Game Over")
				Exit
			EndIf

			_GEng_Sprite_Delete($_Obus[$i])
			_ArrayDelete($_Obus, $i)
			$_Obus[0] -= 1
		EndIf
		If $x < 0 Or $x > $scrW Or $y < 0 Or $y > $scrH Then
			_GEng_Sprite_Delete($_Obus[$i])
			_ArrayDelete($_Obus, $i)
			$_Obus[0] -= 1
			$i -= 1
		EndIf
	Next
	; ---
	; Mine
	For $i = $_Mine[0] To 1 Step -1
		_GEng_Sprite_Draw($_Mine[$i])
		If _GEng_Sprite_Animate($_Mine[$i], $animMine, 1) = -1 Then
			_GEng_Sprite_AnimRewind($_Mine, 1)
		EndIf
	Next
	; Blood
	For $i = $_Blood[0] To 1 Step -1
		_GEng_Sprite_Draw($_Blood[$i])
		; ---
		If _GEng_Sprite_Animate($_Blood[$i], $animBlood, 1) = -1 Then
			_GEng_Sprite_Delete($_Blood[$i])
			_ArrayDelete($_Blood, $i)
			$_Blood[0] -= 1
		EndIf
	Next
	; Explosion Small
	For $i = $_ExpSm[0] To 1 Step -1
		_GEng_Sprite_Draw($_ExpSm[$i])
		; ---
		If _GEng_Sprite_Animate($_ExpSm[$i], $animExplosionSmall, 1) = -1 Then
			_GEng_Sprite_Delete($_ExpSm[$i])
			_ArrayDelete($_ExpSm, $i)
			$_ExpSm[0] -= 1
		EndIf
	Next
		; ---
	; Explosion Big
	For $i = $_ExpBg[0] To 1 Step -1
		_GEng_Sprite_Draw($_ExpBg[$i])
		; ---
		If _GEng_Sprite_Animate($_ExpBg[$i], $animExplosionBig, 1) = -1 Then
			_GEng_Sprite_Delete($_ExpBg[$i])
			_ArrayDelete($_ExpBg, $i)
			$_ExpBg[0] -= 1
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
	; Enemies
	For $i = $Enemies[0] To 1 Step -1
		$tmp = _GEng_SpriteToSprite_Angle($Enemies[$i], $SprT)
		_GEng_Sprite_AngleSet($Enemies[$i], $tmp + 90 + Random( 1, 10))
		$tmp = _GEng_SpriteToSprite_Vector($Enemies[$i], $sprT)

		;~ TODO - OCACIONANDO BUG
		;~ _GEng_Sprite_AccelSet($Enemies[$i], $tmp[0], $tmp[1])
		_GEng_Sprite_Draw($Enemies[$i])
	Next
	; ---
	; Rocketeers
	For $i = $_Rocket[0] To 1 Step -1
		$tmp = _GEng_SpriteToSprite_Angle($_Rocket[$i], $SprT)
		_GEng_Sprite_AngleSet($_Rocket[$i], $tmp + 90)
		$tmp = _GEng_SpriteToSprite_Vector($_Rocket[$i], $sprT)

		;~ TODO - OCACIONANDO BUG
		;~ _GEng_Sprite_AccelSet($_Rocket[$i], $tmp[0], $tmp[1])
		_GEng_Sprite_Draw($_Rocket[$i])
	Next
	; ---
	; Bullets
	For $i = $_Balles[0] To 1 Step -1
		_GEng_Sprite_Draw($_Balles[$i])
		_GEng_Sprite_PosGet($_Balles[$i], $x, $y)
		If _GEng_Sprite_Collision( $_Balles[$i], $sprT ) Then
			If $Health = 0 Then
				MsgBox( 0, "Game Over", "Game Over")
				Exit
			EndIf
			$Health -= 1
			_GEng_Sprite_ImageSetRect($sprHealthbar, 0, 0, ( $Health * 3 ) , 20, True)
			_GEng_Text_StringSet($txtHealth, $Health&" %")

			$spr = _GEng_Sprite_Create()
			_GEng_Sprite_ColorMatrixTranslate($spr, 0, 0, 0, -0.4)
			_GEng_Sprite_OriginSet($spr, 10, 10)
			_GEng_Sprite_PosSet($spr, $x, $y)
			_ArrayAdd($_ExpSm, $spr)
			$_ExpSm[0] += 1
			$spr = 0

			_GEng_Sprite_Delete($_Balles[$i])
			_ArrayDelete($_Balles, $i)
			$_Balles[0] -= 1
			$i -= 1
		EndIf
		If $x < 0 Or $x > $scrW Or $y < 0 Or $y > $scrH Then
			_GEng_Sprite_Delete($_Balles[$i])
			_ArrayDelete($_Balles, $i)
			$_Balles[0] -= 1
		EndIf
	Next
	; ---
	; Enemy Collisions
	For $a = $Enemies[0] to 1 Step -1
			; Bullet Collision
		For $i = $_Balles[0] to 1 Step -1
			If _GEng_Sprite_Collision( $_Balles[$i], $Enemies[$a] ) Then
				$Kills += 1
				_GEng_Text_StringSet($txtKills, "Kills: "&$Kills)

				_GEng_Sprite_PosGet($Enemies[$a], $X, $Y)
				$spr = _GEng_Sprite_Create()
				_GEng_Sprite_OriginSet($spr, 10, 10)
				_GEng_Sprite_PosSet($spr, $x, $y)
				_ArrayAdd($_Blood, $spr)
				$_Blood[0] += 1
				$spr = 0

				_GEng_Sprite_Delete($_Balles[$i])
				_ArrayDelete($_Balles, $i)
				$_Balles[0] -= 1
				_GEng_Sprite_Delete($Enemies[$a])
				_ArrayDelete($Enemies, $a)
				$Enemies[0] -= 1
				_ArrayDelete($ShotTimers, $a)
				$ShotTimers[0] -= 1
				$a -= 1
			EndIf
		Next
			; Rocket Collision
		For $i = $_Obus[0] to 1 Step -1
			If _GEng_Sprite_Collision( $_Obus[$i], $Enemies[$a] ) Then
				$Kills += 1
				_GEng_Text_StringSet($txtKills, "Kills: "&$Kills)

				_GEng_Sprite_PosGet($Enemies[$a], $X, $Y)
				$spr = _GEng_Sprite_Create()
				_GEng_Sprite_OriginSet($spr, 20, 20)
				_GEng_Sprite_PosSet($spr, $x, $y)
				_GEng_Sprite_CollisionSet($spr, 2, $x, $y, 20 )
				_ArrayAdd($_ExpBg, $spr)
				$_ExpBg[0] += 1
				$spr = 0

				_GEng_Sprite_Delete($_Obus[$i])
				_ArrayDelete($_Obus, $i)
				$_Obus[0] -= 1
				_GEng_Sprite_Delete($Enemies[$a])
				_ArrayDelete($Enemies, $a)
				$Enemies[0] -= 1
				_ArrayDelete($ShotTimers, $a)
				$ShotTimers[0] -= 1
				$a -= 1
			EndIf
		Next
			; Explosion Big Collision - splash damage
		For $i = $_ExpBg[0] To 1 Step -1
			If _GEng_Sprite_Collision( $_ExpBg[$i], $Enemies[$a]) Then
				_GEng_Sprite_Delete($Enemies[$a])
				_ArrayDelete($Enemies, $a)
				$Enemies[0] -= 1
				_ArrayDelete($ShotTimers, $a)
				$ShotTimers[0] -= 1
				$a -= 1
			EndIf
		Next
			; Mine Collision
		For $i = $_Mine[0] To 1 Step -1
			If _GEng_Sprite_Collision($_Mine[$i], $Enemies[$a]) Then
				_GEng_Sprite_PosGet($_Mine[$a], $X, $Y)
				$spr = _GEng_Sprite_Create()
				_GEng_Sprite_OriginSet($spr, 20, 20)
				_GEng_Sprite_PosSet($spr, $x, $y)
				_GEng_Sprite_CollisionSet($spr, 2, $x, $y, 20 )
				_ArrayAdd($_ExpBg, $spr)
				$_ExpBg[0] += 1
				$spr = 0
				_ArrayDelete($_Mine[$i], $i)
				$_Mine[0] -= 1
				_ArrayDelete($Enemies, $a)
				$Enemies[0] -= 1
				_ArrayDelete($ShotTimers, $a)
				$ShotTimers[0] -= 1
				$a -= 1
			EndIf
		Next
	Next
	; ---
	; Rocket Enemy Collisions
	For $a = $_Rocket[0] to 1 Step -1
			; Bullet Collision
		For $i = $_Balles[0] to 1 Step -1
			If _GEng_Sprite_Collision( $_Balles[$i], $_Rocket[$a] ) Then
				$Kills += 1
				_GEng_Text_StringSet($txtKills, "Kills: "&$Kills)

				_GEng_Sprite_PosGet($_Rocket[$a], $X, $Y)
				$spr = _GEng_Sprite_Create()
				_GEng_Sprite_OriginSet($spr, 10, 10)
				_GEng_Sprite_PosSet($spr, $x, $y)
				_ArrayAdd($_Blood, $spr)
				$_Blood[0] += 1
				$spr = 0

				_GEng_Sprite_Delete($_Balles[$i])
				_ArrayDelete($_Balles, $i)
				$_Balles[0] -= 1
				_GEng_Sprite_Delete($_Rocket[$a])
				_ArrayDelete($_Rocket, $a)
				$_Rocket[0] -= 1
				_ArrayDelete($ShotTimersR, $a)
				$ShotTimersR[0] -= 1
				$a -= 1
			EndIf
		Next
			; Rocket Collision
		For $i = $_Obus[0] to 1 Step -1
			If _GEng_Sprite_Collision( $_Obus[$i], $_Rocket[$a] ) Then
				$Kills += 1
				_GEng_Text_StringSet($txtKills, "Kills: "&$Kills)

				_GEng_Sprite_PosGet($_Rocket[$a], $X, $Y)
				$spr = _GEng_Sprite_Create()
				_GEng_Sprite_OriginSet($spr, 20, 20)
				_GEng_Sprite_PosSet($spr, $x, $y)
				_GEng_Sprite_CollisionSet($spr, 2, $x, $y, 20 )
				_ArrayAdd($_ExpBg, $spr)
				$_ExpBg[0] += 1
				$spr = 0

				_GEng_Sprite_Delete($_Obus[$i])
				_ArrayDelete($_Obus, $i)
				$_Obus[0] -= 1
				_GEng_Sprite_Delete($_Rocket[$a])
				_ArrayDelete($_Rocket, $a)
				$_Rocket[0] -= 1
				_ArrayDelete($ShotTimersR, $a)
				$ShotTimersR[0] -= 1
				$a -= 1
			EndIf
		Next
			; Explosion Big Collision - splash damage
		For $i = $_ExpBg[0] To 1 Step -1
			If _GEng_Sprite_Collision( $_ExpBg[$i], $_Rocket[$a]) Then
				_GEng_Sprite_Delete($_Rocket[$a])
				_ArrayDelete($_Rocket, $a)
				$_Rocket[0] -= 1
				_ArrayDelete($ShotTimersR, $a)
				$ShotTimersR[0] -= 1
				$a -= 1
			EndIf
		Next
			; Mine Collision
		For $i = $_Mine[0] To 1 Step -1
			If _GEng_Sprite_Collision($_Mine[$i], $_Rocket[$a]) Then
				_GEng_Sprite_PosGet($_Mine[$a], $X, $Y)
				$spr = _GEng_Sprite_Create()
				_GEng_Sprite_OriginSet($spr, 20, 20)
				_GEng_Sprite_PosSet($spr, $x, $y)
				_GEng_Sprite_CollisionSet($spr, 2, $x, $y, 20 )
				_ArrayAdd($_ExpBg, $spr)
				$_ExpBg[0] += 1
				$spr = 0
				_ArrayDelete($_Mine[$i], $i)
				$_Mine[0] -= 1
				_ArrayDelete($_Rocket, $a)
				$_Rocket[0] -= 1
				_ArrayDelete($ShotTimersR, $a)
				$ShotTimersR[0] -= 1
				$a -= 1
			EndIf
		Next
	Next
EndFunc

Func _CreateEnemies()
	$Random = Random()
	If $Random < 0.25 Then ; left
		$x = 6
		$y = Round(Random( 6, $scrH - 12 ), 0)
	ElseIf $Random > 0.25 and $Random < 0.5 Then ; top
		$x = Round(Random( 6, $scrW - 12 ), 0)
		$y = 6
	ElseIf $Random > 0.5 and $Random < 0.75 Then ; right
		$x = $scrW - 6
		$y = Round(Random( 6, $scrH - 12 ), 0)
	ElseIf $Random > 0.75 Then ; bottom
		$x = Round(Random( 6, $scrW - 12 ), 0)
		$y = $scrH - 30
	EndIf
	$Random = Round(Random( 1, 10), 0)
	If $Random <= 2 Then
		$spr = _GEng_Sprite_Create()
		_GEng_Sprite_ImageSet($spr, $imgRocket)
		_GEng_Sprite_OriginSet($spr, 6, 6)
		_GEng_Sprite_CollisionSet($spr, 1, 0, 6, 12, 9)
		_GEng_Sprite_PosSet($spr, $x, $y)
		_GEng_Sprite_SpeedSet($spr, 3, 3, 6)
		_ArrayAdd($_Rocket, $spr)
		$_Rocket[0] += 1
		$spr = 0
		$ShotTimer = TimerInit()
		_ArrayAdd($ShotTimersR, $ShotTimer)
	Else
		$spr = _GEng_Sprite_Create()
		_GEng_Sprite_ImageSet($spr, $imgMarine)
		_GEng_Sprite_OriginSet($spr, 6, 6)
		_GEng_Sprite_CollisionSet($spr, 1, 0, 6, 12, 9)
		_GEng_Sprite_PosSet($spr, $x, $y)
		_GEng_Sprite_SpeedSet($spr, 4, 4, 10)
		_ArrayAdd($Enemies, $spr)
		$Enemies[0] += 1
		$spr = 0
		$ShotTimer = TimerInit()
		_ArrayAdd($ShotTimers, $ShotTimer)
	EndIf

EndFunc

Func _DrawTank()
	Local $x, $y
	_GEng_Sprite_PointGet($sprT, 18, 14, $x, $y)
	_GEng_Sprite_PosSet($sprTx, $x, $y)
	_GEng_Sprite_PointGet($sprT, 36, 8, $x, $y)
	_GEng_Sprite_PosSet($sprTm, $x, $y)
	_GEng_Sprite_Draw($sprT)
	_GEng_Sprite_Draw($sprTm, 0)
	_GEng_Sprite_Draw($sprTx, 0)
EndFunc

Func _DrawBackground()
	_GEng_Sprite_Draw($sprB, 0)
EndFunc

Func _CheckMove()
	Local $x, $y
	Local $tmpa = MouseGetPos()
	$tmp = _GEng_SpriteToPoint_Angle($sprTx, $tmpa[0], $tmpa[1])
	_GEng_Sprite_AngleSet($sprTx, $tmp)
	$tmp = _GEng_SpriteToPoint_Angle($sprTm, $tmpa[0], $tmpa[1])
	_GEng_Sprite_AngleSet($sprTm, $tmp)
	; ---
	$tmp = _GEng_Sprite_AngleGet($sprT)
	$tmp = _GEng_AngleToVector($tmp, 1)
	; ---
	If _IsPressed('41') Then ; A
		_GEng_Sprite_AngleAdd($sprT, -1.5)
	ElseIf _IsPressed('44') Then ; D
		_GEng_Sprite_AngleAdd($sprT, 1)
	EndIf
	; ---
	If _IsPressed('57') Then ; W
		_GEng_Sprite_AccelSet($sprT, $tmp[0] * 1000, $tmp[1] * 1000)
	ElseIf _IsPressed('53') Then ; S
		_GEng_Sprite_AccelSet($sprT, $tmp[0] * -1000, $tmp[1] * -1000)
	Else
		_GEng_Sprite_AccelSet($sprT, 0, 0)
	EndIf
	; ---
EndFunc
