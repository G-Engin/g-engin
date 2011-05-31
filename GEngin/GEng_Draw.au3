#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         Matwachich

 Script Function:


#ce ----------------------------------------------------------------------------

#Region ### Functions ###
#cs
- Main Functions
	_GEng_ScrFlush($iBkColor = 0xFFFFFFFF)
	_GEng_ScrUpdate()
	_GEng_FPS_Start()
	_GEng_FPS_End()
#ce
#EndRegion ###


; # FUNCTION # ==============================================================================================
; Name...........:	_GEng_ScrFlush
; Description....:	Permet d'�ffacer l'�cran, en lui donnant une couleur
; Parameters.....:	$iBkColor = Couleur avec la quelle remplire l'�cran (Defaut = Blanc)
; Return values..:	Succes - 1
;					Echec - 0
; Author.........:	Matwachich
; Remarks........:	Inutile et couteux en ressource si vous avez un sprite qui fait office de background
; ===========================================================================================================
Func _GEng_ScrFlush($iBkColor = 0xFFFFFFFF)
	Return _GDIPlus_GraphicsClear($__GEng_hBuffer, $iBkColor)
EndFunc

; # FUNCTION # ==============================================================================================
; Name...........:	_GEng_ScrUpdate
; Description....:	Valider les op�ration de d�ssin (copie le hBitmap dans le hGraphic)
; Parameters.....:	
; Return values..:	Succes - 1
;					Echec - 0
; Author.........:	Matwachich
; Remarks........:	Inspir� par "Sinus Scroller By UEZ"
; ===========================================================================================================
Func _GEng_ScrUpdate()
	;Return _GDIPlus_GraphicsDrawImage($__GEng_hGraphic, $__GEng_hBitmap, 0, 0)
	; --- Fait gagner env. 2ms!
	Local $gdibitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($__GEng_hBitmap)
	_WinAPI_SelectObject($__GEng_CompatibleDC, $gdibitmap)
	_WinAPI_DeleteObject($gdibitmap)
	Return _WinAPI_BitBlt($__GEng_ScreenDC, 0, 0, $__GEng_WinW, $__GEng_WinH, $__GEng_CompatibleDC, 0, 0, 0x00CC0020) ; 0x00CC0020 = $SRCCOPY
EndFunc

; # FUNCTION # ==============================================================================================
; Name...........:	_GEng_FPS_Start
; Description....:	D�mare un timer pour le calcule de FPS
; Parameters.....:	
; Return values..:	1
; Author.........:	Matwachich
; Remarks........:	A appeler au d�but de la boucle principale, avant les op�rations de d�ssin
; ===========================================================================================================
Func _GEng_FPS_Start()
	$__GEng_FrameTimer = TimerInit()
	Return 1
EndFunc

; # FUNCTION # ==============================================================================================
; Name...........:	_GEng_FPS_End
; Description....:	
; Parameters.....:	
; Return values..:	la valeur du FPS - @extended = temps de g�n�ration de la frame pass� (ms)
; Author.........:	Matwachich
; Remarks........:	A appeler � la fin des op�ration de d�ssin, c'est � dire, juste apr�s _GEng_ScrUpdate
; ===========================================================================================================
Func _GEng_FPS_End()
	Local $t = TimerDiff($__GEng_FrameTimer)
	Return SetError(0, $t, 1000 / $t)	
EndFunc