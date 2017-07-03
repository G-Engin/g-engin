#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         Matwachich

 Script Function:


#ce ----------------------------------------------------------------------------

;File: Sound

#Region ### Functions ###
#cs
- Main Functions
	_GEng_Sound_Init($iSampleRate = 44100, $iStereo = 1)
	_GEng_Sound_Shutdown()
	_GEng_Sound_GlobalVolume($iVolume = Default)
	_GEng_Sound_Load($sPath, $iLoop = 0)
	_GEng_Sound_Play($hSound, $iRestart = 1)
	_GEng_Sound_AttribSet($hSound, $iVolume = 1, $iPan = 0, $iPitch = 0)
	_GEng_Sound_AttribGet($hSound, ByRef $iVolume, ByRef $iPan, ByRef $iPitch, ByRef $iDefaultSampleRate)
	_GEng_Sound_SetLoop(ByRef $hSound, $iLoop)
	_GEng_Sound_IsPlaying(ByRef $hSound)
	_GEng_Sound_Pause(ByRef $hSound)
	_GEng_Sound_Stop(ByRef $hSound)
	_GEng_Sound_Free(ByRef $hSound)
	__GEng_Sound_CreateDll()
	__BASS__DeleteDllAfterExit()
#ce
#EndRegion ###


#include "Bass\bass.au3"

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sound_Init
; Description ...: Initialisation des fonctionnalit�es Audio
; Syntax.........: _GEng_Sound_Init($iSampleRate = 44100, $iStereo = 1)
; Parameters ....: $iSampleRate = Taux d'�chantillonage (Defaut 44100)
;                  $iStereo = 1 -> St�r�o, 0 -> Mono
; Return values .: Succes - 1
;                  Echec - 0 et
;                  	@error = Erreur Bass, @extended = Decription de l'erreur
; Author ........: Matwachich
; Remarks .......:
; ;==========================================================================================
#cs
Function: _GEng_Sound_Init
	Initialize the sound system

Prototype:
	> _GEng_Sound_Init($iSampleRate = 44100, $iStereo = 1)

Parameters:
	$iSampleRate - Sample rate (Default = 44100)
	$iStereo - TRUE/FALSE

Returns:
	Succes - 1
	Failed - 0 And @error = BASS Error code And @extended = BASS Error string (Description)
#ce
Func _GEng_Sound_Init($iSampleRate = 44100, $iStereo = 1)
	__GEng_Sound_CreateDll()
	_Bass_Startup()
	; ---
	Local $flag = $BASS_DEVICE_CPSPEAKERS
	If Not $iStereo Then $flag += $BASS_DEVICE_MONO
	; ---
	Local $ret = _BASS_Init($flag, -1, $iSampleRate, 0, "")
	If @error Then Return SetError(@error, _value2constant(@error), 0)
	Return $ret
	;_BASS_SetConfig($BASS_CONFIG_UPDATEPERIOD, 20)
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sound_Shutdown
; Description ...: Stop les fonctionnalit�es Audio et lib�re les ressources
; Syntax.........: _GEng_Sound_Shutdown()
; Parameters ....:
; Return values .: 1
; Author ........: Matwachich
; Remarks .......:
; ;==========================================================================================
#cs
Function: _GEng_Sound_Shutdown
	Shutdown sound system and free resources

Prototype:
	> _GEng_Sound_Shutdown()

Parameters:
	Nothing

Returns:
	Succes - 1
#ce
Func _GEng_Sound_Shutdown()
	_Bass_Stop()
	_BASS_Free()
	__BASS__DeleteDllAfterExit()
	Return 1
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sound_GlobalVolume
; Description ...: Change/r�cup�re la valeur du volume sonore global de l'application
; Syntax.........: _GEng_Sound_GlobalVolume($iVolume = Default)
; Parameters ....: $iVolume = Niveau du volume (de 0 � 1)
;                  	Si Defaut - la fonction retourne le volume actuel
; Return values .: Succes - 1 ou niveau du volume (de 0 � 1)
;                  Echec - @error = Erreur Bass, @extended = Decription de l'erreur
; Author ........: Matwachich
; Remarks .......: Optionelle car appel� automatiquement � la fin du script
; ;==========================================================================================
#cs
Function: _GEng_Sound_GlobalVolume
	Set or Get the global application sound volume

Prototype:
	> _GEng_Sound_GlobalVolume($iVolume = Default)

Parameters:
	$iVolume - Sound volume (0 to 1.0)

Returns:
	Succes - Either
	- 1 (If $iVolume <> Default)
	- Sound volum value (If $iVolume = Default)

	Failed - 0 And @error = BASS Error code And @extended = BASS Error string (Description)
