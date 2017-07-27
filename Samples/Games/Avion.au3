#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Compression=4
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         Matwachich

 Script Function:


#ce ----------------------------------------------------------------------------

#include "..\..\GEngin.au3"
#include <Misc.au3>

Opt("MouseCoordMode", 2)

$dll = DllOpen("user32.dll")

Global $scrW = 800, $scrH = 600 ; taille de l'ï¿½cran
Global $avionInnertie = 150, $avionRotInnertie = 300 ; variables physiques du joueur
Global $avionMaxSpeed = 300, $avionMaxRotSpeed = 180 ; variables physiques du joueur
Global $tirParSec = 12, $tirSpeed = 800, $coneDeTire = 2 ; variables physiques des balles
Global $MissParSec = 2, $MissAccel = 1200 ; variables physiques des missiles
Global $asterMax = 5 ; nombre max d'astï¿½roides
Global $asterSpeeds[3] = [50, 100, 150] ; vitesse des astï¿½roides (grand, moy, petit)
Global $asterSpeedVar = 50 ; +/- 50
Global $asterLife[3] = [80, 40, 10] ; points de vie des astï¿½roides (grand, moy, petit)
Global $dmgMissile = 75, $dmgBalle = 10 ; dï¿½gats des armes
; ---
Global $score = 0
Global $asterScore[3] = [500, 250, 100] ; Score par astï¿½roide dï¿½truit (grand, moy, petit)
Global $playerLife = 100 ; points de vie du joueur
Global $asterDmg[3] = [50, 20, 10] ; Dï¿½gats des astï¿½roides sur le joueur (grand, moy, petit)
Global $overTime = 2000 ; dï¿½lai entre: Point de vie = 0 ET explosion du vaisseau
Global $overExploTime = 100 ; dï¿½lai entre les petites explosion dans $overTime

; variables internes
Global Const $asterCollCircleRay[3] = [30, 16, 8]
Global $gameOver = 0, $gameOverTimer, $OverExploTimer, $finalExplo = 0
Global $lifeTxtSitchedFont = 0
Global $actifCanon = 1 ; 28,8 - 28,31

Global $shots[1] = [0], $explo[1] = [0], $smokes[1] = [0], $sparks[1] = [0]
Global $aster[1][2]
	$aster[0][0] = 0
Global $exploS[1] = [0]

; ---
; Debug
HotKeySet("{tab}", "_toggleDebug")
Func _toggleDebug()
	If _GEng_SetDebug() Then
		_GEng_SetDebug(0)
	Else
		_GEng_SetDebug($GEng_Debug_Vectors)
	EndIf
EndFunc

_GEng_Start("G-Astéroïdes", $scrW, $scrH)
_GEng_Sound_Init()
; ---

$img_Avion = _GEng_ImageLoad("res\avion\images\viper.png")
;~ $img_Avion = _GEng_ImageLoad("res\avion\avion_new.png", 100, 80)
;~ $img_Shot = _GEng_ImageLoad("res\avion\balle.png", 11, 3)
;~ $img_Miss = _GEng_ImageLoad("res\avion\missile_new.png", 30, 40)
;~ $img_Explo_Small = _GEng_ImageLoad("res\avion\explosion.png")
;~ $img_Explo_Big = _GEng_ImageLoad("res\avion\explo_big.png")
;~ $img_Smoke = _GEng_ImageLoad("res\avion\smoke.png")
;~ $img_Spark = _GEng_ImageLoad("res\avion\spark.png", 24, 24)
;~ $img_Muz = _GEng_ImageLoad("res\avion\muzz.png", 18, 14*5)
;~ $img_Bg = _GEng_ImageLoad("res\avion\bg-blue.jpg", $scrW, $scrH)
;~ ; ---
;~ $img_Ast_1_1 = _GEng_ImageLoad("res\avion\meteorite_large1.png", 64, 64)
;~ $img_Ast_1_2 = _GEng_ImageLoad("res\avion\meteorite_large2.png", 64, 64)
;~ $img_Ast_2_1 = _GEng_ImageLoad("res\avion\meteorite_medium1.png", 32, 32)
;~ $img_Ast_2_2 = _GEng_ImageLoad("res\avion\meteorite_medium2.png", 32, 32)
;~ $img_Ast_3_1 = _GEng_ImageLoad("res\avion\meteorite_small1.png", 16, 16)
;~ $img_Ast_3_2 = _GEng_ImageLoad("res\avion\meteorite_small2.png", 16, 16)

