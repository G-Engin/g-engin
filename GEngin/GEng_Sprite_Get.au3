#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         Matwachich

 Script Function:


#ce ----------------------------------------------------------------------------

;File: Get Parameters

#Region ### Functions ###
#cs
- Main Functions
	_GEng_Sprite_MassGet(ByRef $hSprite)
	_GEng_Sprite_PosGet(ByRef $hSprite, ByRef $x, ByRef $y)
	_GEng_Sprite_SizeGet(ByRef $hSprite, ByRef $x, ByRef $y)
	_GEng_Sprite_OriginGet(ByRef $hSprite, ByRef $x, ByRef $y)

	_GEng_Sprite_SpeedGet(ByRef $hSprite, ByRef $x, ByRef $y)
	_GEng_Sprite_MaxSpeedGet(ByRef $hSprite)
	_GEng_Sprite_AccelGet(ByRef $hSprite, ByRef $x, ByRef $y)
	_GEng_Sprite_InnertieGet(ByRef $hSprite)

	_GEng_Sprite_AngleGet(ByRef $hSprite, $iType = 1)
	_GEng_Sprite_AngleOriginGet(ByRef $hSprite, $iType = 1)

	_GEng_Sprite_AngleSpeedGet(ByRef $hSprite)
	_GEng_Sprite_AngleMaxSpeedGet(ByRef $hSprite)
	_GEng_Sprite_AngleAccelGet(ByRef $hSprite)
	_GEng_Sprite_AngleInnertieGet(ByRef $hSprite)
#ce
#EndRegion ###

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sprite_MassGet
; Description ...: Retourne la masse d'un objet Sprite
; Syntax.........: _GEng_Sprite_MassGet(ByRef $hSprite)
; Parameters ....: $hSprite - Objet Sprite
; Return values .: Success - La masse du sprite
;                  Failure - 0 And @error = 1
; Author ........: Matwachich
; Remarks .......:
; ;==========================================================================================
#cs
Function: _GEng_Sprite_MassGet
	Get a sprite's mass

Prototype:
	> _GEng_Sprite_MassGet(ByRef $hSprite)

Parameters:
	$hSprite - Sprite Object

Returns:
	Succes - Sprite's mass
	Failed - 0 And @error = 1
#ce
Func _GEng_Sprite_MassGet(ByRef $hSprite)
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	Return $hSprite[$_gSpr_Masse]
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sprite_PosGet
; Description ...: Récupère la position d'un Objet Sprite
; Syntax.........: _GEng_Sprite_PosGet(ByRef $hSprite, ByRef $x, ByRef $y)
; Parameters ....: $hSprite = Objet Sprite
;                  $x, $y = Variable qui vont contenir les données récupérées
; Return values .: Succes - 1
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks .......:
; ;==========================================================================================
#cs
Function: _GEng_Sprite_PosGet
	Get the position of a Sprite Object

Prototype:
	> _GEng_Sprite_PosGet(ByRef $hSprite, ByRef $x, ByRef $y)

Parameters:
	$hSprite - Sprite Object
	$x, $y - Vars that will contain the position

Returns:
	Succes - 1
	Failed - 0 And @error = 1
#ce
Func _GEng_Sprite_PosGet(ByRef $hSprite, ByRef $x, ByRef $y)
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	$x = $hSprite[$_gSpr_PosX]
	$y = $hSprite[$_gSpr_PosY]
	Return 1
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sprite_SizeGet
; Description ...: Récupère la taille d'un Objet Sprite
; Syntax.........: _GEng_Sprite_SizeGet(ByRef $hSprite, ByRef $x, ByRef $y)
; Parameters ....: $hSprite = Objet Sprite
;                  $x, $y = Variable qui vont contenir les données récupérées
; Return values .: Succes - 1
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks .......:
; ;==========================================================================================
#cs
Function: _GEng_Sprite_SizeGet
	Get the size of a Sprite Object

