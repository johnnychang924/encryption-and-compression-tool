TITLE dataProcessing          (finalProject.ASM)

INCLUDE Irvine32.inc

main  EQU start@0

node STRUCT
        char BYTE ?
        num DWORD ?
        left DWORD ?
        IsLeaf BYTE 0
        right DWORD ?
node ENDS

.data
;huffman tree variable
charNum DWORD 256 dup(0)
treeNode node 1000 dup(<0,0,0,0,0>)
nodeadress DWORD 256 dup(0)
nodeTop DWORD 0
nodeadressTop DWORD 0
newFile BYTE 10000000 dup(0)
ByteFull BYTE ?
DataLeng DWORD ?
;huffman tree variable
applicationName BYTE 'DataProcessing', 0
fileKey BYTE 100 dup(?),0                                       ;儲存鑰匙
Keyleng2 BYTE 0
fileHandle DWORD ?                                              ;儲存文件handle
filePath BYTE 100 dup(?),0          	                        ;儲存文件路徑
fileBuffer BYTE 10000000 dup(?)                                 ;緩衝區
openErrorTip BYTE 'Open file error !! Please input again !!', 0 ;打開文件失敗
readErrorTip BYTE 'Read file error !!', 0                       ;讀取文件失敗
decompressTrueTip BYTE 'Decompress file true !!', 0             ;解壓縮文件成功
encryptTrueTip BYTE 'Encrypt file true !!', 0                   ;加密文件成功
compressTrueTip BYTE 'Compress file true !!', 0                 ;加壓縮文件成功
decryptTrueTip BYTE 'Decrypt file true !!', 0                   ;解密文件成功
choiceErrorTip BYTE 'Your choice is false, choose again !!', 0  ;輸入錯誤
fileInputTip BYTE 'Please input source file path:', 0           ;要求輸入待處理文件位置
keyTip BYTE 'Please input Key:', 0                              ;要求輸入鑰匙
divide BYTE '******************', 0ah,0                         ;分割符號
menu1 BYTE '(1).Decrypt file', 0ah,0                            ;解密文字內容
menu2 BYTE '(2).Encrypt file', 0ah,0                            ;加密文字內容
menu3 BYTE '(3).Exit', 0ah,0                     			    ;退出程式
menu4 BYTE '(4).Compress option',0ah,0							;跳到加解壓縮
Cmenu1 BYTE '(1).Compress file', 0ah,0                          ;壓縮文字內容
Cmenu2 BYTE '(2).Decompress file', 0ah,0                        ;解壓縮文字內容
Cmenu3 BYTE '(3).Exit', 0ah,0                                   ;退出程式
choiceTip BYTE 'Please input the choice:',0						;要求輸入指令
filenameInputTip BYTE 'Please input file name:', 0              ;要求輸入輸出文件名稱
choice BYTE 4 dup(?)                                            ;功能選擇
fileCount DWORD  ?                                              ;實際讀取的字元數
bytesWriten DWORD ?                                             ;實際寫出的字元數
filename BYTE 100 dup(?), 0     								;寫出的檔案名
choicetype BYTE ?  												;選擇加密還是解密
compresstype BYTE ?    											;選擇加壓還是解壓縮
compressed BYTE ?                                               ;判斷是否已加解壓
D_Day1 BYTE  '                                      *******         *******       **     **    **' ,0ah,
			 '                                     /**////**       /**////**     ****   //**  ** ',0ah,
			 '                                     /**    /**      /**    /**   **//**   //****'  ,0ah,
		     '                                     /**    /** *****/**    /**  **  //**   //** '  ,0ah
D_Day2 BYTE  '                                     /**    /**///// /**    /** **********   /** '  ,0ah,
			 '                                     /**    **       /**    ** /**//////**   /**'  ,0ah,
			 '                                     /*******        /*******  /**     /**   /**'  ,0ah,
			 '                                     ///////         ///////   //      //    // '   ,0ah,0
