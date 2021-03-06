;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICA��ES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                      MAR�O DE 2021                              *
;*                 BASEADO NO EXEMPLO DO LIVRO                     *
;*           Desbravando o PIC. David Jos� de Souza                *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINI��ES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADR�O MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINA��O DE MEM�RIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINI��O DE COMANDOS DE USU�RIO PARA ALTERA��O DA P�GINA DE MEM�RIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEM�RIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAM�RIA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARI�VEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DOS NOMES E ENDERE�OS DE TODAS AS VARI�VEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDERE�O INICIAL DA MEM�RIA DE
					;USU�RIO
		W_TEMP		;REGISTRADORES TEMPOR�RIOS PARA USO
		STATUS_TEMP	;JUNTO �S INTERRUP��ES
		ATUAL_VALUE

		;COLOQUE AQUI SUAS NOVAS VARI�VEIS
		;N�O ESQUE�A COMENT�RIOS ESCLARECEDORES

	ENDC			;FIM DO BLOCO DE DEFINI��O DE VARI�VEIS

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS PINOS QUE SER�O UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMB�M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SA�DAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS PINOS QUE SER�O UTILIZADOS COMO SA�DA
; RECOMENDAMOS TAMB�M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDERE�O INICIAL DE PROCESSAMENTO
	GOTO	INICIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    IN�CIO DA INTERRUP��O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDERE�O DE DESVIO DAS INTERRUP��ES. A PRIMEIRA TAREFA � SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERA��O FUTURA

	ORG	0x04			;ENDERE�O INICIAL DA INTERRUP��O
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUP��O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SER�O ESCRITAS AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUP��ES
AD_ROUTINE
	BTFSS	PIR1, 6 ; TESTA SE HOUVE INTERRUP��O A/D
	GOTO	INT_TIMER ; CASO N�O, PULA PARA TESTE DE INTERRUP��O DE TIMER
	
	MOVLW .26    ;<0.5V ; DE ACORDO COM REGRA DE 3 => 5V /YV = 255 / X ; ONDE YV � A TENS�O DE TESTE
	SUBWF ADRESH, 0
	BTFSS STATUS, C
	GOTO SET_GPIO_N0

	MOVLW .45   ;<1V   ; DE ACORDO COM REGRA DE 3 => 5V /YV = 255 / X ; ONDE YV � A TENS�O DE TESTE
	SUBWF ADRESH, 0
	BTFSS STATUS, C
	GOTO SET_GPIO_N1
	
	MOVLW .76    ;<1.5V  //.79     ;1.55V
	SUBWF ADRESH, 0
	BTFSS STATUS, C
	GOTO SET_GPIO_N2
	
	MOVLW .102   ;<2V
	SUBWF ADRESH, 0
	BTFSS STATUS, C
	GOTO SET_GPIO_N3
	
	MOVLW .128   ;<2.5V	    //.130  ;<2.55V
	SUBWF ADRESH, 0
	BTFSS STATUS, C
	GOTO SET_GPIO_N4
	
	MOVLW .153   ;<3V
	SUBWF ADRESH, 0
	BTFSS STATUS, C
	GOTO SET_GPIO_N5
	
	MOVLW .179   ;<3.5V
	SUBWF ADRESH, 0
	BTFSS STATUS, C
	GOTO SET_GPIO_N6
	
	MOVLW .204   ;<4V
	SUBWF ADRESH, 0
	BTFSS STATUS, C
	GOTO SET_GPIO_N7
	
	MOVLW .230   ;<4.5V
	SUBWF ADRESH, 0
	BTFSS STATUS, C
	GOTO SET_GPIO_N8
	
SET_GPIO_N9	    ; CADA LABEL "SET_GPIO_" IR� ATIVAR AS PORTAS DE ACORDO COM VALOR DE TENSAO ESPECIFICADO NA TABELA
	BSF GPIO, GP0   
	BCF GPIO, GP1
	BCF GPIO, GP4
	BSF GPIO, GP5
	GOTO FINISH_AD_CONV	
SET_GPIO_N8
	BCF GPIO, GP0
	BCF GPIO, GP1
	BCF GPIO, GP4
	BSF GPIO, GP5
	GOTO FINISH_AD_CONV	
SET_GPIO_N7
	BSF GPIO, GP0
	BSF GPIO, GP1
	BSF GPIO, GP4
	BCF GPIO, GP5
	GOTO FINISH_AD_CONV
SET_GPIO_N6
	BCF GPIO, GP0
	BSF GPIO, GP1
	BSF GPIO, GP4
	BCF GPIO, GP5
	GOTO FINISH_AD_CONV