;~ $img_Avion = _GEng_ImageLoad("res\avion\images\avion_new.png")
$img_Shot = _GEng_ImageLoad("res\avion\images\balle.png")
$img_Miss = _GEng_ImageLoad("res\avion\images\missile_new.png")
$img_Explo_Small = _GEng_ImageLoad("res\avion\images\explosion.png")
$img_Explo_Big = _GEng_ImageLoad("res\avion\images\explo_big.png")
$img_Smoke = _GEng_ImageLoad("res\avion\images\smoke.png")
$img_Spark = _GEng_ImageLoad("res\avion\images\spark.png")
$img_Muz = _GEng_ImageLoad("res\avion\images\muzz.png")
$img_Bg = _GEng_ImageLoad("res\avion\images\bg-blue.jpg")
; ---
$img_Ast_1_1 = _GEng_ImageLoad("res\avion\images\meteorite_large1.png")
$img_Ast_1_2 = _GEng_ImageLoad("res\avion\images\meteorite_large2.png")
$img_Ast_2_1 = _GEng_ImageLoad("res\avion\images\meteorite_medium1.png")
$img_Ast_2_2 = _GEng_ImageLoad("res\avion\images\meteorite_medium2.png")
$img_Ast_3_1 = _GEng_ImageLoad("res\avion\images\meteorite_small1.png")
$img_Ast_3_2 = _GEng_ImageLoad("res\avion\images\meteorite_small2.png")

; ---
Global $avSizeX = 50, $avSizeY = 40
Global $sprAvSizeX = 100, $sprAvSizeY = 80
; ---
	
$spr_Bg = _GEng_Sprite_Create($img_Bg)

$spr_Avion = _GEng_Sprite_Create($img_Avion)
	_GEng_Sprite_SizeSet($spr_Avion, $avSizeX, $avSizeY)
	_GEng_Sprite_ImageSetRect($spr_Avion, 0, 0, $sprAvSizeX / 2, $sprAvSizeY / 2, 0)
	_GEng_Sprite_CollisionSet($spr_Avion, 2, $avSizeX / 2, $avSizeY / 2, $avSizeX / 3) ; cercle

	_GEng_Sprite_OriginSetEx($spr_Avion, $GEng_Origin_Mid)
	_GEng_Sprite_PosSet($spr_Avion, $scrW / 2, $scrH / 2)
	
	_GEng_Sprite_InnertieSet($spr_Avion, $avionInnertie)
	_GEng_Sprite_AngleInnertieSet($spr_Avion, $avionRotInnertie)

	_GEng_Sprite_SpeedSet($spr_Avion, 0, 0, $avionMaxSpeed)
	_GEng_Sprite_AngleSpeedSet($spr_Avion, 0, $avionMaxRotSpeed)
	
$sprMuz = _GEng_Sprite_Create()
	_GEng_Sprite_SizeSet($sprMuz, 18, 14)
	_GEng_Sprite_OriginSet($sprMuz, 0, 7)
; ---

$anim = _GEng_Anim_Create()
	_GEng_Anim_FrameAdd($anim, $img_Avion, 100, 	$sprAvSizeX / 2, 0,	$sprAvSizeX / 2, $sprAvSizeY / 2)
	_GEng_Anim_FrameAdd($anim, $img_Avion, 100, 	0, $sprAvSizeY / 2, $sprAvSizeX / 2, $sprAvSizeY / 2)
	_GEng_Anim_FrameAdd($anim, $img_Avion, 100, 	$sprAvSizeX / 2, $sprAvSizeY / 2, $sprAvSizeX / 2, $sprAvSizeY / 2)
	_GEng_Anim_FrameAdd($anim, $img_Avion, 100, 	0, $sprAvSizeY / 2, $sprAvSizeX / 2, $sprAvSizeY / 2)

$animExplo_Small = _GEng_Anim_Create()
	For $i = 0 To 13
		_GEng_Anim_FrameAdd($animExplo_Small, $img_Explo_Small, 75, 48 * $i, 0, 48, 48)
	Next

