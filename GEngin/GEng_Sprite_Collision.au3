#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         Matwachich

 Script Function:
	GEngin - Sprite collision

#ce ----------------------------------------------------------------------------

;File: Collisions

#Region ### Functions ###
#cs
- Main Functions
	_GEng_Sprite_CollisionSet(ByRef $hSprite, $iType, $x = Default, $y = Default, $w = Default, $h = Default)
	_GEng_Sprite_Collision(ByRef $hSprite1, ByRef $hSprite2, $iDynamique = 0, $iPrecision = 0)
	_GEng_Sprite_CollisionScrBorders(ByRef $hSprite, $iDynamique = 0)
	__GEng_SpriteDynamiqueCollision(ByRef $hSprite1, ByRef $hSprite2, $iPrecision = 0)
	__GEng_SpriteCheckCollision(ByRef $hSprite1, ByRef $hSprite2)
	__GEng_PointVsCircle($cX, $cY, $cR, $x, $y)
	__GEng_PointVsRect($rX, $rY, $rW, $rH, $x, $y)
	__GEng_CircleVsCircle($c1X, $c1Y, $c1R, $c2X, $c2Y, $c2R)
	__GEng_Dbg_DrawCircleCircle($iDebugPen, $c1X, $c1Y, $c1R, $c2X, $c2Y, $c2R)
	__GEng_CircleVsRect($cX, $cY, $cR, $rX, $rY, $rW, $rH)
	__GEng_Dbg_DrawRectCercle($iDebugPen, $cX, $cY, $cR, $rX, $rY, $rW, $rH)
	__GEng_RectVsRect($x1, $y1, $w1, $h1, $x2, $y2, $w2, $h2)
	__GEng_Dbg_DrawRectRect($iDebugPen, $x1, $y1, $w1, $h1, $x2, $y2, $w2, $h2)
#ce
#EndRegion ###


; pour les tests de collision avec les bord de la fenètre
Global $GEng_ScrBorder_Top = 1, $GEng_ScrBorder_Bot = 2, $GEng_ScrBorder_Left = 3, $GEng_ScrBorder_Right = 4

