;�ӳ�������
;���ƣ�divdw
;���ܣ����в����������ĳ������㣬������Ϊdword�ͣ�����Ϊword�ͣ����Ϊdword�͡�
;������(ax)=dword�����ݵĵ�16λ
;    (dx)=dword�����ݵĸ�16λ
;    (cx)=����
;���أ�(dx)=����ĸ�16λ��(ax)=����ĵ�16λ
;    (cx)=����
;Ӧ�þ���������1000000/10(F4240H/0AH)

assume cs:code  
    code segment  
    start:mov ax,4240h  ;��������ʮ��λ
          mov dx,000fh  ;��������16λ
          mov cx,0Ah	;����
          call divdw  
          mov ax,4c00H  
          int 21h  
divdw:  
      push bx
      push ax  
      mov ax,dx		;�ȼ����ʮ��λ
      mov dx,0  
      div cx		
      mov bx,ax		;���̴�����
      pop ax		;ȡ����������ʮ��λ�����ʱ��dx���������Ϊ�´μ���ĸ�ʮ��λ
      div cx  
      mov cx,dx		;������������
      mov dx,bx		;���̵ĸ�ʮ��λ������
      pop bx
      ret      
    code ends  
end start