$animExplo_Big = _GEng_Anim_Create()
	For $i = 0 To 5
		_GEng_Anim_FrameAdd($animExplo_Big, $img_Explo_Big, 75, 113 * $i, 0, 113, 104)
	Next
	For $i = 0 To 5
		_GEng_Anim_FrameAdd($animExplo_Big, $img_Explo_Big, 75, 113 * $i, 104, 113, 104)
	Next
	For $i = 0 To 5
		_GEng_Anim_FrameAdd($animExplo_Big, $img_Explo_Big, 75, 113 * $i, 208, 113, 104)
	Next
	For $i = 0 To 5
		_GEng_Anim_FrameAdd($animExplo_Big, $img_Explo_Big, 75, 113 * $i, 312, 113, 104)
	Next
	For $i = 0 To 5
		_GEng_Anim_FrameAdd($animExplo_Big, $img_Explo_Big, 75, 113 * $i, 416, 113, 104)
	Next
	
$animMiss = _GEng_Anim_Create()
	For $i = 0 To 3
		_GEng_Anim_FrameAdd($animMiss, $img_Miss, 75, 0, $i * 10, 30, 10)
	Next
	
$animSmoke = _GEng_Anim_Create()
	For $i = 0 To 11
		_GEng_Anim_FrameAdd($animSmoke, $img_Smoke, 75, 48 * $i, 0, 48, 48)
	Next
	
$animSpark = _GEng_Anim_Create()
	_GEng_Anim_FrameAdd($animSpark, $img_Spark, 75, 0, 0, 12, 12)
	_GEng_Anim_FrameAdd($animSpark, $img_Spark, 75, 12, 0, 12, 12)
	_GEng_Anim_FrameAdd($animSpark, $img_Spark, 75, 0, 12, 12, 12)
	_GEng_Anim_FrameAdd($animSpark, $img_Spark, 75, 12, 12, 12, 12)
	
$animMuz = _GEng_Anim_Create()
	For $i = 0 To 4
		_GEng_Anim_FrameAdd($animMuz, $img_Muz, 50, 0, 14 * $i, 18, 14)
	Next

; ---
Global $x, $y

$font1 = _GEng_Font_Create("Arial", 20, 2)  ; texte standard
$font2 = _GEng_Font_Create("Calibri", 120, 2) ; texte grand (Game Over)

$txt = _GEng_Text_Create($font1, "FPS", 0xFFFFFFFF, $ScrW - 100, 0)
$txtLife = _GEng_Text_Create($font1, $playerLife & " %", 0xFF00FF00, 0, $ScrH - 26)
$txtScore = _GEng_Text_Create($font1, $score, 0xFFFFFFFF, 0, 0)
$txtAsterMax = _GEng_Text_Create($font1, $asterMax & " Astï¿½roï¿½des", 0xFFFFFFFF, 0, 26)

_GEng_Text_SizeMeasure($font2, "GAME OVER", $x, $y)
$txtGameOver = _GEng_Text_Create($font2, "GAME OVER", 0xFFFFFFFF, ($ScrW / 2) - ($x / 2), ($ScrH / 2) - ($y / 2))

; ---

$sndExplo1 = _GEng_Sound_Load("res\avion\sound\explosion02.wav")
$sndExplo2 = _GEng_Sound_Load("res\avion\sound\explosion05.wav")
	_GEng_Sound_AttribSet($sndExplo1, 0.2, -0.5, 0.8)
	_GEng_Sound_AttribSet($sndExplo2, 0.2, +0.5, 0.8)
; ---
$sndTir = _GEng_Sound_Load("res\avion\sound\shot_rapid.wav")
	_GEng_Sound_AttribSet($sndTir, 0.3, 0, 1.5)
	;Global $1, $2, $3, $4
	;_GEng_Sound_AttribGet($sndTir, $1, $2, $3, $4)
	;ConsoleWrite($1 & " - " & $2 & " - " & $3 & " - " & $4 & @CRLF)
	
$sndBing = _GEng_Sound_Load("res\avion\sound\bing.wav")
$sndhit = _GEng_Sound_Load("res\avion\sound\crunch.wav")
	_GEng_Sound_AttribSet($sndhit, 0.2, 0)
$sndWarn = _GEng_Sound_Load("res\avion\sound\shield_warning.wav")
	_GEng_Sound_AttribSet($sndhit, 0.6, 0)

; ---

Global $delaiTir = 1000 / $tirParSec
Global $delaiMiss = 1000 / $MissParSec
Global $tmp, $tmp2, $shotTimer = $delaiTir, $missTimer = $delaiMiss

