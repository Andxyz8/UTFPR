; Exemplo.s
; Desenvolvido para a placa EK-TM4C1294XL

; -------------------------------------------------------------------------------
; Declara??es EQU
;<NOME>         EQU <VALOR>

; -------------------------------------------------------------------------------

        AREA    |.text|, CODE, READONLY, ALIGN=2  
		THUMB
			
		; Se alguma fun??o do arquivo for chamada em outro arquivo	
        EXPORT Start2              	; Permite chamar a fun??o Start a partir de 
			                        ; outro arquivo. No caso startup.s
									
		; Se chamar alguma fun??o externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; fun??o <func>
; --------------------------------------------------------------------------------
Start2

		LDR r0, =123456
		MOV r1, #0
		MOV r2, #10
		MOV r2, #10
loop: CBZ r0, stop
		SDIV r0, r0, r2
		ADD r1, r1, #1
		B loop
		CBZ r0, stop
		SDIV r0, r0, r2
		ADD r1, r1, #1
		B loop
		CBZ r0, stop
		SDIV r0, r0, r2
		ADD r1, r1, #1
		B loop
		CBZ r0, stop
		SDIV r0, r0, r2
		ADD r1, r1, #1
		B loop
		CBZ r0, stop
		SDIV r0, r0, r2
		ADD r1, r1, #1
		B loop
		CBZ r0, stop
		SDIV r0, r0, r2
		ADD r1, r1, #1
		B loop
stop: CBZ r0, stop

; ---------------------------------------------------------------------------------

	ALIGN                           ; garante que o fim da se??o est? alinhada 
	END                             ; fim do arquivo
