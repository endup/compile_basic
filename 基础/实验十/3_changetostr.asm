assume cs:codesg
para segment
	db 12,33	;�������кź��к�
	db 24H		;�����ŵ�����ʾ�����ݵ���ʽ
	db 0 dup(100)	;�����������ת���������
para ends
dig segment
	dw 1250,00001,0	;������ת��Դ��������ת�����ַ����������Ļ,��ʱֻ֧��ʮ����
dig ends

codesg segment
start:
	mov ax,para
	mov ds,ax
	call showdig	;����Ҫת��������ת����ŵ���Ӧλ��
	call showstr	;���ת���������

	mov ax,4c00h	;������ʶ
	int 21h

showdig:
	push ax		;���ݱ���
	push es
	push si
	push di
	push cx
	push bx
	push dx

	mov ax,dig
	mov es,ax	;��Ҫת�������ݵ��׵�ַ
	mov si,0
d:	
	mov cx,es:[di]	;��Դ���ݶ�ȡ���ݣ���Ϊ0��˵���Ѿ�ȫ��ת����
	jcxz a

	mov ax,es:[di]
	mov dx,0	;������ĸ�λ

	push cx		;��������
	push dx		;�����dxΪ0��������ʶÿ�����ݵĽ���
e:
	mov dx,0
	mov bx,10	;10������һ��������10��������ȡ�������е�����
	div bx
	mov bx,dx	;������������
	inc bl		;�������Ӧ���ֵ�ascll��
	push bx		;��������ջ

	mov cx,ax	;�����Ϊ����˵����ǰ�������Ѿ���������
	jcxz b
	jmp short e
b:
	pop cx
	jcxz f
	add cx,2fH
	mov ds:[si + 3],cl
	add si,1
	jmp short b

f:	pop cx
	add di,2
	jmp short d

a:	pop dx		;���ݻָ�
	pop bx
	pop cx
	pop di
	pop si
	pop es
	pop ax
	ret

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