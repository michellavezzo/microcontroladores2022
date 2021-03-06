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
		CEMH
		VALUEH
		NIBBLEUND
		NIBBLEDEC
		NIBBLECENT
		COUNTER

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

SUBROTINA1

	;CORPO DA ROTINA

	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00000000' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SA�DAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000100'
	MOVWF	OPTION_REG	;DEFINE OP��ES DE OPERA��O
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OP��ES DE INTERRUP��ES
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERA��O DO COMPARADOR ANAL�GICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZA��O DAS VARI�VEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
    MOVLW 0
    MOVWF NIBBLEUND
    MOVWF NIBBLEDEC
    MOVWF NIBBLECENT ;; SETAR NIBBLES PARA ZERO
    
    MOVLW .3
    MOVWF COUNTER
    MOVLW 0x64
    MOVWF CEMH
    MOVLW 0xFF
    MOVWF VALUEH

    ;SUBWF  CEMH, W
    ;BTFSC STATUS, C  ; SKIP 0 (PULA SE FOR 0)
    ;GOTO SEMCARRY
    ;GOTO COMCARRY
    ; FALTA TRATAR CARRY https://johnloomis.org/ece314/notes/devices/binary_to_BCD/bin_to_bcd.html
    ;CRIAR VAR UNIDADE DEZENA E CENTENA
    ;COLOCAR O CARRY 
FIRSTROUTINE ;; PRIMEIRA ROTINA, EST� ERRADO, N�O PODE DAR SHIFT AGORA (REVER L�GICA)
    RLF VALUEH, 0
    ANDLW B'11111110'
    MOVWF VALUEH
    RLF VALUEH, 0
    ANDLW B'11111110'
    MOVWF VALUEH
SHIFTVALUE ;; SHIFT DE VALOR EST� ERRADO,
    ;; 1 -DEVER� PEGAR O PRIMEIRO BIT DA ESQUERDA
    ;; ALOCAR ESSE BIT NO WORK OU VARI�VEL
    ;; SHIFTAR O C�DIGO PARA DIREITA (J� IMPLEMENTADO LINHA 174...)
    ;; IR PARA O CHOOSENIBLE 
    ;; 
    RLF VALUEH, 0 ; SHIFT DE VALOR
    ANDLW B'11111110'
    MOVWF VALUEH
    ;INCF COUNTER ;; INCREMENTO DEVE ESTAR NOS SETNIBBLES
    ;; TESTE DO COUNTER		    ;se counter <= 4 vai pra und
				    ;se counter > 4 dec; 
				    ;se counter >= 8 vai pra cent e armazena no work
    MOVFW COUNTER
    SUBLW .5		;se counter <= 4 vai pra und
    BTFSC STATUS,C
    GOTO SETNIBBLEDEC   ; TENHO Q IR COM O NIBBLE LIMPO ROTINA ACIMA NECESSITA AJUSTE
    GOTO SETNIBBLEUND
    
   
TESTNIBLE ;; DECIDE SE O NIBLLE PRECISA SER SOMADO (INCORPORAR AO ADD3)
    ;SWAPF VALUEH, 0 ; INVERTER NIBBLES
    ;ANDLW B'00001111'  
    SUBLW .4 ; subtrai work de literal
    BTFSC STATUS, C ; se der carry pula 
    GOTO SHIFTVALUE
    GOTO ADD3   
    
ADD3 ;; SOMAR 3 AO NIBBLE MAIOR QUE 4
    MOVFW VALUEH  ;;;; trocar o value por work e trabalhar no nibble
    ADDLW B'00110000'
    MOVWF VALUEH
    GOTO SHIFTVALUE
    ;CORPO DA ROTINA PRINCIPAL
    
CHOOSENIBLE ;; ESCOLHER PARA QUAL NIBBLE O RESULTADO VAI
    ;;INCREMENTAR O COUNTER TODA VEZ QUE PASSAR AQUI
    ;;SUBTRARIR COUNTER - 4
    ;; SE FOR MENOR OU IGUAL A 4, SET NIBBLEUND
    ;; SE FOR MAIOR OU IGUAL A 4, SETNIBBLEDEC
    ;;VERIFICAR COMO VEJO SE � MAIOR Q 8, PROVAVELMENTE TESTAR CONDI��O DENTRO DO SETNIBBLEDEC
    
SETNIBBLEUND 
    ;; VAI RECEBER APENAS UM BIT B'00000001' OU B'00000000' 
    SWAP VALUEH, 0 ;; VERIFICAR SE O SWAP EST� USANDO A VARI�VEL CERTA
    ;; SHIFTAR SETNIBBLEUND ATUAL P DIREITA
    ;; OPERA��O DE OU NO ULTIMO BIT PARA SETAR 1 OU 0 
    ;; SETAR VARIAVEL NIBBLEUND
    ;; SE VALOR DO NIBBLE ATUAL > 4, ADD3 NELE 
    ANDLW B'00001111'
    MOVWF NIBBLEUND
    INCF COUNTER
    MOVFW NIBBLEUND
    GOTO TESTNIBLE ;; SE A VERIFICA��O DO NIBBLE > 4 FEITA AQUI, LABEL TESTNIBBLE E ADD3 PODEM SER REMOVIDOS
   
SETNIBBLEDEC
    ;;TESTAR SE COUNTER � MAIOR QUE 8, SE SIM IR� PRO SETNIBBLECENT 
    SWAP VALUEH, 0
    ANDLW B'00001111'
    MOVWF NIBBLEDEC
    INCF COUNTER
    MOVFW NIBBLEDEC
    GOTO TESTNIBLE
    
SETNIBBLECENT
    ;; ARMAZENAR NIBBLE NO WORK
GOTO MAIN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
