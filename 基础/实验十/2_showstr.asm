assume cs:codesg
para segment
	db 12,33
	db 24H
	db 'welcome back',0
para ends

codesg segment
start:
	mov ax,para
	mov ds,ax

	call showstr

	mov ax,4c00h	;������ʶ
	int 21h

showstr:
	push ax		;���ݱ���
	push es
	push cx
	push bx
	push si
	push dx

	mov ax,0B800H
	mov es,ax	;��Ļ���������ɫ���ڴ���׵�ַ
	mov al,160	;ÿ�е��ֽ���
	mov ah,ds:[0]	;��ȡָ��������

	dec ah		;������һ
	mul ah		;�����ǰ������Ŀհ�

	mov bx,ax	;�ȱ���������
	
	mov al,2
	mov ah,ds:[1]
	mul ah

	add bx,ax	;�����ƫ��λ��

	mov dl,[2]	;��ʽ
	mov si,3

s:	mov cl,[si]
	mov ch,0		;��cx�ĸ�ֵΪ�����е�ֵ�����ж�
	jcxz ok			;�����ȡ������λΪ0������ת��ok
	mov ax,[si]		;��ȡҪ��ʾ������
	mov es:[bx],ax		;���������뵽����ڴ���
	mov es:[bx + 1],dl	;������ʽ

	inc si
	add bx,2
	jmp short s	;ѭ����ȡ����
ok:	pop dx
	pop si		;���ݻָ�
	pop bx
	pop cx
	pop es
	pop ax

	ret		;����

codesg ends
end start