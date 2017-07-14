#Include <Misc.au3>
#include <GUIConstantsEx.au3>
#include "..\GEngin.au3"

#Region https://www.autoitscript.com/autoit3/docs/libfunctions/_IsPressed.htm
 Local Const $SPACEBAR = 20
#EndRegion 

Global $scrW = 800, $scrH = 600, $iExplosionFrameCount = 10, $oAnimationExplosion

_GEng_Start("Sound And Animation", $scrW, $scrH)
_GEng_Sound_Init()

$oImageExplosion = _GEng_ImageLoad("./res/images/sound_and_animation/explosion.png")
$oSoundExplosion = _GEng_Sound_Load("./res/sounds/explosion.wav")

_AnimationLoad()

$oSpriteExplosion = _GEng_Sprite_Create()
_GEng_Sprite_ImageSet($oSpriteExplosion, $oImageExplosion)
_GEng_Sprite_OriginSetEx($oSpriteExplosion, $GEng_Origin_Mid)
_GEng_Sprite_SizeSet($oSpriteExplosion, 128, 128)
_GEng_Sprite_PosSet($oSpriteExplosion, $scrW / 2, $scrH - 100)

$oFont = _GEng_Font_Create("Comic Sans MS", 18)
$oText = _GEng_Text_Create($oFont, "* Spacebar => Start Explosion", $GEng_Color_Navy, 0, 0, $scrW, $scrH)

Do
	_GEng_ScrFlush($GEng_Color_White)
	;~ ---
	
	If (_IsPressed($SPACEBAR)) Then
		_GEng_Sound_Play($oSoundExplosion)
	EndIf
	
	_GEng_Sprite_Draw($oSpriteExplosion)
	_GEng_Sprite_Animate($oSpriteExplosion, $oAnimationExplosion)
	_GEng_Text_Draw($oText)

	;~ ---
	_GEng_ScrUpdate()
Until GuiGetMsg() = $GUI_EVENT_CLOSE 

_GEng_Shutdown()


Func _AnimationLoad()
	
	$oAnimationExplosion = _GEng_Anim_Create()
	For $i = 0 To $iExplosionFrameCount
		_GEng_Anim_FrameAdd($oAnimationExplosion, $oImageExplosion, 100, 100 * $i, 0, 20, 120)
	Next
	
EndFunc