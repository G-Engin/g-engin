|Legende       |                 |                   |                     |
|:------------:|:---------------:|:-----------------:|:-------------------:|
| **+:** Ajout | **-:** Délétion | **!:** Correction | **\*:** Modification|
|              |                 |                   |                     |

# v 1.2.3 (25/07/2017)
* +: GEng_Color_Constants.au3

# v 1.2.2 (10/02/2012)
* +: Ajout de l'anti-aliasing pour les text (merci UEZ!)
* +: Paramètre $iAlign pour _GEng_Font_Create (Merci )
* +: _GEng_Sprite_MassGet
* *: Correction d'une fuite de mémoire dans _GEng_ImageLoadStream (Merci UEZ!)
* *: New valid functions header, and calltips (FR, EN)

# v 1.2.1 (02/07/2011)
* +: Documentation complète
* *: Le calcule de l'innertie de mouvement est plus précis
* *: Il n'y plus qu'un seul paramètre Innertie (et pas 2)
* *: La taille d'une police est exprimé en pixels (_GEng_Font_Create)

# v 1.2 (10/06/2011)
* +: Paramètre $iDynamique pour _GEng_Sprite_Collision et _GEng_Sprite_CollisionScrBorders qui permet d'activer le calcule de collisions dynamiques (collision élastique), assez rudimentaire (lent, bugé...) mais exploitable
* +: _GEng_Sprite_MasseSet et _GEng_Sprite_MasseGet, masse d'un sprite pour les collisions dynamiques
* +: _GEng_Sprite_CollisionScrBorders
* +: _GEng_ImageLoadStream: charge la chaine de caractères représentant un fichier image (Résultat de: FileToBinaryString)
* +: _GEng_Sprite_ColorMatrixTranslate, _GEng_Sprite_ColorMatrixReset
* *: Calcules de collision simplifiés (le point n'est plus concidéré comme un rectanlge)
* *: Mode debug amélioré: possibilité de selectionner certaines fonctions seulement (voir _GEng_SetDebug)
* -: _GEng_FPS_Start et _GEng_FPS_End devient: _GEng_FPS_Get


# v 1.1 (03/06/2011)
* +: Volume, pan, pitch for hSound Object (_GEng_Sound_AttribSet, _GEng_Sound_AttribGet)
* +: Possibilité de modifier la couleur d'un objet Text sans devoir créer un nouvel objet Font (voir _GEng_Text_Create)
* +: Ajout de _GEng_Sprite_PointGet: Retourne la position d'un point dans un sprite
* *: Ajout du paramètre $iDelay à _GEng_FPS_End (ne retourne le FPS que toutes les $iDelay ms)
* *: _GEng_Sprite_Del Renommé en _GEng_Sprite_Delete
* !: Bug _GEng_ImageLoad (Issue 1)
* !: Bug _GEng_SpriteToPoint_AngleDiff (Issue 3)
* !: Bug _GEng_Sprite_AngleSet (Issue 4)

# v 1.0 (29/05/2011)
* Première version
* Lance une fenètre de rendu
* Chargement de fichiers images (BMP, ICON, GIF, JPEG, Exif, PNG, TIFF, WMF, EMF) avec gestion de la transparence (PNG, ICO ...)
* Création d'objets Sprites, qui sont le coeur du moteur:
	+ Un objet sprite doit contenir une image, ou une portion d'image
	+ Il possède différent attributs:
		Position (x, y)
		Taille (x, y)
		Point d'origin (x, y)
		Vitesse (x, y) et vitesse max (pixels/s)
		Accelération (x, y) (pixels/s²)
		Innertie (x, y) (pixels/s²)
		Angle (Degres)
		Vitesse de rotation (Deg/s)
		Accélération de rotation (Deg/s²)
		Innertie de rotation (Deg/s²)
	+ Il possède une zone de collision, qui peut être soir un point, un cercle, 
		ou un rectangle
	+ Enfin, il peut être animé grâce à un objer Animation
	+ PS: On peut attacher des variables à un sprite (voir GEng_Sprite_Append.au3)
* Fonctions de calcules géométriques
	+ Distance, Angle, Vecteur entre: point-point, sprite-point, sprite-sprite
	+ Convertion Vecteur->Angle, Angle->Vecteur (en spécifiant la grandeur du vecteur)
* Gestion des collisions entre sprites, et avec les bords de l'écran
* Affichage de texte (couleur, police, taille, format ...)
* Gestion rudimentaire des sons (bass.dll)