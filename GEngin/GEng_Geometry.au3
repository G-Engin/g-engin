#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         Matwachich

 Script Function:


#ce ----------------------------------------------------------------------------

;File: Geometry functions

#Region ### Functions ###
#cs
- Main Functions
	_GEng_PointToPoint_Dist($x0, $y0, $x, $y)
	_GEng_PointToPoint_Angle($x0, $y0, $x, $y)
	_GEng_PointToPoint_Vector($x0, $y0, $x, $y, $iGrandeur = Default)
	_GEng_SpriteToPoint_Dist(ByRef $hSprite, $x, $y)
	_GEng_SpriteToPoint_Angle(ByRef $hSprite, $x, $y)
	_GEng_SpriteToPoint_AngleDiff(ByRef $hSprite, $x, $y)
	_GEng_SpriteToPoint_Vector(ByRef $hSprite, $x, $y, $iGrandeur = Default)
	_GEng_SpriteToSprite_Dist(ByRef $hSprite, ByRef $hSprite2)
	_GEng_SpriteToSprite_Angle(ByRef $hSprite, ByRef $hSprite2)
	_GEng_SpriteToSprite_AngleDiff(ByRef $hSprite, ByRef $hSprite2)
	_GEng_SpriteToSprite_Vector(ByRef $hSprite, ByRef $hSprite2, $iGrandeur = Default)
	_GEng_AngleToVector($iAngle, $iGrandeur = 1)
	_GEng_VectorToAngle($difX, $difY)
	__GEng_GeometryRad2Deg($rad)
	__GEng_GeometryDeg2Rad($nDegrees)
	__GEng_GeometryReduceAngle($iAngle)
#ce
#EndRegion ###

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sprite_PointGet
; Description ...: Retourne la position d'un point dans un sprite
; Syntax.........: _GEng_Sprite_PointGet(ByRef $hSprite, $iImgX, $iImgY, ByRef $x, ByRef $y)
; Parameters ....: $hSprite = Objet Sprite
;                  $iImgX, $iImgY = Position du point recherché dans le sprite
;                  $x, $y = Vont contenir la position de ce point par rapport à l'écran
; Return values .: Succes - 1
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks .......: Cette fonction est idéal pour toujours avoir la position d'un point du sprite malgré
;                  	sa rotation
; ;==========================================================================================
#cs
Function: _GEng_Sprite_PointGet
	Returns the word's relatvie position of a sprite's relative point

Prototype:
	> _GEng_Sprite_PointGet(ByRef $hSprite, $iImgX, $iImgY, ByRef $x, ByRef $y)

Parameters:
	$hSprite - Sprite Object
	$iImgX, $iImgY - Sprite's relative position
	$x, $y - Vars that will contain the word's relative position

Returns:
	Succes - 1
	Failed - 0 And @error = 1

Remarks:
	This function takes into account the rotation of the Sprite Object
#ce
Func _GEng_Sprite_PointGet(ByRef $hSprite, $iImgX, $iImgY, ByRef $x, ByRef $y)
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; --- ; position par rapport à l'origine
	$iImgX -= $hSprite[$_gSpr_OriX]
	$iImgY -= $hSprite[$_gSpr_OriY]
	; --- ; distance entre origine et point
	Local $dist = Sqrt($iImgX^2 + $iImgY^2)
	If $dist = 0 Then ; Car _GEng_PointToPoint_Angle bug si les 2 point on la même position
		$x = $hSprite[$_gSpr_PosX]
		$y = $hSprite[$_gSpr_PosY]
		Return 1
	EndIf
	; --- ; Angle entre l'origine et le point
	Local $angle = _GEng_PointToPoint_Angle(0, 0, $iImgX, $iImgY) + $hSprite[$_gSpr_AngleDeg]
	; ---
	Local $vect = _GEng_AngleToVector($angle, $dist)
	$x = $vect[0] + $hSprite[$_gSpr_PosX]
	$y = $vect[1] + $hSprite[$_gSpr_PosY]
	; ---
	Return 1
EndFunc

