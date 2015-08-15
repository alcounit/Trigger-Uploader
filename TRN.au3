;*****************************************
;TRN.au3 by Danil
;Created with ISN AutoIt Studio v. 0.97 BETA
;*****************************************

#include <Array.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <Crypt.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>
#include <GuiEdit.au3>
#include <GuiTab.au3>
#include <GuiListView.au3>
#include <GuiMenu.au3>
#include <GuiComboBox.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <WinAPI.au3>
#include "lib\connect.au3"



Global $getStorage = RegRead("HKEY_CURRENT_USER\Software\TRNv2\Config", "storage"), $workIcon

If @error Then
	;Delete
	If(FileExists(@ScriptDir & "\data\data.ini")) Then
		$getStorage = @ScriptDir & "\data"
		IniWrite(@ScriptDir & "\data\data.ini", "Config", "storage", @ScriptDir & "\data")
		;RegWrite("HKEY_CURRENT_USER\Software\TRNv2\Config", @ScriptDir & "\data")
	Else
		$getStorage = "\\10.16.2.3\QA_Help\Plugin\TRN"
	EndIf

	RegWrite("HKEY_CURRENT_USER\Software\TRNv2\UserData", "username", "REG_SZ", "")
	RegWrite("HKEY_CURRENT_USER\Software\TRNv2\UserData", "password", "REG_SZ", "")

	RegWrite("HKEY_CURRENT_USER\Software\TRNv2\UserData\Controls", "LastGame", "REG_SZ", "")
	RegWrite("HKEY_CURRENT_USER\Software\TRNv2\UserData\Controls", "LastServer", "REG_SZ", "")
	RegWrite("HKEY_CURRENT_USER\Software\TRNv2\UserData\Controls", "Player", "REG_SZ", "")

	RegWrite("HKEY_CURRENT_USER\Software\TRNv2\UserData\RNGs", "1", "REG_SZ", "Default Tab")
	RegWrite("HKEY_CURRENT_USER\Software\TRNv2\UserData\RNGs\1", "1", "REG_MULTI_SZ", "")
	;Delete

;~ 	RegWrite("HKEY_CURRENT_USER\Software\TRNv2\UserData", "username", "REG_SZ", RegRead("HKEY_CURRENT_USER\Software\TRN\Settings", "u_name"))
;~ 	RegWrite("HKEY_CURRENT_USER\Software\TRNv2\UserData", "password", "REG_SZ", RegRead("HKEY_CURRENT_USER\Software\TRN\Settings", "u_pass"))
;~
;~ 	RegWrite("HKEY_CURRENT_USER\Software\TRNv2\UserData\Controls", "LastGame", "REG_SZ", RegRead("HKEY_CURRENT_USER\Software\TRN\Settings", "last_game"))
;~ 	RegWrite("HKEY_CURRENT_USER\Software\TRNv2\UserData\Controls", "LastServer", "REG_SZ", RegRead("HKEY_CURRENT_USER\Software\TRN\Settings", "last_server"))
;~ 	RegWrite("HKEY_CURRENT_USER\Software\TRNv2\UserData\Controls", "Player", "REG_SZ", RegRead("HKEY_CURRENT_USER\Software\TRN\Settings", "u_player"))
;~
;~ 	RegWrite("HKEY_CURRENT_USER\Software\TRNv2\UserData\RNGs", "1", "REG_SZ", RegRead("HKEY_CURRENT_USER\Software\TRN\Settings", "last_game"))
;~ 	RegWrite("HKEY_CURRENT_USER\Software\TRNv2\UserData\RNGs\1", "1", "REG_MULTI_SZ", RegRead("HKEY_CURRENT_USER\Software\TRN\Settings", "rng_data"))

EndIf

