#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         Matwachich

 Script Function:


#ce ----------------------------------------------------------------------------

;File: Animation

#Region ### Functions ###
#cs
- Main Functions
	_GEng_Anim_Create()
	_GEng_Anim_FrameCount(ByRef $hAnim)
	_GEng_Anim_FrameAdd(ByRef $hAnim, ByRef $hImage, $iFramDuration, $x = Default, $y = Default, $w = Default, $h = Default)
	_GEng_Anim_FrameMod(ByRef $hAnim, $iFrameNumber, ByRef $hImage, $iFramDuration = Default, $x = Default, $y = Default, $w = Default, $h = Default)
	__GEng_Anim_IsAnim(ByRef $hAnim)
#ce
#EndRegion ###

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Anim_Create
; Description ...: Créer un objet Animation
; Syntax.........: _GEng_Anim_Create()
; Parameters ....: Aucun
; Return values .: Objet Animation ($oAnim)
; Author ........: Matwachich
; Remarks .......: 
; ;==========================================================================================
#cs
Function: _GEng_Anim_Create
	Create an Animation Object

Prototype:
	> _GEng_Anim_Create()

Parameters:
	Nothing

Returns:
	Succes - 1
	Failed - 0 And @error = 1
#ce
Func _GEng_Anim_Create()
	Local $a[1][6] ; Index Img, x, y, w, h, fram duration
	$a[0][0] = 0
	Return $a
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Anim_FrameCount
; Description ...: Retourne le nombre de frames contenues dans un objet Animation
; Syntax.........: _GEng_Anim_FrameCount(ByRef $hAnim)
; Parameters ....: ByRef $hAnim = Objet Animation
; Return values .: Succes - Nombre de frames
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks .......: 
; ;==========================================================================================
#cs
Function: _GEng_Anim_FrameCount
	Get the number of frames in an Animation Object

Prototype:
	> _GEng_Anim_FrameCount(ByRef $hAnim)

Parameters:
	$hAnim - Animation Object

Returns:
	Succes - 1
	Failed - 0 And @error = 1
#ce
Func _GEng_Anim_FrameCount(ByRef $hAnim)
	If Not __GEng_Anim_IsAnim($hAnim) Then Return SetError(1, 0, 0)
	; ---
	Return $hAnim[0][0]
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Anim_FrameAdd
; Description ...: Ajoute une frame dans l'objet animation
; Syntax.........: _GEng_Anim_FrameAdd(ByRef $hAnim, ByRef $hImage, $iFramDuration, $x = Default, $y = Default, $w = Default, $h = Default)
; Parameters ....: ByRef $hAnim = Objet Animation
;                  ByRef $hImage = Objet Image
;                  $iFramDuration = Durée de la frame (ms)
;                  - Optionels: prendre une partie de l'objet Image (idéal pour les SpriteSheets)
;                  	Doivent TOUS être spécifiés pour être pris en concidération
;                  $x, $y = coordonnées du point supérieur gauche du rectangle à prendre
;                  $w, $h = largeur et hauteur du rectangle à prendre
; Return values .: Succes - 1
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks .......: 
; ;==========================================================================================
#cs
Function: _GEng_Anim_FrameAdd
	Add a frame to an Animation Object

Prototype:
	> _GEng_Anim_FrameAdd(ByRef $hAnim, ByRef $hImage, $iFramDuration, $x = Default, $y = Default, $w = Default, $h = Default)

Parameters:
	$hAnim - Animation Object
	$hImage - Image Object
	$iFrameDuration - duration of the frame (in ms)
	
	Use the parameters below to specify the rectangle of the Image Object to assign to the frame
	
	$x, $y - Top left corner position of the rectangle
	$w, $h - Size of the rectangle

Returns:
	Succes - 1
	Failed - 0 And @error = 1
