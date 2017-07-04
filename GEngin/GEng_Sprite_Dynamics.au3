#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         Matwachich

 Script Function:


#ce ----------------------------------------------------------------------------

#Region ### Functions ###
#cs
- Main Functions
	_GEng_Sprite_Move(ByRef $hSprite)
#ce
#EndRegion ###


; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sprite_Move
; Description ...: Calcule et met à jout position et angle d'un sprite selon ses paramètres dynamiques
; Syntax.........: _GEng_Sprite_Move(ByRef $hSprite)
; Parameters ....: $hSprite = Objet Sprite
; Return values .: Succes - 1
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks .......: Cette fonction est automatiquement appelé par _GEng_Sprite_Draw si le flag correspondant
;                  	est bien mis à 1. Il est donc, inutile de l'appeler vous même
; ;==========================================================================================
Func _GEng_Sprite_Move(ByRef $hSprite)
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	If Not $hSprite[$_gSpr_MoveTimer] Then
		$hSprite[$_gSpr_MoveTimer] = TimerInit()
		Return 0
	EndIf
	Local $ms = TimerDiff($hSprite[$_gSpr_MoveTimer]) / 1000
	
	; ##############################################################
	
	; ### Rotation Max ###
	If $hSprite[$_gSpr_AngleSpeedMax] <> 0 Then
		If Abs($hSprite[$_gSpr_AngleSpeed]) > Abs($hSprite[$_gSpr_AngleSpeedMax]) Then
			If $hSprite[$_gSpr_AngleSpeed] >= 0 Then
				$hSprite[$_gSpr_AngleSpeed] = Abs($hSprite[$_gSpr_AngleSpeedMax])
			Else
				$hSprite[$_gSpr_AngleSpeed] = -1 * Abs($hSprite[$_gSpr_AngleSpeedMax])
			EndIf
		EndIf
	EndIf
	; ### Application de la rotation ###
	Local $rotVit = $hSprite[$_gSpr_AngleSpeed]
	Local $rotAccel = $hSprite[$_gSpr_AngleAccel]
	Local $rotInner = $hSprite[$_gSpr_AngleInnertie]
	; --- Vitesse
	Local $currAngle = $hSprite[$_gSpr_AngleDeg]
	If $rotVit <> 0 Then
		_GEng_Sprite_AngleSet($hSprite, $currAngle + ($rotVit * $ms))
	EndIf
	; --- Accélération
	If $rotAccel <> 0 Then
		$hSprite[$_gSpr_AngleSpeed] += $rotAccel * $ms
	EndIf
	; --- Innertie
	Local $tmp
	If $rotInner <> 0 And $hSprite[$_gSpr_AngleSpeed] <> 0 Then
		$tmp = $hSprite[$_gSpr_AngleSpeed]
		If $hSprite[$_gSpr_AngleSpeed] > 0 Then
			$hSprite[$_gSpr_AngleSpeed] -= Abs($rotInner) * $ms
		ElseIf $hSprite[$_gSpr_AngleSpeed] < 0 Then
			$hSprite[$_gSpr_AngleSpeed] += Abs($rotInner) * $ms
		EndIf
		If $hSprite[$_gSpr_AngleSpeed] / $tmp < 0 Then $hSprite[$_gSpr_AngleSpeed] = 0
	EndIf
	
	; ##############################################################
	
	Local $posX = $hSprite[$_gSpr_PosX], $posY = $hSprite[$_gSpr_PosY] ; Position actuelle
	Local $accelX = $hSprite[$_gSpr_AccelX], $accelY = $hSprite[$_gSpr_AccelY] ; Accélération
	Local $accelGrand = __GEng_VectorGrandeur($accelX, $accelY)
	;If $accelGrand Then ConsoleWrite("> Accélération: " & $accelX & "	" & $accelY & "	(" & $accelGrand & ")" & @CRLF)
	; ---
	
	; Applique l'accélération
	$hSprite[$_gSpr_SpeedX] += $accelX * $ms
	$hSprite[$_gSpr_SpeedY] += $accelY * $ms
	Local $vitGrand = __GEng_VectorGrandeur($hSprite[$_gSpr_SpeedX], $hSprite[$_gSpr_SpeedY])
	Local $vitAngle = _GEng_VectorToAngle($hSprite[$_gSpr_SpeedX], $hSprite[$_gSpr_SpeedY])
	
	; Vitesse Maximum
	If $hSprite[$_gSpr_SpeedMax] <> 0 And $vitGrand > $hSprite[$_gSpr_SpeedMax] Then
		$tmp = _GEng_AngleToVector($vitAngle, $hSprite[$_gSpr_SpeedMax])
		$hSprite[$_gSpr_SpeedX] = $tmp[0]
		$hSprite[$_gSpr_SpeedY] = $tmp[1]
	EndIf
	
	; Position
	If $hSprite[$_gSpr_SpeedX] <> 0 Then
		$hSprite[$_gSpr_PosX] += $hSprite[$_gSpr_SpeedX] * $ms
	EndIf
	If $hSprite[$_gSpr_SpeedY] <> 0 Then
		$hSprite[$_gSpr_PosY] += $hSprite[$_gSpr_SpeedY] * $ms
	EndIf
	
	; --- 1.2.1
	Local $vect = _GEng_AngleToVector(_GEng_VectorToAngle($hSprite[$_gSpr_SpeedX], $hSprite[$_gSpr_SpeedY]), $hSprite[$_gSpr_Innertie])
	
	If $vect[0] <> 0 And $hSprite[$_gSpr_SpeedX] <> 0 And Not $accelX Then ; Innertie X
		$tmp = $hSprite[$_gSpr_SpeedX]
		If $hSprite[$_gSpr_SpeedX] > 0 Then
			$hSprite[$_gSpr_SpeedX] -= Abs($vect[0]) * $ms
		ElseIf $hSprite[$_gSpr_SpeedX] < 0 Then
			$hSprite[$_gSpr_SpeedX] += Abs($vect[0]) * $ms
		EndIf
		If $hSprite[$_gSpr_SpeedX] / $tmp < 0 Then $hSprite[$_gSpr_SpeedX] = 0
	EndIf
	If $vect[1] <> 0 And $hSprite[$_gSpr_SpeedY] <> 0 And Not $accelY Then ; Innertie Y
		$tmp = $hSprite[$_gSpr_SpeedY]
		If $hSprite[$_gSpr_SpeedY] > 0 Then
			$hSprite[$_gSpr_SpeedY] -= Abs($vect[1]) * $ms
		ElseIf $hSprite[$_gSpr_SpeedY] < 0 Then
			$hSprite[$_gSpr_SpeedY] += Abs($vect[1]) * $ms
		EndIf
		If $hSprite[$_gSpr_SpeedY] / $tmp < 0 Then $hSprite[$_gSpr_SpeedY] = 0
	EndIf
	
	; ##############################################################
	
	; Réinitialisation du timer
	$hSprite[$_gSpr_MoveTimer] = TimerInit()
	; ---
	Return 1
EndFunc

; ==============================================================
; ### Internals
; ==============================================================
Func __GEng_VectorGrandeur($x, $y)
	Return Abs(Sqrt(($x^2) + ($y^2)))
EndFunc
