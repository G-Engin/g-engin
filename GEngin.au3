#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         Matwachich

 Script Function:
	G-Engin:
		G-Engin (GEng) est un UDF qui permet de gérer un affichage 2D
		avec AutoIt simplement.
		Il est basé sur GDI+.
					
	Remarques:
	- L'unité de distance est le pixel => vitesse = pixels/s, accélération = pixels/s²
	- L'unité d'angle est le degré => vitesse de rotation = Deg/s, accélération de rotation = Deg/s²
	- Le point 0, 0 est situé au coin supérieur gauche de l'écran
	- En ce qui concerne les angles:
		+ 0 correspond à la direction droite
		+ un angle (+) signifie 'sens horaire', et inversement.
		+ l'angle d'un sprite sera toujours stocké sous la forme d'une valeur entre 0 et 359
			jamais un _GEng_Sprite_AngleGet ne retournera un nombre supérieur à 359 ou inférieur à 0
			Par contre, vous pouvez spécifier n'IMPORTE quel valeur pour un angle et elle sera toujours
			réduite à la valeur correspondante entre 0 et 359
		+ Concernant la vitesse et accélération de rotation: une valeur (+) signifie 'sens horaire'
			et inversement
	- L'innertie: est définie dans cet UDF comme 'une accélération qui fait tendre la vitesse vers 0'
		vous pouvez spécifier n'importe quelle valeur qu'elle soit + ou -, elle sera prise comme valeur
		absolue
	- Un objet Sprite tourne autour de sont point d'origine, et est positionné pas rapport à ce point
	
	To do:
	- Effets sonors (bass_fx.dll)
	- Permêtre la transmission de forces lors des collisions!
	- Meilleur gestion des erreurs

#ce ----------------------------------------------------------------------------

#include <GDIPlus.au3>
#include <Array.au3>
#include <WinApi.au3>
#include "GEngin\Bass\bass.au3"

; ##############################################################

Global $__GEng_hGui = -1
Global $__GEng_WinW = -1, $__GEng_WinH = -1
Global $__GEng_hBitmap = -1
Global $__GEng_hGraphic = -1
Global $__GEng_hBuffer = -1
Global $__GEng_hDC = -1
Global $__GEng_hCompatibleDC = -1
Global $__GEng_FPSTimer = 0
Global $__GEng_FPSDisplayTimer = 0
; ---
Global Const $__GEng_PI = 4 * ATan(1)

; ##############################################################

Global $__GEng_Debug = 0
Global $_Arrow, _
	$_dbg_Arrow0 = 0, $_dbg_Arrow1, $_dbg_Arrow2, $_dbg_Arrow3, $_dbg_Arrow4, _
	$_dbg_pen0 = 0, $_dbg_pen1, $_dbg_pen2, $_dbg_pen3, $_dbg_pen4

; ##############################################################

#include "GEngin\GEng_System.au3"
#include "GEngin\GEng_Image.au3"
#include "GEngin\GEng_Sprite.au3"
#include "GEngin\GEng_Sprite_Collision.au3"
#include "GEngin\GEng_Sprite_Animation.au3"
#include "GEngin\GEng_Sprite_Dynamics.au3"
#include "GEngin\GEng_Sprite_Get.au3"
#include "GEngin\GEng_Sprite_Set.au3"
#include "GEngin\GEng_Sprite_Append.au3"
#include "GEngin\GEng_Animation.au3"
#include "GEngin\GEng_Draw.au3"
#include "GEngin\GEng_Geometry.au3"
#include "GEngin\GEng_Text.au3"
#include "GEngin\GEng_Sound.au3"
; ---
#include "GEngin\GEng_Debug.au3"