;NameSpace: Point to Point

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_PointToPoint_Dist
; Description ...: Calcule la distance (pixels) entre 2 points
; Syntax.........: _GEng_PointToPoint_Dist($x0, $y0, $x, $y)
; Parameters ....: $x0, $y0 = Coordonnées du premier point
;                  $x, $y = Coordonnées du second point
; Return values .: Distance (pixels)
; Author ........: Matwachich
; Remarks .......: 
; ;==========================================================================================
#cs
Function: _GEng_PointToPoint_Dist
	Returns the distance between 2 points

Prototype:
	> _GEng_PointToPoint_Dist($x0, $y0, $x, $y)

Parameters:
	$x0, $y0 - First point
	$x, $y - Second point

Returns:
	Succes - Distance value
	Failed - 0 And @error = 1
#ce
Func _GEng_PointToPoint_Dist($x0, $y0, $x, $y)
	$x = $x - $x0
	$y = $y - $y0
	; ---
	$tmp = ($x * $x) + ($y * $y)
	; ---
	Return Sqrt($tmp)
EndFunc

; Retourne l'angle "brute", par rapport au point d'origine de hSprite (Utile pour SetAngle)
; #FUNCTION# ;===============================================================================
; Name...........: _GEng_PointToPoint_Angle
; Description ...: Retourne l'angle (degrés) entre le point premier point, et le second
; Syntax.........: _GEng_PointToPoint_Angle($x0, $y0, $x, $y)
; Parameters ....: $x0, $y0 = Coordonnées du premier point
;                  $x, $y = Coordonnées du second point
; Return values .: L'angle en degrés
; Author ........: Matwachich
; Remarks .......: 
; ;==========================================================================================
#cs
Function: _GEng_PointToPoint_Angle
	Returns the angle between 2 points

Prototype:
	> _GEng_PointToPoint_Angle($x0, $y0, $x, $y)

Parameters:
	$x0, $y0 - First point
	$x, $y - Second point

Returns:
	Succes - Angle value
	Failed - 0 And @error = 1
#ce
Func _GEng_PointToPoint_Angle($x0, $y0, $x, $y)
	If $x0 = $x And $y0 = $y Then Return 0
	; ---
	Local $difX = $x - $x0
	Local $difY = $y - $y0
	$tmp = Abs(ATan($difY / $difX))
	; ---
	If $difX < 0 Then $tmp = $__GEng_PI - $tmp
	If $difY < 0 Then $tmp = $__GEng_PI + ($__GEng_PI - $tmp)
	; ---
	Return __GEng_GeometryRad2Deg($tmp)
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_PointToPoint_Vector
; Description ...: Retourne un vecteur (de grandeur variable) orienté du premier point, vers le second
; Syntax.........: _GEng_PointToPoint_Vector($x0, $y0, $x, $y, $iGrandeur = Default)
; Parameters ....: $x0, $y0 = Coordonnées du premier point
;                  $x, $y = Coordonnées du second point
;                  $iGrandeur = Grandeur du vecteur
;                  	Si Defaut - La grandeur sera égale à la distance entre les 2 points
; Return values .: Array représentant le vecteur
;                  	[0] = x
;                  	[1] = y
; Author ........: Matwachich
; Remarks .......: 
; ;==========================================================================================
#cs
Function: _GEng_PointToPoint_Vector
	Returns a vector oriented from the first point to the second

Prototype:
	> _GEng_PointToPoint_Vector($x0, $y0, $x, $y, $iGrandeur = Default)

Parameters:
	$x0, $y0 - First point
	$x, $y - Second point
	$iGrandeur - Lenght of the vector (If Default, then the distance between
		the 2 points is taken as lenght)

Returns:
	Succes - Array representing a vector ([0] = x, [1] = y)
	Failed - 0 And @error = 1
#ce
Func _GEng_PointToPoint_Vector($x0, $y0, $x, $y, $iGrandeur = Default)
	Local $angle = _GEng_PointToPoint_Angle($x0, $y0, $x, $y)
	; ---
	If $iGrandeur = Default Then $iGrandeur = _GEng_PointToPoint_Dist($x0, $y0, $x, $y)
	; ---
	Return _GEng_AngleToVector($angle, $iGrandeur)
EndFunc


; ##############################################################

;NameSpace: Sprite to Point

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_SpriteToPoint_Dist
; Description ...: Calcule la distance (pixels) entre un sprite et un point
; Syntax.........: _GEng_SpriteToPoint_Dist(ByRef $hSprite, $x, $y)
; Parameters ....: $hSprite = Objet sprite
;                  $x, $y = Coordonnées du point
; Return values .: Distance (pixels)
; Author ........: Matwachich
; Remarks .......: 
; ;==========================================================================================
#cs
Function: _GEng_SpriteToPoint_Dist
	Returns the distance between a Sprite Object and a point

