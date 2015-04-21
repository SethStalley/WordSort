%include "io.mac"

.DATA
nonOrderedMsg	db	"Ten unordered Words are: ",0
orderedMsg	db	"The ten words ordered alphabetically: ",0
		;10 words of 10bytes MAX each starts here
word1		db  	"new", 0	;word 1
word2		db 	"mundo", 0
word3		db 	"palindrome"	;if exactly 10 chars no need for 0
word4		db 	"Grecia", 0
word5		db 	"Nasm", 0
word6		db 	"HOLA", 0
word7		db 	"gato", 0
word8		db 	"Costa Rica"
word9		db 	"Arduino", 0
word10		db 	"Dota", 0	;word 10
.UDATA
wordBuffer	resb 10			;used to swap word order arround
wordArray	resb 100		;load words into here, fill with 0

.CODE
	.STARTUP
loadWords:			;load words intro array
	mov esi, wordArray
	mov ebx, word1
	mov cx, 12		;12 because we have 10 words and we dec before looping
	sub esi, 10
loadWordsLoop:
	add esi, 10
	xor edx, edx
	dec cx
	je showNonOrdered
movCharsLoop:			;mov all cahrs in word
	mov ah, [ebx]		;align get our char
	mov [esi+edx],ah
	inc ebx			;move to next char
	inc edx

	cmp edx, 10
	je loadWordsLoop	

	cmp ah, 0		;if end of word go to next word
	je loadWordsLoop	;if we counted through 10 chars then also go to next word
	jmp movCharsLoop	;when 0 stop looping

showNonOrdered:
	nwln
	PutStr nonOrderedMsg
	nwln

sortArrayInit:			;sort the words in the array alphabetically
	mov esi, wordArray
	mov ebx, wordBuffer
	xor ecx, ecx
	push ecx
	xor edx, edx		;we going to compare first letter
getWord:			;Get each word to be compared
	pop ecx
	mov eax, 10		;to move esi pointer 10 bytes 
	imul eax, ecx		;mul displacement by word calculating
	add esi, eax		;add displacement
	inc ecx
	cmp ecx, 10	
	je showOrdered
	push esi
	jmp movWordBuffer
compareWord:
	inc ecx
	add esi, 10
	mov ah, [esi]
	mov al, [ebx]

	cmp ecx, 1
	je showOrdered		;need change for get Word
	push esi
	cmp al, ah
	jge movWordBuffer
	pop esi


showWordsInit:
	mov cx, 11		;10 words to display
	mov esi, wordArray	;point esi to beginning of esi
	sub esi, 10
showWords:
	xor edx, edx		;use as index
	add esi, 10
showChars:
	PutCh	[esi+edx]
	inc edx
	cmp edx ,10
	jne showChars
	nwln
	dec cx
	jne showWords

showOrdered:
	PutStr	orderedMsg
	nwln
	PutStr	wordBuffer
	nwln

END:
	.EXIT


movWordBuffer:
	pop esi
	push cx
	push ebx
	mov ebx, wordBuffer
	xor cx, cx
movWordBufferLoop:
	mov ah,[esi]
	mov [ebx], ah
	cmp ah, 0
	je finishWordBufferMov
	inc ebx
	inc esi
	inc cx
	cmp cx, 10
	je finishWordBufferMov
	jmp movWordBufferLoop
finishWordBufferMov:
	nwln
	PutStr wordBuffer
	nwln
	pop ebx
	pop cx
	jmp compareWord