Global $t
Do
	_GEng_Sprite_Draw($spr_Bg, 0)
	
	_GEng_Text_Draw($txt)
	_GEng_Text_Draw($txtLife)
	_GEng_Text_Draw($txtScore)
	_GEng_Text_Draw($txtAsterMax)
	
	_DrawAster()
	_DrawShots()
	_DrawSmokes()
	_DrawExplosions()
	_DrawSparks()
	
	; ---
	
	_GEng_Sprite_Draw($spr_Avion, 1)
	_CheckCollision()
	_DrawGameOver()
	; ---
	
	If Not $gameOver Then
		Select ; Mouvement Avant/Ariï¿½re
			Case _IsPressed('5A', $dll) ; Z
				$tmp = _GEng_AngleToVector(_GEng_Sprite_AngleGet($spr_Avion), 1200)
				_GEng_Sprite_AccelSet($spr_Avion, $tmp[0], $tmp[1])
				; ---
				_GEng_Sprite_Animate($spr_Avion, $anim)

			Case _IsPressed('53', $dll) ; S
				$tmp = _GEng_AngleToVector(_GEng_Sprite_AngleGet($spr_Avion), 1200)
				_GEng_Sprite_AccelSet($spr_Avion, -1 * $tmp[0], -1 * $tmp[1])
				; ---
				_GEng_Sprite_Animate($spr_Avion, $anim)

			Case Else
				_GEng_Sprite_AccelSet($spr_Avion, 0, 0)
				; ---
				_GEng_Sprite_AnimRewind($spr_Avion)
				_GEng_Sprite_ImageSetRect($spr_Avion, 0, 0, $sprAvSizeX / 2, $sprAvSizeY / 2, 0)
		EndSelect
		
		Select ; Rotation
			Case _IsPressed('51', $dll) ; Q
				_GEng_Sprite_AngleAccelSet($spr_Avion, -1200)

			Case _IsPressed('44', $dll) ; D
				_GEng_Sprite_AngleAccelSet($spr_Avion, 1200)

			Case Else
				_GEng_Sprite_AngleAccelSet($spr_Avion, 0)
		EndSelect
		
		If _IsPressed('20', $dll) Then
			_GEng_Sprite_InnertieSet($spr_Avion, 300)
		Else
			_GEng_Sprite_InnertieSet($spr_Avion, $avionInnertie)
		EndIf
	
	; ---
	
		If _IsPressed('01', $dll) Then ; Tire
			If TimerDiff($shotTimer) >= $delaiTir Then
				_GEng_Sound_Play($sndTir)
				_Shot(1)
				$shotTimer = TimerInit()
			EndIf
		EndIf
		If _IsPressed('02', $dll) Then ; Tire
			If TimerDiff($missTimer) >= $delaiMiss Then
				_Shot(2)
				$missTimer = TimerInit()
			EndIf
		EndIf
	; ---
	EndIf
	
	_GEng_Sprite_PosGet($spr_Avion, $x, $y)
	If $x > $ScrW Then $x = 0
	If $x < 0 Then $x = $ScrW
	If $y > $ScrH Then $y = 0
	If $y < 0 Then $y = $ScrH
	_GEng_Sprite_PosSet($spr_Avion, $x, $y)
	
	; simule un mouvement alï¿½atoire/instable
	;$a = Random(0, 359, 1)
	;$a = _GEng_AngleToVector($a, 1)
	;_GEng_Sprite_SpeedGet($spr_Avion, $tmp, $tmp2)
	;_GEng_Sprite_SpeedSet($spr_Avion, $tmp + $a[0], $tmp2 + $a[1])
	
	; ---
	_GEng_ScrUpdate()
	
	$tmp = $shots[0] + $explo[0] + $smokes[0] + $sparks[0] + $aster[0][0] + 1
	$tmp2 = _GEng_FPS_Get()
	
	If $tmp2 <> -1 Then
		_GEng_Text_StringSet($txt, Round($tmp2) & " FPS")
		WinSetTitle($__GEng_hGui, "", "G-Astéroïdes (Nbr Sprites: " & $tmp & ")")
	EndIf
	
	_AdjustDifficulty()
	_LifeSwitchFont()
	_GEng_Text_StringSet($txtLife, $playerLife & " %")
	_GEng_Text_StringSet($txtScore, $score)
	_GEng_Text_StringSet($txtAsterMax, $asterMax & " Astéroïdes")
	
Until GuiGetMsg() = -3

_GEng_Font_Delete($font1)
_GEng_Font_Delete($font2)
_GEng_Text_Delete($txt)
_GEng_Text_Delete($txtLife)
_GEng_Text_Delete($txtScore)
_GEng_Text_Delete($txtAsterMax)