#ce
Func _GEng_Sound_GlobalVolume($iVolume = Default)
	Local $ret
	If $iVolume = Default Then
		$ret = _BASS_GetVolume()
		If @error Then Return SetError(@error, _value2constant(@error), 0)
		Return $ret
	Else
		$ret = _BASS_SetVolume($iVolume)
		If @error Then Return SetError(@error, _value2constant(@error), 0)
		Return $ret
	EndIf
EndFunc

; ##############################################################

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sound_Load
; Description ...: Charge un fichier audio
; Syntax.........: _GEng_Sound_Load($sPath, $iLoop = 0)
; Parameters ....: $sPath = Chemin du fichier
;                  $iLoop = Sp�cifie si le son doit �tre jou� en boucle ou pas
;                  	Defaut = 0 (pas en boucle)
; Return values .: Succes - Objet Sound
;                  Echec - 0 et
;                  	@error = Erreur Bass, @extended = Decription de l'erreur
; Author ........: Matwachich
; Remarks .......:
; ;==========================================================================================
#cs
Function: _GEng_Sound_Load
	Loads a sound into a Sound Object

Prototype:
	> _GEng_Sound_Load($sPath, $iLoop = 0)

Parameters:
	$sPath - Path of the file to load
	$iLoop - Specify if the Sound Object should be played in loop or not (TRUE/FALSE)

Returns:
	Succes - Sound Object
	Failed - 0 And @error = BASS Error code And @extended = BASS Error string (Description)

Remarks:
	Sound files supported are: MP3, MP2, MP1, OGG, WAV, AIFF
#ce
Func _GEng_Sound_Load($sPath, $iLoop = 0)
	If Not FileExists($sPath) Then Return SetError(1, 0, 0)
	; ---
	Local $flag = $BASS_MUSIC_PRESCAN
	If $iLoop Then $flag += $BASS_SAMPLE_LOOP
	; ---
	Local $hSound = _BASS_StreamCreateFile(False, $sPath, 0, 0, $flag)
	If @error Then Return SetError(@error, _value2constant(@error), 0)
	; ---
	Return $hSound
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sound_Play
; Description ...: Joue un son pr�alablement charg�
; Syntax.........: _GEng_Sound_Play($hSound, $iRestart = 1)
; Parameters ....: $hSound = Objet Sound (retourn� par _GEng_Sound_Load)
;                  $iRestart = Sp�cifie si le son doit �tre jou� du d�but
; Return values .: Succes - 1
;                  Echec - 0 et
;                  	@error = Erreur Bass, @extended = Decription de l'erreur
; Author ........: Matwachich
; Remarks .......:
; ;==========================================================================================
#cs
Function: _GEng_Sound_Play
	Play a Sound Object

Prototype:
	> _GEng_Sound_Play($hSound, $iRestart = 1)

Parameters:
	$hSound - Sound Object
	$iRestart - Sprcify if the sound should be played from the begining (TRUE/FALSE)

Returns:
	Succes - 1
	Failed - 0 And @error = BASS Error code And @extended = BASS Error string (Description)