D_Day3 BYTE '    _  _  _  __ __               _     ___ _    _____     _ ___   _  _    _  _  _  __ __   _  __ _  ___ _    _   ______ ',0ah, 0dh,
	        '   |_)|_)|_ (_ (_   /\ |\ |\_/|/|_ \_/  | / \  (_  |  /\ |_) |   / \|_)  |_)|_)|_ (_ (_   |_ (_ /    | / \  |_ \/ |  |  ',0ah, 0dh,
	        '   |  | \|_ __)__) /--\| \| | |\|_  |   | \_/  __) | /--\| \ |   \_/| \  |  | \|_ __)__)  |_ __)\_   | \_/  |_ /\_|_ |  ',0ah, 0dh
D_DAT4 BYTE	'                                                                                                                        ',0
victory1 BYTE   '                    ><<         ><<><<    ><<   ><<< ><<<<<<    ><<<<     ><<<<<<<    ><<      ><<',0ah,
                '                     ><<       ><< ><< ><<   ><<     ><<      ><<    ><<  ><<    ><<   ><<    ><<',0ah,
                '                      ><<     ><<  ><<><<            ><<    ><<        ><<><<    ><<    ><< ><< ',0ah
victory2 BYTE   '                       ><<   ><<   ><<><<            ><<    ><<        ><<>< ><<          ><<',0ah,
                '                        ><< ><<    ><<><<            ><<    ><<        ><<><<  ><<        ><<',0ah,
                '                         ><<<<     ><< ><<   ><<     ><<      ><<     ><< ><<    ><<      ><<',0ah
victory3 BYTE   '                          ><<      ><<   ><<<<       ><<        ><<<<     ><<      ><<    ><<',0ah,0 
victory4 Byte   ' 			    PRESS ENTER TO RETURN TO ENCRYPT OPTION OR PRESS ESC TO EXIT',0

Defeat1 BYTE    '                                  ____    ____    ____    ____    ______  ______', 0ah
Defeat2 BYTE    '                                 /\  _`\ /\  _`\ /\  _`\ /\  _`\ /\  _  \/\__  _\ ', 0ah
Defeat3 BYTE    '                                 \ \ \/\ \ \ \L\_\ \ \L\_\ \ \L\_\ \ \L\ \/_/\ \/ ', 0ah
Defeat4 BYTE    '                                  \ \ \ \ \ \  _\L\ \  _\/\ \  _\L\ \  __ \ \ \ \ ', 0ah
Defeat5 BYTE    '                                   \ \ \_\ \ \ \L\ \ \ \/  \ \ \L\ \ \ \/\ \ \ \ \ ', 0ah
Defeat6 BYTE    '                                    \ \____/\ \____/\ \_\   \ \____/\ \_\ \_\ \ \_\ ', 0ah
Defeat7 BYTE    '                                     \/___/  \/___/  \/_/    \/___/  \/_/\/_/  \/_/ ', 0ah, 0

STORY1 BYTE  'Historical Background: The Eve of Normandy Landing.',0ah,0
STORY2 BYTE	 'Role: You are an agent belonging to MI6, responsible for encrypting telegrams.',0ah,0
STORY3 BYTE	 'Task: We have to enter a string of characters to encrypt the telegram as the encryption method of the telegram, and',0ah,'transmit it to the Allies.',0ah,0
STORY4 BYTE 'In order to prevent the Germans from deciphering our telegram, we decided to add another security measure outside the',0ah,'telegram',0ah,0
STORY5 BYTE 'Because of your superb encryption skills, we successfully landed in Normandy and achieved great success, which is a big',0ah,'step closer to the victory of the Allies.',0ah,0
STORY6 BYTE 'Because the Encryption we use is too easy to guess, we failed to land in Normandy. But you still can try again'
Features1 BYTE 'You can intput 1,2,3 or 4 to decide the thing you want to do...',0ah,0

screenSize SMALL_RECT <0, 0, 120, 25>
screenBufferSize COORD <9000,9000>
screenBuffer HANDLE ?

.code
main proc
		INVOKE SetConsoleTitle, ADDR applicationName	
		INVOKE GetStdHandle, STD_OUTPUT_HANDLE
		mov screenBuffer, eax
		INVOKE SetConsoleScreenBufferSize, screenBuffer, screenBufferSize
		INVOKE SetConsoleWindowInfo, screenBuffer, 1, ADDR screenSize
		call D_DAY
		mov eax , white + (black*16)          
		call SetTextColor
		call STORY_1     
		call displayMenu
		ret
