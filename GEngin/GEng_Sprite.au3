#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         Matwachich

 Script Function:


#ce ----------------------------------------------------------------------------

;File: Creation

#Region ### Functions ###
#cs
- Main Functions
	_GEng_Sprite_Create($hImage = Default)
	_GEng_Sprite_ImageSet(ByRef $hSprite, ByRef $hImage, $x = Default, $y = Default, $w = Default, $h = Default)
	_GEng_Sprite_ImageSetRect(ByRef $hSprite, $x, $y, $w, $h, $InitSize = 0)
	_GEng_Sprite_Draw(ByRef $hSprite, $iCalculateMovements = 1)
	_GEng_Sprite_Delete(ByRef $hSprite)
	__GEng_Sprite_IsSprite($hSprite)
	__GEng_Sprite_ContainsImage($hSprite)
	__GEng_Sprite_InitArray(ByRef $a)
	_GDIPlus_ColorMatrixTranslate(ByRef $tCM, $nOffsetRed, $nOffsetGreen, $nOffsetBlue, $nOffsetAlpha = 0, $iOrder = 0)
	_GDIPlus_ColorMatrixCreateTranslate($nRed, $nGreen, $nBlue, $nAlpha = 0)
	_GDIPlus_ColorMatrixMultiply(ByRef $tCM1, $tCM2, $iOrder = 0)
	_GDIPlus_ImageAttributesSetColorMatrix($hImageAttributes, $iColorAdjustType = 0, $fEnable = False, $pClrMatrix = 0, $pGrayMatrix = 0, $iColorMatrixFlags = 0)
	_GDIPlus_GraphicsDrawImageRectRectIA($hGraphics, $hImage, $nSrcX, $nSrcY, $nSrcWidth, $nSrcHeight, $nDstX, $nDstY, $nDstWidth, $nDstHeight, $hImageAttributes = 0, $iUnit = 2)
	_GDIPlus_ColorMatrixCreate()
	_GDIPlus_ColorMatrixCreateScale($nRed, $nGreen, $nBlue, $nAlpha = 1)
#ce
#EndRegion ###


Global Const $__GEng_SpritesArrayUB = 40
Global Enum $GEng_Origin_Mid, $GEng_Origin_TL, $GEng_Origin_TR, $GEng_Origin_BL, $GEng_Origin_BR


Global Enum _
	$_gSpr_hBuffer, $_gSpr_iImg, $_gSpr_ImgX, $_gSpr_ImgY, $_gSpr_ImgW, $_gSpr_ImgH, _
	$_gSpr_PosX, $_gSpr_PosY, $_gSpr_Width, $_gSpr_Height, $_gSpr_OriX, $_gSpr_OriY, _
	$_gSpr_SpeedX, $_gSpr_SpeedY, $_gSpr_AccelX, $_gSpr_AccelY, $_gSpr_SpeedMax, _
	$_gSpr_Innertie, _
	$_gSpr_AngleDeg, $_gSpr_AngleRad, _
	$_gSpr_AngleSpeed, $_gSpr_AngleAccel, $_gSpr_AngleSpeedMax, $_gSpr_AngleInnertie, _
	$_gSpr_AngleOriDeg, $_gSpr_AngleOriRad, _
	$_gSpr_AnimFrame, $_gSpr_AnimDelayMulti, _ ; ###
	$_gSpr_CollX, $_gSpr_CollY, $_gSpr_CollW, $_gSpr_CollH, $_gSpr_CollType, _
	$_gSpr_MoveTimer, $_gSpr_AnimTimer, _
	$_gSpr_ColorMatrix, $_gSpr_ColorMatrixPtr, $_gSpr_hImgAttrib, $_gSpr_UseColorMatrix, _
	$_gSpr_Masse

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sprite_Create
; Description ...: Créer un Objet Sprite
; Syntax.........: _GEng_Sprite_Create($hImage = Default)
; Parameters ....: $hImage = Objet Image à assigner au sprite (Optionel)
;                  	Si Defaut, Objet Sprite vide
; Return values .: Objet Sprite
; Author ........: Matwachich
; Remarks .......:
; ;==========================================================================================
#cs
Function: _GEng_Sprite_Create
	Creates a Sprite Object

