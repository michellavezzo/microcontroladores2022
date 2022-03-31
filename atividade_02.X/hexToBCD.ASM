;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICAÇÕES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                      MARÇO DE 2021                              *
;*                 BASEADO NO EXEMPLO DO LIVRO                     *
;*           Desbravando o PIC. David José de Souza                *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINIÇÕES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADRÃO MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINAÇÃO DE MEMÓRIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINIÇÃO DE COMANDOS DE USUÁRIO PARA ALTERAÇÃO DA PÁGINA DE MEMÓRIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEMÓRIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAMÓRIA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARIÁVEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DOS NOMES E ENDEREÇOS DE TODAS AS VARIÁVEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDEREÇO INICIAL DA MEMÓRIA DE
					;USUÁRIO
		W_TEMP		;REGISTRADORES TEMPORÁRIOS PARA USO
		STATUS_TEMP	;JUNTO ÀS INTERRUPÇÕES
		CEMH
		VALUEH
		NIBBLEUND
		NIBBLEDEC
		NIBBLECENT
		COUNTER

		;COLOQUE AQUI SUAS NOVAS VARIÁVEIS
		;NÃO ESQUEÇA COMENTÁRIOS ESCLARECEDORES

	ENDC			;FIM DO BLOCO DE DEFINIÇÃO DE VARIÁVEIS

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SAÍDAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO SAÍDA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDEREÇO INICIAL DE PROCESSAMENTO
	GOTO	INICIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    INÍCIO DA INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDEREÇO DE DESVIO DAS INTERRUPÇÕES. A PRIMEIRA TAREFA É SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERAÇÃO FUTURA

	ORG	0x04			;ENDEREÇO INICIAL DA INTERRUPÇÃO
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SERÃO ESCRITAS AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUPÇÕES

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SAÍDA DA INTERRUPÇÃO                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUPÇÃO

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRIÇÃO DE FUNCIONAMENTO
; E UM NOME COERENTE ÀS SUAS FUNÇÕES.

SUBROTINA1

	;CORPO DA ROTINA

	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00000000' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SAÍDAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000100'
	MOVWF	OPTION_REG	;DEFINE OPÇÕES DE OPERAÇÃO
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OPÇÕES DE INTERRUPÇÕES
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
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
FIRSTROUTINE ;; PRIMEIRA ROTINA, ESTÁ ERRADO, NÃO PODE DAR SHIFT AGORA (REVER LÓGICA)
    RLF VALUEH, 0
    ANDLW B'11111110'
    MOVWF VALUEH
    RLF VALUEH, 0
    ANDLW B'11111110'
    MOVWF VALUEH
SHIFTVALUE ;; SHIFT DE VALOR ESTÁ ERRADO,
    ;; 1 -DEVERÁ PEGAR O PRIMEIRO BIT DA ESQUERDA
    ;; ALOCAR ESSE BIT NO WORK OU VARIÁVEL
    ;; SHIFTAR O CÓDIGO PARA DIREITA (JÁ IMPLEMENTADO LINHA 174...)
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
    ;;VERIFICAR COMO VEJO SE É MAIOR Q 8, PROVAVELMENTE TESTAR CONDIÇÃO DENTRO DO SETNIBBLEDEC
    
SETNIBBLEUND 
    ;; VAI RECEBER APENAS UM BIT B'00000001' OU B'00000000' 
    SWAP VALUEH, 0 ;; VERIFICAR SE O SWAP ESTÁ USANDO A VARIÁVEL CERTA
    ;; SHIFTAR SETNIBBLEUND ATUAL P DIREITA
    ;; OPERAÇÃO DE OU NO ULTIMO BIT PARA SETAR 1 OU 0 
    ;; SETAR VARIAVEL NIBBLEUND
    ;; SE VALOR DO NIBBLE ATUAL > 4, ADD3 NELE 
    ANDLW B'00001111'
    MOVWF NIBBLEUND
    INCF COUNTER
    MOVFW NIBBLEUND
    GOTO TESTNIBLE ;; SE A VERIFICAÇÃO DO NIBBLE > 4 FEITA AQUI, LABEL TESTNIBBLE E ADD3 PODEM SER REMOVIDOS
   
SETNIBBLEDEC
    ;;TESTAR SE COUNTER É MAIOR QUE 8, SE SIM IRÁ PRO SETNIBBLECENT 
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
