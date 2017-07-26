#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         RonildoSouza

 Script Function:
	

#ce ----------------------------------------------------------------------------

Global $oSprChicken
Global $oImgChicken
Global $oAnmChicken
Global $oSoundChicken

Global Const $iCHICKEN_FRAME_COUNT = 10
Global Const $dCHICKEN_SIZE_W = 75.1
Global Const $dCHICKEN_SIZE_H = 60
Global Const $dCHICKEN_POS = [$scrW / 6, $scrH / 2 - $dCHICKEN_SIZE_H / 2]
Global Const $dCHICKEN_FALL_SPEED = 400
Global Const $dCHICKEN_MAX_SPEED = 400
Global Const $dCHICKEN_SPEED_Y = -180

#Region https://www.autoitscript.com/autoit3/docs/libfunctions/_IsPressed.htm
 Global Const $SPACEBAR = "20"
#EndRegion


Func _ChickenAnimationCreate()
	$oImgChicken = _GEng_ImageLoad("../res/flychicken/images/chicken.png")

	$oAnmChicken = _GEng_Anim_Create()
	For $i = 0 To ($iCHICKEN_FRAME_COUNT - 1)
		_GEng_Anim_FrameAdd($oAnmChicken, $oImgChicken, 100, $dCHICKEN_SIZE_W * $i, 0, $dCHICKEN_SIZE_W, $dCHICKEN_SIZE_H)
	Next
EndFunc   ;==>_ChickenAnimationCreate


Func _ChickenCreate()
	_GEng_Sound_Init()
	$oSoundChicken = _GEng_Sound_Load("../res/flychicken/sounds/chicken.wav")

	$oSprChicken = _GEng_Sprite_Create()
	_GEng_Sprite_OriginSetEx($oSprChicken, $GEng_Origin_Mid)
	_GEng_Sprite_PosSet($oSprChicken, $dCHICKEN_POS[0], $dCHICKEN_POS[1])
	_GEng_Sprite_CollisionSet($oSprChicken, 2, ($dCHICKEN_SIZE_W / 2), ($dCHICKEN_SIZE_H / 2), $dCHICKEN_SIZE_H - 30)
	_GEng_Sprite_InnertieSet($oSprChicken, 1000)
	_GEng_Sprite_MasseSet($oSprChicken, 500)
EndFunc   ;==>_ChickenCreate


Func _ChickenDraw()
	_GEng_Sprite_Draw($oSprChicken)
	_GEng_Sprite_Animate($oSprChicken, $oAnmChicken)
EndFunc   ;==>_ChickenDraw


Func _ChickenFly()
	$bIsCollidingTopScreen = (_GEng_Sprite_CollisionScrBorders($oSprChicken, 1) <> $GEng_ScrBorder_Top)

	If (_IsPressed($SPACEBAR) And $bIsCollidingTopScreen) Then
		$bGamePlaying = True
		_GEng_Sprite_SpeedSet($oSprChicken, 0, $dCHICKEN_SPEED_Y, $dCHICKEN_MAX_SPEED)
	EndIf

	If ($bGamePlaying And Not _IsPressed($SPACEBAR)) Then
		_GEng_Sprite_AccelSet($oSprChicken, 0, $dCHICKEN_FALL_SPEED)
	EndIf

	$bIsCollidingBottomScreen = (_GEng_Sprite_CollisionScrBorders($oSprChicken, 1) == $GEng_ScrBorder_Bot)

	If ($bIsCollidingBottomScreen) Then
		__ChickenCollided()
	EndIf
EndFunc   ;==>_ChickenFly


Func _ChickenCheckCollision(ByRef $oSprTubeTop, ByRef $oSprTubeBottom)
	$collisionTop = _GEng_Sprite_Collision($oSprChicken, $oSprTubeTop, 0, 1)
	$collisionBottom = _GEng_Sprite_Collision($oSprChicken, $oSprTubeBottom, 0, 1)
	If ($collisionTop Or $collisionBottom) Then
		__ChickenCollided()
	EndIf
EndFunc   ;==>_ChickenCheckCollision


#cs
	Private Functions
#ce

Func __ChickenCollided()
	_GEng_Sound_Play($oSoundChicken)
	$bCollision = True
EndFunc   ;==>__ChickenCollided