main endp

D_DAY proc 
		
		;call Clrscr 
		call crlf 				;調整D_DAY位置
		call crlf
		call crlf
		call crlf
		mov eax , white           ;把D-DAY設顏色
		call SetTextColor
		mov edx, OFFSET D_Day1
		call WriteString
		call crlf
		call crlf
		call crlf
		call crlf
		call crlf
		call crlf 
		call crlf
		
		mov eax , black + (white*16)
		call SetTextColor      
		
		mov edx ,OFFSET D_Day3
                mov eax, black
		call WriteString
		call SetTextColor
		call ReadChar
		.IF ax == 011bh ;esc
			call ReturnToWindows
		.ENDIF	
		ret
		
D_DAY endp

Victory proc 

		call Clrscr 
		call crlf 				  ;調整victory1位置
		call crlf
		call crlf
		call crlf
		mov eax , white           ;把victory1設顏色
		call SetTextColor
		mov edx, OFFSET victory1
		call WriteString
		call crlf
		call crlf
		call crlf
		mov edx, OFFSET victory4
		call WriteString
		call ReadChar
		.IF ax == 011bh ;esc
			jmp ReturnToWindows
		.ENDIF	
		call ReadChar
		.IF ax == 1c0dh ;enter
			jmp displayMenu
		.ENDIF	

		ret
		
Victory endp

Defeat_1 proc 
		mov compressed,0
		call Clrscr 
		call crlf 				;調整Defeat位置
		call crlf
		call crlf
		call crlf
		mov eax , white           ;把Defeat設顏色
		call SetTextColor
		mov edx, OFFSET Defeat1
		call WriteString
		call crlf
		call crlf
		call crlf
		mov edx, OFFSET victory4
		call WriteString
		call ReadChar
		.IF ax == 011bh ;esc
			jmp ReturnToWindows
		.ENDIF	
		call ReadChar
		.IF ax == 1c0dh ;enter
			jmp displayMenu
		.ENDIF	
		      

		ret
		
Defeat_1 endp 

STORY_1 proc

		call Clrscr
		lea edi , STORY1
		mov ecx , SIZEOF STORY1
	L:	
		mov  eax , 40
		call  Delay
		mov eax,[edi]
		call WriteChar 
		add edi,1
		loop L
		call crlf

		lea edi , STORY2
		mov ecx , SIZEOF STORY2
	L1:	
		mov  eax , 40
		call  Delay
		mov eax,[edi]
		call WriteChar 
		add edi,1
		loop L1
		call crlf

		lea edi , STORY3
		mov ecx , SIZEOF STORY3
	L2:	
		mov  eax , 40
		call  Delay
		mov eax,[edi]
		call WriteChar 
		add edi,1
		loop L2
		call crlf
		call WaitMsg
		
		ret
		
STORY_1 endp	

STORY_2 proc
	
		call Clrscr
		call crlf
		lea edi , STORY4
		mov ecx , SIZEOF STORY4
	L:	
		mov  eax , 40
		call  Delay
		mov eax,[edi]
		call WriteChar 
		add edi,1
		loop L
		call crlf
		call WaitMsg
		call Compressmenu
		ret
		
STORY_2 endp

STORY_3 proc
		call Clrscr
		call crlf
		lea edi , STORY5
		mov ecx , SIZEOF STORY5
	L:	
		mov  eax , 40
		call  Delay
		mov eax,[edi]
		call WriteChar 
		add edi,1
		loop L
		call crlf
		call WaitMsg
		call Victory
        mov Keyleng2, 0
		ret
STORY_3 endp

STORY_4 proc
        call Clrscr
		call crlf
		lea edi , STORY6
		mov ecx , SIZEOF STORY6
	L:	
		mov  eax , 40
		call  Delay
		mov eax,[edi]
		call WriteChar 
		add edi,1
		loop L
		call crlf
		call WaitMsg
		call Defeat_1
        mov Keyleng2, 0
		ret
STORY_4 endp

