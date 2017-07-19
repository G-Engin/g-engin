#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         RonildoSouza

 Script Function:


#ce ----------------------------------------------------------------------------

;File: Color

#Region ### Functions ###
#cs
- Main Functions
	_GEng_Color_ShowList()
	__GEng_Color_InvertColor($hexColor)
#ce
#EndRegion ###

;~ Color format (0xAARRGGBB)

Global Const $GEng_Color_Black 							= 0xFF000000
Global Const $GEng_Color_Navy 							= 0xFF000080
Global Const $GEng_Color_DarkBlue 						= 0xFF00008B
Global Const $GEng_Color_MediumBlue 					= 0xFF0000CD
Global Const $GEng_Color_Blue 							= 0xFF0000FF
Global Const $GEng_Color_DarkGreen 						= 0xFF006400
Global Const $GEng_Color_Green 							= 0xFF008000
Global Const $GEng_Color_Teal 							= 0xFF008080
Global Const $GEng_Color_DarkCyan 						= 0xFF008B8B
Global Const $GEng_Color_DeepSkyBlue 					= 0xFF00BFFF
Global Const $GEng_Color_DarkTurquoise 					= 0xFF00CED1
Global Const $GEng_Color_MediumSpringGreen 				= 0xFF00FA9A
Global Const $GEng_Color_Lime 							= 0xFF00FF00
Global Const $GEng_Color_SpringGreen 					= 0xFF00FF7F
Global Const $GEng_Color_Aqua 							= 0xFF00FFFF
Global Const $GEng_Color_Cyan 							= 0xFF00FFFF
Global Const $GEng_Color_MidnightBlue 					= 0xFF191970
Global Const $GEng_Color_DodgerBlue 					= 0xFF1E90FF
Global Const $GEng_Color_LightSeaGreen 					= 0xFF20B2AA
Global Const $GEng_Color_ForestGreen 					= 0xFF228B22
Global Const $GEng_Color_SeaGreen 						= 0xFF2E8B57
Global Const $GEng_Color_DarkSlateGray 					= 0xFF2F4F4F
Global Const $GEng_Color_LimeGreen 						= 0xFF32CD32
Global Const $GEng_Color_MediumSeaGreen 				= 0xFF3CB371
Global Const $GEng_Color_Turquoise 						= 0xFF40E0D0
Global Const $GEng_Color_RoyalBlue 						= 0xFF4169E1
Global Const $GEng_Color_SteelBlue 						= 0xFF4682B4
Global Const $GEng_Color_DarkSlateBlue 					= 0xFF483D8B
Global Const $GEng_Color_MediumTurquoise 				= 0xFF48D1CC
Global Const $GEng_Color_Indigo 						= 0xFF4B0082
Global Const $GEng_Color_DarkOliveGreen 				= 0xFF556B2F
Global Const $GEng_Color_CadetBlue 						= 0xFF5F9EA0
Global Const $GEng_Color_CornflowerBlue 				= 0xFF6495ED
Global Const $GEng_Color_MediumAquaMarine 				= 0xFF66CDAA
Global Const $GEng_Color_DimGray 						= 0xFF696969
Global Const $GEng_Color_SlateBlue 						= 0xFF6A5ACD
Global Const $GEng_Color_OliveDrab 						= 0xFF6B8E23
Global Const $GEng_Color_SlateGray 						= 0xFF708090
Global Const $GEng_Color_LightSlateGray 				= 0xFF778899
Global Const $GEng_Color_MediumSlateBlue 				= 0xFF7B68EE
Global Const $GEng_Color_LawnGreen 						= 0xFF7CFC00
Global Const $GEng_Color_Chartreuse 					= 0xFF7FFF00
Global Const $GEng_Color_Aquamarine 					= 0xFF7FFFD4
Global Const $GEng_Color_Maroon 						= 0xFF800000
Global Const $GEng_Color_Purple 						= 0xFF800080
Global Const $GEng_Color_Olive 							= 0xFF808000
Global Const $GEng_Color_Gray 							= 0xFF808080
Global Const $GEng_Color_SkyBlue 						= 0xFF87CEEB
Global Const $GEng_Color_LightSkyBlue 					= 0xFF87CEFA
Global Const $GEng_Color_BlueViolet 					= 0xFF8A2BE2
Global Const $GEng_Color_DarkRed 						= 0xFF8B0000
Global Const $GEng_Color_DarkMagenta 					= 0xFF8B008B
Global Const $GEng_Color_SaddleBrown 					= 0xFF8B4513
Global Const $GEng_Color_DarkSeaGreen 					= 0xFF8FBC8F
Global Const $GEng_Color_LightGreen 					= 0xFF90EE90
Global Const $GEng_Color_MediumPurple 					= 0xFF9370D8
Global Const $GEng_Color_DarkViolet 					= 0xFF9400D3
Global Const $GEng_Color_PaleGreen 						= 0xFF98FB98
Global Const $GEng_Color_DarkOrchid 					= 0xFF9932CC
Global Const $GEng_Color_YellowGreen 					= 0xFF9ACD32
Global Const $GEng_Color_Sienna 						= 0xFFA0522D
Global Const $GEng_Color_Brown 							= 0xFFA52A2A
Global Const $GEng_Color_DarkGray 						= 0xFFA9A9A9
Global Const $GEng_Color_LightBlue 						= 0xFFADD8E6
Global Const $GEng_Color_GreenYellow 					= 0xFFADFF2F
Global Const $GEng_Color_PaleTurquoise 					= 0xFFAFEEEE
Global Const $GEng_Color_LightSteelBlue 				= 0xFFB0C4DE
Global Const $GEng_Color_PowderBlue 					= 0xFFB0E0E6
Global Const $GEng_Color_FireBrick 						= 0xFFB22222
Global Const $GEng_Color_DarkGoldenRod 					= 0xFFB8860B
Global Const $GEng_Color_MediumOrchid 					= 0xFFBA55D3
Global Const $GEng_Color_RosyBrown 						= 0xFFBC8F8F
Global Const $GEng_Color_DarkKhaki 						= 0xFFBDB76B
Global Const $GEng_Color_Silver 						= 0xFFC0C0C0
Global Const $GEng_Color_MediumVioletRed 				= 0xFFC71585
Global Const $GEng_Color_IndianRed 						= 0xFFCD5C5C
Global Const $GEng_Color_Peru                           = 0xFFCD853F
Global Const $GEng_Color_Chocolate                      = 0xFFD2691E
Global Const $GEng_Color_Tan                            = 0xFFD2B48C
Global Const $GEng_Color_LightGrey                      = 0xFFD3D3D3
Global Const $GEng_Color_PaleVioletRed                  = 0xFFD87093
Global Const $GEng_Color_Thistle                        = 0xFFD8BFD8
Global Const $GEng_Color_Orchid                         = 0xFFDA70D6
Global Const $GEng_Color_GoldenRod                      = 0xFFDAA520
Global Const $GEng_Color_Crimson                        = 0xFFDC143C
Global Const $GEng_Color_Gainsboro                      = 0xFFDCDCDC
Global Const $GEng_Color_Plum                           = 0xFFDDA0DD
Global Const $GEng_Color_BurlyWood                      = 0xFFDEB887
Global Const $GEng_Color_LightCyan                      = 0xFFE0FFFF
Global Const $GEng_Color_Lavender                       = 0xFFE6E6FA
Global Const $GEng_Color_DarkSalmon                     = 0xFFE9967A
Global Const $GEng_Color_Violet                         = 0xFFEE82EE
Global Const $GEng_Color_PaleGoldenRod                  = 0xFFEEE8AA
Global Const $GEng_Color_LightCoral                     = 0xFFF08080
Global Const $GEng_Color_Khaki                          = 0xFFF0E68C
Global Const $GEng_Color_AliceBlue                      = 0xFFF0F8FF
Global Const $GEng_Color_HoneyDew                       = 0xFFF0FFF0
Global Const $GEng_Color_Azure                          = 0xFFF0FFFF
Global Const $GEng_Color_SandyBrown                     = 0xFFF4A460
Global Const $GEng_Color_Wheat                          = 0xFFF5DEB3
Global Const $GEng_Color_Beige                          = 0xFFF5F5DC
Global Const $GEng_Color_WhiteSmoke                     = 0xFFF5F5F5
Global Const $GEng_Color_MintCream                      = 0xFFF5FFFA
Global Const $GEng_Color_GhostWhite                     = 0xFFF8F8FF
Global Const $GEng_Color_Salmon                         = 0xFFFA8072
Global Const $GEng_Color_AntiqueWhite                   = 0xFFFAEBD7
Global Const $GEng_Color_Linen                          = 0xFFFAF0E6
Global Const $GEng_Color_LightGoldenRodYellow           = 0xFFFAFAD2
Global Const $GEng_Color_OldLace                        = 0xFFFDF5E6
Global Const $GEng_Color_Red                            = 0xFFFF0000
Global Const $GEng_Color_Fuchsia                        = 0xFFFF00FF
Global Const $GEng_Color_Magenta                        = 0xFFFF00FF
Global Const $GEng_Color_DeepPink                       = 0xFFFF1493
Global Const $GEng_Color_OrangeRed                      = 0xFFFF4500
Global Const $GEng_Color_Tomato                         = 0xFFFF6347
Global Const $GEng_Color_HotPink                        = 0xFFFF69B4
Global Const $GEng_Color_Coral                          = 0xFFFF7F50
Global Const $GEng_Color_Darkorange                     = 0xFFFF8C00
Global Const $GEng_Color_LightSalmon                    = 0xFFFFA07A
Global Const $GEng_Color_Orange                         = 0xFFFFA500
Global Const $GEng_Color_LightPink                      = 0xFFFFB6C1
Global Const $GEng_Color_Pink                           = 0xFFFFC0CB
Global Const $GEng_Color_Gold                           = 0xFFFFD700
Global Const $GEng_Color_PeachPuff                      = 0xFFFFDAB9
Global Const $GEng_Color_NavajoWhite                    = 0xFFFFDEAD
Global Const $GEng_Color_Moccasin                       = 0xFFFFE4B5
Global Const $GEng_Color_Bisque                         = 0xFFFFE4C4
Global Const $GEng_Color_MistyRose                      = 0xFFFFE4E1
Global Const $GEng_Color_BlanchedAlmond                 = 0xFFFFEBCD
Global Const $GEng_Color_PapayaWhip                     = 0xFFFFEFD5
Global Const $GEng_Color_LavenderBlush                  = 0xFFFFF0F5
Global Const $GEng_Color_SeaShell                       = 0xFFFFF5EE
Global Const $GEng_Color_Cornsilk                       = 0xFFFFF8DC
Global Const $GEng_Color_LemonChiffon                   = 0xFFFFFACD
Global Const $GEng_Color_FloralWhite                    = 0xFFFFFAF0
Global Const $GEng_Color_Snow                           = 0xFFFFFAFA
Global Const $GEng_Color_Yellow                         = 0xFFFFFF00
Global Const $GEng_Color_LightYellow                    = 0xFFFFFFE0
Global Const $GEng_Color_Ivory                          = 0xFFFFFFF0
Global Const $GEng_Color_White                          = 0xFFFFFFFF

