Global $oSprBackground

Func _BackgroundCreate()
	Local $oImgBackground = _GEng_ImageLoad("../res/flychicken/images/background.png")
	$oSprBackground = _GEng_Sprite_Create($oImgBackground)
	_GEng_Sprite_SizeSet($oSprBackground, $scrW, $scrH)
EndFunc   ;==>_BackgroundCreate


Func _BackgroundDraw()
	_GEng_Sprite_Draw($oSprBackground, 0)
EndFunc   ;==>_BackgroundDraw