displayMenu proc
		call Clrscr
		mov edx,OFFSET divide
		call WriteString
		
		lea edi , menu1
		mov ecx , SIZEOF menu1
	L:	
		mov  eax , 40
		call  Delay
		mov eax,[edi]
		call WriteChar 
		add edi,1
		loop L
		call crlf
		
		lea edi , menu2
		mov ecx , SIZEOF menu2
	L1:	
		mov  eax , 40
		call  Delay
		mov eax,[edi]
		call WriteChar 
		add edi,1
		loop L1
		call crlf
		
		lea edi , menu3
		mov ecx , SIZEOF menu3
	L2:	
		mov  eax , 40
		call  Delay
		mov eax,[edi]
		call WriteChar 
		add edi,1
		loop L2
		call crlf
	
		lea edi , menu4
		mov ecx , SIZEOF menu4
	L4:	
		mov  eax , 40
		call  Delay
		mov eax,[edi]
		call WriteChar 
		add edi,1
		loop L4
		call crlf
		
		mov edx,OFFSET divide
		call WriteString
		
		lea edi , Features1  ;功能選擇敘述
		mov ecx , SIZEOF Features1
	L3:	
		mov  eax , 40
		call  Delay
		mov eax,[edi]
		call WriteChar 
		add edi,1
		loop L3
		call crlf
		call getChoice
		ret

displayMenu endp

getChoice proc
		
		lea edi , choiceTip
		mov ecx , SIZEOF choiceTip
	L:	
		mov  eax , 40
		call  Delay
		mov eax,[edi]
		call WriteChar 
		add edi,1
		loop L
		
		mov edx,OFFSET choice           ;讀取我輸入的選擇
		mov ecx, (SIZEOF choice) - 1
		call ReadString

		cmp [choice+1], 10h				;如果開頭是1,2,3其中一個但後面有任意文字的話的防呆偵測
        jae choiceError		
		
		mov al, choice
		cmp al,31h   		        	;看是不是1
		je getChoice1
		cmp al,32h		        		;看是不是2
		je getChoice2
		cmp al,33h						;看是不是3
		je getChoice3
		cmp al,34h						;看是不是4
		je getChoice4
		
		jmp choiceError					;都不是的話，跳出錯誤訊息並重新輸入

getChoice1:

		mov choicetype, '1'
		call decrypt
		call EncryptFileTrue
		call displayMenu
		ret
	
getChoice2:

		mov choicetype, '2'
        call encrypt
		call EncryptFileTrue
		call displayMenu
        ret

getChoice3:  

        mov al, Keyleng2
        cmp al, 6
        jb Defeat
        call STORY_3
		
getChoice4:

		call STORY_2
		ret
Defeat:
        call STORY_4
		ret  
		
choiceError:

        lea edi , choiceErrorTip 		;印出錯誤訊息
		mov ecx , SIZEOF choiceErrorTip
	L1:	
		mov  eax , 40
		call  Delay
		mov eax,[edi]
		call WriteChar 
		add edi,1
		loop L1
		call crlf
        call getChoice      			;重新呼叫getChoice
        ret

getChoice endp

createFile1 proc
		
		lea edi , filenameInputTip 			;印出輸入檔案位置提示
		mov ecx , SIZEOF filenameInputTip
	L:	
		mov  eax , 40
		call  Delay
		mov eax,[edi]
		call WriteChar 
		add edi,1
		loop L		
		
        lea edx, filename
        mov ecx, (SIZEOF filename) - 1
        call ReadString
		
        INVOKE CreateFile,
                edx,
                GENERIC_WRITE,
                DO_NOT_SHARE,
                NULL,
                CREATE_ALWAYS,
                FILE_ATTRIBUTE_NORMAL,
                0
        mov fileHandle, eax		; 把文件名稱保留在fileHandle裡
										
        .IF eax == INVALID_HANDLE_VALUE
			call createFile1
        .ENDIF

        ret

createFile1 endp

