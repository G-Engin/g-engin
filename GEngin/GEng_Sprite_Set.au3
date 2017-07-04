#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         Matwachich

 Script Function:


#ce ----------------------------------------------------------------------------

;File: Set Parameters

#Region ### Functions ###
#cs
- Main Functions
	_GEng_Sprite_MasseSet(ByRef $hSprite, $iMasse)
	_GEng_Sprite_PosSet(ByRef $hSprite, $x = Default, $y = Default)
	_GEng_Sprite_SizeSet(ByRef $hSprite, $w = Default, $h = Default)
	_GEng_Sprite_OriginSet(ByRef $hSprite, $x = Default, $y = Default)
	_GEng_Sprite_OriginSetEx(ByRef $hSprite, $eOrigin)
	_GEng_Sprite_AngleOriginSet(ByRef $hSprite, $iAngle)
	
	_GEng_Sprite_SpeedSet(ByRef $hSprite, $x = Default, $y = Default, $max = Default)
	_GEng_Sprite_SpeedAdd(ByRef $hSprite, $x = 0, $y = 0)
	_GEng_Sprite_AccelSet(ByRef $hSprite, $x, $y)
	_GEng_Sprite_AccelAdd(ByRef $hSprite, $x = 0, $y = 0)
	_GEng_Sprite_InnertieSet(ByRef $hSprite, $value)
	
	_GEng_Sprite_AngleSet(ByRef $hSprite, $iAngle)
	_GEng_Sprite_AngleAdd(ByRef $hSprite, $iAngle)
	
	_GEng_Sprite_AngleSpeedSet(ByRef $hSprite, $iAngle = Default, $iMax = Default)
	_GEng_Sprite_AngleSpeedAdd(ByRef $hSprite, $iAngle)
	_GEng_Sprite_AngleAccelSet(ByRef $hSprite, $iAngle)
	_GEng_Sprite_AngleAccelAdd(ByRef $hSprite, $iAngle)
	_GEng_sprite_AngleInnertieSet(ByRef $hSprite, $iAngle)

	_GEng_Sprite_ColorMatrixTranslate(ByRef $hSprite, $fRed = 0, $fGreen = 0, $fBlue = 0, $fAlpha = 0)
	_GEng_Sprite_ColorMatrixReset(ByRef $hSprite)