Local $getVersion = "v2.0.06";RegRead("HKEY_CURRENT_USER\Software\TRNv2\", "version")

_updater()

_MainWindow()

Func _MainWindow()

	Local $statusBarParts[3] = [27, 645, -1]

	Global $username = RegRead("HKEY_CURRENT_USER\Software\TRNv2\UserData", "username")

	Global $password = RegRead("HKEY_CURRENT_USER\Software\TRNv2\UserData", "password")

	Local $getGameArray = _regValToArray("HKEY_CURRENT_USER\Software\TRNv2\Games")

	Local $getServersArray = _regValToArray("HKEY_CURRENT_USER\Software\TRNv2\Servers")

	Local $getLastServer = RegRead("HKEY_CURRENT_USER\Software\TRNv2\UserData\Controls", "LastServer")

	Local $getLastGame = RegRead("HKEY_CURRENT_USER\Software\TRNv2\UserData\Controls", "LastGame")

	Local $getPlayer = RegRead("HKEY_CURRENT_USER\Software\TRNv2\UserData\Controls", "Player")

	Local $getTabsArray = _regValToArray("HKEY_CURRENT_USER\Software\TRNv2\UserData\RNGs")

	;_ArrayDisplay($getTabsArray)

	;Local $onTheTopStatus = RegRead("HKEY_CURRENT_USER\Software\TRNv2\UserData\Controls", "OnTheTop")

	$getMainTabName = RegRead("HKEY_CURRENT_USER\Software\TRNv2\UserData\RNGs", "1")
	$getMainTabData = RegRead("HKEY_CURRENT_USER\Software\TRNv2\UserData\RNGs\1", "1")

	$mainWindow = GUICreate("Trigger Uploader " & $getVersion, 709, 665, -1, -1)
	$mainWindow_Menu1 = GUICtrlCreateMenu("&File")
	$mainWindow_Menu_OpenFile = GUICtrlCreateMenuItem("Open File", $mainWindow_Menu1)
	;$mainWindow_Menu_OpenRemoteFile = GUICtrlCreateMenuItem("Open Remote File", $mainWindow_Menu1)
	;GUICtrlSetState($mainWindow_Menu_OpenRemoteFile, $GUI_DISABLE)
	GUICtrlCreateMenuItem("", $mainWindow_Menu1, 2)
	$mainWindow_Menu_ExitProgramm = GUICtrlCreateMenuItem("Exit Programm", $mainWindow_Menu1)
	$mainWindow_Menu2 = GUICtrlCreateMenu("Edit")
	$mainWindow_Menu_Credentials = GUICtrlCreateMenuItem("Credentials", $mainWindow_Menu2)
	$mainWindow_Menu_Games = GUICtrlCreateMenuItem("Games", $mainWindow_Menu2)
	$mainWindow_Menu_ViewPredefinedRNG = GUICtrlCreateMenu("Predefined RNG's")
	$mainWindow_Menu_ViewPredefinedRNG_Add = GUICtrlCreateMenuItem("Add", $mainWindow_Menu_ViewPredefinedRNG)
	$mainWindow_Menu_ViewPredefinedRNG_View = GUICtrlCreateMenuItem("View and Use", $mainWindow_Menu_ViewPredefinedRNG)
	$mainWindow_Group_Control = GUICtrlCreateGroup("Control", 16, 8, 673, 65)
	$mainWindow_Label_Server = GUICtrlCreateLabel("Server", 40, 32, 35, 17)

	If IsArray($getServersArray) Then

		_ArraySort($getServersArray, 0, 0, 0, 1)

		$mainWindow_Combo_Server = GUICtrlCreateCombo($getLastServer, 80, 32, 137, 25, $CBS_DROPDOWNLIST)

		For $i = 1 to Ubound($getServersArray, 1) -1
			GUICtrlSetData($mainWindow_Combo_Server, $getServersArray[$i][1])
		Next

	Else

		$mainWindow_Combo_Server = GUICtrlCreateCombo($getLastServer, 80, 32, 137, 25, $CBS_DROPDOWNLIST)

	EndIf

	$mainWindow_Label_Game = GUICtrlCreateLabel("Game", 240, 32, 32, 17)

	If IsArray($getGameArray) Then

		_ArraySort($getGameArray, 0, 0, 0, 1)

		$mainWindow_Combo_Game = GUICtrlCreateCombo($getLastGame, 288, 32, 185, 25)
		For $i = 1 to Ubound($getGameArray, 1) -1
			GUICtrlSetData($mainWindow_Combo_Game, $getGameArray[$i][1])
		Next


	Else
		$mainWindow_Combo_Game = GUICtrlCreateCombo($getLastGame, 144, 124, 177, 25, $CBS_DROPDOWNLIST)
	EndIf

	$mainWindow_Label_Player = GUICtrlCreateLabel("Player", 496, 32, 33, 17)
	$mainWindow_Input_Player = GUICtrlCreateInput($getPlayer, 552, 32, 113, 21)
	Global $mainWindow_Tab = GUICtrlCreateTab(16, 80, 640, 20)

	If IsArray($getTabsArray) Then

		For $i = 1 to Ubound($getTabsArray, 1) -1
			_GUICtrlTab_InsertItem($mainWindow_Tab, $i, $getTabsArray[$i][1] & " [" & $getTabsArray[$i][0] & "]")
		Next

	EndIf

	$mainWindow_Tab_Menu = GUICtrlCreateContextMenu($mainWindow_Tab)
	$mainWindow_Tab_Menu_New = GUICtrlCreateMenuItem("New Tab", $mainWindow_Tab_Menu)
	$mainWindow_Tab_Menu_Rename = GUICtrlCreateMenuItem("Rename Tab", $mainWindow_Tab_Menu)
	$mainWindow_Tab_Menu_Close = GUICtrlCreateMenuItem("Close Tab", $mainWindow_Tab_Menu)

	$mainWindow_Tab_Button_New = GUICtrlCreateButton("+", 672, 80, 17, 17)

	Global $mainWindow_Edit = GUICtrlCreateEdit("", 16, 100, 673, 457, BitOR($ES_AUTOVSCROLL,$ES_AUTOHSCROLL,$ES_WANTRETURN,$WS_VSCROLL))
	GUICtrlSetData($mainWindow_Edit, $getMainTabData)
	GUICtrlCreateTabItem("")
	Global $mainWindow_Label_Log = GUICtrlCreateLabel("Please fill form data", 245, 580, 215, 17, $SS_CENTER)
	Global $mainWindow_Button_Cancel = GUICtrlCreateButton("Clean", 16, 576, 105, 33)
	Global $mainWindow_Button_Send = GUICtrlCreateButton("Send", 580, 576, 105, 33)

	GUICtrlSetFont($mainWindow_Label_Log, 8, 800, 0, "MS Sans Serif")
	GUICtrlSetColor($mainWindow_Label_Log, 0x008080)

	GUISetState()

	;$ahIcons = _WinAPI_LoadShell32Icon(9) ;Network mode
	$ahIcons = _WinAPI_LoadShell32Icon($workIcon) ;Local mode
	;network

	Global $mainWindow_StatusBar = _GUICtrlStatusBar_Create($mainWindow, $statusBarParts)
	$mainWindow_StatusBar_Ckeckbox = GUICtrlCreateCheckbox(" On top", 0, 0)
	Global $mainWindow_StatusBar_Ckeckbox_Handle = GUICtrlGetHandle($mainWindow_StatusBar_Ckeckbox)

	If GUICtrlRead($mainWindow_Combo_Server) <> "" And GUICtrlRead($mainWindow_Combo_Game) Then
		_GUICtrlStatusBar_SetText($mainWindow_StatusBar, "Current server: " & GUICtrlRead($mainWindow_Combo_Server) & ". Current game: " & GUICtrlRead($mainWindow_Combo_Game), 1)
	EndIf

	Global $mainWindow_StatusBar_Dummy = GUICtrlCreateDummy()
	_GUICtrlStatusBar_SetIcon($mainWindow_StatusBar, 0, $ahIcons)
	_GUICtrlStatusBar_EmbedControl($mainWindow_StatusBar, 2, $mainWindow_StatusBar_Ckeckbox_Handle)

	$wProcNew = DllCallbackRegister("_StatusBarWindowProc", "int", "hwnd;uint;wparam;lparam")
	Global $wProcOld = _WinAPI_SetWindowLong($mainWindow_StatusBar, $GWL_WNDPROC, DllCallbackGetPtr($wProcNew))

	_Crypt_Startup()

	;$w_editBoxProcNew = DllCallbackRegister("_MyWindowProc", "ptr", "hwnd;uint;long;ptr")
	;$w_editBoxProcOld = _WinAPI_SetWindowLong(GUICtrlGetHandle($mainWindow_Edit), $GWL_WNDPROC, DllCallbackGetPtr($w_editBoxProcNew))

	AdlibRegister("_autoSave", 300)

	$hSelAll = GUICtrlCreateDummy()

	Global $aAccelKeys[1][2]=[["^a", $hSelAll]]
	GUISetAccelerators($aAccelKeys)

	;ConsoleWrite($onTheTopStatus)

	_checkOnTopStatus($mainWindow, $mainWindow_StatusBar_Ckeckbox)

;~ 	If RegRead("HKEY_CURRENT_USER\Software\TRNv2\UserData\Controls", "OnTheTop") == 0 Then
;~ 		WinSetOnTop($mainWindow, "", 0)
;~ 		GUICtrlSetState ($mainWindow_StatusBar_Ckeckbox, 4)
;~ 	Else;If RegRead("HKEY_CURRENT_USER\Software\TRNv2\UserData\Controls", "OnTheTop") == 1 Then
;~ 		WinSetOnTop($mainWindow, "", 1)
;~ 		GUICtrlSetState ($mainWindow_StatusBar_Ckeckbox, 1)
;~ 	EndIf

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg

			Case -3
				;Delete StatusBar window callback function
				_WinAPI_SetWindowLong($mainWindow_StatusBar, $GWL_WNDPROC, $wProcOld)
				;_WinAPI_SetWindowLong(GUICtrlGetHandle($mainWindow_Edit), $GWL_WNDPROC, DllCallbackGetPtr($w_editBoxProcNew))
				DllCallbackFree($wProcNew)
				;DllCallbackFree($w_editBoxProcOld)
				_Crypt_Shutdown()
				Exit 0

			Case $hSelAll
				_SelectAll($mainWindow_Edit)

			Case $GUI_EVENT_CLOSE, $mainWindow_Menu_ExitProgramm
				Exit

			Case $GUI_EVENT_RESTORE
				_GUICtrlStatusBar_EmbedControl($mainWindow_StatusBar, 2, $mainWindow_StatusBar_Ckeckbox_Handle)

			Case $mainWindow_Menu_OpenFile
				$sFileOpenDialog = FileOpenDialog("Select File", @DesktopDir & "\", "Text (*.txt)");, $FD_FILEMUSTEXIST)
				If Not @error Then
					$rFileRead = FileRead ($sFileOpenDialog)
					GUICtrlSetData($mainWindow_Edit, $rFileRead)
					FileClose($sFileOpenDialog)
				EndIf

			Case $mainWindow_Menu_Credentials
				GUISetState(@SW_DISABLE, $mainWindow)
				_userCredentials()
				GUISetState(@SW_ENABLE, $mainWindow)
				WinActivate($mainWindow)

			Case $mainWindow_Menu_Games
				GUISetState(@SW_DISABLE, $mainWindow)
				_gameList($getStorage, $mainWindow_Combo_Game)
				GUISetState(@SW_ENABLE, $mainWindow)
				WinActivate($mainWindow)

			Case $mainWindow_Menu_ViewPredefinedRNG_Add
				GUISetState(@SW_DISABLE, $mainWindow)
				_newCombination($getStorage, $getGameArray, GUICtrlRead($mainWindow_Combo_Game))
				GUISetState(@SW_ENABLE, $mainWindow)
				WinActivate($mainWindow)

			Case $mainWindow_Menu_ViewPredefinedRNG_View
				GUISetState(@SW_DISABLE, $mainWindow)
				_viewCombination()
				GUISetState(@SW_ENABLE, $mainWindow)
				WinActivate($mainWindow)

			Case $mainWindow_StatusBar_Dummy
				_setOnTopStatus($mainWindow, $mainWindow_StatusBar_Ckeckbox)

			Case $mainWindow_Tab
				$tempTab = 0
				$tempLen = 0
				_getTabData($mainWindow_Tab, $mainWindow_Edit)

			Case $mainWindow_Tab_Menu_New, $mainWindow_Tab_Button_New
				$tabName = InputBox("Enter Tab Name", "Name:", "", "", -1, 150, Default, Default)
				If $tabName <> "" Then
					_newTabItem($tabName, $mainWindow_Tab, $mainWindow_Edit)
				Else
					MsgBox(64, "Warning", "Name field can't be empty")
				EndIf

			Case $mainWindow_Tab_Menu_Rename
				$tabName = InputBox("Enter New Tab Name", "Name:", "", "", -1, 150, Default, Default)
				If $tabName <> "" Then
					_renameTabItem($tabName, $mainWindow_Tab)
				EndIf

			Case $mainWindow_Tab_Menu_Close
				_deleteTabItem($mainWindow_Tab, $mainWindow_Edit)

			Case $mainWindow_Combo_Server
				RegWrite("HKEY_CURRENT_USER\Software\TRNv2\UserData\Controls", "LastServer", "REG_SZ", GUICtrlRead($mainWindow_Combo_Server))
				_GUICtrlStatusBar_SetText($mainWindow_StatusBar, "Current server: " & GUICtrlRead($mainWindow_Combo_Server) & ". Current game: " & GUICtrlRead($mainWindow_Combo_Game), 1)

			Case $mainWindow_Combo_Game
				RegWrite("HKEY_CURRENT_USER\Software\TRNv2\UserData\Controls", "LastGame", "REG_SZ", GUICtrlRead($mainWindow_Combo_Game))
				_GUICtrlStatusBar_SetText($mainWindow_StatusBar, "Current server: " & GUICtrlRead($mainWindow_Combo_Server) & ". Current game: " & GUICtrlRead($mainWindow_Combo_Game), 1)

			Case $mainWindow_Input_Player
				RegWrite("HKEY_CURRENT_USER\Software\TRNv2\UserData\Controls", "Player", "REG_SZ", GUICtrlRead($mainWindow_Input_Player))

			Case $mainWindow_Button_Send
				_sendData(GUICtrlRead($mainWindow_Combo_Server), GUICtrlRead($mainWindow_Combo_Game), GUICtrlRead($mainWindow_Input_Player), GUICtrlRead($mainWindow_Edit))

			Case $mainWindow_Button_Cancel
				_removeRng(GUICtrlRead($mainWindow_Combo_Server), GUICtrlRead($mainWindow_Combo_Game), GUICtrlRead($mainWindow_Input_Player))

		EndSwitch
	WEnd
	_WinAPI_DestroyIcon($ahIcons)
	GUIDelete($mainWindow)

EndFunc

Func _SelectAll($editBox)

	_GUICtrlEdit_SetSel($editBox,0,-1) ;See GUIEdit.au3 for info on the parameters to this function

EndFunc

Func _StatusBarWindowProc($hWnd, $nMsg, $wParam, $lParam)

	Local $nNotifyCode = BitShift($wParam, 16)
	Local $nID = BitAND($wParam, 0x0000FFFF)

	Switch $nMsg
		Case $WM_COMMAND
			Switch $lParam
				Case $mainWindow_StatusBar_Ckeckbox_Handle
					Switch $nNotifyCode
						Case $BN_CLICKED
							GUICtrlSendToDummy($mainWindow_StatusBar_Dummy)
					EndSwitch
			EndSwitch
	EndSwitch
	Return _WinAPI_CallWindowProc($wProcOld, $hWnd, $nMsg, $wParam, $lParam)

EndFunc

Func _regValToArray($regKey)
	$i = 1
	Local $regArray[1][2]
	While 1
		$rValue = RegEnumVal($regKey, $i)
		If Not @error Then

			$rList = RegRead($regKey, $rValue)

				ReDim $regArray[UBound($regArray) + 1][2]
				$regArray[UBound($regArray) -1][0] = $rValue
				$regArray[UBound($regArray) -1][1] = $rList

			$i = $i + 1
		Else
			Return $regArray
		EndIf
	WEnd
EndFunc

Func _regKeyToArray($regKey)
	$i = 1
	Local $regArray[1]
	While 1
		$rValue = RegEnumKey($regKey, $i)
		If Not @error Then

			$rList = RegRead($regKey, $rValue)

				ReDim $regArray[UBound($regArray) + 1]
				$regArray[UBound($regArray) -1] = $rValue

			$i = $i + 1
		Else
			Return $regArray
		EndIf
	WEnd
EndFunc

Func _lockButtons($sendButton, $cancelButton)
	GUICtrlSetState($mainWindow_Button_Cancel, $GUI_DISABLE)
	GUICtrlSetState($mainWindow_Button_Send, $GUI_DISABLE)
EndFunc

Func _unlockButtons($sendButton, $cancelButton)
	GUICtrlSetState($mainWindow_Button_Cancel, $GUI_ENABLE)
	GUICtrlSetState($mainWindow_Button_Send, $GUI_ENABLE)
EndFunc

Func _newTabItem($tabName, $tabHandler, $editHandler)
	$tabsCounter = _regValToArray("HKEY_CURRENT_USER\Software\TRNv2\UserData\RNGs")
	$lastTab = _ArrayMax($tabsCounter, 1, 1)
	$lastTab = $lastTab + 1
	$tabName = StringRegExpReplace(StringRegExpReplace($tabName, "\[", ""), "\]", "")
	$newTab = _GUICtrlTab_InsertItem($tabHandler, $lastTab, $tabName & " [" & $lastTab & "]")
	_GUICtrlTab_SetCurFocus($tabHandler, $newTab)
	RegWrite("HKEY_CURRENT_USER\Software\TRNv2\UserData\RNGs", $lastTab, "REG_SZ", $tabName)
	RegWrite("HKEY_CURRENT_USER\Software\TRNv2\UserData\RNGs" &  "\" & $lastTab, $lastTab, "REG_MULTI_SZ", "")
	GUICtrlSetData($editHandler, "")

EndFunc

Func _renameTabItem($tabName, $tabHandler)
	$currentTab = _GUICtrlTab_GetCurFocus($tabHandler)
	$tabText = _GUICtrlTab_GetItemText ($tabHandler, $currentTab)
	$tabIndex = StringRegExpReplace(StringRegExpReplace($tabText, "^.{1,}\[", ""), "\]", "")
	ConsoleWrite($tabIndex)
	RegWrite("HKEY_CURRENT_USER\Software\TRNv2\UserData\RNGs", $tabIndex, "REG_SZ", $tabName)
	_GUICtrlTab_SetItemText($tabHandler, $currentTab, $tabName & " [" & $tabIndex & "]")
EndFunc

Func _deleteTabItem($tabHandler, $editHandler)

	$currentTab = _GUICtrlTab_GetCurFocus($tabHandler)
	ConsoleWrite($currentTab)
	If $currentTab <> 0 Then

		$tabName = StringRegExpReplace(_GUICtrlTab_GetItemText($tabHandler, $currentTab), " \[[0-9]{1,}\]", "")
		$confirmDeleteTab = MsgBox(4100, "Close tab?", 'Are you shure you want close tab "' & $tabName & '"')
		If $confirmDeleteTab == 6 Then
			$tabText = _GUICtrlTab_GetItemText ($tabHandler, $currentTab)
			$tabIndex = StringRegExpReplace(StringRegExpReplace($tabText, "^.{1,}\[", ""), "\]", "")
			_GUICtrlTab_DeleteItem($tabHandler, $currentTab)
			RegDelete("HKEY_CURRENT_USER\Software\TRNv2\UserData\RNGs", $tabIndex)
			RegDelete("HKEY_CURRENT_USER\Software\TRNv2\UserData\RNGs" &  "\" & $tabIndex)
			_GUICtrlTab_SetCurFocus($tabHandler, 0)
			GUICtrlSetData($editHandler, RegRead("HKEY_CURRENT_USER\Software\TRNv2\UserData\RNGs\1", "1"))
		EndIf

	Else
		MsgBox($MB_SYSTEMMODAL, "Ooops", "Sorry this is default tab it can't be closed", 10)
	EndIf

EndFunc

Func _getTabData($tabHandler, $editHandler)
	$currentTab = _GUICtrlTab_GetCurFocus($tabHandler)
	$tabText = _GUICtrlTab_GetItemText ($tabHandler, $currentTab)
	$tabIndex = StringRegExpReplace(StringRegExpReplace($tabText, "^.{1,}\[", ""), "\]", "")
	GUICtrlSetData($editHandler, RegRead("HKEY_CURRENT_USER\Software\TRNv2\UserData\RNGs" &  "\" & $tabIndex, $tabIndex))
EndFunc

Func _autoSave()

	Local Static $tempTab = 0
	Local Static $tempLen = _Crypt_HashData(0, $CALG_MD5)

	;ConsoleWrite($tempLen & @CRLF)

	;$currentTab = _GUICtrlTab_GetCurFocus($mainWindow_Tab)
	;$tabText = _GUICtrlTab_GetItemText ($mainWindow_Tab, _GUICtrlTab_GetCurFocus($mainWindow_Tab))
	$editData = GUICtrlRead($mainWindow_Edit)
	$tabIndex = StringRegExpReplace(StringRegExpReplace(_GUICtrlTab_GetItemText ($mainWindow_Tab, _GUICtrlTab_GetCurFocus($mainWindow_Tab)), "^.{1,}\[", ""), "\]", "")

	If $tempTab <> $tabIndex Then
		RegWrite("HKEY_CURRENT_USER\Software\TRNv2\UserData\Controls", "LastTab", "REG_SZ", $tabIndex)
		$tempTab = $tabIndex
		;$tempLen = 0
		;debug
		ConsoleWrite("Tab changed to " & $tabIndex & @CRLF)
	EndIf

	If $tempLen <> _Crypt_HashData($editData, $CALG_MD5) Then
		$tempLen = _Crypt_HashData($editData, $CALG_MD5)

		If $editData <> "" Then
			RegWrite("HKEY_CURRENT_USER\Software\TRNv2\UserData\RNGs" &  "\" & $tabIndex, $tabIndex, "REG_MULTI_SZ", $editData)
			;debug
			ConsoleWrite("Data len " & $tempLen & @CRLF)
		Else
			RegWrite("HKEY_CURRENT_USER\Software\TRNv2\UserData\RNGs" &  "\" & $tabIndex, $tabIndex, "REG_MULTI_SZ", "")
			$tempLen = _Crypt_HashData(0, $CALG_MD5)
			;debug
			ConsoleWrite("Data len " & $tempLen & @CRLF)
		EndIf

	EndIf
EndFunc

Func _toLog($message, $color)
	GUICtrlSetData($mainWindow_Label_Log, $message)
	If $color = "error" Then
		GUICtrlSetColor($mainWindow_Label_Log, 0xFF0000)
	ElseIf $color = "success" Then
		GUICtrlSetColor($mainWindow_Label_Log, 0x008080)
	EndIf
EndFunc

Func _sendData($server, $game, $player, $rng)

	$regExp = StringRegExpReplace(StringRegExpReplace($rng, @TAB, ' '), @CRLF, '\\n')

	$serversArray = _regValToArray("HKEY_CURRENT_USER\Software\TRNv2\Servers")

	If $server = "" Then
		$ip = $server
	Else
		  $key = _ArraySearch($serversArray, $server, 0)
		  ;$value = $key
		  $ip = $serversArray[$key][0]
	EndIf

	If $username = "" OR $password = "" Then
	   _userCredentials()
	Else

	If $ip = '' OR $game = '' OR $player = '' OR $rng = '' Then
		_toLog("All fields must be filled", "error")
	Else
		_lockButtons($mainWindow_Button_Send, $mainWindow_Button_Cancel)
		_toLog("Start connection", "success")
		$pid = _Connect($ip,$username,$password)

		If $pid > 0 Then
			_toLog("Connected", "success")
			sleep(300)
			$sudo = "sudo -u devapp -i"
			_send($pid,$sudo & @CR)
			sleep(400)
			$rtn = _read($pid)
			If Not StringInstr($rtn,"devapp@") Then
				_toLog("Error - Need credentials for devapp user", "error")
			Else
				$rm = "rm -f $HOME/tomcat/rngFile_" & $game & "_" & $player & ".txt"
				_send($pid,$rm & @CR)
				Sleep(200)
				$echo = "echo -e '" & $regExp & "' > $HOME/tomcat/rngFile_" & $game & "_" & $player & ".txt"
				_send($pid,$echo & @CR)
				Sleep(200)
				$rtn = _read($pid)
				If StringInStr($rtn, "Permission denied") Then
				   _toLog("Error - permission denied", "error")
				   _exit($pid)
				Else
				   _toLog("File write success", "success")
				   Sleep(200)
				   _toLog("All done", "success")
				EndIf
			EndIf
		_exit($pid)
		Else
			_errMSG($pid)
		EndIf
			_unlockButtons($mainWindow_Button_Send, $mainWindow_Button_Cancel)
		EndIf
	EndIf
EndFunc

Func _removeRng($server, $game, $player)

		$serversArray = _regValToArray("HKEY_CURRENT_USER\Software\TRNv2\Servers")

		If $server = "" Then
			$ip = $server
		Else
			$key = _ArraySearch($serversArray, $server, 0)
			$ip = $serversArray[$key][0]
		EndIf

		If $username = "" OR $password = "" Then
		   _userCredentials()
		Else

		If $ip = '' OR $game = '' OR $player = '' Then
		  _toLog("All fields must be filled", "error")
		Else
			_lockButtons($mainWindow_Button_Send, $mainWindow_Button_Cancel)
			_toLog("Start connection", "success")
			$pid = _connect($ip,$username,$password)

			If $pid > 0 Then
				_toLog("Connected", "success")
				sleep(300)
				$sudo = "sudo -u devapp -i"
				_send($pid,$sudo & @CR)
				sleep(400)
				$rtn = _read($pid)
				If Not StringInstr($rtn,"devapp") Then
					_toLog("Error - Need credentials for devapp user", "error")
				Else
					$rm = "rm -f $HOME/tomcat/rngFile_" & $game & "_" & $player & ".txt"
					_send($pid,$rm & @CR)
					Sleep(200)
					$rtn = _read($pid)
					If StringInStr($rtn, "Permission denied") Then
					   _toLog("Error - permission denied", "error")
					   _exit($pid)
					Else
					   _toLog("File clean success", "success")
					   Sleep(200)
					   _toLog("All done", "success")
					EndIf
				EndIf
			_exit($pid)
			Else
				_errMSG($pid)
			EndIf
			_unlockButtons($mainWindow_Button_Send, $mainWindow_Button_Cancel)
		EndIf
	EndIf
EndFunc

Func _userCredentials()

	$username = RegRead("HKEY_CURRENT_USER\Software\TRNv2\UserData", "username")

	$password = RegRead("HKEY_CURRENT_USER\Software\TRNv2\UserData", "password")

	$credentialsWindow = GUICreate("Connect credentials", 433, 201, -1, -1)
	$credentialsWindow_Group = GUICtrlCreateGroup("Credentials", 8, 8, 417, 129)
	$credentialsWindow_Label_Username = GUICtrlCreateLabel("Usename", 56, 40, 49, 17)
	If $username <> "" Then
		$credentialsWindow_Input_Username = GUICtrlCreateInput($username, 136, 40, 241, 21)
	Else
		$credentialsWindow_Input_Username = GUICtrlCreateInput("", 136, 40, 241, 21)
	EndIf
	$credentialsWindow_Label_Password = GUICtrlCreateLabel("Password", 56, 88, 50, 17)
	If $password <> "" Then
		$credentialsWindow_Input_Password = GUICtrlCreateInput($password, 136, 88, 241, 21)
	Else
		$credentialsWindow_Input_Password = GUICtrlCreateInput("", 136, 88, 241, 21)
	EndIf
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$credentials_Window_Button_Cancel = GUICtrlCreateButton("Close", 8, 152, 97, 33)
	$credentialsWindow_Button_Save = GUICtrlCreateButton("Save", 328, 152, 97, 33)
	GUISetState()

	_checkOnTopStatus($credentialsWindow)

	_removeWindowButtons($credentialsWindow)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE, $credentials_Window_Button_Cancel
				GUIDelete($credentialsWindow)
				ExitLoop
			Case $credentialsWindow_Button_Save

				$newUsername = GUICtrlRead($credentialsWindow_Input_Username)
				$newPassword = GUICtrlRead($credentialsWindow_Input_Password)

				If $newUsername <> "" AND $newPassword <> "" Then
					RegWrite("HKEY_CURRENT_USER\Software\TRNv2\UserData\", "username", "REG_SZ", $newUsername)
					RegWrite("HKEY_CURRENT_USER\Software\TRNv2\UserData\", "password", "REG_SZ", $newPassword)
					GUIDelete($credentialsWindow)
					ExitLoop
				Else
					MsgBox($MB_SYSTEMMODAL, "Ooops", "Sorry but You can't save empty fields", 10)
				EndIf
		EndSwitch
	WEnd
EndFunc

Func _gameList($dataStorage, $gamesComboBox)

	$gamesArray = IniReadSection($dataStorage & "\data.ini", "Games")

	$gameListWindow = GUICreate("Game list", 342, 450, -1, -1)
	$gameListWindow_Viev = GUICtrlCreateListView("id|Game Name", 16, 16, 305, 333)
	_GUICtrlListView_SetColumnWidth($gameListWindow_Viev, 0, 40)
	_GUICtrlListView_SetColumnWidth($gameListWindow_Viev, 1, 235)
	$gameListWindow_Input_Game = GUICtrlCreateInput("", 16, 369, 305, 21)
	_GUICtrlListView_DeleteAllItems($gameListWindow_Viev)
	If IsArray($gamesArray) Then

		_ArraySort($gamesArray, 0, 0, 0, 1)

		For $i = 1 To $gamesArray[0][0]
			GUICtrlCreateListViewItem($gamesArray[$i][0] & "|" & $gamesArray[$i][1], $gameListWindow_Viev)
		Next
	EndIf
	$gameListWindow_Button_Add = GUICtrlCreateButton("&Add Game", 135, 400, 75, 25)
	GUISetState()

	_checkOnTopStatus($gameListWindow)

	_removeWindowButtons($gameListWindow)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete($gameListWindow)
				ExitLoop
			Case $gameListWindow_Button_Add
				$game = GUICtrlRead($gameListWindow_Input_Game)
				If $game <> "" Then
					If Not StringInStr($game, " ") Then
						$id = $gamesArray[0][0] + 1
						If IniWrite($dataStorage & "\data.ini", "Games", $id, $game) == 1 Then
							_GUICtrlListView_DeleteAllItems($gameListWindow_Viev)
							RegWrite("HKEY_CURRENT_USER\Software\TRNv2\Games", $id, "REG_SZ", $game)
							_GUICtrlComboBox_AddString($gamesComboBox, $game)
							;$getGameArray = _regValToArray("HKEY_CURRENT_USER\Software\TRNv2\Games")
							;_GUICtrlComboBox_SetEditSel($mainWindow_Combo_Game, 0, -1)
							;_GUICtrlComboBox_ReplaceEditSel($mainWindow_Combo_Game, $game)
							;$games_list = IniReadSection($script_dir & "\data.ini", "Games")
							$gamesArray = IniReadSection($dataStorage & "\data.ini", "Games")
 							If IsArray($gamesArray) Then
 								For $i = 1 To $gamesArray[0][0]
 									GUICtrlCreateListViewItem($gamesArray[$i][0] & "|" & $gamesArray[$i][1], $gameListWindow_Viev)
 								Next
 							EndIf
							MsgBox(64, "Done", "Game Added successfuly", 10)
							GUIDelete($gameListWindow)
							ExitLoop
						EndIf
					Else
						MsgBox(64, "Error", "Game name without spaces!")
					EndIf
				Else
					MsgBox(64, "Error", "Please enter game name")
				EndIf
		EndSwitch
	WEnd

EndFunc

Func _newCombination($dataStorage, $gamesArray, $mainGame)

	$newCombinationWindow = GUICreate("Add RNG Combination", 466, 443, -1, -1)
	$newCombinationWindow_Group = GUICtrlCreateGroup("New combination Settings", 16, 8, 433, 377)
	$newCombinationWindow_Label_Game = GUICtrlCreateLabel("Select game", 32, 40, 63, 17)

	If IsArray($gamesArray) Then
		;_ArrayDisplay($gamesArray)
	   ;$newCombinationWindow_Input_Game = GUICtrlCreateCombo($last_game, 128, 40, 305, 25)
	   $newCombinationWindow_Input_Game = GUICtrlCreateCombo($mainGame, 128, 40, 305, 25)
		For $i = 1 To UBound($gamesArray) -1
			GUICtrlSetData($newCombinationWindow_Input_Game, $gamesArray[$i][1])
		Next
	Else
		$newCombinationWindow_Input_Game = GUICtrlCreateCombo("", 128, 40, 305, 25, $CBS_DROPDOWNLIST)
	EndIf

	$newCombinationWindow_Label_Name = GUICtrlCreateLabel("Combination name", 32, 80, 91, 17)
	$newCombinationWindow_Input_Name = GUICtrlCreateInput("", 128, 80, 305, 21)
	$newCombinationWindow_Label_Combination = GUICtrlCreateLabel("Combination", 32, 120, 62, 17)
	$newCombinationWindow_Edit_Combination = GUICtrlCreateEdit("", 32, 144, 401, 225, BitOR($ES_AUTOVSCROLL,$ES_AUTOHSCROLL,$ES_WANTRETURN,$WS_VSCROLL))
	GUICtrlSetData($newCombinationWindow_Edit_Combination, "")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$newCombinationWindow_Button_Save = GUICtrlCreateButton("Save", 328, 400, 121, 33)
	$newCombinationWindow_Button_Cancel = GUICtrlCreateButton("Close", 16, 400, 121, 33)
	GUISetState()

	_checkOnTopStatus($newCombinationWindow)

	_removeWindowButtons($newCombinationWindow)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE, $newCombinationWindow_Button_Cancel
				GUIDelete($newCombinationWindow)
				ExitLoop
			Case $newCombinationWindow_Button_Save
				;Debug
				;ConsoleWrite($newCombinationWindow_GameName)

				If GUICtrlRead($newCombinationWindow_Input_Game) == "" OR GUICtrlRead($newCombinationWindow_Input_Name) == "" OR GUICtrlRead($newCombinationWindow_Edit_Combination) == "" Then

					MsgBox(64, "Error", "You must fill all fields")

				Else
					$name_input = StringReplace(GUICtrlRead($newCombinationWindow_Input_Name), " ", "_")
					$combination_edit = StringReplace(GUICtrlRead($newCombinationWindow_Edit_Combination), @CRLF, "<br>")
					$data = $name_input & '=' & $combination_edit

					;IniReadSection(@ScriptDir & "\combinations.ini", $newCombinationWindow_GameName)
					IniReadSection($dataStorage & "\combinations.ini", GUICtrlRead($newCombinationWindow_Input_Game))
					If Not @error Then
						;IniWrite(@ScriptDir & "\combinations.ini", $newCombinationWindow_GameName, $name_input, $combination_edit)
						;IniWrite($RemDir & "\combinations.ini", $newCombinationWindow_GameName, $name_input, $combination_edit)
						If IniWrite($dataStorage & "\combinations.ini", GUICtrlRead($newCombinationWindow_Input_Game), $name_input, StringStripCR($combination_edit)) == 1 Then
							MsgBox(64, "Done", "New combination added", 10)
							GUICtrlSetData($newCombinationWindow_Input_Name, "")
							GUICtrlSetData($newCombinationWindow_Edit_Combination, "")
							_iniReadToArray($dataStorage, "combinations.ini", "HKEY_CURRENT_USER\Software\TRNv2\Combinations", "REG_MULTI_SZ")
						Else
							MsgBox(64, "Error", "Error occured, check network connection")
						EndIf
					Else
						;IniWriteSection(@ScriptDir & "\combinations.ini", $newCombinationWindow_GameName, $data)
						;IniWriteSection($RemDir & "\combinations.ini", $newCombinationWindow_GameName, $data)
						If IniWriteSection($dataStorage & "\combinations.ini", GUICtrlRead($newCombinationWindow_Input_Game), StringStripCR($data)) == 1 Then
							MsgBox(64, "Done", "New combination added", 10)
							GUICtrlSetData($newCombinationWindow_Input_Name, "")
							GUICtrlSetData($newCombinationWindow_Edit_Combination, "")
							_iniReadToArray($dataStorage, "combinations.ini", "HKEY_CURRENT_USER\Software\TRNv2\Combinations", "REG_MULTI_SZ")
						Else
							MsgBox(64, "Error", "Error occured, check network connection", 10)
						EndIf
					EndIf

					;_ArrayDisplay($data)
				EndIf
		EndSwitch
	WEnd

EndFunc

Func _viewCombination()

	$gamesArray = _regKeyToArray("HKEY_CURRENT_USER\Software\TRNv2\Combinations\")
	;Debug
	;_ArrayDisplay($gamesArray)

	$viewCombinationWindow = GUICreate("View Predefined RNG's", 466, 443, -1, -1)
	$viewCombinationWindow_Group = GUICtrlCreateGroup("New combination Settings", 16, 8, 433, 377)
	$viewCombinationWindow_Label_Game = GUICtrlCreateLabel("Select game", 32, 40, 63, 17)

	If IsArray($gamesArray) Then

		_ArraySort($gamesArray, 0, 0, 0, 1)

	   $viewCombinationWindow_Input_Game = GUICtrlCreateCombo("", 128, 40, 305, 25)
		For $i = 1 To UBound($gamesArray) -1
			GUICtrlSetData($viewCombinationWindow_Input_Game, $gamesArray[$i])
		Next
	Else
		$viewCombinationWindow_Input_Game = GUICtrlCreateCombo("", 128, 40, 305, 25)
	EndIf

	$viewCombinationWindow_Label_Name = GUICtrlCreateLabel("Combination name", 32, 80, 91, 17)

	$viewCombinationWindow_Input_Name = GUICtrlCreateCombo("", 128, 80, 305, 21)

	$viewCombinationWindow_Label_Combination = GUICtrlCreateLabel("Combination", 32, 120, 62, 17)
	$viewCombinationWindow_Edit_Combination = GUICtrlCreateEdit("", 32, 144, 401, 225, BitOR($ES_AUTOVSCROLL,$ES_AUTOHSCROLL,$ES_WANTRETURN,$WS_VSCROLL))
	GUICtrlSetData($viewCombinationWindow_Edit_Combination, "")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$viewCombinationWindow_Button_Use = GUICtrlCreateButton("Use", 328, 400, 121, 33)
	$viewCombinationWindow_Button_Cancel = GUICtrlCreateButton("Close", 16, 400, 121, 33)
	GUISetState()

	_checkOnTopStatus($viewCombinationWindow)

	_removeWindowButtons($viewCombinationWindow)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE, $viewCombinationWindow_Button_Cancel
				GUIDelete($viewCombinationWindow)
				ExitLoop
			Case $viewCombinationWindow_Button_Use
				If GUICtrlRead($viewCombinationWindow_Input_Game) <> "" And GUICtrlRead($viewCombinationWindow_Input_Name) <> "" And GUICtrlRead($viewCombinationWindow_Edit_Combination) Then
					GUICtrlSetData($mainWindow_Edit, @LF & GUICtrlRead($viewCombinationWindow_Edit_Combination), 2)
				Else
					MsgBox(64, "Error", "You must select game and Combination before use it")
				EndIf
			Case $viewCombinationWindow_Input_Game
				_GUICtrlComboBox_ResetContent($viewCombinationWindow_Input_Name)
				GUICtrlSetData($viewCombinationWindow_Edit_Combination, "")
				If GUICtrlRead($viewCombinationWindow_Input_Game) <> "" Then

					$combinationsArray = _regValToArray("HKEY_CURRENT_USER\Software\TRNv2\Combinations" & "\" & GUICtrlRead($viewCombinationWindow_Input_Game))
					_ArraySort($combinationsArray, 0, 0, 0, 1)
					For $i = 1 To UBound($combinationsArray) -1
						GUICtrlSetData($viewCombinationWindow_Input_Name, StringReplace($combinationsArray[$i][0], "_", " "))
					Next
				EndIf
			Case $viewCombinationWindow_Input_Name
				GUICtrlSetData($viewCombinationWindow_Edit_Combination, StringRegExpReplace(RegRead("HKEY_CURRENT_USER\Software\TRNv2\Combinations" & "\" & GUICtrlRead($viewCombinationWindow_Input_Game), GUICtrlRead($viewCombinationWindow_Input_Name)), '<br>', @CRLF))
		EndSwitch
	WEnd

EndFunc

Func _iniReadToArray($remoteStorage, $iniFile, $registry, $registryKey = "REG_SZ")
	$iniToArray = IniReadSectionNames($remoteStorage & "\" & $iniFile)
	If Not @error Then
		For $i = 0 To UBound($iniToArray, 1) -1
			RegDelete($registry & "\" & $iniToArray[$i])
			$iniSections = IniReadSection($remoteStorage & "\" & $iniFile, $iniToArray[$i])
			For $j = 1 To UBound($iniSections, 1) -1
				For $k = 1 To UBound($iniSections, 2) -1
					RegWrite($registry & "\" & $iniToArray[$i], StringRegExpReplace($iniSections[$j][0], "_", " "), $registryKey, StringRegExpReplace($iniSections[$j][$k], '<br>', @CRLF))
				Next
			Next
		Next
		Return 0
	Else
		Return 1
	EndIf
EndFunc

Func _updater()

	If _iniReadToArray($getStorage, "data.ini", "HKEY_CURRENT_USER\Software\TRNv2") <> 1 And _iniReadToArray($getStorage, "combinations.ini", "HKEY_CURRENT_USER\Software\TRNv2\Combinations", "REG_MULTI_SZ") <> 1 Then
		Global $workIcon = 9
		Global $locker = False
	Else
		Global $workIcon = 10
		Global $locker = True
	EndIf

EndFunc

Func _setOnTopStatus($windowHandler, $checkBox)

		If RegRead("HKEY_CURRENT_USER\Software\TRNv2\UserData\Controls", "OnTheTop") == 0 Then
			RegWrite("HKEY_CURRENT_USER\Software\TRNv2\UserData\Controls", "OnTheTop", "REG_SZ", 1)
			WinSetOnTop($windowHandler, "", 1)
			GUICtrlSetState ($checkBox, 1)
		Else;If RegRead("HKEY_CURRENT_USER\Software\TRNv2\UserData\Controls", "OnTheTop") == 1 Then
			RegWrite("HKEY_CURRENT_USER\Software\TRNv2\UserData\Controls", "OnTheTop", "REG_SZ", 0)
			GUICtrlSetState ($checkBox, 4)
			WinSetOnTop($windowHandler, "", 0)
		EndIf

EndFunc

Func _checkOnTopStatus($windowHandler, $checkBox = "")

		If RegRead("HKEY_CURRENT_USER\Software\TRNv2\UserData\Controls", "OnTheTop") == 1 Then
			WinSetOnTop($windowHandler, "", 1)
			If $checkBox <> "" Then
				GUICtrlSetState($checkBox, 1)
			EndIf
		Else
			If $checkBox <> "" Then
				GUICtrlSetState($checkBox, 4)
			EndIf
		EndIf

EndFunc

Func _removeWindowButtons($windowHandler)

	$windowStyle = _WinAPI_GetWindowLong($windowHandler, $GWL_STYLE)
	_WinAPI_SetWindowLong($windowHandler, $GWL_STYLE, BitXOr($windowStyle, $WS_MINIMIZEBOX))

EndFunc

Func _errMSG($pid)
	;ConsoleWrite($pid)
	Select
		Case $pid = -1
			_toLog("Plink.exe file not found, aborting", "error")
		Case $pid = -2
			_toLog("Plink.exe run error", "error")
		Case $pid = -3
			_toLog("Wrong credentials, please recheck", "error")
		Case $pid = -4
			_toLog("Remote host unreachable", "error")
	EndSelect
EndFunc ;==>_errMSG