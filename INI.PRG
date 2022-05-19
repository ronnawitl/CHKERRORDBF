*
FUNCTION getPPS
LPARAMETERS csection, centry, cdefault, cinifile
LOCAL cbuffer, nbufsize, nerrnum, ntotparms
ntotparms = PARAMETERS()
IF m.ntotparms<3
 m.centry = 0
ENDIF
m.cbuffer = SPACE(2000)
IF EMPTY(m.cinifile)
 m.nbufsize = getwinini(m.csection,m.centry,"",@cbuffer,LEN(m.cbuffer))
ELSE
 m.nbufsize = getprivateini(m.csection,m.centry,"",@cbuffer,LEN(m.cbuffer),m.cinifile)
ENDIF
IF EMPTY(LEFT(m.cbuffer, m.nbufsize))
 RETURN cdefault
ELSE
 RETURN LEFT(m.cbuffer, m.nbufsize)
ENDIF
ENDFUNC
*
FUNCTION WritePPS
LPARAMETERS csection, centry, cvalue, cinifile
LOCAL nerrnum
IF EMPTY(m.cinifile)
 nerrnum = writewinini(m.csection,m.centry,m.cvalue)
ELSE
 nerrnum = writeprivateini(m.csection,m.centry,m.cvalue,m.cinifile)
ENDIF
RETURN nerrnum
ENDFUNC
*
PROCEDURE LoadINIFuncs
DECLARE INTEGER GetPrivateProfileString IN Win32API AS GetPrivateINI STRING, STRING, STRING, STRING, INTEGER, STRING
DECLARE INTEGER GetProfileString IN Win32API AS GetWinINI STRING, STRING, STRING, STRING, INTEGER
DECLARE INTEGER WriteProfileString IN Win32API AS WriteWinINI STRING, STRING, STRING
DECLARE INTEGER WritePrivateProfileString IN Win32API AS WritePrivateINI STRING, STRING, STRING, STRING
ENDPROC
*
