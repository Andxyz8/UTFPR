; Exemplo.s
; Desenvolvido para a placa EK-TM4C1294XL

; -------------------------------------------------------------------------------
; Declara??es EQU
;<NOME>         EQU <VALOR>

; -------------------------------------------------------------------------------

        AREA    |.text|, CODE, READONLY, ALIGN=2  
		THUMB
			
		; Se alguma fun??o do arquivo for chamada em outro arquivo	
        EXPORT Start              	; Permite chamar a fun??o Start a partir de 
			                        ; outro arquivo. No caso startup.s
									
		; Se chamar alguma fun??o externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; fun??o <func>
; --------------------------------------------------------------------------------
Start

		MOV r1, #3
		MOV r2, #5
		MOVS r3, #6
		ADD r0, r2, r3
		ADDS r0, r2, r3
		ADDS r0, #9
		CMP r0, #8
		SUBS r0, #10
		SUBS r0, r0, #256
		SUB r0, r0, #3000
		ASR r0, r0, #5

menor
stop B stop

; ---------------------------------------------------------------------------------

	ALIGN                           ; garante que o fim da se??o est? alinhada 
	END                             ; fim do arquivo
