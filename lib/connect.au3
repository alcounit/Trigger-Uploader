Func _connect($host,$usr,$pass)
   $exec = @ScriptDir & "\PLINK.EXE"
   If Not FileExists($exec) Then Return -1
   $pid = Run($exec & " -ssh -pw " & $pass & " " & $usr & "@" & $host, @SystemDir, @SW_HIDE, 0x1 + 0x8)
   If Not $pid Then Return -2
   $rtn = _read($pid)  ;Check for Login Success - Prompt
   If StringInstr($rtn,"(y/n)") Then
	  _send($pid,"y" & @CR)
      $rtn = _read($pid)
   EndIf
   If StringInstr($rtn,"yes/no") Then
	  _send($pid,"yes" & @CR)
      $rtn = _read($pid)
   EndIf
	If StringInstr($rtn,"s password:") Then
	    Return -3
	EndIf
   ;# issue https://github.com/alcounit/rngFile/issues/1
	If StringInstr($rtn,"Access denied") Then
	   Return -3
	EndIf
	If StringInstr($rtn,"FATAL ERROR") Then
	   Return -4
	EndIf
   ;# issue https://github.com/alcounit/rngFile/issues/1
   Return $pid
EndFunc

Func _read($pid)
    Local $dataA
    Local $dataB
    Do
        $dataB = $dataA
        sleep(100)
        $dataA &= StdOutRead($pid)
        If @error Then ExitLoop
	Until $dataB = $dataA And $dataA And $dataB
	;Debug
	ConsoleWrite($dataA & @LF)

    Return $dataA
EndFunc

Func _send($pid,$cmd)
   If Not $pid Then Return -1
   StdinWrite($pid,$cmd)
EndFunc

Func _exit($pid)
   ProcessClose($pid)
EndFunc