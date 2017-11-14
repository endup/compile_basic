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

	mov ax,4c00h	;结束标识
	int 21h

showstr:
	push ax		;数据保存
	push es
	push cx
	push bx
	push si
	push dx

	mov ax,0B800H
	mov es,ax	;屏幕中能输出颜色的内存的首地址
	mov al,160	;每行的字节数
	mov ah,ds:[0]	;读取指定的行数

	dec ah		;行数减一
	mul ah		;求出当前行上面的空白

	mov bx,ax	;先保存运算结果
	
	mov al,2
	mov ah,ds:[1]
	mul ah

	add bx,ax	;输出的偏移位置

	mov dl,[2]	;样式
	mov si,3

s:	mov cl,[si]
	mov ch,0		;把cx的赋值为数据中的值来做判断
	jcxz ok			;如果读取的数据位为0，则跳转至ok
	mov ax,[si]		;读取要显示的数据
	mov es:[bx],ax		;把数据输入到输出内存中
	mov es:[bx + 1],dl	;设置样式

	inc si
	add bx,2
	jmp short s	;循环读取数据
ok:	pop dx
	pop si		;数据恢复
	pop bx
	pop cx
	pop es
	pop ax

	ret		;返回

codesg ends
end start