; $iType: 0 - point, 1 - Carré, 2 - Ellipse
; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sprite_CollisionSet
; Description ...: Spécifie la forme et la taille de la hit-box d'un sprite
; Syntax.........: _GEng_Sprite_CollisionSet(ByRef $hSprite, $iType, $x = Default, $y = Default, $w = Default, $h = Default)
; Parameters ....: $hSprite = Objet Sprite
;                  $iType = Forme de la hit-box, dont dépend $x, $y, $w, $h
;                  	0 - Point
;                  		$x, $y = Coordonnées du point (par défaut: Point d'origine du sprite)
;                  		$w, $h = pas pris en concidération
;                  	1 - Rectangle
;                  		$x, $y = Coordonnées du point supérieur gauche du rectangle (par défaut: 0, 0)
;                  					(Par rapport au sprite, pas à l'écran)
;                  		$w, $h = largeur et hauteur du rectangle (par défaut: Largeur et hauteur du sprite)
;                  	2 - Cercle
;                  		$x, $y = Coordonnées du centre du cercle (par défaut: Point d'origine du sprite)
;                  		$w = Rayon du cercle (par défaut: (Largeur + Hauteur)/4)
;                  		$h = pas pris en concidération
; Return values .: Succes - 1
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks .......: 
; ;==========================================================================================
#cs
Function: _GEng_Sprite_CollisionSet
	Define the collision shape of a Sprite Object

Prototype:
	> _GEng_Sprite_CollisionSet(ByRef $hSprite, $iType, $x = Default, $y = Default, $w = Default, $h = Default)

Parameters:
	$hSprite - Sprite Object
	$iType - Defines which shape to use. Can be one of the following:
	
	- *0:* Dot
		$x, $y - Sprite's relative position of the collision point
		$w, $h - Not used
	- *1:* Rectangle (AABB)
		$x, $y - Upper left corner of the bounding box (sprites relative)
		$w, $h - Size of the bounding box (widht, height)
	- *2:* Circle
		$x, $y - Circle's center point position
		$w - Radius
		$h - Not used

Returns:
	Succes - 1
	Failed - 0 And @error = 1
#ce
Func _GEng_Sprite_CollisionSet(ByRef $hSprite, $iType, $x = Default, $y = Default, $w = Default, $h = Default)
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	$hSprite[$_gSpr_CollType] = $iType ; Collision Type
	; ---
	; Point
	If $iType = 0 Then
		If $x = Default Then
			$hSprite[$_gSpr_CollX] = $hSprite[$_gSpr_OriX]
		Else
			$hSprite[$_gSpr_CollX] = $x
		EndIf
		; ---
		If $y = Default Then
			$hSprite[$_gSpr_CollY] = $hSprite[$_gSpr_OriY]
		Else
			$hSprite[$_gSpr_CollY] = $y
		EndIf
		; ---
		$hSprite[$_gSpr_CollW] = 0
		$hSprite[$_gSpr_CollH] = 0
		; ---
		Return 1
	EndIf
	; ---
	; Carré
	If $iType = 1 Then
		If $x <> Default And $y <> Default And $w <> Default And $h <> Default Then
			$hSprite[$_gSpr_CollX] = $x
			$hSprite[$_gSpr_CollY] = $y
			$hSprite[$_gSpr_CollW] = $w
			$hSprite[$_gSpr_CollH] = $h
		Else
			$hSprite[$_gSpr_CollX] = 0
			$hSprite[$_gSpr_CollY] = 0
			$hSprite[$_gSpr_CollW] = $hSprite[9]
			$hSprite[$_gSpr_CollH] = $hSprite[10]
		EndIf
		; ---
		Return 1
	EndIf
	; ---
	; Cercle
	If $iType = 2 Then
		If $x <> Default And $y <> Default And $w <> Default Then
			$hSprite[$_gSpr_CollX] = $x ; centre X
			$hSprite[$_gSpr_CollY] = $y ; centre Y
			$hSprite[$_gSpr_CollW] = $w ; Rayon
			$hSprite[$_gSpr_CollH] = 0
		Else
			$hSprite[$_gSpr_CollX] = $hSprite[$_gSpr_OriX] ; originX
			$hSprite[$_gSpr_CollY] = $hSprite[$_gSpr_OriY] ; originY
			$hSprite[$_gSpr_CollW] = ($hSprite[$_gSpr_Width] + $hSprite[$_gSpr_Height]) / 4  ; sprite size (1/2 moyenne)
			$hSprite[$_gSpr_CollH] = 0
		EndIf
		; ---
		Return 1
	EndIf
	; ---
	Return SetError(1, 0, 0)
EndFunc


; #FUNCTION# ;===============================================================================
; Name...........: _GEng_SpriteCollision
; Description ...: Test si il y a collision entre 2 sprites
; Syntax.........: _GEng_Sprite_Collision(ByRef $hSprite1, ByRef $hSprite2, $iScrBorderPosition = 0, $iDynamique = 0, $iPrecision = 0)
; Parameters ....: $hSprite1 = Objet Sprite
;                  $hSprite2 = Objet Sprite OU une de ces constantes:
;                  	$GEng_ScrBorder_Top -> Bord supérieur de l'écran
;                  	$GEng_ScrBorder_Bot -> Bord inférieur
;                  	$GEng_ScrBorder_Left -> Bord gauche
;                  	$GEng_ScrBorder_Right -> Bord droit
;                  $iScrBorderPosition = Distance entre le bord réel de l'écran, et la ligne limite de collision
;                  $iDynamique = 1 -> Calcules dynamique des collision (collision élastique)
;                  			  0 -> N'influence pas le mouvement des objets en collision (Par défaut)
;                  $iPrecision = Degré de précision dans les collision dynamiques. ne l'augmentez que si
;                  	vos sprites se collent l'un à l'autre lors d'une collision.
; Return values .: Succes - 1
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks .......: Le calcule de collision dynamique (avec $iPrecision = 10) prend 8 à 20 fois plus de temps 
;                  	qu'une détection uniquement (passe de 0.15 ms à au max: 3 ms) selon la vitesse et l'angle
;                  	de collision des sprites
;                  Le système de collision dynamqie est plus que rudimentaire, il arrive qu'il bug
;                  	(sprites qui se collent, collision manquée...). A term, il est possible
;                  	qu'une bibliothèque physique externe soit exploitée par G-Engin
; ;==========================================================================================
#cs
Function: _GEng_Sprite_Collision
	Test if 2 sprites collides

Prototype:
	> _GEng_Sprite_Collision(ByRef $hSprite1, ByRef $hSprite2, $iScrBorderPosition = 0, $iDynamique = 0, $iPrecision = 0)

Parameters:
	$hSprite1 - Sprite Object
	$hSprite2 - Sprite Object *OR* one of the followings:
	
		- *$GEng_ScrBorder_Top* -> Upper screen edge
		- *$GEng_ScrBorder_Bot* -> Bottom screen edge
		- *$GEng_ScrBorder_Left* -> Left screen edge
		- *$GEng_ScrBorder_Right* -> Right screen edge
	
	$iScrBorderPosition - Distance between the screen edge and the collision line
	$iDynamique - If TRUE, then the 2 tested sprites will collide dynamically
	$iPrecision - Defines the precision of the dynamic collision anti-bugs algorithm, 
		high values can really slow your program, so increase only if you encounter bugs.

Returns:
	Succes - 1
	Failed - 0 And @error = 1

Remarks:
	The dynamic collision system is rudimentary and buggy (sticking sprites, missing some collisions especially
	at high speed).
#ce
Func _GEng_Sprite_Collision(ByRef $hSprite1, ByRef $hSprite2, $iScrBorderPosition = 0, $iDynamique = 0, $iPrecision = 0)
	If Not __GEng_Sprite_IsSprite($hSprite1) Then Return SetError(1, 0, 0)
	; ---
	Local $collision = __GEng_SpriteCheckCollision($hSprite1, $hSprite2, $iScrBorderPosition)
	If $collision And $iDynamique Then __GEng_SpriteDynamiqueCollision($hSprite1, $hSprite2, $iPrecision)
	; ---
	Return $collision
EndFunc

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Sprite_CollisionScrBorders
; Description ...: Test la collision entre un sprite et tous les bords de l'écran
; Syntax.........: _GEng_Sprite_CollisionScrBorders(ByRef $hSprite, $iDynamique = 0)
; Parameters ....: $hSprite = Objet Sprite
;                  $iDynamique = 1 -> Calcules dynamique des collision (collision élastique)
;                  			  0 -> N'influence pas le mouvement des objets en collision (Par défaut)
; Return values .: Succes
;                  	Si collision:
;                  	$GEng_ScrBorder_Top, $GEng_ScrBorder_Bot, $GEng_ScrBorder_Left, $GEng_ScrBorder_Right
;                  	Pas de collision: 0
;                  Echec - 0 et @error = 1
; Author ........: Matwachich
; Remarks .......: 
; ;==========================================================================================
#cs
Function: _GEng_Sprite_CollisionScrBorders
	Test collision between a Sprite Object and all screen borders.

Prototype:
	> _GEng_Sprite_CollisionScrBorders(ByRef $hSprite, $iDynamique = 0)

Parameters:
	$hSprite - Sprite Object
	$iDynamique - Dynamics collisions ON/OFF

Returns:
	Succes - If no collision 0
	
		If collision occures, returns one of the following
		- *$GEng_ScrBorder_Top* -> Collision with the upper screen edge
		- *$GEng_ScrBorder_Bot* -> Collision with the bottom screen edge
		- *$GEng_ScrBorder_Left* -> Collision with the left screen edge
		- *$GEng_ScrBorder_Right* -> Collision with the right screen edge
		
	Failed - 0 And @error = 1
#ce
Func _GEng_Sprite_CollisionScrBorders(ByRef $hSprite, $iDynamique = 0)
	If Not __GEng_Sprite_IsSprite($hSprite) Then Return SetError(1, 0, 0)
	; ---
	If _GEng_Sprite_Collision($hSprite, $GEng_ScrBorder_Top, 0, $iDynamique) Then Return $GEng_ScrBorder_Top
	If _GEng_Sprite_Collision($hSprite, $GEng_ScrBorder_Bot, 0, $iDynamique) Then Return $GEng_ScrBorder_Bot
	If _GEng_Sprite_Collision($hSprite, $GEng_ScrBorder_Left, 0, $iDynamique) Then Return $GEng_ScrBorder_Left
	If _GEng_Sprite_Collision($hSprite, $GEng_ScrBorder_Right, 0, $iDynamique) Then Return $GEng_ScrBorder_Right
	; ---
	Return 0
EndFunc

; ==============================================================
; ### Internals
; ==============================================================
Func __GEng_SpriteDynamiqueCollision(ByRef $hSprite1, ByRef $hSprite2, $iPrecision = 0)
	Switch $hSprite2
		Case $GEng_ScrBorder_Top
			If $hSprite1[$_gSpr_Masse] > 0 Then _
				$hSprite1[$_gSpr_SpeedY] = Abs($hSprite1[$_gSpr_SpeedY])
			Return
		Case $GEng_ScrBorder_Bot
			If $hSprite1[$_gSpr_Masse] > 0 Then _
				$hSprite1[$_gSpr_SpeedY] = -1 * Abs($hSprite1[$_gSpr_SpeedY])
			Return
		Case $GEng_ScrBorder_Left
			If $hSprite1[$_gSpr_Masse] > 0 Then _
				$hSprite1[$_gSpr_SpeedX] = Abs($hSprite1[$_gSpr_SpeedX])
			Return
		Case $GEng_ScrBorder_Right
			If $hSprite1[$_gSpr_Masse] > 0 Then _
				$hSprite1[$_gSpr_SpeedX] = -1 * Abs($hSprite1[$_gSpr_SpeedX])
			Return
	EndSwitch
	; ---
	If Not __GEng_Sprite_IsSprite($hSprite2) Then Return SetError(1, 0, 0)
	; ---
	Local $dist = _GEng_SpriteToSprite_Dist($hSprite1, $hSprite2)
	Local $mass_tot = $hSprite1[$_gSpr_Masse] + $hSprite2[$_gSpr_Masse]
	Local $nx, $ny, $gx, $gy
	$nx = ($hSprite2[$_gSpr_PosX] - $hSprite1[$_gSpr_PosX]) / $dist
	$ny = ($hSprite2[$_gSpr_PosY] - $hSprite1[$_gSpr_PosY]) / $dist
	$gx = -1 * $ny
	$gy = $nx
	; ---
	Local $v1n, $v1g, $v2n, $v2g
	$v1n = $nx * $hSprite1[$_gSpr_SpeedX] + $ny * $hSprite1[$_gSpr_SpeedY]
	$v1g = $gx * $hSprite1[$_gSpr_SpeedX] + $gy * $hSprite1[$_gSpr_SpeedY]
	$v2n = $nx * $hSprite2[$_gSpr_SpeedX] + $ny * $hSprite2[$_gSpr_SpeedY]
	$v2g = $gx * $hSprite2[$_gSpr_SpeedX] + $gy * $hSprite2[$_gSpr_SpeedY]
	; ---
	;calculate new vectors according to mass
	If $hSprite1[$_gSpr_Masse] <> 0 Then _
		$v2n = ($hSprite1[$_gSpr_Masse] - $hSprite2[$_gSpr_Masse]) / $mass_tot * $v1n + 2 * $hSprite2[$_gSpr_Masse] / $mass_tot * $v2n
	If $hSprite2[$_gSpr_Masse] <> 0 Then _
		$v1n = ($hSprite2[$_gSpr_Masse] - $hSprite1[$_gSpr_Masse]) / $mass_tot * $v2n + 2 * $hSprite1[$_gSpr_Masse] / $mass_tot * $v1n
	; ---
	If $hSprite1[$_gSpr_Masse] > 0 Then
		$hSprite1[$_gSpr_SpeedX] = $nx * $v2n + $gx * $v1g
		$hSprite1[$_gSpr_SpeedY] = $ny * $v2n + $gy * $v1g
	EndIf
	If $hSprite2[$_gSpr_Masse] > 0 Then
		$hSprite2[$_gSpr_SpeedX] = $nx * $v1n + $gx * $v2g
		$hSprite2[$_gSpr_SpeedY] = $ny * $v1n + $gy * $v2g
	EndIf
	; ---
	If $iPrecision <= 0 Then Return
	; ---
	Local $rat1x, $rat1y ; ratio de vitesse x/y
	Local $rat2x, $rat2y ; ratio de vitesse x/y
	; ---
	If $hSprite1[$_gSpr_SpeedX] = 0 Then
		$rat1x = 0
		$rat1y = 1
	ElseIf $hSprite1[$_gSpr_SpeedY] = 0 Then
		$rat1x = 1
		$rat1y = 0
	Else
		$rat1x = $hSprite1[$_gSpr_SpeedX] / (Abs($hSprite1[$_gSpr_SpeedY]) + Abs($hSprite1[$_gSpr_SpeedX]))
		$rat1y = $hSprite1[$_gSpr_SpeedY] / (Abs($hSprite1[$_gSpr_SpeedY]) + Abs($hSprite1[$_gSpr_SpeedX]))
	EndIf
	;ConsoleWrite($rat1x & " , " & $rat1y & @CRLF)
	; ---
	If $hSprite1[$_gSpr_SpeedX] < 0 Then
		$rat1x = -1 * Abs($rat1x)
	Else
		$rat1x = Abs($rat1x)
	EndIf
	If $hSprite1[$_gSpr_SpeedY] < 0 Then
		$rat1y = -1 * Abs($rat1y)
	Else
		$rat1y = Abs($rat1y)
	EndIf
	; ---
	; ---
	If $hSprite2[$_gSpr_SpeedX] = 0 Then
		$rat2x = 0
		$rat2y = 1
	ElseIf $hSprite2[$_gSpr_SpeedY] = 0 Then
		$rat2x = 1
		$rat2y = 0
	Else
		$rat2x = $hSprite2[$_gSpr_SpeedX] / (Abs($hSprite2[$_gSpr_SpeedY]) + Abs($hSprite2[$_gSpr_SpeedX]))
		$rat2y = $hSprite2[$_gSpr_SpeedY] / (Abs($hSprite2[$_gSpr_SpeedY]) + Abs($hSprite2[$_gSpr_SpeedX]))
	EndIf
	;ConsoleWrite($rat2x & " , " & $rat2y & @CRLF)
	; ---
	If $hSprite2[$_gSpr_SpeedX] < 0 Then
		$rat2x = -1 * Abs($rat2x)
	Else
		$rat2x = Abs($rat2x)
	EndIf
	If $hSprite2[$_gSpr_SpeedY] < 0 Then
		$rat2y = -1 * Abs($rat2y)
	Else
		$rat2y = Abs($rat2y)
	EndIf
	; ---
	Local $x = 0
	Do
		If $hSprite1[$_gSpr_Masse] > 0 Then
			If $hSprite1[$_gSpr_PosX] > $hSprite1[$_gSpr_OriX] And _
				$hSprite1[$_gSpr_PosY] > $hSprite1[$_gSpr_OriY] And _
				$hSprite1[$_gSpr_PosX] < $__GEng_WinW - $hSprite1[$_gSpr_OriX] And _
				$hSprite1[$_gSpr_PosY] < $__GEng_WinH - $hSprite1[$_gSpr_OriY] Then
					$hSprite1[$_gSpr_PosX] += $rat1x
					$hSprite1[$_gSpr_PosY] += $rat1y
			EndIf
		EndIf
		If $hSprite2[$_gSpr_Masse] > 0 Then
			If $hSprite2[$_gSpr_PosX] > $hSprite2[$_gSpr_OriX] And _
				$hSprite2[$_gSpr_PosY] > $hSprite2[$_gSpr_OriY] And _
				$hSprite2[$_gSpr_PosX] < $__GEng_WinW - $hSprite2[$_gSpr_OriX] And _
				$hSprite2[$_gSpr_PosY] < $__GEng_WinH - $hSprite2[$_gSpr_OriY] Then
					$hSprite2[$_gSpr_PosX] += $rat2x
					$hSprite2[$_gSpr_PosY] += $rat2y
			EndIf
		EndIf
		;ConsoleWrite($rat1x & " , " & $rat1y & @CRLF)
		;ConsoleWrite($rat2x & " , " & $rat2y & @CRLF)
		$x += 1
		;ConsoleWrite(" >>> " & $x & @CRLF)
		If $x >= $iPrecision Then
			;ConsoleWrite("Max!" & @CRLF)
			ExitLoop
		EndIf
	Until Not _GEng_Sprite_Collision($hSprite1, $hSprite2, 0)
EndFunc

#cs
	// Calcul de la collision entre 2 boules 
	// de même masse et de rayon r en 2D (ex: boules de billard)
	// Les boules sont positionnées au point de contact
	// (m.x,m.y) = centre de la boule m (repère de l'image)
	// (m.vx,m.vy) = vitesse de la boule m avant le choc (repère de l'image)

	// Calcul de la base orthonormée (n,g)
	// n est perpendiculaire au plan de collision, g est tangent
	double nx = (m2.x - m1.x)/(2*r);
	double ny = (m2.y - m1.y)/(2*r);
	double gx = -ny;
	double gy = nx;

	// Calcul des vitesses dans cette base
	double v1n = nx*m1.vx + ny*m1.vy;
	double v1g = gx*m1.vx + gy*m1.vy;
	double v2n = nx*m2.vx + ny*m2.vy;
	double v2g = gx*m2.vx + gy*m2.vy;

	// Permute les coordonnées n et conserve la vitesse tangentielle
	// Exécute la transformation inverse (base orthonormée => matrice transposée)
	m1.vx = nx*v2n +  gx*v1g;
	m1.vy = ny*v2n +  gy*v1g;
	m2.vx = nx*v1n +  gx*v2g;
	m2.vy = ny*v1n +  gy*v2g;
#ce

Func __GEng_SpriteCheckCollision(ByRef $hSprite1, ByRef $hSprite2, $iScrBorderPosition = 0)
	Local $x1, $y1, $w1, $h1, $type1
	Local $x2, $y2, $w2, $h2, $type2
	
	Switch $hSprite1[$_gSpr_CollType]
		Case 0 ; point
			$x1 = $hSprite1[$_gSpr_PosX] - $hSprite1[$_gSpr_OriX] + $hSprite1[$_gSpr_CollX]
			$y1 = $hSprite1[$_gSpr_PosY] - $hSprite1[$_gSpr_OriY] + $hSprite1[$_gSpr_CollY]
			$w1 = 0
			$h1 = 0
		Case 1 ; rect
			$x1 = $hSprite1[$_gSpr_PosX] - $hSprite1[$_gSpr_OriX] + $hSprite1[$_gSpr_CollX]
			$y1 = $hSprite1[$_gSpr_PosY] - $hSprite1[$_gSpr_OriY] + $hSprite1[$_gSpr_CollY]
			$w1 = $hSprite1[$_gSpr_CollW]
			$h1 = $hSprite1[$_gSpr_CollH]
		Case 2 ; cercle
			$x1 = $hSprite1[$_gSpr_PosX] - $hSprite1[$_gSpr_OriX] + $hSprite1[$_gSpr_CollX]
			$y1 = $hSprite1[$_gSpr_PosY] - $hSprite1[$_gSpr_OriY] + $hSprite1[$_gSpr_CollY]
			$w1 = $hSprite1[$_gSpr_CollW]
			$h1 = 0
	EndSwitch
	$type1 = $hSprite1[$_gSpr_CollType]
	
	; ---
	Switch $hSprite2
		Case $GEng_ScrBorder_Top
			$x2 = 0
			$y2 = -100 + $iScrBorderPosition
			$w2 = $__GEng_WinW
			$h2 = 101
			$type2 = 1 ; Car les bords de l'écran sont assimilés à un carré
		Case $GEng_ScrBorder_Bot
			$x2 = 0
			$y2 = $__GEng_WinH - (1 + $iScrBorderPosition)
			$w2 = $__GEng_WinW
			$h2 = 101
			$type2 = 1 ; Car les bords de l'écran sont assimilés à un carré
		Case $GEng_ScrBorder_Left
			$x2 = -100
			$y2 = 0
			$w2 = 101 + $iScrBorderPosition
			$h2 = $__GEng_WinH
			$type2 = 1 ; Car les bords de l'écran sont assimilés à un carré
		Case $GEng_ScrBorder_Right
			$x2 = $__GEng_WinW - (1 + $iScrBorderPosition)
			$y2 = 0
			$w2 = 101
			$h2 = $__GEng_WinH
			$type2 = 1 ; Car les bords de l'écran sont assimilés à un carré
		Case Else
			If Not __GEng_Sprite_IsSprite($hSprite2) Then Return SetError(1, 0, 0)
			; ---
			Switch $hSprite2[$_gSpr_CollType]
				Case 0 ; point
					$x2 = $hSprite2[$_gSpr_PosX] - $hSprite2[$_gSpr_OriX] + $hSprite2[$_gSpr_CollX]
					$y2 = $hSprite2[$_gSpr_PosY] - $hSprite2[$_gSpr_OriY] + $hSprite2[$_gSpr_CollY]
					$w2 = 0
					$h2 = 0
				Case 1 ; rect
					$x2 = $hSprite2[$_gSpr_PosX] - $hSprite2[$_gSpr_OriX] + $hSprite2[$_gSpr_CollX]
					$y2 = $hSprite2[$_gSpr_PosY] - $hSprite2[$_gSpr_OriY] + $hSprite2[$_gSpr_CollY]
					$w2 = $hSprite2[$_gSpr_CollW]
					$h2 = $hSprite2[$_gSpr_CollH]
				Case 2 ; cercle
					$x2 = $hSprite2[$_gSpr_PosX] - $hSprite2[$_gSpr_OriX] + $hSprite2[$_gSpr_CollX]
					$y2 = $hSprite2[$_gSpr_PosY] - $hSprite2[$_gSpr_OriY] + $hSprite2[$_gSpr_CollY]
					$w2 = $hSprite2[$_gSpr_CollW]
					$h2 = 0
			EndSwitch
			$type2 = $hSprite2[$_gSpr_CollType]
	EndSwitch
	; ---

	; Entre 2 points
	If $type1 = 0 And $type2 = 0 Then
		If $x1 = $x2 And $y1 = $y2 Then
			Return 1
		Else
			Return 0
		EndIf
	EndIf
	
	; SI: Il y a un point
	If $type1 = 0 Then
		Switch $type2
			Case 1
				Return __GEng_PointVsRect($x2, $y2, $w2, $h2, $x1, $y1)
			Case 2
				Return __GEng_PointVsCircle($x2, $y2, $w2, $x1, $y1)
		EndSwitch
	EndIf
	If $type2 = 0 Then
		Switch $type1
			Case 1
				Return __GEng_PointVsRect($x1, $y1, $w1, $h1, $x2, $y2)
			Case 2
				Return __GEng_PointVsCircle($x1, $y1, $w1, $x2, $y2)
		EndSwitch
	EndIf
	
	; SI: les 2 sont des cercles
	If $type1 = 2 And $type2 = 2 Then
		Return __GEng_CircleVsCircle($x1, $y1, $w1, _
									$x2, $y2, $w2)
	EndIf
	; ---
	
	; SI: il y à un cercle
	If $type1 = 2 Then
		Return __GEng_CircleVsRect($x1, $y1, $w1, _
									$x2, $y2, $w2, $h2)
	EndIf
	If $type2 = 2 Then
		Return __GEng_CircleVsRect($x2, $y2, $w2, _
									$x1, $y1, $w1, $h1)
	EndIf
	; ---
	
	; SI: les 2 sont des rectangles
	Return __GEng_RectVsRect($x1, $y1, $w1, $h1, _
							$x2, $y2, $w2, $h2)
EndFunc

Func __GEng_PointVsCircle($cX, $cY, $cR, $x, $y)
	If Sqrt(($x - $cX)^2 + ($y - $cY)^2) <= $cR Then
		__GEng_Dbg_DrawCircleCircle(1, $cX, $cY, $cR, $x, $y, 1)
		Return 1
	Else
		Return 0
	EndIf
EndFunc

Func __GEng_PointVsRect($rX, $rY, $rW, $rH, $x, $y)
	If $x >= $rX And $x <= $rX + $rW And _
		$y >= $rY And $y <= $rY + $rH Then
		__GEng_Dbg_DrawRectCercle(1, $x, $y, 1, $rX, $rY, $rW, $rH)
		Return 1
	Else
		Return 0
	EndIf
EndFunc

Func __GEng_CircleVsCircle($c1X, $c1Y, $c1R, $c2X, $c2Y, $c2R)
	Local $cDist = Sqrt(($c2X - $c1X)^2 + ($c2Y - $c1Y)^2)
	; ---
	If $cDist <= $c1R + $c2R Then
		__GEng_Dbg_DrawCircleCircle(1, $c1X, $c1Y, $c1R, $c2X, $c2Y, $c2R)
		Return 1
	EndIf
	; ---
	Return 0
EndFunc

Func __GEng_Dbg_DrawCircleCircle($iDebugPen, $c1X, $c1Y, $c1R, $c2X, $c2Y, $c2R)
	If BitAnd($__GEng_Debug, $GEng_Debug_Collisions) Then
		_GEng_Debug_DrawCircle($iDebugPen, $c1X, $c1Y, $c1R)
		_GEng_Debug_DrawCircle($iDebugPen, $c2X, $c2Y, $c2R)
		; ---
		Sleep(50)
	EndIf
EndFunc

; Thanks: http://stackoverflow.com/questions/401847/circle-rectangle-collision-detection-intersection/3491126#3491126
Func __GEng_CircleVsRect($cX, $cY, $cR, $rX, $rY, $rW, $rH)
	Local $w = $rW / 2, $h = $rH / 2
	; ---
	Local $rcX, $rcY
	$rcX = $rX + $w
	$rcY = $rY + $h
	; ---
	Local $dx = Abs($rcX - $cX)
	Local $dy = Abs($rcY - $cY)
	; ---
	If ($dx > ($cR + $w)) Or ($dy > ($cR + $h)) Then Return 0
	; ---
	Local $cDistX, $cDistY
	$cDistX = Abs($cX - $rX - $w)
	$cDistY = Abs($cY - $rY - $h)
	; ---
	If ($cDistX <= $w) Or ($cDistY <= $h) Then
		__GEng_Dbg_DrawRectCercle(1, $cX, $cY, $cR, $rX, $rY, $rW, $rH)
		Return 1
	EndIf
	; ---
	Local $cornerDistSq = (($cDistX - $w)^2) + (($cDistY - $h)^2)
	; ---
	If ($cornerDistSq <= ($cR^2)) Then
		__GEng_Dbg_DrawRectCercle(1, $cX, $cY, $cR, $rX, $rY, $rW, $rH)
		Return 1
	Else
		Return 0
	EndIf
EndFunc

Func __GEng_Dbg_DrawRectCercle($iDebugPen, $cX, $cY, $cR, $rX, $rY, $rW, $rH)
	If BitAnd($__GEng_Debug, $GEng_Debug_Collisions) Then
		_GEng_Debug_DrawCircle($iDebugPen, $cX, $cY, $cR)
		_GEng_Debug_DrawRect($iDebugPen, $rX, $rY, $rW, $rH)
		; ---
		Sleep(50)
	EndIf
EndFunc

Func __GEng_RectVsRect($x1, $y1, $w1, $h1, $x2, $y2, $w2, $h2)
	Local $halfW1, $halfH1, $halfW2, $halfH2
	$halfW1 = $w1 / 2
	$halfH1 = $h1 / 2
	$halfW2 = $w2 / 2
	$halfH2 = $h2 / 2
	; ---
	Local $center1X, $center1Y, $center2X, $center2Y
	$center1X = $x1 + $halfW1
	$center1Y = $y1 + $halfH1
	$center2X = $x2 + $halfW2
	$center2Y = $y2 + $halfH2
	; ---
	Local $distX, $distY
	$distX = Abs($center1X - $center2X)
	$distY = Abs($center1Y - $center2Y)
	; ---
	If $distX <= $halfW1 + $halfW2 And $distY <= $halfH1 + $halfH2 Then
		__GEng_Dbg_DrawRectRect(1, $x1, $y1, $w1, $h1, $x2, $y2, $w2, $h2)
		Return 1
	EndIf
	; ---
	Return 0
EndFunc

Func __GEng_Dbg_DrawRectRect($iDebugPen, $x1, $y1, $w1, $h1, $x2, $y2, $w2, $h2)
	If BitAnd($__GEng_Debug, $GEng_Debug_Collisions) Then
		_GEng_Debug_DrawRect($iDebugPen, $x1, $y1, $w1, $h1)
		_GEng_Debug_DrawRect($iDebugPen, $x2, $y2, $w2, $h2)
		Sleep(50)
	EndIf
EndFunc

#cs
http://stackoverflow.com/questions/401847/circle-rectangle-collision-detection-intersection/3491126#3491126

 var rectangleCenter = new PointF((rectangle.X +  rectangle.Width / 2),
                                         (rectangle.Y + rectangle.Height / 2));

        var w = rectangle.Width  / 2;
        var h = rectangle.Height / 2;

        var dx = Math.Abs(circle.X - rectangleCenter.X);
        var dy = Math.Abs(circle.Y - rectangleCenter.Y);

        if (dx > (radius + w) || dy > (radius + h)) return false;


        var circleDistance = new PointF
                                 {
                                     X = Math.Abs(circle.X - rectangle.X - w),
                                     Y = Math.Abs(circle.Y - rectangle.Y - h)
                                 };


        if (circleDistance.X <= (w))
        {
            return true;
        }

        if (circleDistance.Y <= (h))
        {
            return true;
        }

        var cornerDistanceSq = Math.Pow(circleDistance.X - w, 2) + 
                    Math.Pow(circleDistance.Y - h, 2);

        return (cornerDistanceSq <= (Math.Pow(radius, 2)));
    }
#ce
