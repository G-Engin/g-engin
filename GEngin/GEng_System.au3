#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         Matwachich

 Script Function:


#ce ----------------------------------------------------------------------------

; For natural Docs

;File: System

#Region ### Functions ###
#cs
- Main Functions
	_GEng_Start($sTitle, $iW, $iH, $iX = -1, $iY = -1, $iStyle = -1, $iExtStyle = -1)
	_GEng_Shutdown()
	_GEng_SetDebug($mode)
	__GEng_GetBuffer()
	__GEng_IsStarted()
#ce
#EndRegion ###

Enum Step *2 $GEng_Debug_Pens = 1, $GEng_Debug_Sprites, $GEng_Debug_Vectors, $GEng_Debug_Collisions

Global $ghGDIPDll = 'user32.dll'

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Start
; Description ...: Créer une fenètre d'affichage et lance GEngin
; Syntax.........: _GEng_Start($sTitle, $iW, $iH, $iX = -1, $iY = -1, $iStyle = -1, $iExtStyle = -1)
; Parameters ....: Idem GuiCreate()
; Return values .: Succes - 1
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks .......:
; ;==========================================================================================
#cs
Function: _GEng_Start
	Starts G-Engin, and creates a display window.

Prototype:
	> _GEng_Start($sTitle, $iW, $iH, $iX = -1, $iY = -1, $iStyle = -1, $iExtStyle = -1)

Parameters:
	sTitle - The title of the dialog box.
	iW - The width of the window.
	iH - The height of the window.
	iX - The left side of the dialog box. By default (-1), the window is centered. If defined, top must also be defined.
	iY - The top of the dialog box. Default (-1) is centered.
	iStyle - defines the style of the window. See GUI Control Styles Appendix (AutoIt3 Doc).

		Use -1 for the default style which includes a combination of *$WS_MINIMIZEBOX*, *$WS_CAPTION*, *$WS_POPUP*, *$WS_SYSMENU* styles.

		Some styles are always included: *$WS_CLIPSIBLINGS*, and *$WS_SYSMENU* if *$WS_MAXIMIZEBOX* or *$WS_SIZEBOX* is specified.

	iExtStyle - defines the extended style of the window.
		See the Extended Style Table in GuiCreate Doc. -1 is the default.

Returns:
	Succes - 1
	Failed - 0 And @error = 1
#ce
Func _GEng_Start($sTitle, $iW, $iH, $iX = -1, $iY = -1, $iStyle = -1, $iExtStyle = -1)
	If __GEng_IsStarted() Then Return SetError(1, 0, 0)
	; ---
	$__GEng_hGui = GuiCreate($sTitle, $iW, $iH, $iX, $iY, $iStyle, $iExtStyle)
	If @error Then Return SetError(1, 0, 0)
	; ---
	$__GEng_WinW = $iW
	$__GEng_WinH = $iH
	; ---
	_GDIPlus_Startup()
	; ---
	$__GEng_hGraphic = _GDIPlus_GraphicsCreateFromHWND($__GEng_hGui)
	$__GEng_hBitmap = _GDIPlus_BitmapCreateFromGraphics($__GEng_WinW, $__GEng_WinH, $__GEng_hGraphic)
	$__GEng_hBuffer = __GEng_GetBuffer()
	; ---
	_GDIPlus_GraphicsSetInterpolationMode($__GEng_hGraphic, 7) ; je l'ajoute sans vraiement voir de résultat!
	DllCall($ghGDIPDll, "uint", "GdipSetTextRenderingHint", "handle", $__GEng_hBuffer, "int", 4) ; Thanks UEZ! (1.2.2)
	; ---
	$__GEng_hDC = _WinAPI_GetDC($__GEng_hGui)
	$__GEng_hCompatibleDC = _WinAPI_CreateCompatibleDC($__GEng_hDC)
	GuiSetState(@SW_SHOW, $__GEng_hGui)
	Return SetError(0, 0, 1)
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Shutdown
; Description ...: Stop GEngin, supprime la fenètre d'affichage, et libère toutes les ressources
; Syntax.........: _GEng_Shutdown()
; Parameters ....:
; Return values .:
; Author ........: Matwachich
; Remarks .......:
; ;==========================================================================================
#cs
Function: _GEng_Shutdown
	Stops G-Engin, deletes the display window, and free all the resources.

Prototype:
	> _GEng_Shutdown()

Parameters:
	Nothing

Returns:
	Nothing
#ce
Func _GEng_Shutdown()
	__GEng_Image_DisposeAll()
	; ---
	__GEng_Debug_DiscardPens()
	; ---
	_WinAPI_ReleaseDC($__GEng_hGui, $__GEng_hDC)
	_WinAPI_ReleaseDC($__GEng_hGui, $__GEng_hCompatibleDC)
	_WinAPI_DeleteDC($__GEng_hDC)
	_WinAPI_DeleteDC($__GEng_hCompatibleDC)
	; ---
	_GDIPlus_GraphicsDispose($__GEng_hBuffer)
	_GDIPlus_BitmapDispose($__GEng_hBitmap)
	_GDIPlus_GraphicsDispose($__GEng_hGraphic)
	; ---
	_GDIPlus_Shutdown()
	GuiDelete($__GEng_hGui)
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_SetDebug
; Description ...: Active/Désactive/Récupère le status actuel du mode debug
; Syntax.........: _GEng_SetDebug($mode = Default)
; Parameters ....: $mode = 0 -> off, Defaut -> récupère la valeur du mode debug
;                  	Ou: un/plusieurs de ces flags (additionnés)
;                  - $GEng_Debug_Pens = Créer les couleurs nécessaires au déssins manuels avec les fonctions
;                  	_GEng_Debug_xxx (paramètre $iDbgPen)
;                  - $GEng_Debug_Sprites = Dessine les sprites
;                  - $GEng_Debug_Vectors = Dessine les vecteurs vitesse et accélération
;                  - $GEng_Debug_Collisions = Dessine les collisions
; Return values .:
; Author ........: Matwachich
; Remarks .......: Le mode débug est surtout utile pour 'voir' les collisions
;                  	Quand une collision a lieu, les hit-boxes des sprites en collision s'affichent en rouge
;                  Les modes $GEng_Debug_Sprites et $GEng_Debug_Collisions activent automatiquement
;                  	$GEng_Debug_Pens
;                  Cette fonction appel _GDIPlus_Startup, tout comme _GEng_Start
; ;==========================================================================================
#cs
Function: _GEng_SetDebug
	Change debug mode, or get it's current status