; #FUNCTION# ;===============================================================================
; Name...........: _GEng_Color_ShowList
; Description ...: Afficher la liste des couleurs
; Syntax.........: _GEng_Color_ShowList()
; Parameters ....: Aucun
; Return values .: Aucun
; Author ........: RonildoSouza
; Remarks .......: 
; ;==========================================================================================
#cs
Function: _GEng_Color_ShowList
	Show List of colors

Prototype:
	> _GEng_Color_ShowList()

Parameters:
	Nothing

Returns:
	Nothing
#ce
Func _GEng_Color_ShowList()
    Local $aColors = [["$GEng_Color_Black", $GEng_Color_Black], _
                    ["$GEng_Color_Navy", $GEng_Color_Navy], _
                    ["$GEng_Color_DarkBlue", $GEng_Color_DarkBlue], _
                    ["$GEng_Color_MediumBlue", $GEng_Color_MediumBlue], _
                    ["$GEng_Color_Blue", $GEng_Color_Blue], _
                    ["$GEng_Color_DarkGreen", $GEng_Color_DarkGreen], _
                    ["$GEng_Color_Green", $GEng_Color_Green], _
                    ["$GEng_Color_Teal", $GEng_Color_Teal], _
                    ["$GEng_Color_DarkCyan", $GEng_Color_DarkCyan], _
                    ["$GEng_Color_DeepSkyBlue", $GEng_Color_DeepSkyBlue], _
                    ["$GEng_Color_DarkTurquoise", $GEng_Color_DarkTurquoise], _
                    ["$GEng_Color_MediumSpringGreen", $GEng_Color_MediumSpringGreen], _
                    ["$GEng_Color_Lime", $GEng_Color_Lime], _
                    ["$GEng_Color_SpringGreen", $GEng_Color_SpringGreen], _
                    ["$GEng_Color_Aqua", $GEng_Color_Aqua], _
                    ["$GEng_Color_Cyan", $GEng_Color_Cyan], _
                    ["$GEng_Color_MidnightBlue", $GEng_Color_MidnightBlue], _
                    ["$GEng_Color_DodgerBlue", $GEng_Color_DodgerBlue], _
                    ["$GEng_Color_LightSeaGreen", $GEng_Color_LightSeaGreen], _
                    ["$GEng_Color_ForestGreen", $GEng_Color_ForestGreen], _
                    ["$GEng_Color_SeaGreen", $GEng_Color_SeaGreen], _
                    ["$GEng_Color_DarkSlateGray", $GEng_Color_DarkSlateGray], _
                    ["$GEng_Color_LimeGreen", $GEng_Color_LimeGreen], _
                    ["$GEng_Color_MediumSeaGreen", $GEng_Color_MediumSeaGreen], _
                    ["$GEng_Color_Turquoise", $GEng_Color_Turquoise], _
                    ["$GEng_Color_RoyalBlue", $GEng_Color_RoyalBlue], _
                    ["$GEng_Color_SteelBlue", $GEng_Color_SteelBlue], _
                    ["$GEng_Color_DarkSlateBlue", $GEng_Color_DarkSlateBlue], _
                    ["$GEng_Color_MediumTurquoise", $GEng_Color_MediumTurquoise], _
                    ["$GEng_Color_Indigo", $GEng_Color_Indigo], _
                    ["$GEng_Color_DarkOliveGreen", $GEng_Color_DarkOliveGreen], _
                    ["$GEng_Color_CadetBlue", $GEng_Color_CadetBlue], _
                    ["$GEng_Color_CornflowerBlue", $GEng_Color_CornflowerBlue], _
                    ["$GEng_Color_MediumAquaMarine", $GEng_Color_MediumAquaMarine], _
                    ["$GEng_Color_DimGray", $GEng_Color_DimGray], _
                    ["$GEng_Color_SlateBlue", $GEng_Color_SlateBlue], _
                    ["$GEng_Color_OliveDrab", $GEng_Color_OliveDrab], _
                    ["$GEng_Color_SlateGray", $GEng_Color_SlateGray], _
                    ["$GEng_Color_LightSlateGray", $GEng_Color_LightSlateGray], _
                    ["$GEng_Color_MediumSlateBlue", $GEng_Color_MediumSlateBlue], _
                    ["$GEng_Color_LawnGreen", $GEng_Color_LawnGreen], _
                    ["$GEng_Color_Chartreuse", $GEng_Color_Chartreuse], _
                    ["$GEng_Color_Aquamarine", $GEng_Color_Aquamarine], _
                    ["$GEng_Color_Maroon", $GEng_Color_Maroon], _
                    ["$GEng_Color_Purple", $GEng_Color_Purple], _
                    ["$GEng_Color_Olive", $GEng_Color_Olive], _
                    ["$GEng_Color_Gray", $GEng_Color_Gray], _
                    ["$GEng_Color_SkyBlue", $GEng_Color_SkyBlue], _
                    ["$GEng_Color_LightSkyBlue", $GEng_Color_LightSkyBlue], _
                    ["$GEng_Color_BlueViolet", $GEng_Color_BlueViolet], _
                    ["$GEng_Color_DarkRed", $GEng_Color_DarkRed], _
                    ["$GEng_Color_DarkMagenta", $GEng_Color_DarkMagenta], _
                    ["$GEng_Color_SaddleBrown", $GEng_Color_SaddleBrown], _
                    ["$GEng_Color_DarkSeaGreen", $GEng_Color_DarkSeaGreen], _
                    ["$GEng_Color_LightGreen", $GEng_Color_LightGreen], _
                    ["$GEng_Color_MediumPurple", $GEng_Color_MediumPurple], _
                    ["$GEng_Color_DarkViolet", $GEng_Color_DarkViolet], _
                    ["$GEng_Color_PaleGreen", $GEng_Color_PaleGreen], _
                    ["$GEng_Color_DarkOrchid", $GEng_Color_DarkOrchid], _
                    ["$GEng_Color_YellowGreen", $GEng_Color_YellowGreen], _
                    ["$GEng_Color_Sienna", $GEng_Color_Sienna], _
                    ["$GEng_Color_Brown", $GEng_Color_Brown], _
                    ["$GEng_Color_DarkGray", $GEng_Color_DarkGray], _
                    ["$GEng_Color_LightBlue", $GEng_Color_LightBlue], _
                    ["$GEng_Color_GreenYellow", $GEng_Color_GreenYellow], _
                    ["$GEng_Color_PaleTurquoise", $GEng_Color_PaleTurquoise], _
                    ["$GEng_Color_LightSteelBlue", $GEng_Color_LightSteelBlue], _
                    ["$GEng_Color_PowderBlue", $GEng_Color_PowderBlue], _
                    ["$GEng_Color_FireBrick", $GEng_Color_FireBrick], _
                    ["$GEng_Color_DarkGoldenRod", $GEng_Color_DarkGoldenRod], _
                    ["$GEng_Color_MediumOrchid", $GEng_Color_MediumOrchid], _
                    ["$GEng_Color_RosyBrown", $GEng_Color_RosyBrown], _
                    ["$GEng_Color_DarkKhaki", $GEng_Color_DarkKhaki], _
                    ["$GEng_Color_Silver", $GEng_Color_Silver], _
                    ["$GEng_Color_MediumVioletRed", $GEng_Color_MediumVioletRed], _
                    ["$GEng_Color_IndianRed", $GEng_Color_IndianRed], _
                    ["$GEng_Color_Peru", $GEng_Color_Peru], _
                    ["$GEng_Color_Chocolate", $GEng_Color_Chocolate], _
                    ["$GEng_Color_Tan", $GEng_Color_Tan], _
                    ["$GEng_Color_LightGrey", $GEng_Color_LightGrey], _
                    ["$GEng_Color_PaleVioletRed", $GEng_Color_PaleVioletRed], _
                    ["$GEng_Color_Thistle", $GEng_Color_Thistle], _
                    ["$GEng_Color_Orchid", $GEng_Color_Orchid], _
                    ["$GEng_Color_GoldenRod", $GEng_Color_GoldenRod], _
                    ["$GEng_Color_Crimson", $GEng_Color_Crimson], _
                    ["$GEng_Color_Gainsboro", $GEng_Color_Gainsboro], _
                    ["$GEng_Color_Plum", $GEng_Color_Plum], _
                    ["$GEng_Color_BurlyWood", $GEng_Color_BurlyWood], _
                    ["$GEng_Color_LightCyan", $GEng_Color_LightCyan], _
                    ["$GEng_Color_Lavender", $GEng_Color_Lavender], _
                    ["$GEng_Color_DarkSalmon", $GEng_Color_DarkSalmon], _
                    ["$GEng_Color_Violet", $GEng_Color_Violet], _
                    ["$GEng_Color_PaleGoldenRod", $GEng_Color_PaleGoldenRod], _
                    ["$GEng_Color_LightCoral", $GEng_Color_LightCoral], _
                    ["$GEng_Color_Khaki", $GEng_Color_Khaki], _
                    ["$GEng_Color_AliceBlue", $GEng_Color_AliceBlue], _
                    ["$GEng_Color_HoneyDew", $GEng_Color_HoneyDew], _
                    ["$GEng_Color_Azure", $GEng_Color_Azure], _
                    ["$GEng_Color_SandyBrown", $GEng_Color_SandyBrown], _
                    ["$GEng_Color_Wheat", $GEng_Color_Wheat], _
                    ["$GEng_Color_Beige", $GEng_Color_Beige], _
                    ["$GEng_Color_WhiteSmoke", $GEng_Color_WhiteSmoke], _
                    ["$GEng_Color_MintCream", $GEng_Color_MintCream], _
                    ["$GEng_Color_GhostWhite", $GEng_Color_GhostWhite], _
                    ["$GEng_Color_Salmon", $GEng_Color_Salmon], _
                    ["$GEng_Color_AntiqueWhite", $GEng_Color_AntiqueWhite], _
                    ["$GEng_Color_Linen", $GEng_Color_Linen], _
                    ["$GEng_Color_LightGoldenRodYellow", $GEng_Color_LightGoldenRodYellow], _
                    ["$GEng_Color_OldLace", $GEng_Color_OldLace], _
                    ["$GEng_Color_Red", $GEng_Color_Red], _
                    ["$GEng_Color_Fuchsia", $GEng_Color_Fuchsia], _
                    ["$GEng_Color_Magenta", $GEng_Color_Magenta], _
                    ["$GEng_Color_DeepPink", $GEng_Color_DeepPink], _
                    ["$GEng_Color_OrangeRed", $GEng_Color_OrangeRed], _
                    ["$GEng_Color_Tomato", $GEng_Color_Tomato], _
                    ["$GEng_Color_HotPink", $GEng_Color_HotPink], _
                    ["$GEng_Color_Coral", $GEng_Color_Coral], _
                    ["$GEng_Color_Darkorange", $GEng_Color_Darkorange], _
                    ["$GEng_Color_LightSalmon", $GEng_Color_LightSalmon], _
                    ["$GEng_Color_Orange", $GEng_Color_Orange], _
                    ["$GEng_Color_LightPink", $GEng_Color_LightPink], _
                    ["$GEng_Color_Pink", $GEng_Color_Pink], _
                    ["$GEng_Color_Gold", $GEng_Color_Gold], _
                    ["$GEng_Color_PeachPuff", $GEng_Color_PeachPuff], _
                    ["$GEng_Color_NavajoWhite", $GEng_Color_NavajoWhite], _
                    ["$GEng_Color_Moccasin", $GEng_Color_Moccasin], _
                    ["$GEng_Color_Bisque", $GEng_Color_Bisque], _
                    ["$GEng_Color_MistyRose", $GEng_Color_MistyRose], _
                    ["$GEng_Color_BlanchedAlmond", $GEng_Color_BlanchedAlmond], _
                    ["$GEng_Color_PapayaWhip", $GEng_Color_PapayaWhip], _
                    ["$GEng_Color_LavenderBlush", $GEng_Color_LavenderBlush], _
                    ["$GEng_Color_SeaShell", $GEng_Color_SeaShell], _
                    ["$GEng_Color_Cornsilk", $GEng_Color_Cornsilk], _
                    ["$GEng_Color_LemonChiffon", $GEng_Color_LemonChiffon], _
                    ["$GEng_Color_FloralWhite", $GEng_Color_FloralWhite], _
                    ["$GEng_Color_Snow", $GEng_Color_Snow], _
                    ["$GEng_Color_Yellow", $GEng_Color_Yellow], _
                    ["$GEng_Color_LightYellow", $GEng_Color_LightYellow], _
                    ["$GEng_Color_Ivory", $GEng_Color_Ivory], _
                    ["$GEng_Color_White", $GEng_Color_White]]

    GUICreate("Colors", 450, 450)
    $colors = GUICtrlCreateListView("Name of Variable|Color", 8, 8, 444, 450)
    GUICtrlSendMsg($colors, 0x101E, 0, 340)

    For $i = 0 to (UBound($aColors) - 1)
        GUICtrlCreateListViewItem($aColors[$i][0] & "|0x" & Hex($aColors[$i][1], 8), $colors)
        GUICtrlSetBkColor(-1, "0x" & Hex($aColors[$i][1], 6))
        GUICtrlSetColor(-1, __GEng_Color_InvertColor("0x" & Hex($aColors[$i][1], 6)))
    Next

    GUISetState(@SW_SHOW)
    While 1
        Switch GUIGetMsg()
            Case -3 ;~ $GUI_EVENT_CLOSE
                ExitLoop
        EndSwitch
    WEnd
EndFunc

; ==============================================================
; ### Internals
; ==============================================================
Func __GEng_Color_InvertColor($hexColor)
    $color = ($hexColor > 0xFFFFFF / 2) ? 0x000000 : 0xFFFFFF
    Return $color
EndFunc

; ==============================================================
; ### Test
; ==============================================================
;~ _GEng_Color_ShowList()