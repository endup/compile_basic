;子程序描述
;名称：divdw
;功能：进行不会产生溢出的除法运算，被除数为dword型，除数为word型，结果为dword型。
;参数：(ax)=dword型数据的低16位
;    (dx)=dword型数据的高16位
;    (cx)=除数
;返回：(dx)=结果的高16位，(ax)=结果的低16位
;    (cx)=余数
;应用举例：计算1000000/10(F4240H/0AH)

assume cs:code  
    code segment  
    start:mov ax,4240h  ;被除数低十六位
          mov dx,000fh  ;被除数高16位
          mov cx,0Ah	;除数
          call divdw  
          mov ax,4c00H  
          int 21h  
divdw:  
      push bx
      push ax  
      mov ax,dx		;先计算高十六位
      mov dx,0  
      div cx		
      mov bx,ax		;把商存起来
      pop ax		;取出被除数低十六位，这个时候dx里的余数作为下次计算的高十六位
      div cx  
      mov cx,dx		;把余数存起来
      mov dx,bx		;把商的高十六位存起来
      pop bx
      ret      
    code ends  
end start