openFile proc
		lea edi , fileInputTip		;提示輸入文件路徑
		mov ecx , SIZEOF fileInputTip
	L:	
		mov  eax , 40
		call  Delay
		mov eax,[edi]
		call WriteChar 
		add edi,1
		loop L		
				
        mov edx,OFFSET filePath                                              
        mov ecx, (SIZEOF filePath) - 1
        call ReadString             ;讀取輸入的文件路徑
        INVOKE CreateFile,
                  edx,
                  GENERIC_READ,
                  DO_NOT_SHARE,
                  NULL,
                  OPEN_EXISTING,
                  FILE_ATTRIBUTE_NORMAL,
                  0
		cmp eax, INVALID_HANDLE_VALUE
        je openError
getFileHandle:

		mov fileHandle, eax      ; save console handle
        ret
		
openError:

        mov edx,OFFSET openErrorTip
        call WriteString
        call Crlf
        call openFile
        ret
		
openFile endp

readFile1 proc
        mov ecx, SIZEOF fileBuffer
        INVOKE ReadFile,
                fileHandle,
                ADDR fileBuffer,
                ecx,
                ADDR fileCount,
                0
		.IF eax == INVALID_HANDLE_VALUE
			jmp readError
        .ENDIF		
		 INVOKE CloseHandle, fileHandle
        ret

readError:

        mov edx,OFFSET readErrorTip;提示讀文件失敗
        call WriteString
        call Crlf
        call WaitMsg
        call ReturnToWindows
        ret

readFile1 endp

writeFile1 proc

        lea esi,fileHandle
        mov ebx,[esi]
        lea edi,fileCount
        mov ecx,[edi]
        INVOKE WriteFile,
                fileHandle,
                ADDR fileBuffer,
                fileCount,
                ADDR bytesWriten,
                0

        INVOKE CloseHandle, fileHandle
		ret
		
writeFile1 endp			

EncryptFileTrue proc

		cmp choicetype,31h
		je  decryptTrue
        jmp encryptTrue

decryptTrue:

        mov edx,OFFSET decryptTrueTip ;解密成功
        call WriteString
		call Crlf
		call waitMsg
		call Clrscr
        ret

encryptTrue:
		
		mov edx,OFFSET encryptTrueTip ;加密成功
        call WriteString
		call Crlf
		call waitMsg
		call Clrscr
        ret

EncryptFileTrue endp


ReturnToWindows proc

        exit
        ret

ReturnToWindows endp

;加密文件内容

encrypt proc

		call openFile
		call readFile1
		xor ecx,ecx
        call saveKey
DoAgain:	
		push ecx
        lea ebx,fileBuffer
        mov ecx, fileCount
 do:
        mov dl,[ebx]
        mov al,[edi]
        add al,dl
        mov [ebx],al
        inc ebx
        loop do
		pop ecx
		add edi,1
		loop DoAgain
		
        call createFile1

        call writeFile1

        ret

encrypt endp

decrypt proc

        call openFile
        call readFile1
		xor ecx,ecx
        call saveKey
                
UnDoAgain:

		push ecx
		lea ebx,fileBuffer
        mov ecx, fileCount		

undo:                
                                   
        mov al,[ebx]	; 解密文件内容    		
        mov dl,[edi]
        sub al,dl
        mov [ebx],al
        inc ebx
        loop undo
		pop ecx 
		add edi , 1
	    loop UnDoAgain
        call createFile1
        call writeFile1
        ret

decrypt endp


saveKey proc
		lea edi , keyTip   ;提示輸入密碼
		mov ecx , SIZEOF keyTip
	L:	
		mov  eax , 40
		call  Delay
		mov eax,[edi]
		call WriteChar 
		add edi,1
		loop L

		mov edx,OFFSET fileKey
		mov ecx, (SIZEOF fileKey) - 1
		call ReadString
        mov Keyleng2, al
		mov ecx ,eax
		lea edi, fileKey
        ret

saveKey endp
 
Compressmenu proc

		call Clrscr
		mov edx,OFFSET divide
		call WriteString
		
		lea edi , Cmenu1
		mov ecx , SIZEOF Cmenu1
	L:	
		mov  eax , 40
		call  Delay
		mov eax,[edi]
		call WriteChar 
		add edi,1
		loop L
		call crlf
		
		lea edi , Cmenu2
		mov ecx , SIZEOF Cmenu2
	L1:	
		mov  eax , 40
		call  Delay
		mov eax,[edi]
		call WriteChar 
		add edi,1
		loop L1
		call crlf
		
		lea edi , Cmenu3
		mov ecx , SIZEOF Cmenu3
	L2:	
		mov  eax , 40
		call  Delay
		mov eax,[edi]
		call WriteChar 
		add edi,1
		loop L2
		call crlf
		
		mov edx,OFFSET divide
		call WriteString
		
		call crlf
		call getCompressChoice
		ret
