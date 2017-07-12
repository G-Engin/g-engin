#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         Matwachich

 Script Function:
	Tutoriel montrant l'utilit� de la fonction _GEng_Sprite_PointGet

#ce ----------------------------------------------------------------------------

Opt("MouseCoordMode", 2)
#include <Misc.au3>
#include <..\GEngin.au3>

Global $scrW = 800, $scrH = 600, $fps

_GEng_Start("", $scrW, $scrH)

; Une image
$hImg = _GEng_ImageLoad("res\gengin.png", 128, 128)

; Un Sprite, au milieux de l'�cran
$hSpr = _GEng_Sprite_Create($hImg)
	_GEng_Sprite_OriginSetEx($hSpr, $GEng_Origin_Mid)
	_GEng_Sprite_SizeSet($hSpr, 128, 128)
	_GEng_Sprite_PosSet($hSpr, $scrW / 2, $scrH / 2)
	
	_GEng_Sprite_AngleSpeedSet($hSpr, 100, 0)
	
; Un autre plus petit
$hSpr2 = _GEng_Sprite_Create($hImg)
	_GEng_Sprite_SizeSet($hSpr2, 32, 32)
	_GEng_Sprite_OriginSetEx($hSpr2, $GEng_Origin_Mid)

; Maintenant: l'interret de la fonction _GEng_Sprite_PointGet et de convertir une coordonn�
; relative � un sprite, en coordonn� relative � l'�cran entier
; utile par exemple pour garder une tourelle toujours au m�me endroit du sprite, quelle que soit
; l'angle de ce sprite

; dans cet example nous allons positionner le petit sprite $hSpr2 sur le point 16, 16 du grand sprite
; (dans le cadran sup�rieur gauche) et faire tourner ce dernier
; vous verez que le petit sprite reste "coll�" au grand!

Global $x, $y ; vont stocker la position � donner au petit sprite

Do
	_GEng_ScrFlush(0xFFFFFFFF)
	; ---
	
	; On positionne le petit sprite sur le point 16, 16 du grand
	_GEng_Sprite_PointGet($hSpr, 16, 16, $x, $y)
	_GEng_Sprite_PosSet($hSpr2, $x, $y)
	
	; On dessine le tout!
	_GEng_Sprite_Draw($hSpr)
	_GEng_Sprite_Draw($hSpr2, 0)
	
	; ---
	_GEng_ScrUpdate()
	; ---
	$fps = _GEng_FPS_Get()
	If $fps <> -1 Then ConsoleWrite($fps & " FPS" & @CRLF)
Until GuiGetMsg() = -3

_GEng_Shutdown()
