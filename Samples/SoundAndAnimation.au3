#Include <Misc.au3>
#include <GUIConstantsEx.au3>
#include "..\GEngin.au3"

#Region https://www.autoitscript.com/autoit3/docs/libfunctions/_IsPressed.htm
 Local Const $SPACEBAR = 20
#EndRegion 

Global $scrW = 800, $scrH = 600, $iExplosionFrameCount = 10

_GEng_Start("Sound And Animation", $scrW, $scrH)
_GEng_Sound_Init()

$oImageExplosion = _GEng_ImageLoad("./res/images/sound_and_animation/explosion.png")
$oSoundExplosion = _GEng_Sound_Load("./res/sounds/explosion.wav")

_AnimationLoad()

$sprite1 = _GEng_Sprite_Create()
_GEng_Sprite_ImageSet($sprite1, $oImageExplosion)
_GEng_Sprite_OriginSet($sprite1, 90, 200)
_GEng_Sprite_SizeSet($sprite1, 128, 128)
_GEng_Sprite_SpeedSet($sprite1, 0, 0, 100)
_GEng_Sprite_AngleSpeedSet($sprite1, 0, 30)
_GEng_Sprite_InnertieSet($sprite1, 20)
_GEng_Sprite_AngleInnertieSet($sprite1, 60)
_GEng_Sprite_MasseSet($sprite1, 1)
_GEng_Sprite_PosSet($sprite1, $scrW - 200, $scrH / 2)

$oFont = _GEng_Font_Create("Comic Sans MS", 18)
$oText = _GEng_Text_Create($oFont, "* Spacebar => Start Explosion", $GEng_Color_Navy, 0, 0, $scrW, $scrH)

Do
	_GEng_ScrFlush($GEng_Color_White)
	;~ ---
	
	If (_IsPressed($SPACEBAR)) Then
		_GEng_Sound_Play($oSoundExplosion)
	EndIf
	
	_GEng_Sprite_Draw($sprite1)
	_GEng_Text_Draw($oText)

	;~ ---
	_GEng_ScrUpdate()
Until GuiGetMsg() = $GUI_EVENT_CLOSE 

_GEng_Shutdown()


Func _Animation($Param)
	
	Return True
EndFunc