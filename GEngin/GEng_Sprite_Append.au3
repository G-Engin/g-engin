#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         Matwachich

 Script Function:


#ce ----------------------------------------------------------------------------

;File: Appended Info

#Region ### Functions ###
#cs
- Main Functions
	_GEng_Sprite_ExtInfoAdd(ByRef $hSprite, $Info)
	_GEng_Sprite_ExtInfoSet(ByRef $hSprite, $index, $Info)
	_GEng_Sprite_ExtInfoGet(ByRef $hSprite, $index)
#ce
#EndRegion ###


; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sprite_ExtInfoAdd
; Description ...: Attache une variable à un sprite
; Syntax.........: _GEng_Sprite_ExtInfoAdd(ByRef $hSprite, $vInfo)
; Parameters ....: $hSprite = Objet Sprite
;                  $vInfo = Valeur à attaché
; Return values .: Succes - Index de la valeur attaché
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks .......: par exemple: points de vie, nom du personnage ...
; ;==========================================================================================
#cs
Function: _GEng_Sprite_ExtInfoAdd
	Append some value to a Sprite Object

Prototype:
	> _GEng_Sprite_ExtInfoAdd(ByRef $hSprite, $vInfo)

Parameters:
	$hSprite - Sprite Object
	$vInfo - Value to append (Integer, string, array...)

Returns:
	Succes - The index of the appended value
	Failed - 0 And @error = 1

Remarks:
	Usefull for health, caracter name, ammo...
#ce
Func _GEng_Sprite_ExtInfoAdd(ByRef $hSprite, $vInfo)
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	Local $uB = UBound($hSprite)
	ReDim $hSprite[$uB + 1]
	$hSprite[$uB] = $vInfo
	Return $uB + 1 - $__GEng_SpritesArrayUB
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sprite_ExtInfoSet
; Description ...: Modifie la valeur d'une variable attaché à un sprite
; Syntax.........: _GEng_Sprite_ExtInfoSet(ByRef $hSprite, $iIndex, $vInfo)
; Parameters ....: $hSprite = Objet Sprite
;                  $iIndex = Index de la valeur à modifier (retourné par _GEng_Sprite_ExtInfoAdd)
;                  $vInfo = Valeur à attaché
; Return values .: Succes - 1
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks........:
; ;==========================================================================================
#cs
Function: _GEng_Sprite_ExtInfoSet
	Modifie an appended value.

Prototype:
	> _GEng_Sprite_ExtInfoSet(ByRef $hSprite, $iIndex, $vInfo)

Parameters:
	$hSprite - Sprite Object
	$iIndex - Index of the value to modify (returned by <_GEng_Sprite_ExtInfoAdd>)
	$vInfo - New value

Returns:
	Succes - 1
	Failed - 0 And @error = 1
#ce
Func _GEng_Sprite_ExtInfoSet(ByRef $hSprite, $iIndex, $vInfo)
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	If $iIndex > UBound($hSprite) - 1 Then Return SetError(1, 0, 0)
	; ---
	$hSprite[$__GEng_SpritesArrayUB + $iIndex - 1] = $vInfo
	; ---
	Return 1
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sprite_ExtInfoGet
; Description ...: Récupère un valeur attaché à un sprite
; Syntax.........: _GEng_Sprite_ExtInfoGet(ByRef $hSprite, $iIndex)
; Parameters ....: $hSprite = Objet Sprite
;                  $iIndex = Index de la valeur à modifier (retourné par _GEng_Sprite_ExtInfoAdd)
; Return values .: Succes - la valeur attaché
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks........:
; ;==========================================================================================
#cs
Function: _GEng_Sprite_ExtInfoGet
	Read an appended value

Prototype:
	> _GEng_Sprite_ExtInfoGet(ByRef $hSprite, $iIndex)

Parameters:
	$hSprite - Sprite Object
	$iIndex - Index of the value to read (returned by <_GEng_Sprite_ExtInfoAdd>)

Returns:
	Succes - The readed value
	Failed - 0 And @error = 1
#ce
Func _GEng_Sprite_ExtInfoGet(ByRef $hSprite, $iIndex)
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	If $iIndex > UBound($hSprite) - 1 Then Return SetError(1, 0, 0)
	; ---
	Return $hSprite[$__GEng_SpritesArrayUB + $iIndex - 1]
EndFunc
