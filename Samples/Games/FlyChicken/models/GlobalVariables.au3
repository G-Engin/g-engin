#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         RonildoSouza

 Script Function:
	

#ce ----------------------------------------------------------------------------

Local Const $sGAME_VERSION = "v1.0.0"
Global Const $sGAME_NAME = "Fly Chicken " & $sGAME_VERSION
Global $bGamePlaying = False
Global $bCollision = False

Global $scrW = 400
Global $scrH = @DesktopHeight - 80