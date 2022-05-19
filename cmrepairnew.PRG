**Sample call
SET STEP ON 
*!*	RepairHeader('RED09NAT.dbf')
RepairHeader('D:\Newrest\MENGDEMO\Red09NAT.dbf')

Function RepairHeader
Lparameters tcDBF
Local handle, lnFileSize, lnReccount, lnHeaderSize, lnRecordSize, lnCalculatedReccount, llHasMemo
handle=fopen(tcDBF,12) && Opened readwrite
lnFileSize = fseek(handle,0,2) && Get file size
* Read header info
lnReccount = ReadBytes(handle, 4,4)
lnHeaderSize = ReadBytes(handle, 8,2)
lnRecordSize = ReadBytes(handle,10,2)

lnCalculatedReccount = floor((lnFileSize-(lnHeaderSize+1))/lnRecordSize)
If lnCalculatedReccount # lnReccount && If calculated # recorded fix it
WriteBytes(handle, 4,4,lnCalculatedReccount)
Endif
=fclose(handle)

function WriteBytes
Lparameters tnHandle, tnPos, tnSize, tnNumber, tlLR
Local lcString, lnLowDword, lnHighDword,ix
lcString=''
If tlLR
For ix=tnSize-1 to 0 step -1
lcString=lcString+chr(tnNumber/256^ix%256)
Endfor
Else
For ix=0 to tnSize-1
lcString=lcString+chr(tnNumber/256^ix%256)
Endfor
Endif
=fseek(tnHandle, tnPos,0) && Go to Pos
Return fwrite(tnHandle,lcString)

function ReadBytes
Lparameters tnHandle, tnPos, tnSize, tlLR
Local lcString, lnRetValue,ix
=fseek(tnHandle, tnPos,0) && Go to Pos
lcString = fread(tnHandle, tnSize) && Read tnSize bytes
lnRetValue = 0
For ix=0 to tnSize-1 && Convert to a number
lnRetValue = lnRetValue + asc(substr(lcString,ix+1)) * ;
iif(tlLR,256^(tnSize-1-ix),256^ix)
Endfor
Return int(lnRetValue)