Prototype:
	> _GEng_SetDebug($mode = Default)

Parameters:
	mode - One of the following:

	- *Default* Get the status of debug mode
	- *0* : Deactivate debug mode

	_Combination of_
		- *$GEng_Debug_Pens* Only Creates the colors needed to manualy draw with the _GEng_Debug_xxx Functions (parameter $iDbgPen)
		- *$GEng_Debug_Sprites* Draws the sprites boxes
		- *$GEng_Debug_Vectors* Draw the vectors (Speed and Acceleration)
		- *$GEng_Debug_Collisions* Draw the collisions

Returns:
	If mode = Default - The Debug mode
	Else - 1 / 0 And @error = 1

Remarks:
	The debug mode is usefull to see the collisions: when a collision occures between two sprites, their hit boxes are displayed in red.

	If the flags $GEng_Debug_Sprites, $GEng_Debug_Vectors and $GEng_Debug_Collisions are set, the flag $GEng_Debug_Pens is automatically set.

	This function calls _GDIPlus_Startup, just life <_GEng_Start>
#ce
Func _GEng_SetDebug($mode = Default)
	If $mode = Default Then Return $__GEng_Debug
	; ---
	_GDIPlus_Startup()
	; ---
	If $mode = 0 Then $__GEng_Debug = 0;Return __GEng_Debug_DiscardPens()
	; ---
	Select
		Case BitAnd($mode, $GEng_Debug_Pens) <> 0
			__GEng_Debug_CreatePens()
			$__GEng_Debug = 0
		Case BitAnd($mode, $GEng_Debug_Sprites) <> 0 Or _
			 BitAnd($mode, $GEng_Debug_Vectors) <> 0 Or _
			 BitAnd($mode, $GEng_Debug_Collisions) <> 0
			__GEng_Debug_CreatePens()
			$__GEng_Debug = $mode

		Case Else
			$__GEng_Debug = 0
			Return SetError(1, 0, 0)
	EndSelect
	; ---
	Return SetError(0, 0, 1)
EndFunc


; ==============================================================
; ### Internals
; ==============================================================
;Func _WinAPI_CreateDIB($iWidth, $iHeight, $iBitsPerPel = 32) ;taken from WinAPIEx.au3 by Yashied
;    Local $tBIHDR, $hBitmap, $pBits
;    Local Const $BI_RGB = 0, $DIB_RGB_COLORS = 0
;    Local Const $tagBITMAPINFOHEADER = 'dword biSize;long biWidth;long biHeight;ushort biPlanes;ushort biBitCount;dword biCompression;dword biSizeImage;long biXPelsPerMeter;long biYPelsPerMeter;dword biClrUsed;dword biClrImportant'
;    $tBIHDR = DllStructCreate($tagBITMAPINFOHEADER)
;    DllStructSetData($tBIHDR, 'biSize', DllStructGetSize($tBIHDR))
;    DllStructSetData($tBIHDR, 'biWidth', $iWidth)
;    DllStructSetData($tBIHDR, 'biHeight', $iHeight)
;    DllStructSetData($tBIHDR, 'biPlanes', 1)
;    DllStructSetData($tBIHDR, 'biBitCount', $iBitsPerPel)
;    DllStructSetData($tBIHDR, 'biCompression', $BI_RGB)
;    $hBitmap = _WinAPI_CreateDIBSection(0, $tBIHDR, $DIB_RGB_COLORS, $pBits)
;    If @error Then Return SetError(1, 0, 0)
;    Return $hBitmap
;EndFunc   ;==>_WinAPI_CreateDIB
;
;Func _WinAPI_CreateDIBSection($hDC, ByRef $tBITMAPINFO, $iUsage, ByRef $pBits, $hSection = 0, $iOffset = 0) ;taken from WinAPIEx.au3 by Yashied
;    $pBits = 0
;    Local $Ret = DllCall('gdi32.dll', 'ptr', 'CreateDIBSection', 'hwnd', $hDC, 'ptr', DllStructGetPtr($tBITMAPINFO), 'uint', $iUsage, 'ptr*', 0, 'ptr', $hSection, 'dword', $iOffset)
;    If @error Or (Not $Ret[0]) Then Return SetError(1, 0, 0)
;    $pBits = $Ret[4]
;    Return $Ret[0]
;EndFunc   ;==>_WinAPI_CreateDIBSection

Func __GEng_GetBuffer()
	Local $hBuffer = _GDIPlus_ImageGetGraphicsContext($__GEng_hBitmap)
	_GDIPlus_GraphicsSetSmoothingMode($hBuffer, 7)
	Return $hBuffer
EndFunc

Func __GEng_IsStarted()
	If $__GEng_hGui = -1 Then Return 0
	Return 1
EndFunc