#ce
Func _GEng_Sound_Play($hSound, $iRestart = 1)
	Local $ret = _BASS_ChannelPlay($hSound, $iRestart)
	If @error Then Return SetError(@error, _value2constant(@error), $ret)
	; ---
	Return $ret
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sound_AttribSet
; Description ...: Ajuste les attributs d'un objet Sound
; Syntax.........: _GEng_Sound_AttribSet($hSound, $iVolume = 1, $iPan = 0, $iPitch = 0)
; Parameters ....: $hSound - Objet Sound
;                  $iVolume - Volume individule de l'objet (0 to 1.0)
;                  $iPan - La balance
;                  |-1 = Full left
;                  |+1 = Full right
;                  |0 = Center
;                  $iPitch - Pitch (0 = R�initialise � la valeur originale/Taux d'�chantillonage)
; Return values .: Succes - 1
;                  Failed - 0 And @error = BASS Error code And @extended = BASS Error string (Description)
; Author ........: Matwachich
; Remarks .......:
; ;==========================================================================================
#cs
Function: _GEng_Sound_AttribSet
	Adjust the attributes of a Sound Object

Prototype:
	> _GEng_Sound_AttribSet($hSound, $iVolume = 1, $iPan = 0, $iPitch = 0)

Parameters:
	$hSound - Sound Object
	$iVolume - Individual volum of the Sound Object (0 to 1.0)
	$iPan - The panning/balance of the Sound Object

	- -1 = Full left
	- +1 = Full right
	- 0 = Center

	$iPitch - Pitch (0 = Reset to original value/sample rate)

Returns:
	Succes - 1
	Failed - 0 And @error = BASS Error code And @extended = BASS Error string (Description)
#ce
Func _GEng_Sound_AttribSet($hSound, $iVolume = 1, $iPan = 0, $iPitch = 0)
	Local $ret
	; ---
	$ret = _BASS_ChannelSetAttribute($hSound, $BASS_ATTRIB_VOL, $iVolume)
	If @error Then Return SetError(@error, _value2constant(@error), $ret)
	$ret = _BASS_ChannelSetAttribute($hSound, $BASS_ATTRIB_PAN, $iPan)
	If @error Then Return SetError(@error, _value2constant(@error), $ret)
	; ---
	If $iPitch <> 0 Then
		$freq = _BASS_ChannelGetInfo($hSound)
		$iPitch = $iPitch * $freq[0]
	EndIf
	$ret = _BASS_ChannelSetAttribute($hSound, $BASS_ATTRIB_FREQ, $iPitch)
	If @error Then Return SetError(@error, _value2constant(@error), $ret)
	; ---
	Return 1
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sound_AttribGet
; Description ...: R�cup�re les attributs d'un objet Sound
; Syntax.........: _GEng_Sound_AttribGet($hSound, ByRef $iVolume, ByRef $iPan, ByRef $iPitch, ByRef $iDefaultSampleRate)
; Parameters ....: $hSound - Objet Sound
;                  $iVolume - Va contenir le volume individuel
;                  $iPan - Va contenir la valeur de la balance
;                  $iPitch - Va contenir la valeur du pitch
;                  $iDefaultSampleRate - Va contenir le taux d'�chantillonage original
; Return values .: Succes - 1
;                  Failed - 0 And @error = BASS Error code And @extended = BASS Error string (Description)
; Author ........: Matwachich
; Remarks .......:
; ;==========================================================================================
#cs
Function: _GEng_Sound_AttribGet
	Get the attributes of a Sound Object

Prototype:
	> _GEng_Sound_AttribGet($hSound, ByRef $iVolume, ByRef $iPan, ByRef $iPitch, ByRef $iDefaultSampleRate)

Parameters:
	$hSound - Sound Object
	$iVolume - Var that will contain the Sound Object's volume
	$iPan - Var that will contain the Sound Object's panning/balance
	$iPitch - Var that will contain the Sound Object's Pitch
	$iDefaultSampleRate - Var that will contain the Sound Object's original sample rate

Returns:
	Succes - 1
	Failed - 0 And @error = BASS Error code And @extended = BASS Error string (Description)
#ce
Func _GEng_Sound_AttribGet($hSound, ByRef $iVolume, ByRef $iPan, ByRef $iPitch, ByRef $iDefaultSampleRate)
	Local $ret, $ret2
	; ---
	$ret = _BASS_ChannelGetAttribute($hSound, $BASS_ATTRIB_VOL)
	If @error Then Return SetError(@error, _value2constant(@error), $ret)
	$iVolume = $ret
	; ---
	$ret = _BASS_ChannelGetAttribute($hSound, $BASS_ATTRIB_PAN)
	If @error Then Return SetError(@error, _value2constant(@error), $ret)
	$iPan = $ret
	; ---
	$ret = _BASS_ChannelGetAttribute($hSound, $BASS_ATTRIB_FREQ) ; actuelle
	$ret2 = _BASS_ChannelGetInfo($hSound) ; defaut
	$iPitch = $ret / $ret2[0]
	$iDefaultSampleRate = $ret2[0]
	; ---
	Return 1
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sound_SetLoop
; Description ...: Sp�cifie si l'objet Sound doit �tre jou� en boucle ou pas
; Syntax.........: _GEng_Sound_SetLoop(ByRef $hSound, $iLoop)
; Parameters ....: $hSound = Objet Sound (retourn� par _GEng_Sound_Load)
;                  $iLoop = 1 -> Boucle, 0 -> Pas de boucle
; Return values .: Succes - 1
;                  Echec - 0 et
;                  	@error = Erreur Bass, @extended = Decription de l'erreur
; Author ........: Matwachich
; Remarks .......:
; ;==========================================================================================
#cs
Function: _GEng_Sound_SetLoop
	Specify if a sound object should be played in loop

Prototype:
	> _GEng_Sound_SetLoop(ByRef $hSound, $iLoop)

Parameters:
	$hSound - Sound Object
	$iLoop - TRUE/FALSE

Returns:
	Succes - 1
	Failed - 0 And @error = BASS Error code And @extended = BASS Error string (Description)
#ce
Func _GEng_Sound_SetLoop(ByRef $hSound, $iLoop)
	Local $ret
	If $iLoop Then
		$ret = _BASS_ChannelFlags($hSound, $BASS_SAMPLE_LOOP, $BASS_SAMPLE_LOOP)
	Else
		$ret = _BASS_ChannelFlags($hSound, 0, $BASS_SAMPLE_LOOP)
	EndIf
	; ---
	If @error Then Return SetError(@error, _value2constant(@error), $ret)
	; ---
	Return 1
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sound_IsPlaying
; Description ...: Retourne le status d'un objet Sound
; Syntax.........: _GEng_Sound_IsPlaying(ByRef $hSound)
; Parameters ....: $hSound = Objet Sound (retourn� par _GEng_Sound_Load)
; Return values .: Succes - 0 => Stop
;                  		 1 => Play
;                  		 -1 => Pause
;                  		 -2 => Stalled
;                  Echec - @error = Erreur Bass, @extended = Decription de l'erreur
; Author ........: Matwachich
; Remarks .......: Voir BASS_ChannelIsActive (bass.dll)
; ;==========================================================================================
#cs
Function: _GEng_Sound_IsPlaying
	Get the status of a Sound Object

Prototype:
	> _GEng_Sound_IsPlaying(ByRef $hSound)

Parameters:
	$hSound - Sound Object

Returns:
	Succes - One of the following

	- 0 => Stop
	- 1 => Play
	- -1 => Pause
	- -2 => Stalled

	Failed - 0 And @error = BASS Error code And @extended = BASS Error string (Description)
#ce
Func _GEng_Sound_IsPlaying(ByRef $hSound)
	Local $ret = _BASS_ChannelIsActive($hSound)
	If @error Then Return SetError(@error, _value2constant(@error), 0)
	; ---
	Switch $ret
		Case $BASS_ACTIVE_STOPPED
			Return 0
		Case $BASS_ACTIVE_PLAYING
			Return 1
		Case $BASS_ACTIVE_PAUSED
			Return -1
		Case $BASS_ACTIVE_STALLED
			Return -2
		Case Else
			Return SetError(1, 0, $ret)
	EndSwitch
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sound_Pause
; Description ...: Met en pause un objet Sound
; Syntax.........: _GEng_Sound_Pause(ByRef $hSound)
; Parameters ....: $hSound = Objet Sound
; Return values .: Succes - 1
;                  Echec - 0 et
;                  	@error = Erreur Bass, @extended = Decription de l'erreur
; Author ........: Matwachich
; Remarks .......:
; ;==========================================================================================
#cs
Function: _GEng_Sound_Pause
	Pause a Sound Object

Prototype:
	> _GEng_Sound_Pause(ByRef $hSound)

Parameters:
	$hSound - Sound Object

Returns:
	Succes - 1
	Failed - 0 And @error = BASS Error code And @extended = BASS Error string (Description)
#ce
Func _GEng_Sound_Pause(ByRef $hSound)
	Local $ret = _BASS_ChannelPause($hSound)
	If @error Then Return SetError(@error, _value2constant(@error), $ret)
	Return $ret
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sound_Stop
; Description ...: Stop un objet Sound
; Syntax.........: _GEng_Sound_Stop(ByRef $hSound)
; Parameters ....: $hSound = Objet Sound
; Return values .: Succes - 1
;                  Echec - 0 et
;                  	@error = Erreur Bass, @extended = Decription de l'erreur
; Author ........: Matwachich
; Remarks .......:
; ;==========================================================================================
#cs
Function: _GEng_Sound_Stop
	Stop a Sound Object

Prototype:
	> _GEng_Sound_Stop(ByRef $hSound)

Parameters:
	$hSound - Sound Object

Returns:
	Succes - 1
	Failed - 0 And @error = BASS Error code And @extended = BASS Error string (Description)
#ce
Func _GEng_Sound_Stop(ByRef $hSound)
	Local $ret = _BASS_ChannelStop($hSound)
	If @error Then Return SetError(@error, _value2constant(@error), $ret)
	Return $ret
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sound_Free
; Description ...: Supprime et lib�re les ressources d'un objet Sound
; Syntax.........: _GEng_Sound_Free(ByRef $hSound)
; Parameters ....: $hSound = Objet Sound
; Return values .: 1
; Author ........: Matwachich
; Remarks .......:
; ;==========================================================================================
#cs
Function: _GEng_Sound_Free
	Delete and free the resources used by a Sound Object

Prototype:
	> _GEng_Sound_Free(ByRef $hSound)

Parameters:
	$hSound - Sound Object

Returns:
	Succes - 1
	Failed - 0 And @error = BASS Error code And @extended = BASS Error string (Description)
#ce
Func _GEng_Sound_Free(ByRef $hSound)
	_BASS_StreamFree($hSound)
	$hSound = 0
	Return 1
EndFunc

; ==============================================================
; ### Internals
; ==============================================================
Func __GEng_Sound_CreateDll()
	_File_bass_dll(@ScriptDir & "\bass.dll")
	FileSetAttrib(@ScriptDir & "\bass.dll", "+HS")
	OnAutoItExitRegister("_GEng_Sound_Shutdown")
EndFunc

Func __BASS__DeleteDllAfterExit()
	DllClose($_ghBassDll)
	FileDelete(@ScriptDir & "\bass.dll")
EndFunc