Prototype:
	> _GEng_Sprite_SizeGet(ByRef $hSprite, ByRef $x, ByRef $y)

Parameters:
	$hSprite - Sprite Object
	$x, $y - Vars that will contain the size

Returns:
	Succes - 1
	Failed - 0 And @error = 1
#ce
Func _GEng_Sprite_SizeGet(ByRef $hSprite, ByRef $x, ByRef $y)
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	$x = $hSprite[$_gSpr_Width]
	$y = $hSprite[$_gSpr_Height]
	Return 1
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sprite_OriginGet
; Description ...: Récupère la position du point d'origine d'un Objet Sprite
; Syntax.........: _GEng_Sprite_OriginGet(ByRef $hSprite, ByRef $x, ByRef $y)
; Parameters ....: $hSprite = Objet Sprite
;                  $x, $y = Variable qui vont contenir les données récupérées
; Return values .: Succes - 1
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks .......:
; ;==========================================================================================
#cs
Function: _GEng_Sprite_OriginGet
	Get the origin point of a Sprite Object

Prototype:
	> _GEng_Sprite_OriginGet(ByRef $hSprite, ByRef $x, ByRef $y)

Parameters:
	$hSprite - Sprite Object
	$x, $y - Vars that will contain the origin point position (relative to the Sprite)

Returns:
	Succes - 1
	Failed - 0 And @error = 1
#ce
Func _GEng_Sprite_OriginGet(ByRef $hSprite, ByRef $x, ByRef $y)
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	$x = $hSprite[$_gSpr_OriX]
	$y = $hSprite[$_gSpr_OriY]
	Return 1
EndFunc

; ##############################################################

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sprite_SpeedGet
; Description ...: Récupère la vitesse d'un Objet Sprite
; Syntax.........: _GEng_Sprite_SpeedGet(ByRef $hSprite, ByRef $x, ByRef $y)
; Parameters ....: $hSprite = Objet Sprite
;                  $x, $y = Variable qui vont contenir les données récupérées
; Return values .: Succes - 1
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks .......:
; ;==========================================================================================
#cs
Function: _GEng_Sprite_SpeedGet
	Get the speed of a Sprite Object

Prototype:
	> _GEng_Sprite_SpeedGet(ByRef $hSprite, ByRef $x, ByRef $y)

Parameters:
	$hSprite - Sprite Object
	$x, $y - Vars that will contain the speed

Returns:
	Succes - 1
	Failed - 0 And @error = 1
#ce
Func _GEng_Sprite_SpeedGet(ByRef $hSprite, ByRef $x, ByRef $y)
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	$x = $hSprite[$_gSpr_SpeedX]
	$y = $hSprite[$_gSpr_SpeedY]
	Return 1
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sprite_MaxSpeedGet
; Description ...: Récupère la vitesse maximum d'un Objet Sprite
; Syntax.........: _GEng_Sprite_MaxSpeedGet(ByRef $hSprite)
; Parameters ....: $hSprite = Objet Sprite
; Return values .: Succes - valeur de la vitesse
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks .......:
; ;==========================================================================================
#cs
Function: _GEng_Sprite_MaxSpeedGet
	Get the maximum speed of a Sprite Object

Prototype:
	> _GEng_Sprite_MaxSpeedGet(ByRef $hSprite)

Parameters:
	$hSprite - Sprite Object

Returns:
	Succes - Max Speed value
	Failed - 0 And @error = 1
#ce
Func _GEng_Sprite_MaxSpeedGet(ByRef $hSprite)
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	Return $hSprite[$_gSpr_SpeedMax]
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sprite_AccelGet
; Description ...: Récupère l'accélération d'un Objet Sprite
; Syntax.........: _GEng_Sprite_AccelGet(ByRef $hSprite, ByRef $x, ByRef $y)
; Parameters ....: $hSprite = Objet Sprite
;                  $x, $y = Variable qui vont contenir les données récupérées
; Return values .: Succes - 1
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks .......:
; ;==========================================================================================
#cs
Function: _GEng_Sprite_AccelGet
	Get the acceleration of a Sprite Object

