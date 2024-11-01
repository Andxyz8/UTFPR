; -------------------------------------------------------------------------------
; Declara??es EQU
;<NOME>         EQU <VALOR>

; -------------------------------------------------------------------------------

        AREA    |.text|, CODE, READONLY, ALIGN=2  
		THUMB
			
		; Se alguma fun??o do arquivo for chamada em outro arquivo	
        EXPORT Start3              	; Permite chamar a fun??o Start a partir de 
			                        ; outro arquivo. No caso startup.s
									
		; Se chamar alguma fun??o externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; fun??o <func>
; --------------------------------------------------------------------------------
Start3

		MOV r0, #1
		MOV r1, #5
		MOV r2, #1
		loop: CMP r2, r1
		BGT stop
		MULS r0, r2, r0
		ADD r2, r2, #1
		B loop
		cmp r2, r1
		BGT stop
		MULS r0, r2, r0
		ADD r2, r2, #1
		B loop
		cmp r2, r1
		BGT stop
		MULS r0, r2, r0
		ADD r2, r2, #1
		B loop
		cmp r2, r1
		BGT stop
		MULS r0, r2, r0
		ADD r2, r2, #1
		B loop
		cmp r2, r1
		BGT stop
		MULS r0, r2, r0
		ADD r2, r2, #1
		B loop
		cmp r2, r1
		BGT stop
		stop: B loop

; ---------------------------------------------------------------------------------

	ALIGN                           ; garante que o fim da se??o est? alinhada 
	END                             ; fim do arquivo
