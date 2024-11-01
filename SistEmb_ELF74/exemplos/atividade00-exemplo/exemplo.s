; Exemplo.s
; Desenvolvido para a placa EK-TM4C1294XL

; -------------------------------------------------------------------------------
; Declara��es EQU
;<NOME>         EQU <VALOR>

; -------------------------------------------------------------------------------

        AREA    |.text|, CODE, READONLY, ALIGN=2  
		THUMB
			
		; Se alguma fun��o do arquivo for chamada em outro arquivo	
        EXPORT Start              	; Permite chamar a fun��o Start a partir de 
			                        ; outro arquivo. No caso startup.s
									
		; Se chamar alguma fun��o externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; fun��o <func>
; --------------------------------------------------------------------------------
Start

		MOV r0,#1
		MOV r1,#5
		ADD r2,r1,r0
		MUL r0,r2,r1
		CMP r0,#15
		BGE menor
		SUB r0,r2,r1
menor
stop B stop

; ---------------------------------------------------------------------------------

	ALIGN                           ; garante que o fim da se��o est� alinhada 
	END                             ; fim do arquivo