Prototype:
	> _GEng_Sprite_Create($hImage = Default)

Parameters:
	$hImage - If specified, then <_GEng_Sprite_ImageSetw> will be called, and the sprite will be assigned *hImage* Image object

Returns:
	Succes - The Sprite Object
	Failed - 0 And @error = 1
#ce
Func _GEng_Sprite_Create($hImage = Default)
	Local $hSprite[$__GEng_SpritesArrayUB]
	__GEng_Sprite_InitArray($hSprite)
	; ---
	If $hImage <> Default Then _GEng_Sprite_ImageSet($hSprite, $hImage)
	_GEng_Sprite_AnimRewind($hSprite)
	; ---
	Return $hSprite
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sprite_ImageSet
; Description ...: Assigne un objet Image à un Objet Sprite
; Syntax.........: _GEng_Sprite_ImageSet(ByRef $hSprite, ByRef $hImage, $x = Default, $y = Default, $w = Default, $h = Default)
; Parameters ....: $hSprite = Objet Sprite
;                  $hImage = Objet Image à assigner
;                  - Optionels: prendre une partie de l'objet Image (idéal pour les SpriteSheets)
;                  	Doivent TOUS être spécifiés pour être pris en concidération
;                  $x, $y = coordonnées du point supérieur gauche du rectangle à prendre
;                  $w, $h = largeur et hauteur du rectangle à prendre
; Return values .: Succes - 1
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks .......: Si il n'y avait aucune image associée au sprite lors de l'appel à cette fonction,
;                  	alors la taille du sprite est initialisé à la taille de l'image assigné
;                  	(appel à _GEng_Sprite_SizeSet)
; ;==========================================================================================
#cs
Function: _GEng_Sprite_ImageSet
	Assigne an image object, or a part of it to a sprite

Prototype:
	> _GEng_Sprite_ImageSet(ByRef $hSprite, ByRef $hImage, $x = Default, $y = Default, $w = Default, $h = Default)

Parameters:
	$hSprite - The Sprite Object
	$hImage - The image object to assigne

	Use the parameters below to specify the rectangle of the image object to assign to the sprite

	$x, $y - Top left corner position of the rectangle
	$w, $h - Size of the rectangle

Returns:
	Succes - 1
	Failed - 0 And @error = 1

Remarks:
	The rectangle here is different from the one of <_GEng_ImageLoad>:
	- Here, we take a part of an Image Object
	- In <_GEng_ImageLoad>, we take a part of an image file