_GEng_Sound_Free($sndExplo1)
_GEng_Sound_Free($sndExplo2)
_GEng_Sound_Free($sndTir)
_GEng_Sound_Free($sndBing)
_GEng_Sound_Free($sndhit)
_GEng_Sound_Free($sndWarn)

_GEng_Sound_Shutdown() ; optionelle
_GEng_Shutdown()

DllClose($dll)

; ---

Func _LifeSwitchFont()
	If $lifeTxtSitchedFont Then Return
	; ---
	If $playerLife <= 30 Then
		_GEng_Text_ColorSet($txtLife, 0xFFFF0000)
		$lifeTxtSitchedFont = 1
	EndIf
EndFunc

Func _AdjustDifficulty()
	If $score >= 5000 Then $asterMax = 7
	If $score >= 10000 Then $asterMax = 9
	If $score >= 15000 Then $asterMax = 11
	If $score >= 20000 Then $asterMax = 13
EndFunc

Func _CheckCollision()
	If $gameOver Then Return
	; ---
	Local $dmg
	; ---
	For $i = $aster[0][0] To 1 Step -1
		If _GEng_Sprite_Collision($spr_Avion, $aster[$i][0]) Then
			_GEng_Sound_Play($sndWarn)
			$dmg = $asterDmg[$aster[$i][1] - 1]
			$playerLife -= $dmg
			If $playerLife < 0 Then $playerLife = 0
			_DestroyAster($i, 0)
		EndIf
	Next
	; ---
	If $playerLife <= 0 Then _GameOver()
EndFunc

Func _GameOver()
	$gameOver = 1
	$gameOverTimer = TimerInit()
	$OverExploTimer = TimerInit()
	; ---
	_GEng_Sprite_AccelSet($spr_Avion, 0, 0)
	_GEng_Sprite_AngleAccelSet($spr_Avion, 0)
	_GEng_Sprite_InnertieSet($spr_Avion, 0)
	; ---
	_GEng_Sprite_AngleSpeedSet($spr_Avion, Default, 800)
	_GEng_Sprite_AngleAccelSet($spr_Avion, 3000)
	; ---
	_GEng_Sprite_ImageSetRect($spr_Avion, 0, 0, $sprAvSizeX / 2, $sprAvSizeY / 2, 0)
EndFunc

Func _DrawGameOver()
	If Not $gameOver Then Return
	; ---
	If TimerDiff($OverExploTimer) >= $overExploTime And Not $finalExplo Then
		_GameOverAddExplo()
		$OverExploTimer = TimerInit()
	EndIf
	; ---
	If TimerDiff($gameOverTimer) >= $overTime Then
		$finalExplo = 1
		_GEng_Sprite_SizeSet($spr_Avion, 113, 104)
		_GEng_Sprite_OriginSetEx($spr_Avion, $GEng_Origin_Mid)
		_GEng_Sprite_InnertieSet($spr_Avion, 1000)
		_GEng_Sprite_AngleSpeedSet($spr_Avion, 0)
	EndIf
	; ---
	For $i = $exploS[0] To 1 Step -1
		_GEng_Sprite_Draw($exploS[$i], 0)
		If _GEng_Sprite_Animate($exploS[$i], $animExplo_Small, 1) = -1 Then
			_ArrayDelete($exploS, $i)
			$exploS[0] -= 1
		EndIf
	Next
	; ---
	If $finalExplo Then
		_GEng_Text_Draw($txtGameOver)
		If _GEng_Sprite_Animate($spr_Avion, $animExplo_Big, 1) = -1 Then
			_GEng_Sprite_Delete($spr_Avion)
		EndIf
	EndIf
EndFunc

Func _GameOverAddExplo()
	If $spr_Avion = 0 Then Return
	; ---
	Local $angle = Random(0, 359, 1)
	Local $dist = Random(5, 30, 1)
	Local $vect = _GEng_AngleToVector($angle, $dist)
	Local $posX, $posY
	_GEng_Sprite_PosGet($spr_Avion, $posX, $posY)
	$posX += $vect[0]
	$posY += $vect[1]
	; ---
	Local $spr = _GEng_Sprite_Create()
	_GEng_Sprite_SizeSet($spr, 32, 32)
	_GEng_Sprite_OriginSetEx($spr, $GEng_Origin_Mid)
	_GEng_Sprite_PosSet($spr, $posX, $posY)
	; ---
	_ArrayAdd($exploS, $spr)
	$exploS[0] += 1
EndFunc