#ce
#EndRegion ###

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sprite_MasseSet
; Description ...: Ajuste la masse d'un Sprite pour les calcules de collision dynamique
; Syntax.........: _GEng_Sprite_MasseSet(ByRef $hSprite, $iMasse)
; Parameters ....: $hSprite = Objet Sprite
;                  $iMasse = Valeur de la masse
; Return values .: Succes - 1
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks .......: Une masse de 0 (par d�faut lorsqu'un sprite est cr�e) signifie que le sprite
;                  	ne sera pas affect� par les collisions dynamiques
; ;==========================================================================================
#cs
Function: _GEng_Sprite_MasseSet
	Set Sprite mass (for collision calculation)

Prototype:
	> _GEng_Sprite_MasseSet(ByRef $hSprite, $iMasse)

Parameters:
	$hSprite - Sprite Object
	$iMasse - Mass value

Returns:
	Succes - 1
	Failed - 0 And @error = 1

Remarks:
	a value of 0 (default when a sprite is created) means that it will not be
	affected by dynamique collisions
#ce
Func _GEng_Sprite_MasseSet(ByRef $hSprite, $iMasse)
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	$hSprite[$_gSpr_Masse] = $iMasse
	; ---
	Return 1
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sprite_PosSet
; Description ...: Modifie la position d'un Objet Sprite
; Syntax.........: _GEng_Sprite_PosSet(ByRef $hSprite, $x = Default, $y = Default)
; Parameters ....: $hSprite = Objet Sprite
;                  $x, $y = Nouvelle position
;                  	Si une valeur est laiss� par d�faut, elle n'est pas modifi�
; Return values .: Succes - 1
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks .......: 
; ;==========================================================================================
#cs
Function: _GEng_Sprite_PosSet
	Set the position of a Sprite Object

Prototype:
	> _GEng_Sprite_PosSet(ByRef $hSprite, $x = Default, $y = Default)

Parameters:
	$hSprite - Sprite Object
	$x, $y - new position

Returns:
	Succes - 1
	Failed - 0 And @error = 1
#ce
Func _GEng_Sprite_PosSet(ByRef $hSprite, $x = Default, $y = Default)
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	; J'enregistre la position que JE donne
	If $x <> Default Then $hSprite[$_gSpr_PosX] = $x; - $hSprite[11]
	If $y <> Default Then $hSprite[$_gSpr_PosY] = $y; - $hSprite[12]
	; ---
	Return 1
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sprite_SizeSet
; Description ...: Modifie la taille d'un Objet Sprite
; Syntax.........: _GEng_Sprite_SizeSet(ByRef $hSprite, $w = Default, $h = Default)
; Parameters ....: $hSprite = Objet Sprite
;                  $w, $h = Nouvelle valeurs de taille
;                  	Une valeur laiss� par d�faut n'est pas chang�
;                  	Une valeur n�gative se vera attribu� la taille de l'image assign� au sprite
; Return values .: Succes - 1
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks .......: Apres setSize, origin est fauss�
; ;==========================================================================================
#cs
Function: _GEng_Sprite_SizeSet
	Set the size of a Sprite Object

Prototype:
	> _GEng_Sprite_SizeSet(ByRef $hSprite, $w = Default, $h = Default)

Parameters:
	$hSprite - Sprite Object
	$w, $h - new size (width, height)
	
	*If Default*, no change
	
	*If <= 0*, set to current assigned Image Object Size

Returns:
	Succes - 1
	Failed - 0 And @error = 1

Remarks:
	When changing size, origin is distorded (must update it)
#ce
Func _GEng_Sprite_SizeSet(ByRef $hSprite, $w = Default, $h = Default) ; If Default => No Change, <= 0 => Image Size
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	If $w <> Default Then
		If $w > 0 Then
			$hSprite[$_gSpr_Width] = $w
		Else
			$hSprite[$_gSpr_Width] = $hSprite[$_gSpr_ImgW]
		EndIf
	EndIf
	; ---
	If $h <> Default Then
		If $h > 0 Then
			$hSprite[$_gSpr_Height] = $h
		Else
			$hSprite[$_gSpr_Height] = $hSprite[$_gSpr_ImgH]
		EndIf
	EndIf
	; ---
	Return 1
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sprite_OriginSet
; Description ...: Modifie le point d'origine d'un Objet Sprite
; Syntax.........: _GEng_Sprite_OriginSet(ByRef $hSprite, $x = Default, $y = Default)
; Parameters ....: $hSprite = Objet Sprite
;                  $x, $y = Position du point d'origine
;                  	Une valeur laiss� par d�faut n'est pas modifi�
; Return values .: Succes - 1
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks .......: Cette fonction donne une valeur pr�cise au point d'origine
; ;==========================================================================================
#cs
Function: _GEng_Sprite_OriginSet
	Set the origin point of a Sprite Object

Prototype:
	> _GEng_Sprite_OriginSet(ByRef $hSprite, $x = Default, $y = Default)

Parameters:
	$hSprite - Sprite Object
	$x, $y - *Sprite Relative* coordinates of the origin point

Returns:
	Succes - 1
	Failed - 0 And @error = 1
#ce
Func _GEng_Sprite_OriginSet(ByRef $hSprite, $x = Default, $y = Default) ; If Default => No change
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	If $x <> Default Then _
		$hSprite[$_gSpr_OriX] = $x
	If $y <> Default Then _
		$hSprite[$_gSpr_OriY] = $y
	; ---
	Return 1
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sprite_OriginSetEx
; Description ...: Modifie le point d'origine d'un Objet Sprite
; Syntax.........: _GEng_Sprite_OriginSetEx(ByRef $hSprite, $eOrigin)
; Parameters ....: $hSprite = Objet Sprite
;                  $eOrigine = Une des Constantes suivante:
;                  	$GEng_Origin_Mid = Milieu de l'image (Middle)
;                  	$GEng_Origin_TL = Coin sup�rieur gauche de l'image (Top Left)
;                  	$GEng_Origin_TR = Coin sup�rieur droit de l'image (Top Right)
;                  	$GEng_Origin_BL = Coin inf�rieur gauche de l'image (Bottom Left)
;                  	$GEng_Origin_BR = Coin sup�rieur droit de l'image (Bottom Right)
; Return values .: Succes - 1
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks .......: 
; ;==========================================================================================
#cs
Function: _GEng_Sprite_OriginSetEx
	Set the origin point of a Sprite Object, to some specifique presets (most commons)

Prototype:
	> _GEng_Sprite_OriginSetEx(ByRef $hSprite, $eOrigin)

Parameters:
	$hSprite - Sprite Object
	$eOrigin - On of the following Enums
		- $GEng_Origin_Mid = Middle
		- $GEng_Origin_TL = Top Left
		- $GEng_Origin_TR = Top Right
		- $GEng_Origin_BL = Bottom Left
		- $GEng_Origin_BR = Bottom Right

Returns:
	Succes - 1
	Failed - 0 And @error = 1
#ce
Func _GEng_Sprite_OriginSetEx(ByRef $hSprite, $eOrigin)
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	Local $ret = 1, $err = 0
	Switch $eOrigin
		Case $GEng_Origin_Mid
			_GEng_Sprite_OriginSet($hSprite, $hSprite[$_gSpr_Width] / 2, $hSprite[$_gSpr_Height] / 2)
		Case $GEng_Origin_TL
			_GEng_Sprite_OriginSet($hSprite, 0, 0)
		Case $GEng_Origin_TR
			_GEng_Sprite_OriginSet($hSprite, $hSprite[$_gSpr_Width], 0)
		Case $GEng_Origin_BL
			_GEng_Sprite_OriginSet($hSprite, 0, $hSprite[$_gSpr_Height])
		Case $GEng_Origin_BR
			_GEng_Sprite_OriginSet($hSprite, $hSprite[$_gSpr_Width], $hSprite[$_gSpr_Height])
		Case Else
			$ret = 0
			$err = 1
	EndSwitch
	; ---
	Return SetError($err, 0, $ret)
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sprite_AngleOriginSet
; Description ...: Modifie la valeur de l'angle d'origine d'un Sprite (la direction avant de l'image, 0�)
; Syntax.........: _GEng_Sprite_AngleOriginSet(ByRef $hSprite, $iAngle)
; Parameters ....: $hSprite = Objet Sprite
;                  $iAngle = Valeur de l'angle (n'importe quelle valeur)
; Return values .: Succes - 1
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks .......: Exemple: un Sprite contenant l'image d'un avion orient� vers le haut aura un angle
;                  	d'origine de -90 ou 270
;                  L'utilit� est que un _GEng_Sprite_AngleSet sera dirig� vers l'avant de l'avion
; ;==========================================================================================
#cs
Function: _GEng_Sprite_AngleOriginSet
	Specify the angular origin of a Sprite Object