#ce
Func _GEng_Sprite_ImageSet(ByRef $hSprite, ByRef $hImage, $x = Default, $y = Default, $w = Default, $h = Default) ; If Default => 0,0,ImgW,ImgH
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	If Not __GEng_Image_IsImage($hImage) Then Return SetError(1, 0, 0)
	; ---
	$hSprite[$_gSpr_iImg] = $hImage[0] ; Image Index
	; ---
	If $x <> Default And $y <> Default And $w <> Default And $h <> Default Then
		$hSprite[$_gSpr_ImgX] = $x
		$hSprite[$_gSpr_ImgY] = $y
		$hSprite[$_gSpr_ImgW] = $w
		$hSprite[$_gSpr_ImgH] = $h
	Else
		$hSprite[$_gSpr_ImgX] = 0
		$hSprite[$_gSpr_ImgY] = 0
		$hSprite[$_gSpr_ImgW] = $hImage[1]
		$hSprite[$_gSpr_ImgH] = $hImage[2]
	EndIf
	; Déjà fait dans _GEng_SpriteSetSize()
	;$hSprite[9] = $hSprite[3]
	;$hSprite[10] = $hSprite[4]
	; ---
	If $hSprite[$_gSpr_Width] = 0 And $hSprite[$_gSpr_Height] = 0 Then _ ; Si il n'y avait aucune image dans le sprite
		_GEng_Sprite_SizeSet($hSprite, -1, -1) ; on initialiser la taille (Size) aux dimensions de l'image
	; ---
	Return 1
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sprite_ImageSetRect
; Description ...: Change le rectangle sélectioné de l'objet image actuellement assigné à l'objet sprite
; Syntax.........: _GEng_Sprite_ImageSetRect(ByRef $hSprite, $x, $y, $w, $h, $InitSize = 0)
; Parameters ....: $hSprite = Objet Sprite
;                  - Doivent TOUS être spécifiés pour être pris en concidération
;                  $x, $y = coordonnées du point supérieur gauche du rectangle à prendre
;                  $w, $h = largeur et hauteur du rectangle à prendre
;                  $InitSize = Si 1, la taille du sprite est initialisé à la taille du rectangle
;                  	sélectioné de l'objet image
; Return values .: Succes - 1
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks .......:
; ;==========================================================================================
#cs
Function: _GEng_Sprite_ImageSetRect
	Specifiy the part (rectangle) of the Image Object actually assigned to the Sprite that will be drawn

Prototype:
	> _GEng_Sprite_ImageSetRect(ByRef $hSprite, $x, $y, $w, $h, $InitSize = 0)

Parameters:
	$hSprite - Sprite Object
	$x, $y, $w, $h - Rectangle
	$InitSize - If TRUE, the size of the sprite will be set to the size of the rectangle

Returns:
	Succes - 1
	Failed - 0 And @error = 1
#ce
Func _GEng_Sprite_ImageSetRect(ByRef $hSprite, $x, $y, $w, $h, $InitSize = 0)
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	$hSprite[$_gSpr_ImgX] = $x
	$hSprite[$_gSpr_ImgY] = $y
	$hSprite[$_gSpr_ImgW] = $w
	$hSprite[$_gSpr_ImgH] = $h
	; ---
	If $InitSize Then _
	_GEng_Sprite_SizeSet($hSprite, -1, -1) ; Pour initialiser la taille (Size) aux dimensions de l'image
	; ---
	Return 1
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sprite_Draw
; Description ...: Déssine un sprite à l'écran selon ses attribut position
; Syntax.........: _GEng_Sprite_Draw(ByRef $hSprite, $iCalculateMovements = 1)
; Parameters ....: $hSprite = Objet Sprite
;                  $iCalculateMovements = Si 1, alors tous les mouvements du sprite sont calculé selon ses
;                  	attribut vitesse, accélération, innertie. et Vitesse, accélération et innertie de rotation
; Return values .: Succes - 1
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks .......: Un sprite fix (arrière plan, objet de décore immobile) devrai toujour avoir $iCalculateMovements = 0
; ;==========================================================================================
#cs
Function: _GEng_Sprite_Draw
	Draws a sprite at it's current position and angle

Prototype:
	> _GEng_Sprite_Draw(ByRef $hSprite, $iCalculateMovements = 1)

Parameters:
	$hSprite - Sprite Object
	$iCalculateMovements - If TRUE, then sprite is concidered as dynamique, so speed, acceleration,
		innertia... will ba calculated befor drawing.

Returns:
	Succes - 1
	Failed - 0 And @error = 1

Remarks:
	A static sprite (such as background image, static scenery) should always have $iCalculateMovements = 0