SET_GPIO_N5
	BSF GPIO, GP0
	BCF GPIO, GP1
	BSF GPIO, GP4
	BCF GPIO, GP5
	GOTO FINISH_AD_CONV
SET_GPIO_N4
	BCF GPIO, GP0
	BCF GPIO, GP1
	BSF GPIO, GP4
	BCF GPIO, GP5
	GOTO FINISH_AD_CONV
SET_GPIO_N3
	BSF GPIO, GP0
	BSF GPIO, GP1
	BCF GPIO, GP4
	BCF GPIO, GP5
	GOTO FINISH_AD_CONV
SET_GPIO_N2
	BCF GPIO, GP0
	BSF GPIO, GP1
	BCF GPIO, GP4
	BCF GPIO, GP5
	GOTO FINISH_AD_CONV
SET_GPIO_N1
	BSF GPIO, GP0
	BCF GPIO, GP1
	BCF GPIO, GP4
	BCF GPIO, GP5
	GOTO FINISH_AD_CONV
SET_GPIO_N0
	BCF GPIO, GP0
	BCF GPIO, GP1
	BCF GPIO, GP4
	BCF GPIO, GP5
	GOTO FINISH_AD_CONV

FINISH_AD_CONV	;FIM DE CONVERSAO
	BCF	PIR1, 6 ; LIMPAR FLAG AD INTER
	GOTO	SAI_INT	; SAIR INT...
	
INT_TIMER 
	BSF	ADCON0, 0 ; LIGAR CONVERSOR DEPOIS TIMER
	BSF	ADCON0, 1 ; ACIONA A CONVERS�O
	
	BCF	PIR1, 0	    ; LIMPAR FLAG TIMER INTER
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SA�DA DA INTERRUP��O                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUP��O

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRI��O DE FUNCIONAMENTO
; E UM NOME COERENTE �S SUAS FUN��ES.

	
	; O CALCULO TEMPO FOI FEITO COM BASE EM QUANTOS uS � PRECISO P�RA 1OOms, 
	; QUANTOS uS DISPON�VEL PARA CONTAGEM COM PRESCALER 2X 
	; E PARA CADA BYTE FOI CALCULADO O VALOR 
	; HIGH (VALTOT - VALNECES) / (256 x 2) (CONTAGEM EM UM BYTE X 2 DO PRESCALER = 60)
	; LOW (RESTO DIV * 256 ) O QUE SOBROU PARA O BYTE LOW
	
	;TMR1H:TTMR1L register pair and the TMR1IF bit should be cleared before enabling interrupts.
SUBROT_HUNDRED_MS
	BCF	PIR1, TMR1IF ; LIMPANDO FLAG TMR1
	MOVLW	.60	    
	MOVWF	TMR1H	    ;SETANDO VALOR INICIAL  PARA TMR1H PARA CONTAGEM 
	MOVLW	.174	    ;SETANDO VALOR INICIAL PARA TMR1L PARA CONTAGEM 
	MOVWF	TMR1L
SUBROT_COUNT_LOOP
	BTFSS PIR1, TMR1IF
	GOTO SUBROT_COUNT_LOOP
	
	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00000100' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SA�DAS
	MOVWF	ANSEL 		;DEFINE PORTAS COMO Digital I/O, gp2 analogico
	MOVLW	B'00000100'
	MOVWF	OPTION_REG	;DEFINE OP��ES DE OPERA��O
	MOVLW	B'11000000'
	MOVWF	INTCON		;DEFINE OP��ES DE INTERRUP��ES interrup�ao perif�ricos
	MOVLW	B'01000001'     ;ATIVANDO INTERRUPCAO TMR1 E A/D CONVERTER
	MOVWF	PIE1
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERA��O DO COMPARADOR ANAL�GICO
	MOVLW	B'00001000'     ; LIGANDO CONVERSOR AD, SETANDO GP2/AN2 COMO ENTRADA; CONV DESLIGADA
	MOVWF	ADCON0
	MOVLW	B'00010001'
	MOVWF	T1CON           ; CONFIG TIMER1 ATIVANDO CONTAGEM PRESC 2
	MOVLW	B'00000000'
	MOVWF	PIR1		;LIMPANDO FLAGS
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZA��O DAS VARI�VEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	;CORPO DA ROTINA PRINCIPAL
	BCF	ADCON0, 0 ; DESLIGAR CONVERSAO DURANTE TIMER
	CALL	SUBROT_HUNDRED_MS ; CHAMAR TIMER
MAIN_CONV_LOOP
	BTFSC	ADCON0, 1  ; AGUARDAR CONVERSAO 
	GOTO MAIN_CONV_LOOP
	
	GOTO	MAIN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