Prototype:
	> _GEng_SpriteToPoint_Dist(ByRef $hSprite, $x, $y)

Parameters:
	$hSprite - Sprite Object
	$x, $y - Point

Returns:
	Succes - Distance value
	Failed - 0 And @error = 1
#ce
Func _GEng_SpriteToPoint_Dist(ByRef $hSprite, $x, $y)
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	Local $x0, $y0
	_GEng_Sprite_PosGet($hSprite, $x0, $y0)
	; ---
	$x = $x - $x0
	$y = $y - $y0
	; ---
	$tmp = ($x * $x) + ($y * $y)
	; ---
	Return Sqrt($tmp)
EndFunc

; Retourne l'angle "brute", par rapport au point d'origine de hSprite (Utile pour SetAngle)
; #FUNCTION# ;===============================================================================
; Name...........: _GEng_SpriteToPoint_Angle
; Description ...: Retourne l'angle (degrés) entre un sprite et un point
; Syntax.........: _GEng_SpriteToPoint_Angle(ByRef $hSprite, $x, $y)
; Parameters ....: $hSprite = Objet sprite
;                  $x, $y = Coordonnées du point
; Return values .: Angle (degrés)
; Author ........: Matwachich
; Remarks .......: L'angle retourné est l'angle par rapport au point d'origine de hSprite, et de l'angle 0
;                  	Il sera compris entre 0 et 359
; ;==========================================================================================
#cs
Function: _GEng_SpriteToPoint_Angle
	Returns the angle between a Sprite Object and a point

Prototype:
	> _GEng_SpriteToPoint_Angle(ByRef $hSprite, $x, $y)

Parameters:
	$hSprite - Sprite Object
	$x, $y - Point

Returns:
	Succes - Angle value (0 - 359)
	Failed - 0 And @error = 1