#ce
Func _GEng_Sprite_Draw(ByRef $hSprite, $iCalculateMovements = 1)
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	If Not __GEng_Sprite_ContainsImage($hSprite) Then Return SetError(1, 0, 0)
	; ---
	;$t = TimerInit()
	If $iCalculateMovements Then _GEng_Sprite_Move($hSprite)
	;ConsoleWrite(TimerDiff($t) & @CRLF)
	; ---
	;Local $hBuffer = $hSprite[$_gSpr_hBuffer]
	;Local $imgIndex = $hSprite[$_gSpr_iImg]
	; ---
	Local $rotDeg = $hSprite[$_gSpr_AngleDeg]
	Local $rotRad = $hSprite[$_gSpr_AngleRad]
	; ---
	Local $posX = $hSprite[$_gSpr_PosX], $posY = $hSprite[$_gSpr_PosY]
	Local $oriX = $hSprite[$_gSpr_OriX], $oriY = $hSprite[$_gSpr_OriY]
	Local $sizeW = $hSprite[$_gSpr_Width], $sizeH = $hSprite[$_gSpr_Height]
	; ---
	Local $sheetX = $hSprite[$_gSpr_ImgX], $sheetY = $hSprite[$_gSpr_ImgY]
	Local $sheetW = $hSprite[$_gSpr_ImgW], $sheetH = $hSprite[$_gSpr_ImgH]
	; ---
	Local $ret
	If $rotDeg = 0 Then ; Si pas de rotation => Dessine sur le buffer principal
		If $hSprite[$_gSpr_UseColorMatrix] Then
			$ret = _GDIPlus_GraphicsDrawImageRectRectIA($__GEng_hBuffer, $__GEng_Images[$hSprite[$_gSpr_iImg]], _
						$sheetX, $sheetY, $sheetW, $sheetH, _ ; region de l'image d'origin
						$posX - $oriX, $posY - $oriY, _ ; position à l'écran
						$sizeW, $sizeH, _ ; taille à l'écran
						$hSprite[$_gSpr_hImgAttrib])
		Else
			$ret = _GDIPlus_GraphicsDrawImageRectRect($__GEng_hBuffer, $__GEng_Images[$hSprite[$_gSpr_iImg]], _
						$sheetX, $sheetY, $sheetW, $sheetH, _ ; region de l'image d'origin
						$posX - $oriX, $posY - $oriY, _ ; position à l'écran
						$sizeW, $sizeH) ; taille à l'écran
		EndIf

		If $__GEng_Debug <> 0 Then
			If BitAnd($__GEng_Debug, $GEng_Debug_Sprites) Then
				_GEng_Debug_DrawRect(0, $posX - $oriX, $posY - $oriY, $sizeW, $sizeH)
				_GEng_Debug_DrawCircle(1, $posX, $posY, 2)
				_GEng_Debug_DrawCircle(3, $posX - $oriX, $posY - $oriY, 2)
			EndIf
			If BitAnd($__GEng_Debug, $GEng_Debug_Vectors) Then
				_GEng_Debug_DrawVector(2, $hSprite[$_gSpr_PosX], $hSprite[$_gSpr_PosY], _
					$hSprite[$_gSpr_PosX] + $hSprite[$_gSpr_SpeedX], $hSprite[$_gSpr_PosY] + $hSprite[$_gSpr_SpeedY])
				_GEng_Debug_DrawVector(3, $hSprite[$_gSpr_PosX], $hSprite[$_gSpr_PosY], _
					$hSprite[$_gSpr_PosX] + $hSprite[$_gSpr_AccelX], $hSprite[$_gSpr_PosY] + $hSprite[$_gSpr_AccelY])
				If $hSprite[$_gSpr_SpeedMax] <> 0 Then _
					_GEng_Debug_DrawCircle(2, $hSprite[$_gSpr_PosX], $hSprite[$_gSpr_PosY], $hSprite[$_gSpr_SpeedMax])
			EndIf
		EndIf

	Else ; Si rotation => Calcule la rotation et position et dessine sur le buffer personnel du sprite
		Local $matrix = _GDIPlus_MatrixCreate()
		_GDIPlus_MatrixRotate($matrix, $rotDeg)
		_GDIPlus_MatrixTranslate($matrix, $posX * Cos(-$rotRad) - $posY * Sin(-$rotRad), $posX * Sin(-$rotRad) + $posY * Cos(-$rotRad))
		_GDIPlus_GraphicsSetTransform($hSprite[$_gSpr_hBuffer], $matrix)
		; ---
		If $hSprite[$_gSpr_UseColorMatrix] Then
			$ret = _GDIPlus_GraphicsDrawImageRectRectIA($hSprite[$_gSpr_hBuffer], $__GEng_Images[$hSprite[$_gSpr_iImg]], _
						$sheetX, $sheetY, $sheetW, $sheetH, _
						-1 * $oriX, -1 * $oriY, _
						$sizeW, $sizeH, _
						$hSprite[$_gSpr_hImgAttrib])
		Else
			$ret = _GDIPlus_GraphicsDrawImageRectRect($hSprite[$_gSpr_hBuffer], $__GEng_Images[$hSprite[$_gSpr_iImg]], _
						$sheetX, $sheetY, $sheetW, $sheetH, _
						-1 * $oriX, -1 * $oriY, _
						$sizeW, $sizeH)
		EndIf

		If $__GEng_Debug <> 0 Then
			If BitAnd($__GEng_Debug, $GEng_Debug_Sprites) Then
				_GEng_Debug_DrawRect(0, $posX - $oriX, $posY - $oriY, $sizeW, $sizeH)
				_GEng_Debug_DrawCircle(1, $posX, $posY, 2)
				_GEng_Debug_DrawCircle(3, $posX - $oriX, $posY - $oriY, 2)
				; ---
				_GEng_Debug_DrawVector(1, 0, 0, 30, 0, $hSprite[$_gSpr_hBuffer])
				_GEng_Debug_DrawVector(1, 0, 0, 0, 30, $hSprite[$_gSpr_hBuffer])
			EndIf
			If BitAnd($__GEng_Debug, $GEng_Debug_Vectors) Then
				_GEng_Debug_DrawVector(2, $hSprite[$_gSpr_PosX], $hSprite[$_gSpr_PosY], _
					$hSprite[$_gSpr_PosX] + $hSprite[$_gSpr_SpeedX], $hSprite[$_gSpr_PosY] + $hSprite[$_gSpr_SpeedY])
				_GEng_Debug_DrawVector(3, $hSprite[$_gSpr_PosX], $hSprite[$_gSpr_PosY], _
					$hSprite[$_gSpr_PosX] + $hSprite[$_gSpr_AccelX], $hSprite[$_gSpr_PosY] + $hSprite[$_gSpr_AccelY])
				If $hSprite[$_gSpr_SpeedMax] <> 0 Then _
					_GEng_Debug_DrawCircle(2, $hSprite[$_gSpr_PosX], $hSprite[$_gSpr_PosY], $hSprite[$_gSpr_SpeedMax])
			EndIf
		EndIf

		; ---
		_GDIPlus_MatrixDispose($matrix)
	EndIf

	; ---
	Return $ret
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sprite_Delete
; Description ...: Supprime un Objet Sprite
; Syntax.........: _GEng_Sprite_Delete(ByRef $hSprite)
; Parameters ....: $hSprite = Objet Sprite
; Return values .: 1
; Author ........: Matwachich
; Remarks .......:
; ;==========================================================================================
#cs
Function: _GEng_Sprite_Delete
	Delete a Sprite Object