Func _DrawAster()
	_SpawnAster(Random(1, 3, 1))
	; ---
	Local $x, $y
	For $i = $aster[0][0] To 1 Step -1
		; ---
		;For $x = 1 To $aster[0][0] ; Collisions
		;	If $x <> $i Then _GEng_Sprite_Collision($aster[$i][0], $aster[$x][0], 1, 10)
		;Next
		; ---
		_GEng_Sprite_Draw($aster[$i][0], 1)
		; ---
		If _GEng_Sprite_ExtInfoGet($aster[$i][0], 1) <= 0 Then
			_DestroyAster($i)
		Else
			; ---
			_GEng_Sprite_PosGet($aster[$i][0], $x, $y)
			If $x > $ScrW Then $x = 0
			If $x < 0 Then $x = $ScrW
			If $y > $ScrH Then $y = 0
			If $y < 0 Then $y = $ScrH
			_GEng_Sprite_PosSet($aster[$i][0], $x, $y)
		EndIf
	Next
EndFunc

Func _DestroyAster($index, $spawnNew = 1)
	local $spr = _GEng_Sprite_Create()
	; ---
	Local $x, $y
	Switch $aster[$index][1]
		Case 1
			$x = 64
			$y = 64
		Case 2
			$x = 32
			$y = 32
		Case 3
			$x = 16
			$y = 16
	EndSwitch
	; ---
	$score += $asterScore[$aster[$index][1] - 1]
	; ---
	_GEng_Sprite_SizeSet($spr, $x, $y)
	_GEng_Sprite_OriginSetEx($spr, $GEng_Origin_Mid)
	; ---
	_GEng_Sprite_PosGet($aster[$index][0], $x, $y)
	_GEng_Sprite_PosSet($spr, $x, $y)
	; ---
	_ArrayAdd($smokes, $spr)
	$smokes[0] += 1
	; ---
	If $spawnNew Then
		Switch $aster[$index][1]
			Case 1
				_SpawnAster(2, 1, $x, $y)
				_SpawnAster(2, 1, $x, $y)
			Case 2
				_SpawnAster(3, 1, $x, $y)
				_SpawnAster(3, 1, $x, $y)
		EndSwitch
	EndIf
	; ---
	_GEng_Sound_Play($sndBing)
	; ---
	_ArrayDelete($aster, $index)
	$aster[0][0] -= 1
EndFunc

Func _Sound_Boom()
	Local $i = Random(1, 2, 1)
	_GEng_Sound_Play(Eval("sndExplo" & $i), 1)
EndFunc

Func _SpawnAster($size, $force = 0, $posX = Default, $posY = Default)
	If Not $force Then
		If $aster[0][0] >= $asterMax Then Return
	EndIf
	; ---
	Local $x, $y
	If $posX = Default Then 
		$x = Random(100, $ScrW - 100, 1)
	Else
		$x = $posX
	EndIf
	If $posY = Default Then 
		$y = Random(100, $ScrH - 100, 1)
	Else
		$y = $posY
	EndIf
	; ---
	Local $type, $tmp
	$type = Random(1, 2, 1)
	Local $img = Eval("img_Ast_" & $size & "_" & $type)
	Local $speed = Random($asterSpeeds[$size - 1] - $asterSpeedVar, $asterSpeeds[$size - 1] + $asterSpeedVar, 1)
	Local $angle = Random(0, 359, 1)
	Local $angleSpeed = Random(20, 90, 1)
	$tmp = _GEng_AngleToVector($angle, $speed)
	; ---
	Local $spr = _GEng_Sprite_Create($img)
	_GEng_Sprite_OriginSetEx($spr, $GEng_Origin_Mid)
	_GEng_Sprite_PosSet($spr, $x, $y)
	_GEng_Sprite_SpeedSet($spr, $tmp[0], $tmp[1])
	_GEng_Sprite_AngleSpeedSet($spr, $angleSpeed)
	; ---
	Local $coll = $asterCollCircleRay[$size - 1]
	_GEng_Sprite_CollisionSet($spr, 2, $coll, $coll, $coll, 0) ; cercle de collision
	;_GEng_Sprite_MasseSet($spr, 200 - $speed)
	; ---
	Local $health = $asterLife[$size - 1]
	_GEng_Sprite_ExtInfoAdd($spr, $health)
	; ---
	ReDim $aster[$aster[0][0] + 2][2]
	$aster[$aster[0][0] + 1][0] = $spr
	$aster[$aster[0][0] + 1][1] = $size
	$aster[0][0] += 1
EndFunc

