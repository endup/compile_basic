assume cs:codesg
para segment
	db 12,33	;这里存放行号和列号
	db 24H		;这里存放的是显示的数据的样式
	db 0 dup(100)	;这里用来存放转化后的数据
para ends
dig segment
	dw 1250,00001,0	;这里是转换源，将数字转换成字符串输出到屏幕,暂时只支持十进制
dig ends

codesg segment
start:
	mov ax,para
	mov ds,ax
	call showdig	;把需要转换的数字转换后放到相应位置
	call showstr	;输出转换后的数据

	mov ax,4c00h	;结束标识
	int 21h

showdig:
	push ax		;数据保存
	push es
	push si
	push di
	push cx
	push bx
	push dx

	mov ax,dig
	mov es,ax	;需要转换的数据的首地址
	mov si,0
d:	
	mov cx,es:[di]	;从源数据读取数据，若为0则说明已经全部转换完
	jcxz a

	mov ax,es:[di]
	mov dx,0	;算除法的高位

	push cx		;保持数据
	push dx		;这里的dx为0，用来标识每个数据的结束
e:
	mov dx,0
	mov bx,10	;10，利用一个数除以10的商来逐渐取出数字中的数字
	div bx
	mov bx,dx	;把余数存起来
	inc bl		;计算出对应数字的ascll码
	push bx		;把余数入栈

	mov cx,ax	;如果商为零则说明当前的数字已经处理完了
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

a:	pop dx		;数据恢复
	pop bx
	pop cx
	pop di
	pop si
	pop es
	pop ax
	ret

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