#ce
Func _GEng_Anim_FrameAdd(ByRef $hAnim, ByRef $hImage, $iFramDuration, $x = Default, $y = Default, $w = Default, $h = Default)
	If Not __GEng_Anim_IsAnim($hAnim) Then Return SetError(1, 0, 0)
	If Not __GEng_Image_IsImage($hImage) Then Return SetError(1, 0, 0)
	; ---
	Local $uB = $hAnim[0][0]
	ReDim $hAnim[$uB + 2][6]
	$hAnim[$uB + 1][0] = $hImage[0]
	; ---
	If $x <> Default And $y <> Default And $w <> Default And $h <> Default Then
		$hAnim[$uB + 1][1] = $x
		$hAnim[$uB + 1][2] = $y
		$hAnim[$uB + 1][3] = $w
		$hAnim[$uB + 1][4] = $h
	Else
		$hAnim[$uB + 1][1] = 0
		$hAnim[$uB + 1][2] = 0
		$hAnim[$uB + 1][3] = $hImage[1]
		$hAnim[$uB + 1][4] = $hImage[2]
	EndIf
	; ---
	$hAnim[$uB + 1][5] = $iFramDuration
	; ---
	$hAnim[0][0] += 1
	; ---
	Return 1
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Anim_FrameMod
; Description ...: Modifier une frame d'un Objet Animation
; Syntax.........: _GEng_Anim_FrameMod(ByRef $hAnim, $iFrameNumber, ByRef $hImage, $iFramDuration = Default, $x = Default, $y = Default, $w = Default, $h = Default)
; Parameters ....: ByRef $hAnim = Objet Animation
;                  $iFrameNumber = Numéro de la frame à modifier (base 1)
;                  ByRef $hImage = Objet Image
;                  $iFramDuration = Durée de la frame (ms)
;                  - Optionels: prendre une partie de l'objet Image (idéal pour les SpriteSheets)
;                  	Doivent TOUS être spécifiés pour être pris en concidération
;                  $x, $y = coordonnées du point supérieur gauche du rectangle à prendre
;                  $w, $h = largeur et hauteur du rectangle à prendre
; Return values .: Succes - 1
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks .......: 
; ;==========================================================================================
#cs
Function: _GEng_Anim_FrameMod
	Modify an Animation Object's frame

Prototype:
	> _GEng_Anim_FrameMod(ByRef $hAnim, $iFrameNumber, ByRef $hImage, $iFramDuration = Default, $x = Default, $y = Default, $w = Default, $h = Default)

Parameters:
	$hAnim - Animation Object
	$iFrameNumber - 1-based index of the frame to modify
	
	Other parameters - see <_GEng_Anim_FrameAdd>
	
	PS: A parameters ommited (Default) will not be modified

Returns:
	Succes - 1
	Failed - 0 And @error = 1
#ce
Func _GEng_Anim_FrameMod(ByRef $hAnim, $iFrameNumber, ByRef $hImage, $iFramDuration = Default, _
									$x = Default, $y = Default, $w = Default, $h = Default)
	If Not __GEng_Anim_IsAnim($hAnim) Then Return SetError(1, 0, 0)
	If $hImage <> Default Then
		If Not __GEng_Image_IsImage($hImage) Then Return SetError(1, 0, 0)
	EndIf
	; ---
	If $iFrameNumber > $hAnim[0][0] Then Return SetError(1, 0, 0)
	Local $i = $iFrameNumber
	; ---
	$hAnim[$i][0] = $hImage[0]
	; ---
	If $x <> Default And $y <> Default And $w <> Default And $h <> Default Then
		$hAnim[$i][1] = $x
		$hAnim[$i][2] = $y
		$hAnim[$i][3] = $w
		$hAnim[$i][4] = $h
	Else
		$hAnim[$i][1] = 0
		$hAnim[$i][2] = 0
		$hAnim[$i][3] = $hImage[1]
		$hAnim[$i][4] = $hImage[2]
	EndIf
	; ---
	If $iFramDuration <> Default Then $hAnim[$i][5] = $iFramDuration
	; ---
	Return 1
EndFunc

; ==============================================================
; ### Internals
; ==============================================================
Func __GEng_Anim_IsAnim(ByRef $hAnim)
	If UBound($hAnim, 2) <> 6 Then Return SetError(1, 0, 0)
	; ---
	Return 1
EndFunc