Func _AnimMuz($mgAngle, $x, $y)
	_GEng_Sprite_AngleSet($sprMuz, $mgAngle)
	_GEng_Sprite_PosSet($sprMuz, $x, $y)
	_GEng_Sprite_Animate($sprMuz, $animMuz)
	_GEng_Sprite_Draw($sprMuz, 0)
EndFunc

Func _Shot($type)
	If $gameOver Then Return
	; ---
	Local $tmp
	Local $posX, $posY
	_GEng_Sprite_PosGet($spr_Avion, $posX, $posY)
	; ---
	Switch $type
		Case 1
			Local $spr = _GEng_Sprite_Create($img_Shot)
			_GEng_Sprite_SizeSet($spr, 12, 3)
			_GEng_Sprite_CollisionSet($spr, 2, 12, 1.5, 2)
			_GEng_Sprite_OriginSetEx($spr, $GEng_Origin_Mid)
			; ---
			Switch $actifCanon
				Case 1
					_GEng_Sprite_PointGet($spr_Avion, 28, 8, $posX, $posY)
					_GEng_Sprite_PosSet($spr, $posX, $posY)
					$actifCanon = 2
				Case 2
					_GEng_Sprite_PointGet($spr_Avion, 28, 31, $posX, $posY)
					_GEng_Sprite_PosSet($spr, $posX, $posY)
					$actifCanon = 1
			EndSwitch
		Case 2
			Local $spr = _GEng_Sprite_Create()
			_GEng_Sprite_ImageSetRect($spr, 0, 0, 64, 20)
			_GEng_Sprite_SizeSet($spr, 48, 16)
			_GEng_Sprite_CollisionSet($spr, 2, 24, 8, 8)
			_GEng_Sprite_OriginSetEx($spr, $GEng_Origin_Mid)
			_GEng_Sprite_PosSet($spr, $posX, $posY)
			; ---
			;Local $spr2 = _GEng_Sprite_Create()
			;_GEng_Sprite_ImageSetRect($spr2, 0, 0, 48, 48)
			;_GEng_Sprite_SizeSet($spr2, 32, 32)
			;_GEng_Sprite_OriginSetEx($spr2, $GEng_Origin_Mid)
			;_GEng_Sprite_PosSet($spr2, $posX, $posY)
			;; ---
			;_ArrayAdd($smokes, $spr2)
			;$smokes[0] += 1
	EndSwitch
	; ---
	Local $angle = _GEng_Sprite_AngleGet($spr_Avion)
	Switch $type
		Case 1
			If $coneDeTire = 0 Then
				$tmp = _GEng_AngleToVector($angle, $tirSpeed)
			Else
				$angle = Random($angle - ($coneDeTire / 2), $angle + ($coneDeTire / 2), 1)
				$tmp = _GEng_AngleToVector($angle, $tirSpeed)
			EndIf
			_GEng_Sprite_SpeedSet($spr, $tmp[0], $tmp[1])
		Case 2
			$tmp = _GEng_AngleToVector($angle, $MissAccel)
			; ---
			_GEng_Sprite_AccelSet($spr, $tmp[0], $tmp[1])
	EndSwitch
	; ---
	_GEng_Sprite_AngleSet($spr, $angle)
	If $type = 1 Then _AnimMuz($angle, $posX, $posY)
	; ---
	_ArrayAdd($shots, $spr)
	$shots[0] += 1
EndFunc