Compressmenu endp
 
getCompressChoice proc
		
		lea edi , choiceTip
		mov ecx , SIZEOF choiceTip
	L:	
		mov  eax , 40
		call  Delay
		mov eax,[edi]
		call WriteChar 
		add edi,1
		loop L
		
		mov edx,OFFSET choice           ;讀取我輸入的選擇
		mov ecx, (SIZEOF choice) - 1
		call ReadString

		cmp [choice+1], 10h				;如果開頭是1,2,3其中一個但後面有任意文字的話的防呆偵測
        jae choiceError		
		
		mov al, choice
		
		cmp al,31h   		        	;看是不是1
		je getChoice1

		cmp al,32h		        		;看是不是2
		je getChoice2

		cmp al,33h						;看是不是3
		je getChoice3
       
		jmp choiceError					;都不是的話，跳出錯誤訊息並重新輸入

getChoice1:

		mov compresstype, '1'
		call compress
		call writeTrue
		call Compressmenu
		ret
	
getChoice2:

		mov compresstype, '2'
        call deCompress
		call writeTrue
		call Compressmenu
        ret

getChoice3:

		mov al, Keyleng2
        cmp al, 6
		jb STORY_4
		cmp compressed,1
		je STORY_3
        call STORY_4
        ret

choiceError:

        lea edi , choiceErrorTip 		;印出錯誤訊息
		mov ecx , SIZEOF choiceErrorTip
	L1:	
		mov  eax , 40
		call  Delay
		mov eax,[edi]
		call WriteChar 
		add edi,1
		loop L1
		call crlf
        call getCompressChoice    			;重新呼叫getChoice
        ret
		
getCompressChoice endp

writeTrue proc
		cmp compresstype,31h
		je compressTrue
        jmp decompressTrue

compressTrue:
        ;加壓成功
         mov edx,OFFSET compressTrueTip
         call WriteString
		 call Crlf
		 call waitMsg
         ret

decompressTrue:
		;解壓成功
		mov edx,OFFSET decompressTrueTip
        call WriteString
		call Crlf
		call waitMsg
        ret
		
writeTrue endp
 
deCompress proc      ;解壓縮
		mov compressed,1
		call openFile
		call ReadNewFile
		call LoadTree
		call dataHandle
		call createFile1
		mov eax, DataLeng
		mov fileCount, eax
		call writeFile1
		ret
	
deCompress endp

LoadTree proc

		lea esi, newFile
		mov ecx, DWORD PTR [esi]
		add esi, 8
		lea edi, treenode
		
treeHandle2:

		mov eax, (node PTR [esi]).left
		add eax, edi
		mov (node PTR [esi]).left, eax
		mov eax, (node PTR [esi]).right
		add eax, edi
		mov (node PTR [esi]).right, eax
		add esi, TYPE node
		loop treeHandle2

		lea esi, newFile
		mov eax, DWORD PTR [esi]
		add esi, 4
		mov nodeTop, eax

		mov ecx, DWORD PTR [esi]
		add esi, 4
		mov nodeadress, ecx

		mov ecx, 14
		mul ecx
		mov ecx, eax
		lea edi, treeNode
		rep movsb

		lea edi, treeNode
		mov eax, nodeadress
		add eax, edi
		mov nodeadress, eax

		ret
LoadTree endp

dataHandle proc

		mov eax, DWORD PTR [esi]
		add esi, 4
		mov DataLeng, eax
		mov al, BYTE PTR [esi]
		inc esi
		mov ByteFull, al
		mov ecx, DataLeng
		mov eax, 0
		mov DataLeng, eax
		mov eax, nodeadress; root
		mov bh, 0
		lea edi, fileBuffer
	
dataDecompress:
		mov bl, [esi]
