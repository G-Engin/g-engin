#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         Matwachich

 Script Function:
	Tutoriel basic pour GEngin
	- Créer une fenètre
	- Afficher une image et lui changer de position et d'angle

#ce ----------------------------------------------------------------------------

Global $scrW = 400, $scrH = 300
Global $x, $y
Opt("MouseCoordMode", 2) ; Pour récupérer la position de la souris par rapport à la fenètre
#include <Misc.au3> ; pour _IsPressed

; d'abors, on inclu GEngin.au3
#include <..\GEngin.au3>

; On démare GEngin, avec une fenètre qui aura pour titre "GEngin - Tuto 1"
; et pour dimensions 400x300 pixels
_GEng_Start("GEngin - Tuto 1", 400, 300)

; On charge les image que nous allons afficher dans des variables
; Conseil: Il est préférable de modifié la taille de l'image lors de son chargement
;  plutôt que avec les paramètres du sprite (_GEng_Sprite_SizeSet) (performances)
$img_Gimp = _GEng_ImageLoad("res\gengin.png", 256, 256)

; On créer nos objet sprites, pour l'instant un seul et on le stock dans une variable
$spr_Gimp = _GEng_Sprite_Create()

; On Assigne une image à notr sprite
; Ici, le sprite se vera assigné la taille de l'image qu'on vient de lui assigné (128x128)
_GEng_Sprite_ImageSet($spr_Gimp, $img_Gimp)
_GEng_Sprite_SizeGet($spr_Gimp, $x, $y)
ConsoleWrite("Taille du Sprite: " & $x & "x" & $y & @CRLF)

; On assigne à notre Sprite un point d'origine, c'est le centre de rotation du sprite
; et le point de l'image que l'on positionne. On le place au milieux de l'image
; On aurai pu le faire par: _GEng_Sprite_OriginSet($spr_Gimp, 64, 64)
; mais imaginez que la taille de l'image change, ou soit inconnue!
_GEng_Sprite_OriginSetEx($spr_Gimp, $GEng_Origin_Mid)

; Maintenant, on positionne le Sprite au centre de l'écran
_GEng_Sprite_PosSet($spr_Gimp, $scrW / 2, $scrH / 2)

; A ce stade, rien ne s'affiche encore, car l'écran n'est ni initialisé à une couleur, ni rafraichi
; et on a pas afficher notre sprite.
; On le fait maintenant
MsgBox(0, "GEngin", "Rien ne s'affiche!")
_GEng_ScrFlush(0xFFFFFFFF)
_GEng_Sprite_Draw($spr_Gimp)
_GEng_ScrUpdate()
MsgBox(0, "GEngin", "Sprite au centre de l'écran")

; Maintenant, on change la position du sprite, mais le changement ne sera pris en concidération que
; si on répete les 3 fonction juste au dessu!
_GEng_Sprite_PosSet($spr_Gimp, $scrW / 4, $scrH / 4)
MsgBox(0, "GEngin", "Le Sprite n'a pas changer de position!")

; l'idéal est donc de mettre tout ça dans une boucle
; On en profite pour insérer la modification de l'angle du Sprite
; par un clique Droit, qui ajoute 30° à chaque fois
MsgBox(0, "GEngin", "Clique gauche pour changer la position du Sprite" & @CRLF & _
			"Clique droit pour modifier l'angle")
Global $tmp
Do
	_GEng_ScrFlush(0xFFFFFFFF)
	; ---
	If _IsPressed('01') Then
		$tmp = MouseGetPos()
		_GEng_Sprite_PosSet($spr_Gimp, $tmp[0], $tmp[1])
	EndIf
	If _IsPressed('02') Then
		_GEng_Sprite_AngleAdd($spr_Gimp, 30)
	EndIf
	; ---
	_GEng_Sprite_Draw($spr_Gimp)
	; ---
	_GEng_ScrUpdate()
Until GuiGetMsg() = -3 ; $GUI_EVENT_CLOSE

; On ferme GEngin et on libère les ressources!
_GEng_Shutdown()

; Fin!