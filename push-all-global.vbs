' push-all-global.vbs — wrapper silencieux pour la tache planifiee Windows
' Lance push-all-global.sh via bash sans afficher de fenetre console.
'
' Usage : wscript.exe C:\dev\claude\push-all-global.vbs
' Tache planifiee : schtasks /Create /SC MINUTE /MO 15 /TN "Claude Push All" /TR "wscript.exe \"C:\dev\claude\push-all-global.vbs\"" /F

Set WshShell = CreateObject("WScript.Shell")
WshShell.Run """C:\Program Files\Git\usr\bin\bash.exe"" -lc ""C:/dev/claude/push-all-global.sh""", 0, False