ByteHandle:
		shl bl, 1
		jc IsOne
IsZero:
		mov eax, (node PTR [eax]).left
		mov dl, (node PTR [eax]).IsLeaf
		cmp dl, 1
		jne NotLeaf
        mov dl, (node PTR [eax]).char
        mov BYTE PTR [edi], dl
        mov eax, nodeadress
        inc edi
        inc DataLeng
NotLeaf:
		jmp findNext
IsOne:
		mov eax, (node PTR [eax]).right
		mov dl, (node PTR [eax]).IsLeaf
		cmp dl, 1
		jne findNext
        mov dl, (node PTR [eax]).char
        mov BYTE PTR [edi], dl
        mov eax, nodeadress
        inc edi
        inc DataLeng
findNext:
		inc bh
		cmp bh, 8
		jae continue
		jmp ByteHandle
continue:
		inc esi
		mov bh, 0
		.IF ecx == 2
			mov bl, ByteFull
			mov bh, 8
			sub bh, bl
		.ENDIF
		loop dataDeCompress
		ret
dataHandle endp

ReadNewFile proc
		mov ecx, SIZEOF newFile
		INVOKE ReadFile,
			fileHandle,
			ADDR newFile,
			ecx,
			ADDR fileCount,
			0
		.IF eax == INVALID_HANDLE_VALUE
			jmp readError
		.ENDIF
		INVOKE CloseHandle, fileHandle
		ret
readError:
		mov edx,OFFSET readErrorTip;提示讀文件失敗
		call WriteString
		call Crlf
		call WaitMsg
		call ReturnToWindows
		ret
ReadNewFile endp

searchChar proc uses eax edx esi,;結果裝在cx，長度裝在bh dl放fileBuffer
		root: DWORD, Key: WORD, Keyleng: BYTE
		mov eax, root
		mov dh, (node PTR [eax]).IsLeaf
		cmp dh, 0
		ja Leaf
		inc Keyleng
		mov eax, root
		mov eax, (node PTR [eax]).left
		push eax
		mov ax, Key
		shl ax, 1
		mov key, ax
		pop eax
		mov esi, eax
		INVOKE searchChar, esi, Key, Keyleng
		mov eax, root
		mov eax, (node PTR [eax]).right
		inc Key
		mov esi, eax
		INVOKE searchChar, esi, Key, Keyleng
		ret
Leaf:
		mov dh, (node PTR [eax]).char
		cmp dh, dl
		jne EndSearch
		mov bh, Keyleng
		mov cx, Key
EndSearch:
		ret
searchChar endp

compress proc
		mov compressed,1
        call openFile
	    call readFile1
        mov ecx, 256
        lea edx, charNum
Init:
        mov DWORD PTR [edx], 0
        add edx, 4
        loop Init

        mov ecx, fileCount
        lea edi, fileBuffer
        lea edx, charNum
calcualate:
        movzx ebx, BYTE PTR [edi]
        shl ebx, 2
        inc DWORD PTR [edx + ebx]
        inc edi
        loop calcualate

        mov ecx, 256
        lea edi, charNum
        lea eax, treeNode
        mov edx, 0
        mov nodeadressTop, edx
        mov nodeTop, edx
CreateEveryNode:
        cmp DWORD PTR [edi], 0
        je IfZero
        mov edx, 256
        sub edx, ecx
        mov (node PTR [eax]).char, dl
        mov edx, DWORD PTR [edi]
        mov (node PTR [eax]).num, edx
        mov (node PTR [eax]).left, 0
        mov (node PTR [eax]).right, 0
        mov (node PTR [eax]).IsLeaf, 1
        mov edx, nodeadressTop
        shl edx, 2
        lea esi, nodeadress
        mov DWORD PTR [esi + edx], eax
        add eax, TYPE node
        inc nodeTop
        inc nodeadressTop
IfZero:
        add edi, 4
        loop CreateEveryNode

        mov ecx, nodeTop
        sub ecx, 1