Prototype:
	> _GEng_Sprite_Delete(ByRef $hSprite)

Parameters:
	$hSprite - Sprite Object

Returns:
	Succes - 1
	Failed - 0 And @error = 1
#ce
Func _GEng_Sprite_Delete(ByRef $hSprite)
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	$hSprite = 0
	; ---
	Return 1
EndFunc

; ==============================================================
; ### Internals
; ==============================================================
Func __GEng_Sprite_IsSprite($hSprite)
	If Not IsArray($hSprite) Then Return SetError(1, 0, 0)
	If UBound($hSprite) < $__GEng_SpritesArrayUB Then Return SetError(1, 0, 0)
	; ---
	Return 1
EndFunc

Func __GEng_Sprite_ContainsImage($hSprite)
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	If $hSprite[$_gSpr_iImg] = 0 Then Return SetError(1, 0, 0)
	; ---
	Return 1
EndFunc

Func __GEng_Sprite_InitArray(ByRef $a)
	For $i = 0 To $__GEng_SpritesArrayUB - 1
		$a[$i] = 0
	Next
	; ---
	$a[$_gSpr_AnimDelayMulti] = 1 ; AnimDelay Multiplier
	$a[$_gSpr_hBuffer] = __GEng_GetBuffer()
	$a[$_gSpr_hImgAttrib] = _GDIPlus_ImageAttributesCreate()
	$a[$_gSpr_ColorMatrix] = _GDIPlus_ColorMatrixCreate()
	$a[$_gSpr_ColorMatrixPtr] = DllStructGetPtr($a[$_gSpr_ColorMatrix])
	_GDIPlus_ImageAttributesSetColorMatrix($a[$_gSpr_hImgAttrib], 0, True, $a[$_gSpr_ColorMatrixPtr])