Prototype:
	> _GEng_Sprite_AngleOriginSet(ByRef $hSprite, $iAngle)

Parameters:
	$hSprite - Sprite Object
	$iAngle - Angle (in degrees)

Returns:
	Succes - 1
	Failed - 0 And @error = 1

Remarks:
	The angular origin is the direction of what will be concidered as the front of a Sprite,
	or it's 0� direction.
	
	For example: if the picture of your sprite is a space ship turned up, you must set the
	angular origin to -90� or 270�.
#ce
Func _GEng_Sprite_AngleOriginSet(ByRef $hSprite, $iAngle) ; en degres
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	$iAngle = __GEng_GeometryReduceAngle($iAngle)
	; ---
	$hSprite[$_gSpr_AngleOriDeg] = $iAngle
	$hSprite[$_gSpr_AngleOriRad] = __GEng_GeometryDeg2Rad($iAngle) ; rad
	Return 1
EndFunc

; ##############################################################

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sprite_SpeedSet
; Description ...: Modifie la vitesse et la vitesse maximale d'un Sprite
; Syntax.........: _GEng_Sprite_SpeedSet(ByRef $hSprite, $x = Default, $y = Default, $max = Default)
; Parameters ....: $hSprite = Objet Sprite
;                  $x, $y = Valeur de la vitesse sur les diff�rents axes
;                  $max = Vitesse maximale
;                  	Une valeur laiss� par d�faut ne sera pas modifi�
; Return values .: Succes - 1
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks .......: La vitesse maximale est le produit vectoriel de $x et $y
; ;==========================================================================================
#cs
Function: _GEng_Sprite_SpeedSet
	Set the speed, and the max speed of a Sprite Object

Prototype:
	> _GEng_Sprite_SpeedSet(ByRef $hSprite, $x = Default, $y = Default, $max = Default)

Parameters:
	$hSprite - Sprite Object
	$x, $y - Speed
	$max - max authorized speed
	
	An omitted parameter (Default) will not be changed

Returns:
	Succes - 1
	Failed - 0 And @error = 1

Remarks:
	$max is the vector sum
#ce
Func _GEng_Sprite_SpeedSet(ByRef $hSprite, $x = Default, $y = Default, $max = Default)
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	If $x <> Default Then $hSprite[$_gSpr_SpeedX] = $x
	If $y <> Default Then $hSprite[$_gSpr_SpeedY] = $y
	; ---
	If $max <> Default Then $hSprite[$_gSpr_SpeedMax] = $max ; somme vectorielle
	; ---
	Return 1
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sprite_SpeedAdd
; Description ...: Additione les valeur en param�tres � la vitesse actuelle d'un Sprite
; Syntax.........: _GEng_Sprite_SpeedAdd(ByRef $hSprite, $x = 0, $y = 0)
; Parameters ....: $hSprite = Objet Sprite
;                  $x, $y = Valeur � ajouter (par d�faut: 0)
; Return values .: Succes - 1
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks .......: 
; ;==========================================================================================
#cs
Function: _GEng_Sprite_SpeedAdd
	Add values to the actual speed of a Sprite Object

Prototype:
	> _GEng_Sprite_SpeedAdd(ByRef $hSprite, $x = 0, $y = 0)

Parameters:
	$hSprite - Sprite Object
	$x, $y - Values to add (negative to substract)

Returns:
	Succes - 1
	Failed - 0 And @error = 1
#ce
Func _GEng_Sprite_SpeedAdd(ByRef $hSprite, $x = 0, $y = 0)
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	$hSprite[$_gSpr_SpeedX] += $x
	$hSprite[$_gSpr_SpeedY] += $y
	; ---
	Return 1
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sprite_AccelSet
; Description ...: Modifie l'acc�l�ration d'un sprite
; Syntax.........: _GEng_Sprite_AccelSet(ByRef $hSprite, $x = Default, $y = Default)
; Parameters ....: $hSprite = Objet Sprite
;                  $x, $y = Valeur de l'acc�l�ration sur les diff�rents axes
;                  	Une valeur laiss� par d�faut ne sera pas modifi�
; Return values .: Succes - 1
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks .......: 
; ;==========================================================================================
#cs
Function: _GEng_Sprite_AccelSet
	Set the acceleration of a Sprite Object

Prototype:
	> _GEng_Sprite_AccelSet(ByRef $hSprite, $x = Default, $y = Default)

Parameters:
	$hSprite - Sprite Object
	$x, $y - Acceleration

Returns:
	Succes - 1
	Failed - 0 And @error = 1
#ce
Func _GEng_Sprite_AccelSet(ByRef $hSprite, $x = Default, $y = Default)
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	If $x <> Default Then $hSprite[$_gSpr_AccelX] = $x
	If $y <> Default Then $hSprite[$_gSpr_AccelY] = $y
	; ---
	Return 1
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sprite_AccelAdd
; Description ...: Additione les valeur en param�tres � l'acc�l�ration actuelle d'un Sprite
; Syntax.........: _GEng_Sprite_AccelAdd(ByRef $hSprite, $x = 0, $y = 0)
; Parameters ....: $hSprite = Objet Sprite
;                  $x, $y = Valeur � ajouter (par d�faut: 0)
; Return values .: Succes - 1
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks .......: 
; ;==========================================================================================
#cs
Function: _GEng_Sprite_SpeedAdd
	Add values to the actual acceleration of a Sprite Object

Prototype:
	> _GEng_Sprite_AccelAdd(ByRef $hSprite, $x = 0, $y = 0)

Parameters:
	$hSprite - Sprite Object
	$x, $y - Values to add (negative to substract)

Returns:
	Succes - 1
	Failed - 0 And @error = 1
#ce
Func _GEng_Sprite_AccelAdd(ByRef $hSprite, $x = 0, $y = 0)
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	$hSprite[$_gSpr_AccelX] += $x
	$hSprite[$_gSpr_AccelY] += $y
	; ---
	Return 1
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sprite_InnertieSet
; Description ...: Modifie l'innertie d'un Sprite
; Syntax.........: _GEng_Sprite_InnertieSet(ByRef $hSprite, $value)
; Parameters ....: $hSprite = Objet Sprite
;                  $value = Valeur de l'innertie
; Return values .: Succes - 1
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks .......: 
; ;==========================================================================================
#cs
Function: _GEng_Sprite_InnertieSet
	Set the innertia of a Sprite Object

Prototype:
	> _GEng_Sprite_InnertieSet(ByRef $hSprite, $value)

Parameters:
	$hSprite - Sprite Object
	$value - Innertia

Returns:
	Succes - 1
	Failed - 0 And @error = 1

Remarks:
	Innertia is the amount of speed lost by a sprite in one second
#ce
Func _GEng_Sprite_InnertieSet(ByRef $hSprite, $value)
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	$hSprite[$_gSpr_Innertie] = $value
	Return 1
EndFunc

; ##############################################################

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sprite_AngleSet
; Description ...: Modifie l'angle (direction) d'un Sprite
; Syntax.........: _GEng_Sprite_AngleSet(ByRef $hSprite, $iAngle)
; Parameters ....: $hSprite = Objet Sprite
;                  $iAngle = N'importe quelle valeur, elle sera convertie entre 0 et 359
; Return values .: Succes - 1
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks .......: 
; ;==========================================================================================
#cs
Function: _GEng_Sprite_AngleSet
	Set the angle of a Sprite Object

Prototype:
	> _GEng_Sprite_AngleSet(ByRef $hSprite, $iAngle)

Parameters:
	$hSprite - Sprite Object
	$iAngle - Angle (in degrees)

Returns:
	Succes - 1
	Failed - 0 And @error = 1
#ce
Func _GEng_Sprite_AngleSet(ByRef $hSprite, $iAngle) ; en degres
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	$iAngle -= $hSprite[$_gSpr_AngleOriDeg]
	$iAngle = __GEng_GeometryReduceAngle($iAngle)
	; ---
	$hSprite[$_gSpr_AngleDeg] = $iAngle ; deg
	$hSprite[$_gSpr_AngleRad] = __GEng_GeometryDeg2Rad($iAngle) ; rad
	; ---
	Return 1
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sprite_AngleAdd
; Description ...: Additione la valeur pass� en param�tre � l'angle actuel d'un Sprite
; Syntax.........: _GEng_Sprite_AngleAdd(ByRef $hSprite, $iAngle = 0)
; Parameters ....: $hSprite = Objet Sprite
;                  $iAngle = Valeur � ajouter
; Return values .: Succes - 1
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks .......: 
; ;==========================================================================================
#cs
Function: _GEng_Sprite_AngleAdd
	Add a value to the actual angle of a Sprite Object

Prototype:
	> _GEng_Sprite_AngleAdd(ByRef $hSprite, $iAngle = 0)

Parameters:
	$hSprite - Sprite Object
	$iAngle - value to add (in degrees), can be + or -

Returns:
	Succes - 1
	Failed - 0 And @error = 1
#ce
Func _GEng_Sprite_AngleAdd(ByRef $hSprite, $iAngle = 0)
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	Local $newAngle = __GEng_GeometryReduceAngle($hSprite[$_gSpr_AngleDeg] + $iAngle)
	; ---
	$hSprite[$_gSpr_AngleDeg] = $newAngle ; deg
	$hSprite[$_gSpr_AngleRad] = __GEng_GeometryDeg2Rad($newAngle) ; rad
	; ---
	Return 1
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sprite_AngleSpeedSet
; Description ...: Modifie la vitesse de rotation, et la vitesse de rotation maximale d'un Sprite
; Syntax.........: _GEng_Sprite_AngleSpeedSet(ByRef $hSprite, $iAngle = Default, $iMax = Default)
; Parameters ....: $hSprite = Objet Sprite
;                  $iAngle = Vitesse de rotation (+ => Horaire, - => Anti-horaire)
;                  $iMax = Vitesse maximale (Voir remarque)
; Return values .: Succes - 1
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks .......: La vitesse maximale est prise comme valeur absolue, et est donc valable pour les
;                  	2 directions de rotation
; ;==========================================================================================
#cs
Function: _GEng_Sprite_AngleSpeedSet
	Set the rotation (angular) speed, and the max rotation speed

Prototype:
	> _GEng_Sprite_AngleSpeedSet(ByRef $hSprite, $iAngle = Default, $iMax = Default)

Parameters:
	$hSprite - Sprite Object
	$iAngle - Rotation speed (in degrees per second)
	$iMax - Max rotation speed (0 for no limit)

Returns:
	Succes - 1
	Failed - 0 And @error = 1

Remarks:
	The max rotation speed is taken as absolute value, and will limit both 2 rotation directions
	
	For example, a max of 100 will limit the rotation speed between -100 and +100 degrees/sec
#ce
Func _GEng_Sprite_AngleSpeedSet(ByRef $hSprite, $iAngle = Default, $iMax = Default)
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	If $iAngle <> Default Then $hSprite[$_gSpr_AngleSpeed] = $iAngle
	If $iMax <> Default Then $hSprite[$_gSpr_AngleSpeedMax] = $iMax
	Return 1
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sprite_AngleSpeedAdd
; Description ...: Ajoute la valeur en param�tre � la vitesse de rotation actuelle d'un Sprite
; Syntax.........: _GEng_Sprite_AngleSpeedAdd(ByRef $hSprite, $iAngle = 0)
; Parameters ....: $hSprite = Objet Sprite
;                  $iAngle = Valeur � ajouter
; Return values .: Succes - 1
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks .......: 
; ;==========================================================================================
#cs
Function: _GEng_Sprite_AngleSpeedAdd
	Add a value to the actual rotation speed of a Sprite Object

Prototype:
	> _GEng_Sprite_AngleSpeedAdd(ByRef $hSprite, $iAngle = 0)

Parameters:
	$hSprite - Sprite Object
	$iAngle - Value to add

Returns:
	Succes - 1
	Failed - 0 And @error = 1
#ce
Func _GEng_Sprite_AngleSpeedAdd(ByRef $hSprite, $iAngle = 0)
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	$hSprite[$_gSpr_AngleSpeed] += $iAngle
	Return 1
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sprite_AngleAccelSet
; Description ...: Modifie l'acc�l�ration de rotation d'un objet Sprite
; Syntax.........: _GEng_Sprite_AngleAccelSet(ByRef $hSprite, $iAngle = Default)
; Parameters ....: $hSprite = Objet Sprite
;                  $iAngle = Acc�l�ration de rotation
;                  	Si laiss� par d�faut, ne sera pas modifi�e
; Return values .: Succes - 1
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks .......: 
; ;==========================================================================================
#cs
Function: _GEng_Sprite_AngleAccelSet
	Set the rotation (angular) acceleration of a Sprite Object

Prototype:
	> _GEng_Sprite_AngleAccelSet(ByRef $hSprite, $iAngle = Default)

Parameters:
	$hSprite - Sprite Object
	$iAngle - Rotation acceleration (+/-)

Returns:
	Succes - 1
	Failed - 0 And @error = 1
#ce
Func _GEng_Sprite_AngleAccelSet(ByRef $hSprite, $iAngle = Default)
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	If $iAngle <> Default Then $hSprite[$_gSpr_AngleAccel] = $iAngle
	Return 1
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sprite_AngleAccelAdd
; Description ...: Additione la valeur en param�tre � l'acc�l�ration de rotation actuelle d'un Sprite
; Syntax.........: _GEng_Sprite_AngleAccelAdd(ByRef $hSprite, $iAngle = 0)
; Parameters ....: $hSprite = Objet Sprite
;                  $iAngle = Valeur � ajouter
; Return values .: Succes - 1
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks .......: 
; ;==========================================================================================
#cs
Function: _GEng_Sprite_AngleAccelAdd
	Add a value to the actual angular acceleration of a Sprite Object

Prototype:
	> _GEng_Sprite_AngleAccelAdd(ByRef $hSprite, $iAngle = 0)

Parameters:
	$hSprite - Sprite Object
	$iAngle - Value to add (+/-)

Returns:
	Succes - 1
	Failed - 0 And @error = 1
#ce
Func _GEng_Sprite_AngleAccelAdd(ByRef $hSprite, $iAngle = 0)
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	$hSprite[$_gSpr_AngleAccel] += $iAngle
	Return 1
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_sprite_AngleInnertieSet
; Description ...: Modifie l'innertie de rotation d'un Sprite
; Syntax.........: _GEng_sprite_AngleInnertieSet(ByRef $hSprite, $iAngle = Default)
; Parameters ....: $hSprite = Objet Sprite
;                  $iAngle = Valeur de l'innertie de rotation
; Return values .: Succes - 1
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks .......: 
; ;==========================================================================================
#cs
Function: _GEng_sprite_AngleInnertieSet
	Set the angular innertia of a Sprite Object

Prototype:
	> _GEng_sprite_AngleInnertieSet(ByRef $hSprite, $iAngle = Default)

Parameters:
	$hSprite - Sprite Object
	$iAngle - Value of the angular innertia

Returns:
	Succes - 1
	Failed - 0 And @error = 1

Remarks:
	Angular innertia is the ammount of rotation speed lost in one second
#ce
Func _GEng_sprite_AngleInnertieSet(ByRef $hSprite, $iAngle = Default)
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	If $iAngle <> Default Then $hSprite[$_gSpr_AngleInnertie] = $iAngle
	Return 1
EndFunc