CreateHuffmanTree:
        call findLittle
        mov eax, edx
        call findLittle
        mov ebx, edx
        lea edx, treeNode
        mov edi, nodeTop
        
        push eax
        push edx
        mov eax, 14
        mul edi
        mov edi, eax
        pop edx
        pop eax
        add edx, edi
        
        mov (node PTR [edx]).char, 0
        mov edi, (node PTR [eax]).num
        add edi, (node PTR [ebx]).num
        mov (node PTR [edx]).num, edi
        mov (node PTR [edx]).left, eax
        mov (node PTR [edx]).right, ebx
        mov (node PTR [edx]).IsLeaf, 0
        inc nodeTop

        mov eax, nodeadressTop
        shl eax, 2
        lea ebx, nodeadress
        add eax, ebx
        mov DWORD PTR [eax], edx
        inc nodeadressTop
        loop CreateHuffmanTree

        lea edi, fileBuffer
        lea esi, newFile
        mov ecx, fileCount
        mov bl, 0 ;BYTE裝到哪裡
        mov DataLeng, 0
dataCompress:
        push ecx
        mov dl, BYTE PTR [edi]
        INVOKE searchChar, nodeadress, 0, 0 ;結果裝在ah，長度裝在bh; 結果裝在cx，長度裝在bh
        
        mov dl, [esi]
        mov ax, cx
        mov cl, 16
        sub cl, bh
        shl ax, cl
        movzx ecx, bh
PushData:
        shl dl, 1
        cld
        shl ax, 1
        jnc EndPush
        add dl, 1
EndPush:
        inc bl
        .IF bl == 8
            mov bl, 0
            mov [esi], dl
            inc esi
            inc DataLeng
            mov dl, [esi]
        .ENDIF
        loop PushData

        mov BYTE PTR [esi], dl
        inc edi
        pop ecx
        dec ecx
        cmp ecx, 0
        ja dataCompress

        .IF bl != 0
			inc DataLeng
        .ENDIF
        mov ByteFull, bl
        mov cl, 8
        sub cl, bl
        mov al, BYTE PTR [esi]
        shl al, cl
        mov BYTE PTR [esi], al
        call writeCompressFile
        ret
compress endp

findLittle proc uses eax ebx ecx esi edi ;地址放在edx
        mov ecx, nodeadressTop
        lea edi, nodeadress
        mov ebx, 0ffffffffh
        mov edx, 0
find:
        mov eax, DWORD PTR [edi]
        cmp (node PTR [eax]).num, ebx
        jae continueFind
        mov ebx, (node PTR [eax]).num
        mov edx, edi
continueFind:
        add edi, 4
        loop find

        lea eax, nodeadress
        mov ebx, edx
        sub ebx, eax
        shr ebx, 2
        mov ecx, nodeadressTop
        sub ecx, ebx
        mov edi, edx
        mov esi, edx
        add esi, 4
        mov edx, DWORD PTR [edx]
        rep movsd
        dec nodeadressTop
        ret
findLittle endp

writeCompressFile proc
        call createFile1
        INVOKE WriteFile,
                fileHandle,
                ADDR nodeTop,
                4,
                ADDR bytesWriten,
                0
        mov eax, nodeadress
        lea ebx, treeNode
        sub eax, ebx
        mov nodeadress, eax
        INVOKE WriteFile,
                fileHandle,
                ADDR nodeadress,
                4,
                ADDR bytesWriten,
                0
        mov ecx, nodeTop
        lea esi, treeNode
        mov eax, esi
treeHandle:
        sub (node PTR [esi]).left, eax
        sub (node PTR [esi]).right, eax
        add esi, TYPE node
        loop treeHandle
        mov ecx, nodeTop
        mov eax, 14
        mul ecx
        mov ecx, eax
        INVOKE WriteFile,
                fileHandle,
                ADDR treeNode,
                eax,
                ADDR bytesWriten,
                0
        INVOKE WriteFile,
                fileHandle,
                ADDR DataLeng,
                4,
                ADDR bytesWriten,
                0
        INVOKE WriteFile,
                fileHandle,
                ADDR ByteFull,
                1,
                ADDR bytesWriten,
                0
        INVOKE WriteFile,
                fileHandle,
                ADDR newFile,
                DataLeng,
                ADDR bytesWriten,
                0
        INVOKE CloseHandle, fileHandle
        ret
writeCompressFile endp

end main