Remarks:
	The angle returned is the absolute (word's relative) angle, and will be always 
	in the range 0-359
#ce
Func _GEng_SpriteToPoint_Angle(ByRef $hSprite, $x, $y)
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	Local $x0, $y0
	_GEng_Sprite_PosGet($hSprite, $x0, $y0)
	; ---
	Local $difX = $x - $x0
	Local $difY = $y - $y0
	$tmp = Abs(ATan($difY / $difX))
	; ---
	If $difX < 0 Then $tmp = $__GEng_PI - $tmp
	If $difY < 0 Then $tmp = $__GEng_PI + ($__GEng_PI - $tmp)
	; ---
	Return __GEng_GeometryRad2Deg($tmp)
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_SpriteToPoint_AngleDiff
; Description ...: Retourne l'angle relatif à l'angle du sprite, entre ce dernier et un point
; Syntax.........: _GEng_SpriteToPoint_AngleDiff(ByRef $hSprite, $x, $y)
; Parameters ....: $hSprite = Objet sprite
;                  $x, $y = Coordonnées du point
; Return values .: Angle (degrés)
; Author ........: Matwachich
; Remarks .......: L'angle retourné est l'angle par rapport au point d'origine de hSprite, et de l'angle de hSprite
;                  	Il sera compris entre -179 - 0 - +180 
;                  	(selon la position du point par rapport à *l'angle* du sprite)
;                  En d'autres termes:
;                  Retourne la différence d'angle entre hSprite et la position donné (Utile pour SetAngleSpeed)
;   					(De 0 à 180 => Sens horaire, De 0 à -179 => Send Anti-Horaire)
; ;==========================================================================================
#cs
Function: _GEng_SpriteToPoint_AngleDiff
	Returns the angle between a Sprite Object and a point, relativelly to the
	actual angle of the Sprite Object

Prototype:
	> _GEng_SpriteToPoint_AngleDiff(ByRef $hSprite, $x, $y)

Parameters:
	$hSprite - Sprite Object
	$x, $y - Point

Returns:
	Succes - Angle value (-180 - 0 - 180)
	Failed - 0 And @error = 1

Remarks:
	The angle returned is relative to the angle of the Sprite Object, it will be in the range
	- -180 - 0 if the point is at the left of the Sprite (counter-clockwise)
	- 0 - 180 if the point is at the right of the Sprite (clockwise)
	
#ce
Func _GEng_SpriteToPoint_AngleDiff(ByRef $hSprite, $x, $y) ; 0.2 ms 
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	Local $angleDiff = _GEng_SpriteToPoint_Angle($hSprite, $x, $y)
	Local $angleCurr = _GEng_Sprite_AngleGet($hSprite)
	If $angleCurr = 0 Then $angleCurr = 360
	; ---
	Local $angleInverse = __GEng_GeometryReduceAngle($angleCurr + 180)
	; ---
	Local $result = 0
	If $angleCurr >= 180 Then
		If $angleDiff < $angleCurr And $angleDiff > $angleInverse Then ; -
			$result = -1 * Abs($angleCurr - $angleDiff)
		Else ; +
			If $angleDiff > $angleCurr Then
				$result = Abs($angleDiff - $angleCurr)
			Else
				$result = Abs(Abs(360 - $angleCurr) + $angleDiff)
			EndIf
		EndIf
	Else
		If $angleDiff > $angleCurr And $angleDiff < $angleInverse Then ; +
			$result = Abs($angleDiff - $angleCurr)
		Else ; -
			If $angleDiff < $angleCurr Then
				$result = -1 * Abs($angleCurr - $angleDiff)
			ElseIf $angleDiff > $angleInverse And $angleDiff < 360 Then
				$result = -1 * Abs($angleCurr + Abs(360 - $angleDiff))
			EndIf
		EndIf
	EndIf
	; ---
	; NE JAMAIS appliquer ici _ReduceAngle(), car elle retourne toujour un angle (+)
	If $result = 360 Then $result = 0 ; cas spécial ou l'algoritme se trompe en retournant 360
	; ---
	Return $result
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_SpriteToPoint_Vector
; Description ...: Retourne un vecteur (de grandeur variable) orienté du sprite, vers le point
; Syntax.........: _GEng_SpriteToPoint_Vector(ByRef $hSprite, $x, $y, $iGrandeur = Default)
; Parameters ....: $hSprite = Objet sprite
;                  $x, $y = Coordonnées du point
; Return values .: Array représentant le vecteur
;                  	[0] = x
;                  	[1] = y
; Author ........: Matwachich
; Remarks .......: 
; ;==========================================================================================
#cs
Function: _GEng_SpriteToPoint_Vector
	Returns a vector oriented from a Sprite Object to a point

Prototype:
	> _GEng_SpriteToPoint_Vector(ByRef $hSprite, $x, $y, $iGrandeur = Default)

Parameters:
	$hSprite - Sprite Object
	$x, $y - Point
	$iGrandeur - Lenght of the vector (If Default, then the distance between
		the Sprite Object and the points is taken as lenght)

Returns:
	Succes - Array representing a vector ([0] = x, [1] = y)
	Failed - 0 And @error = 1
#ce
Func _GEng_SpriteToPoint_Vector(ByRef $hSprite, $x, $y, $iGrandeur = Default)
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	Local $angle = _GEng_SpriteToPoint_Angle($hSprite, $x, $y)
	; ---
	If $iGrandeur = Default Then $iGrandeur = _GEng_SpriteToPoint_Dist($hSprite, $x, $y)
	; ---
	Return _GEng_AngleToVector($angle, $iGrandeur)
EndFunc

; ##############################################################

;NameSpace: Sprite to Sprite

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_SpriteToSprite_Dist
; Description ...: Calcule la distance (pixels) entre 2 objets Sprite
; Syntax.........: _GEng_SpriteToSprite_Dist(ByRef $hSprite, ByRef $hSprite2)
; Parameters ....: $hSprite1 & $hSprite2 = Objets sprite
; Return values .: Distance (Pixels)
; Author ........: Matwachich
; Remarks .......: 
; ;==========================================================================================
#cs
Function: _GEng_SpriteToSprite_Dist
	Returns the distance between 2 Sprite Objects

Prototype:
	> _GEng_SpriteToSprite_Dist(ByRef $hSprite, ByRef $hSprite2)

Parameters:
	$hSprite & $hSprite2 - Sprite Objects

Returns:
	Succes - Distance value
	Failed - 0 And @error = 1
#ce
Func _GEng_SpriteToSprite_Dist(ByRef $hSprite, ByRef $hSprite2)
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	If Not __GEng_Sprite_IsSprite($hSprite2) Then Return SetError(1, 0, 0)
	; ---
	Local $x2, $y2
	_GEng_Sprite_PosGet($hSprite2, $x2, $y2)
	Return _GEng_SpriteToPoint_Dist($hSprite, $x2, $y2)
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_SpriteToSprite_Angle
; Description ...: Retourne l'angle (degrés) entre 2 objets Sprite
; Syntax.........: _GEng_SpriteToSprite_Angle(ByRef $hSprite, ByRef $hSprite2)
; Parameters ....: $hSprite1 & $hSprite2 = Objets sprite
; Return values .: Angle (Degrés)
; Author ........: Matwachich
; Remarks .......: 
; ;==========================================================================================
#cs
Function: _GEng_SpriteToSprite_Angle
	Returns the angle from the first Sprite Object to the second

Prototype:
	> _GEng_SpriteToSprite_Angle(ByRef $hSprite, ByRef $hSprite2)

Parameters:
	$hSprite & $hSprite2 - First and second Sprite Objects

Returns:
	Succes - Angle value (in degrees)
	Failed - 0 And @error = 1
#ce
Func _GEng_SpriteToSprite_Angle(ByRef $hSprite, ByRef $hSprite2)
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	If Not __GEng_Sprite_IsSprite($hSprite2) Then Return SetError(1, 0, 0)
	; ---
	Local $x2, $y2
	_GEng_Sprite_PosGet($hSprite2, $x2, $y2)
	Return _GEng_SpriteToPoint_Angle($hSprite, $x2, $y2)
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_SpriteToSprite_AngleDiff
; Description ...: Retourne l'angle relatif à l'angle du premier sprite, entre ce dernier et le second sprite
; Syntax.........: _GEng_SpriteToSprite_AngleDiff(ByRef $hSprite, ByRef $hSprite2)
; Parameters ....: $hSprite1 & $hSprite2 = Objets sprite
; Return values .: Angle (Degrés)
; Author ........: Matwachich
; Remarks .......: Idem _GEng_SpriteToPoint_AngleDiff
; ;==========================================================================================
#cs
Function: _GEng_SpriteToSprite_AngleDiff
	Returns the angle between a Sprite Object and another, relativelly to the
	actual angle of the first Sprite Object

Prototype:
	> _GEng_SpriteToSprite_AngleDiff(ByRef $hSprite, ByRef $hSprite2)

Parameters:
	$hSprite & $hSprite2 - Sprite Object

Returns:
	Succes - Angle value (-180 - 0 - 180)
	Failed - 0 And @error = 1

Remarks:
	The angle returned is relative to the angle of the Sprite Object, it will be in the range
	- -180 - 0 if the point is at the left of the Sprite (counter-clockwise)
	- 0 - 180 if the point is at the right of the Sprite (clockwise)
	
#ce
Func _GEng_SpriteToSprite_AngleDiff(ByRef $hSprite, ByRef $hSprite2)
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	If Not __GEng_Sprite_IsSprite($hSprite2) Then Return SetError(1, 0, 0)
	; ---
	Local $x2, $y2
	_GEng_Sprite_PosGet($hSprite2, $x2, $y2)
	Return _GEng_SpriteToPoint_AngleDiff($hSprite, $x2, $y2)
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_SpriteToSprite_Vector
; Description ...: Retourne un vecteur (de grandeur variable) orienté du premier sprite, vers le second
; Syntax.........: _GEng_SpriteToSprite_Vector(ByRef $hSprite, ByRef $hSprite2, $iGrandeur = Default)
; Parameters ....: $hSprite1 & $hSprite2 = Objets sprite
; Return values .: Array représentant le vecteur
;                  	[0] = x
;                  	[1] = y
; Author ........: Matwachich
; Remarks .......: 
; ;==========================================================================================
#cs
Function: _GEng_SpriteToSprite_Vector
	Returns a vector oriented from a Sprite Object to another

Prototype:
	> _GEng_SpriteToSprite_Vector(ByRef $hSprite, ByRef $hSprite2, $iGrandeur = Default)

Parameters:
	$hSprite & $hSprite2 - Sprite Objects
	$iGrandeur - Lenght of the vector (If Default, then the distance between
		the Sprite Objects is taken as lenght)

Returns:
	Succes - Array representing a vector ([0] = x, [1] = y)
	Failed - 0 And @error = 1
#ce
Func _GEng_SpriteToSprite_Vector(ByRef $hSprite, ByRef $hSprite2, $iGrandeur = Default)
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	If Not __GEng_Sprite_IsSprite($hSprite2) Then Return SetError(1, 0, 0)
	; ---
	Local $x2, $y2
	_GEng_Sprite_PosGet($hSprite2, $x2, $y2)
	Return _GEng_SpriteToPoint_Vector($hSprite, $x2, $y2, $iGrandeur)
EndFunc

; ##############################################################

;NameSpace: Misc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_AngleToVector
; Description ...: Retourne un vecteur, à partire d'un angle et d'une grandeur
; Syntax.........: _GEng_AngleToVector($iAngle, $iGrandeur = 1)
; Parameters ....: $iAngle = Angle du vecteur (Degrés)
;                  $iGrandeur = Grandeur du vecteur (Pixels)
; Return values .: Array représentant le vecteur
;                  	[0] = x
;                  	[1] = y
; Author ........: Matwachich
; Remarks .......: 
; ;==========================================================================================
#cs
Function: _GEng_AngleToVector
	Returns a vector from an Angle and a Lenght

Prototype:
	> _GEng_AngleToVector($iAngle, $iGrandeur = 1)

Parameters:
	$iAngle - Angle value (in degrees)
	$iGrandeur - Lenght of the vector

Returns:
	Succes - Array representing a vector ([0] = x, [1] = y)
	Failed - 0 And @error = 1
#ce
Func _GEng_AngleToVector($iAngle, $iGrandeur = 1) ; OK
	$iAngle = __GEng_GeometryDeg2Rad(__GEng_GeometryReduceAngle($iAngle))
	; ---
	Local $ret[2] = [ _
		Cos($iAngle) * $iGrandeur, _
		Sin($iAngle) * $iGrandeur _
	]
	Return $ret
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_VectorToAngle
; Description ...: Retourne l'angle d'un vecteur (similaire à _GEng_SpriteToPoint_Angle)
; Syntax.........: _GEng_VectorToAngle($difX, $difY)
; Parameters ....: $difX, $difY = 
; Return values .: Angle (degrés)
; Author ........: Matwachich
; Remarks .......: Fonction pas très utile vu l'existance de _GEng_PointToPoint_Angle & _GEng_SpriteToPoint_Angle
; ;==========================================================================================
#cs
Function: _GEng_VectorToAngle
	Returns an Angle from a Vector

Prototype:
	> _GEng_VectorToAngle($difX, $difY)

Parameters:
	$difX & $difY - Components of the vector

Returns:
	Succes - Angle value (in degrees)
	Failed - 0 And @error = 1
#ce
Func _GEng_VectorToAngle($difX, $difY) ; OK
	If $difX = 0 And $difY = 0 Then Return 0
	; ---
	Local $tmp = Abs(ATan($difY / $difX))
	; ---
	If $difX < 0 Then $tmp = $__GEng_PI - $tmp
	If $difY < 0 Then $tmp = $__GEng_PI + ($__GEng_PI - $tmp)
	; ---
	Return __GEng_GeometryRad2Deg($tmp)
EndFunc


; ==============================================================
; ### Internals
; ==============================================================

Func __GEng_GeometryRad2Deg($rad) ; OK
	Local $ret = $rad / ($__GEng_PI / 180)
	Return __GEng_GeometryReduceAngle($ret)
EndFunc

Func __GEng_GeometryDeg2Rad($nDegrees) ; OK
	If $nDegrees >= 360 Then $nDegrees = __GEng_GeometryReduceAngle($nDegrees)
	Return $nDegrees / 57.2957795130823
EndFunc

Func __GEng_GeometryReduceAngle($iAngle) ; OK
	$iAngle = Round($iAngle)
	If $iAngle < 0 Then
		$iAngle = 360 - (Abs($iAngle) - 360)
	EndIf
	While $iAngle >= 360
		$iAngle -= 360
	WEnd
	If $iAngle = 360 Then $iAngle = 0
	Return $iAngle
EndFunc