Func _DrawShots()
	Local $posX, $posY
	Local $sizeX, $sizeY
	Local $hit = 0
	For $i = $shots[0] To 1 Step -1
		_GEng_Sprite_Draw($shots[$i])
		; ---
		_GEng_Sprite_PosGet($shots[$i], $posX, $posY)
		_GEng_Sprite_SizeGet($shots[$i], $sizeX, $sizeY)
		; ---
		If $sizeX > 12 Then ; If missile
			_GEng_Sprite_Animate($shots[$i], $animMiss)
			; ---
			If $posX > $scrW Or $posX < 0 Or $posY > $scrH Or $posY < 0 Then
				_ArrayDelete($shots, $i)
				$shots[0] -= 1
			Else
				$hit = _CheckHitMissile($i)
				; ---	
				If $hit Then
					; ---
					_GEng_Sprite_SizeSet($shots[$i], 48, 48)
					_GEng_Sprite_SpeedSet($shots[$i], 0, 0)
					_GEng_Sprite_AccelSet($shots[$i], 0, 0)
					_GEng_Sprite_OriginSet($shots[$i], 24, 24)
					_GEng_Sprite_AngleSet($shots[$i], Random(0, 359, 1))
					; ---
					If $posX <= 10 Then _GEng_Sprite_PosSet($shots[$i], 10, Default)
					If $posX >= $scrW - 10 Then _GEng_Sprite_PosSet($shots[$i], $scrW - 10, Default)
					If $posY <= 10 Then _GEng_Sprite_PosSet($shots[$i], Default, 10)
					If $posY >= $scrH - 10 Then _GEng_Sprite_PosSet($shots[$i], Default, $scrH - 10)
					; ---
					_Sound_Boom()
					_GEng_Sprite_AnimRewind($shots[$i])
					_ArrayAdd($explo, $shots[$i])
					$explo[0] += 1
					; ---
					_ArrayDelete($shots, $i)
					$shots[0] -= 1
				EndIf
			EndIf
		; ---
		Else ; If balle
			; ---
			If $posX > $scrW Or $posX < 0 Or $posY > $scrH Or $posY < 0 Then
				_ArrayDelete($shots, $i)
				$shots[0] -= 1
			Else
				$hit = _CheckHitBalle($i)
				; ---
				If $hit Then
					; ---
					_GEng_Sprite_SizeSet($shots[$i], 12, 12)
					_GEng_Sprite_SpeedSet($shots[$i], 0, 0)
					_GEng_Sprite_AccelSet($shots[$i], 0, 0)
					_GEng_Sprite_OriginSet($shots[$i], 6, 6)
					_GEng_Sprite_AngleSet($shots[$i], Random(0, 359, 1))
					; ---
					If $posX <= 3 Then _GEng_Sprite_PosSet($shots[$i], 3, Default)
					If $posX >= $scrW - 3 Then _GEng_Sprite_PosSet($shots[$i], $scrW - 3, Default)
					If $posY <= 3 Then _GEng_Sprite_PosSet($shots[$i], Default, 3)
					If $posY >= $scrH - 3 Then _GEng_Sprite_PosSet($shots[$i], Default, $scrH - 3)
					; ---
					_GEng_Sprite_AnimRewind($shots[$i])
					; ---
					_ArrayAdd($sparks, $shots[$i])
					$sparks[0] += 1
					; ---
					_ArrayDelete($shots, $i)
					$shots[0] -= 1
				EndIf
			EndIf
		; ---
		Endif
	Next
EndFunc

Func _CheckHitBalle($i)
	Local $projectile = $shots[$i]
	Local $health
	; ---
	For $i = 1 To $aster[0][0]
		If _GEng_Sprite_Collision($projectile, $aster[$i][0]) Then
			_GEng_Sound_Play($sndHit)
			$health = _GEng_Sprite_ExtInfoGet($aster[$i][0], 1)
			_GEng_Sprite_ExtInfoSet($aster[$i][0], 1, $health - $dmgBalle)
			Return 1
		EndIf
	Next
EndFunc

Func _CheckHitMissile($i)
	Local $projectile = $shots[$i]
	Local $health
	; ---
	For $i = 1 To $aster[0][0]
		If _GEng_Sprite_Collision($projectile, $aster[$i][0]) Then
			$health = _GEng_Sprite_ExtInfoGet($aster[$i][0], 1)
			_GEng_Sprite_ExtInfoSet($aster[$i][0], 1, $health - $dmgMissile)
			_Sound_Boom()
			Return 1
		EndIf
	Next
EndFunc

Func _DrawExplosions()
	For $i = $explo[0] To 1 Step -1
		If _GEng_Sprite_Animate($explo[$i], $animExplo_Small, 1) = -1 Then
			_ArrayDelete($explo, $i)
			$explo[0] -= 1
		Else
			_GEng_Sprite_Draw($explo[$i], 0)
		EndIf
	Next
EndFunc

Func _DrawSparks()
	For $i = $sparks[0] To 1 Step -1
		If _GEng_Sprite_Animate($sparks[$i], $animSpark, 1) = -1 Then
			_ArrayDelete($sparks, $i)
			$sparks[0] -= 1
		Else
			_GEng_Sprite_Draw($sparks[$i], 0)
		EndIf
	Next
EndFunc

Func _DrawSmokes()
	For $i = $smokes[0] To 1 Step -1
		If _GEng_Sprite_Animate($smokes[$i], $animSmoke, 1) = -1 Then
			_ArrayDelete($smokes, $i)
			$smokes[0] -= 1
		Else
			_GEng_Sprite_Draw($smokes[$i], 0)
		EndIf
	Next
EndFunc
