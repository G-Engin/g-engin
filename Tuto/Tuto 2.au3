#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         Matwachich

 Script Function:
	Tutoriel Basique 2
	- Mouvements dynamiques

 Remarque:
	- Il faut avoir lu le Tuto 1, car ce qui a été expliqué ne le sera pas
		une 2e fois! (les absents ont toujours tort!!! :-p)
#ce ----------------------------------------------------------------------------

Global $scrW = 800, $scrH = 600

Opt("MouseCoordMode", 2) ; Pour récupérer la position de la souris par rapport à la fenètre
#include <Misc.au3> ; pour _IsPressed
#include <..\GEngin.au3>

_GEng_Start("GEngin - Tuto 2", $scrW, $scrH)
; ---
$img_Gimp = _GEng_ImageLoad("res\gengin.png", 64, 64)
; ---
$spr_Gimp = _GEng_Sprite_Create()
	_GEng_Sprite_ImageSet($spr_Gimp, $img_Gimp)
	_GEng_Sprite_OriginSetEx($spr_Gimp, $GEng_Origin_Mid)
	_GEng_Sprite_PosSet($spr_Gimp, $scrW / 2, $scrH / 2)
; ---

; le nouveau par rapport au Tuto 1 commence ici
; J'assigne la vitesse maximum de mouvement et de rotation de mon sprite
_GEng_Sprite_SpeedSet($spr_Gimp, 0, 0, 100) ; 100 pixels/s
_GEng_Sprite_AngleSpeedSet($spr_Gimp, 0, 30) ; 30 Deg/s

; On met aussi une innertie de mouvement et de rotation,
; pour que le Sprite s'arrète de bouger tout seul si il n'a pas d'accélération
; Plus le valeur est grande, plus l'arret du mouvement est rapide après qu'il
; n'y ai plus d'accélération (voir la boucle principale)
_GEng_Sprite_InnertieSet($spr_Gimp, 100)
_GEng_Sprite_AngleInnertieSet($spr_Gimp, 60)

Do
	_GEng_ScrFlush(0xFFFFFFFF)
	; ---
	Select ; Mouvement
		Case _IsPressed('26') ; Haut
			_GEng_Sprite_AccelSet($spr_Gimp, Default, -500) ; On ne touche pas à l'accélération sur l'axe X (car $x = Default)
		Case _IsPressed('28') ; Bas
			_GEng_Sprite_AccelSet($spr_Gimp, Default, 500) ; Idem
		Case _IsPressed('25') ; Gauche
			_GEng_Sprite_AccelSet($spr_Gimp, -500, Default) ; On ne touche pas à l'accélération sur l'axe Y (car $y = Default)
		Case _IsPressed('27') ; Droite
			_GEng_Sprite_AccelSet($spr_Gimp, 500, Default) ; Idem
		Case Else
			_GEng_Sprite_AccelSet($spr_Gimp, 0, 0) ; accélération nul, c'est l'innertie qui va stoper le mouvement
	EndSelect
	; ---
	Select ; Rotation	
		Case _IsPressed('11') ; Ctrl
			_GEng_Sprite_AngleAccelSet($spr_Gimp, +500)
		Case _IsPressed('10') ; Shift
			_GEng_Sprite_AngleAccelSet($spr_Gimp, -500)
		Case Else
			_GEng_Sprite_AngleAccelSet($spr_Gimp, 0) ; accélération nul, c'est l'innertie qui va stoper le mouvement
	EndSelect
	; ---
	_GEng_Sprite_Draw($spr_Gimp)
	; ---
	_GEng_ScrUpdate()
Until GuiGetMsg() = -3 ; $GUI_EVENT_CLOSE

_GEng_Shutdown()

; Fin!