; ##############################################################

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sprite_ColorMatrixAdd
; Description ...: Modifie les composantes des couleurs de l'image d'un Objet Sprite
; Syntax.........: _GEng_Sprite_ColorMatrixTranslate(ByRef $hSprite, $fRed = 0, $fGreen = 0, $fBlue = 0, $fAlpha = 0)
; Parameters ....: $hSprite = Objet Sprite
;                  $fRed = Pourcentage � ajouter/soustraire � la composante ROUGE
;                  $fGreen = Pourcentage � ajouter/soustraire � la composante VERTE
;                  $fBlue = Pourcentage � ajouter/soustraire � la composante BLEU
;                  $fAlpha = Pourcentage � ajouter/soustraire � la composante ALPHA (Transparence)
; Return values .: Succes - 1
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks .......: Exemple: $fRed = 0.5 ajoute 50% � la composante rouge, 1.0 ajoute 100%, un nombre sup�rieur
;                  	� 1.0 ajoute aussi 100%, un nombre n�gatif soustrait � la composante en question
;                  Cette fonction double le temps n�cessaire au dessin du sprite (_GEng_Sprite_Draw)
; ;==========================================================================================
#cs
Function: _GEng_Sprite_ColorMatrixTranslate
	Change the color components of a Sprite Object

Prototype:
	> _GEng_Sprite_ColorMatrixTranslate(ByRef $hSprite, $fRed = 0, $fGreen = 0, $fBlue = 0, $fAlpha = 0)

Parameters:
	$hSprite - Sprite Object
	$fRed = Percents to add/sub for the RED component
	$fGreen = Percents to add/sub for the GREEN component
	$fBlue = Percents to add/sub for the BLUE component
	$fAlpha = Percents to add/sub for the ALPHA component (transparency)

Returns:
	Succes - 1
	Failed - 0 And @error = 1

Remarks:
	For example, $fRed = 0.5 adds 50% to the red component, 1.0 adds 100%, a number geater than 1.0 adds also 100%,
	and a negative number substract to the component
	
	This function doubles the time needed to draw a sprite (<_GEng_Sprite_Draw>), and have
	a big performance impact
#ce
Func _GEng_Sprite_ColorMatrixTranslate(ByRef $hSprite, $fRed = 0, $fGreen = 0, $fBlue = 0, $fAlpha = 0)
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	_GDIPlus_ColorMatrixTranslate($hSprite[$_gSpr_ColorMatrix], $fRed, $fGreen, $fBlue, $fAlpha)
	_GDIPlus_ImageAttributesSetColorMatrix($hSprite[$_gSpr_hImgAttrib], 0, True, $hSprite[$_gSpr_ColorMatrixPtr])
	; ---
	$hSprite[$_gSpr_UseColorMatrix] = 1 ; Active l'utilisation de la ColorMatrix
	; ---
	Return 1
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sprite_ColorMatrixSet
; Description ...: R�initialise la matrice couleur d'un objet Sprite
; Parameters ....: $hSprite = Objet Sprite
; Return values .: Succes - 1
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks .......: Cette fonction annule le ralentissement caus� par _GEng_Sprite_ColorMatrixTranslate
; ;==========================================================================================
#cs
Function: _GEng_Sprite_ColorMatrixReset
	Reset the colors of a Sprite Object

Prototype:
	> _GEng_Sprite_ColorMatrixReset(ByRef $hSprite)

Parameters:
	$hSprite - Sprite Object

Returns:
	Succes - 1
	Failed - 0 And @error = 1

Remarks:
	This function removes the performance impact of <_GEng_Sprite_ColorMatrixTranslate>
#ce
Func _GEng_Sprite_ColorMatrixReset(ByRef $hSprite)
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	$hSprite[$_gSpr_ColorMatrix] = 0
	$hSprite[$_gSpr_ColorMatrix] = _GDIPlus_ColorMatrixCreate()
	$hSprite[$_gSpr_ColorMatrixPtr] = DllStructGetPtr($hSprite[$_gSpr_ColorMatrix])
	_GDIPlus_ImageAttributesSetColorMatrix($hSprite[$_gSpr_hImgAttrib], 0, True, $hSprite[$_gSpr_ColorMatrixPtr])
	; ---
	$hSprite[$_gSpr_UseColorMatrix] = 0 ; Lib�re des ressources
	; ---
	Return 1
EndFunc