Prototype:
	> _GEng_Sprite_AccelGet(ByRef $hSprite, ByRef $x, ByRef $y)

Parameters:
	$hSprite - Sprite Object
	$x, $y - Vars that will contain the acceleration

Returns:
	Succes - 1
	Failed - 0 And @error = 1
#ce
Func _GEng_Sprite_AccelGet(ByRef $hSprite, ByRef $x, ByRef $y)
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	$x = $hSprite[$_gSpr_AccelX]
	$y = $hSprite[$_gSpr_AccelY]
	Return 1
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sprite_InnertieGet
; Description ...: Récupère l'innertie d'un Objet Sprite
; Syntax.........: _GEng_Sprite_InnertieGet(ByRef $hSprite)
; Parameters ....: $hSprite = Objet Sprite
; Return values .: Succes - valeur de l'innertie
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks .......:
; ;==========================================================================================
#cs
Function: _GEng_Sprite_InnertieGet
	Get the innertia of a Sprite Object

Prototype:
	> _GEng_Sprite_InnertieGet(ByRef $hSprite)

Parameters:
	$hSprite - Sprite Object

Returns:
	Succes - Innertia value
	Failed - 0 And @error = 1
#ce
Func _GEng_Sprite_InnertieGet(ByRef $hSprite)
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	Return $hSprite[$_gSpr_Innertie]
EndFunc

; ##############################################################

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sprite_AngleGet
; Description ...: Récupère l'angle d'un Objet Sprite
; Syntax.........: _GEng_Sprite_AngleGet(ByRef $hSprite, $iType = 1)
; Parameters ....: $hSprite = Objet Sprite
; Return values .: Succes - valeur de l'angle (orientation)
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks .......:
; ;==========================================================================================
#cs
Function: _GEng_Sprite_AngleGet
	Get the angle of a Sprite Object (degrees Or radians)

Prototype:
	> _GEng_Sprite_AngleGet(ByRef $hSprite, $iType = 1)

Parameters:
	$hSprite - Sprite Object
	$iType - If 1 Then angle returned in degrees, If 2 Then angle returned in radians

Returns:
	Succes - Angle Value
	Failed - 0 And @error = 1
#ce
Func _GEng_Sprite_AngleGet(ByRef $hSprite, $iType = 1) ; 1- Degres, 2- Radians
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	Local $ret
	Switch $iType
		Case 1
			$ret = $hSprite[$_gSpr_AngleDeg] + $hSprite[$_gSpr_AngleOriDeg]
			If $ret = 360 Then $ret = 0
		Case 2
			$ret =  $hSprite[$_gSpr_AngleRad] + $hSprite[$_gSpr_AngleOriRad]
		Case Else
			Return SetError(1, 0, 0)
	EndSwitch
	; ---
	Return $ret
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sprite_AngleOriginGet
; Description ...: Récupère l'angle origine d'un Objet Sprite
; Syntax.........: _GEng_Sprite_AngleOriginGet(ByRef $hSprite, $iType = 1)
; Parameters ....: $hSprite = Objet Sprite
;                  $iType = 1 -> Degres, 2 -> Radians
; Return values .: Succes - valeur de la vitesse
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks .......: L'angle origine est utile pour un Sprite dont l'image est orienté vers une autre direction
;                  	que la droite
; ;==========================================================================================
#cs
Function: _GEng_Sprite_AngleOriginGet
	Get then angular origin of a Sprite Object

Prototype:
	> _GEng_Sprite_AngleOriginGet(ByRef $hSprite, $iType = 1)

Parameters:
	$hSprite - Sprite Object

Returns:
	Succes - Angular origin value
	Failed - 0 And @error = 1

Related:
	<_GEng_Sprite_AngleOriginSet>
#ce
Func _GEng_Sprite_AngleOriginGet(ByRef $hSprite, $iType = 1) ; 1- Degres, 2- Radians
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	Switch $iType
		Case 1
			Return $hSprite[$_gSpr_AngleOriDeg]
		Case 2
			Return $hSprite[$_gSpr_AngleOriRad]
		Case Else
			Return SetError(1, 0, 0)
	EndSwitch
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sprite_AngleSpeedGet
; Description ...: Récupère la vitesse de rotation d'un Objet Sprite
; Syntax.........: _GEng_Sprite_AngleSpeedGet(ByRef $hSprite)
; Parameters ....: $hSprite = Objet Sprite
; Return values .: Succes - valeur de la vitesse de rotation (Deg/s)
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks .......:
; ;==========================================================================================
#cs
Function: _GEng_Sprite_AngleSpeedGet
	Get the rotation speed of a Sprite Object

Prototype:
	> _GEng_Sprite_AngleSpeedGet(ByRef $hSprite)

Parameters:
	$hSprite - Sprite Object

Returns:
	Succes - Rotation speed value
	Failed - 0 And @error = 1
#ce
Func _GEng_Sprite_AngleSpeedGet(ByRef $hSprite)
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	Return $hSprite[$_gSpr_AngleSpeed]
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sprite_AngleMaxSpeedGet
; Description ...: Récupère la vitesse de rotation maximale d'un Objet Sprite
; Syntax.........: _GEng_Sprite_AngleMaxSpeedGet(ByRef $hSprite)
; Parameters ....: $hSprite = Objet Sprite
; Return values .: Succes - valeur de la vitesse de rotation maximale
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks .......:
; ;==========================================================================================
#cs
Function: _GEng_Sprite_AngleMaxSpeedGet
	Get the maximum rotation speed of a Sprite Object

Prototype:
	> _GEng_Sprite_AngleMaxSpeedGet(ByRef $hSprite)

Parameters:
	$hSprite - Sprite Object

Returns:
	Succes - Max rotation speed value
	Failed - 0 And @error = 1
#ce
Func _GEng_Sprite_AngleMaxSpeedGet(ByRef $hSprite)
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	Return $hSprite[$_gSpr_AngleSpeedMax]
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sprite_AngleAccelGet
; Description ...: Récupère l'accélération de rotation d'un Objet Sprite
; Syntax.........: _GEng_Sprite_AngleAccelGet(ByRef $hSprite)
; Parameters ....: $hSprite = Objet Sprite
; Return values .: Succes - valeur de l'accélération
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks .......:
; ;==========================================================================================
#cs
Function: _GEng_Sprite_AngleAccelGet
	Get the rotation acceleration of a Sprite Object

Prototype:
	> _GEng_Sprite_AngleAccelGet(ByRef $hSprite)

Parameters:
	$hSprite - Sprite Object

Returns:
	Succes - Rotation acceleration value
	Failed - 0 And @error = 1
#ce
Func _GEng_Sprite_AngleAccelGet(ByRef $hSprite)
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	Return $hSprite[$_gSpr_AngleAccel]
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sprite_AngleInnertieGet
; Description ...: Récupère l'innertie de rotation d'un Objet Sprite
; Parameters ....: $hSprite = Objet Sprite
; Return values .: Succes - valeur de l'innertie
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks .......:
; ;==========================================================================================
#cs
Function: _GEng_Sprite_AngleInnertieGet
	Get the rotation innertia of a Sprite Object

Prototype:
	> _GEng_Sprite_AngleInnertieGet(ByRef $hSprite)

Parameters:
	$hSprite - Sprite Object

Returns:
	Succes - Rotation innertia value
	Failed - 0 And @error = 1
#ce
Func _GEng_Sprite_AngleInnertieGet(ByRef $hSprite)
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	Return $hSprite[$_gSpr_AngleInnertie]
EndFunc
