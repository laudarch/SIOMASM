; ��������� ������� 21 ������ 2014�
; �������� ��������� �������, ����� ����������� ������� � �������� ������-�������, ��� �� ����������
.686
include /masm32/include/io.asm


.data
	msgInputN	db '������� N: ', 0
	msgBefore 	db '��: ', 0
	msgAfter 	db '�����: ', 0
	msgMinEl 	db 'Min = ', 0
	Arr 	dd 100 dup( 100 dup (?) )
	N 		dd ?
	i 		dd ?
	j 		dd ?

.code


;========= ��������� ������ ������� �� ����� ==========
_outMatrix proc
pusha
	mov esi, 0
	mov ecx, 0
	.while ecx < N
		push ecx

		mov ebx, 0
		mov ecx, 0
		.while ecx < N
			outint Arr[esi][ebx], 3 			; ������� ������� � ��������
			
			add ebx, 4
			inc ecx
		.endw

		newline
		pop ecx

		; too lazy to multiply by 4
		add esi, N
		add esi, N
		add esi, N
		add esi, N

		inc ecx
	.endw
popa
	ret
_outMatrix endp
;=======================================================


;====== ��������� �������� i ������� � j ������ =========
_nulMatrix proc
pusha
	mov esi, i
	mov ebx, 0
	mov ecx, 0
	.while ecx < N
		mov esi, i
		mov Arr[esi][ebx], 0

		add ebx, 4
		inc ecx
	.endw

	mov ebx, j
	mov esi, 0
	mov ecx, 0
	.while ecx < N
		mov ebx, j
		mov Arr[esi][ebx], 0

		; toooo lazy
		add esi, N
		add esi, N
		add esi, N
		add esi, N

		inc ecx
	.endw

popa
	ret
_nulMatrix endp
;==========================================================





start:
	; ���������� ������  (randomize)
	invoke GetCurrentProcessId
	invoke nseed, eax


	; ������ N
	outstr offset msgInputN
	inint N


	; ��������� ������� ������. �������
	mov esi, 0
	mov ecx, 0
	.while ecx < N
		push ecx

		mov ebx, 0
		mov ecx, 0
		.while ecx < N
			pusha 								; ������, ��� invoke ������� ��������
			invoke nrandom, 100 				; eax = random(100)
			mov Arr[esi][ebx], eax
			popa		
			
			add ebx, 4
			inc ecx
		.endw

		pop ecx

		; ��������� �� ������ ���������
		add esi, N
		add esi, N
		add esi, N
		add esi, N

		inc ecx
	.endw


	; ������� �������
	newline
	outstr offset msgBefore
	newline
	call _outMatrix


	; ���� min,
	; � ������ [i,j] - ����������
	mov eax, Arr
	mov esi, 0
	mov ecx, 0
	.while ecx < N
		push ecx

		mov ebx, 0
		mov ecx, 0
		.while ecx < N
			.if Arr[esi][ebx] < eax
				mov i, esi
				mov j, ebx
				mov eax, Arr[esi][ebx]
			.endif		
			
			add ebx, 4
			inc ecx
		.endw

		pop ecx

		; �� ������� ��� ���������!
		add esi, N
		add esi, N
		add esi, N
		add esi, N

		inc ecx
	.endw


	; ������� min
	newline
	outstr offset msgMinEl
	outint eax
	newline

	; �������� ������-�������
	call _nulMatrix

	; ������� �������
	newline
	outstr offset msgAfter
	newline
	call _outMatrix
	
	inint eax

exit

end start