EndFunc

; ##############################################################
; thanks to the: Rotating Cube 2 with textures v0.85 Beta Build 2010-03-24 by UEZ 2010
Func _GDIPlus_ColorMatrixTranslate(ByRef $tCM, $nOffsetRed, $nOffsetGreen, $nOffsetBlue, $nOffsetAlpha = 0, $iOrder = 0)
	Local $tTranslateCM
	$tTranslateCM = _GDIPlus_ColorMatrixCreateTranslate($nOffsetRed, $nOffsetGreen, $nOffsetBlue, $nOffsetAlpha)
	_GDIPlus_ColorMatrixMultiply($tCM, $tTranslateCM, $iOrder)
EndFunc   ;==>_GDIPlus_ColorMatrixTranslate

Func _GDIPlus_ColorMatrixMultiply(ByRef $tCM1, $tCM2, $iOrder = 0)
	Local $iX, $iY, $iI, $iOffset, $nT, $tA, $tB, $tTmpCM

	If $iOrder Then
		$tA = $tCM2
		$tB = $tCM1
	Else
		$tA = $tCM1
		$tB = $tCM2
	EndIf
	$tTmpCM = DllStructCreate($tagGDIPCOLORMATRIX)
	For $iY = 0 To 4
		For $iX = 0 To 3
			$nT = 0
			For $iI = 0 To 4
				$nT += DllStructGetData($tB, "m", $iY * 5 + $iI + 1) * DllStructGetData($tA, "m", $iI * 5 + $iX + 1)
			Next
			DllStructSetData($tTmpCM, "m", $nT, $iY * 5 + $iX + 1)
		Next
	Next
	For $iY = 0 To 4
		For $iX = 0 To 3
			$iOffset = $iY * 5 + $iX + 1
			DllStructSetData($tCM1, "m", DllStructGetData($tTmpCM, "m", $iOffset), $iOffset)
		Next
	Next
EndFunc   ;==>_GDIPlus_ColorMatrixMultiply

Func _GDIPlus_GraphicsDrawImageRectRectIA($hGraphics, $hImage, $nSrcX, $nSrcY, $nSrcWidth, $nSrcHeight, $nDstX, $nDstY, $nDstWidth, $nDstHeight, $hImageAttributes = 0, $iUnit = 2)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDrawImageRectRect", "hwnd", $hGraphics, "hwnd", $hImage, "float", $nDstX, "float", _
			$nDstY, "float", $nDstWidth, "float", $nDstHeight, "float", $nSrcX, "float", $nSrcY, "float", $nSrcWidth, "float", _
			$nSrcHeight, "int", $iUnit, "hwnd", $hImageAttributes, "int", 0, "int", 0)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsDrawImageRectRectIA
