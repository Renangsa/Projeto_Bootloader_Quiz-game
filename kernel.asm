org 0x7e00
jmp 0x0000:start

data:
    X times 1 db 0
    valor times 10 dw 0
    contador times 10 db 0
    mensagem db 'Bem-vindo ao Quiz de Infra de soft!',0
    questao1 db 'Qual o nome dos dois modos nos SO?? ' , 0
    resposta1a db 'a) kernel e usuario.' , 0                        ;correta
    resposta1b db 'b) kernel e real.' , 0
    resposta1c db 'c) real e imaginario.' ,0
    resposta1d db 'd) maquina e usuario.', 0  
    questao2 db 'Quais sao os estados de um processo?' , 0
    resposta2a db 'a) Analisando, Pronto, Despachando.' , 0
    resposta2b db 'b) Produzindo, Execucao, Exclusao.' , 0
    resposta2c db 'c) Bloqueado, Pronto, Execucao.' ,0              ;correta
    resposta2d db 'd) Bloqueado, Comparando, Pronto.', 0
    questao3 db 'O que eh uma condicao de disputa em infra-software?' , 0
    resposta3a db 'a) Eh quando um aplicativo apresenta algum erro de execucao.' , 0
    resposta3b db 'b) Quando duas pessoas escolhem o mesmo PC para jogar em uma lan house lotada.' , 0
    resposta3c db 'c) Eh uma linha de execucao de codigo que executa em paralelo outras linhas do mesmo processo.' ,0
    resposta3d db 'd) Quando 2 ou mais processos estao lendo/escrevendo dados compartilhados.', 0                       ;correta
    questao4 db 'Qual das alternativas abaixo nao representam o CPU-Bound?' , 0
    resposta4a db 'a) Maior parte do tempo usando a CPU e caracteriza um sistema interativo.' , 0                        
    resposta4b db 'b) Pouca interatividade com o usuario e maior tempo em espera por I/O.' , 0
    resposta4c db 'c) Maior tempo em espera por I/O e caracteriza um sistema interativo.' ,0
    resposta4d db 'd) Maior parte do tempo usando a CPU e pouca interatividade com o usuario.', 0  ;correta
    questao5 db 'Qual desses algoritmos eh nao preemptivo?' , 0
    resposta5a db 'a) Round-Robin.' , 0                        ;correta
    resposta5b db 'b) FIFO.' , 0
    resposta5c db 'c) Multiple Feedback Queue.' ,0
    resposta5d db 'd) Algoritmo por prioridade.', 0
    opcoes db 'Selecione uma das duas opcoes',0
    opcao1 db '1)Jogar',0
    opcao2 db '2)Creditos',0
    alunos db 'Alunos',0
    nome1 db 'Joao Pedro Barreto',0
    nome2 db 'Renan Siqueira',0
    nome3 db 'Vinicius Principe',0
    aviso db 'ESC para voltar',0
    final db 'Obrigado por ter jogado!', 0

putchar:    ;Printa um caractere na tela, pega o valor salvo em al
  mov ah, 0x0e
  int 10h
  ret
    
getchar:    ;Pega o caractere lido no teclado e salva em al
  mov ah, 0x00
  int 16h
  ret

delchar:    ;Deleta um caractere lido no teclado
  mov al, 0x08          ; backspace
  call putchar
  mov al, ' '
  call putchar
  mov al, 0x08          ; backspace
  call putchar
  ret
  
endl:       ;Pula uma linha, printando na tela o caractere que representa o /n
  mov al, 0x0a          ; line feed
  call putchar
  mov al, 0x0d          ; carriage return
  call putchar
  ret

reverse:              ; mov si, string , pega a string apontada por si e a reverte 
  mov di, si
  xor cx, cx          ; zerar contador
  .loop1:             ; botar string na stack
    lodsb
    cmp al, 0
    je .endloop1
    inc cl
    push ax
    jmp .loop1
  .endloop1:
  .loop2:             ; remover string da stack        
    pop ax
    stosb
    loop .loop2
  ret

gets:                 ; mov di, string, salva na string apontada por di, cada caractere lido na linha
  xor cx, cx          ; zerar contador
  .loop1:
    call getchar
    cmp al, 0x08      ; backspace
    je .backspace
    cmp al, 0x0d      ; carriage return
    je .done
    cmp cl, 10        ; string limit checker
    je .loop1
    
    stosb
    inc cl
    call putchar
    
    jmp .loop1
    .backspace:
      cmp cl, 0       ; is empty?
      je .loop1
      dec di
      dec cl
      mov byte[di], 0
      call delchar
    jmp .loop1
  .done:
  mov al, 0
  stosb
  call endl
  ret

strcmp:              ; mov si, string1, mov di, string2, compara as strings apontadas por si e di
  .loop1:
    lodsb
    cmp al, byte[di]
    jne .notequal
    cmp al, 0
    je .equal
    inc di
    jmp .loop1
  .notequal:
    clc
    ret
  .equal:
    stc
    ret


prints:             ; mov si, string
  .loop:
    lodsb           ; bota character apontado por si em al 
    cmp al, 0       ; 0 é o valor atribuido ao final de uma string
    je .endloop     ; Se for o final da string, acaba o loop
    call putchar    ; printa o caractere
    jmp .loop       ; volta para o inicio do loop
  .endloop:
ret

clear:                   ; mov bl, color
  ; set the cursor to top left-most corner of screen
  mov dx, 0 
  mov bh, 0      
  mov ah, 0x2
  int 0x10

  ; print 2000 blank chars to clean  
  mov cx, 2000 
  mov bh, 0
  mov al, 0x20 ; blank char
  mov ah, 0x9
  int 0x10
  
  ; reset cursor to top left-most corner of screen
  mov dx, 0 
  mov bh, 0      
  mov ah, 0x2
  int 0x10
  ret

delay: 
  mov    CX, 0FH
  mov    DX, 8480H
  mov    AH, 86H
  int    15H

  ret

init_video:
  mov ah, 00h ;escolhe modo video
  mov al, 12h ;modo VGA
  int 10h     ;chama interrupt

  ret

tela_vermelha:
  mov ah, 0xb
  mov bh, 0
  mov bl, 4
  int 10h

  ret

tela_verde:
  mov ah, 0xb
  mov bh, 0
  mov bl, 2
  int 10h

  ret

primeira:
  mov bl, 15
  mov si, questao1        ;coloca a string no source index register
  call prints             ;printa o que tá no si
  call endl               ;faz o \n pulando pra próxima linha
  
  call delay              ;faz um delay na hora de mostrar as respostas
  call delay
  mov si, resposta1a      ;faz a mesma coisa acima ao colocar as respostas no si para serem lidas no prints
  call prints 
  call endl
  mov si, resposta1b
  call prints 
  call endl
  mov si, resposta1c
  call prints 
  call endl
  mov si, resposta1d
  call prints 
  call endl
  ret

segunda:
  mov bl, 15            ;serve pra 'limpar' a cor do texto
  mov si, questao2
  call prints 
  call endl
  
  call delay
  call delay
  mov si, resposta2a
  call prints 
  call endl
  mov si, resposta2b
  call prints 
  call endl
  mov si, resposta2c
  call prints 
  call endl
  mov si, resposta2d
  call prints 
  call endl
  ret

terceira:
  mov bl, 15
  mov si, questao3
  call prints 
  call endl
  
  call delay
  call delay
  mov si, resposta3a
  call prints 
  call endl
  mov si, resposta3b
  call prints 
  call endl
  mov si, resposta3c
  call prints 
  call endl
  mov si, resposta3d
  call prints 
  call endl
  ret

quarta:
  mov bl, 15
  mov si, questao4
  call prints 
  call endl
  
  call delay
  call delay
  mov si, resposta4a
  call prints 
  call endl
  mov si, resposta4b
  call prints 
  call endl
  mov si, resposta4c
  call prints 
  call endl
  mov si, resposta4d
  call prints 
  call endl
  ret

quinta:
  mov bl, 15
  mov si, questao5
  call prints 
  call endl
  
  call delay
  call delay
  mov si, resposta5a
  call prints 
  call endl
  mov si, resposta5b
  call prints 
  call endl
  mov si, resposta5c
  call prints 
  call endl
  mov si, resposta5d
  call prints 
  call endl
  ret

compare:    
  ;move 'a' para o counter register
  cmp [X],cl          ;compara o que está em cl com o caractere quee estiver em X(colocado pelo usuario)
  JNE tela_vermelha   ;jump if not equal (Caso o que estiver em X não seja igual a resposta correta dentro do cl)
  call tela_verde     ;caso seja igual, vai ignorar o jne e vai printar a tela verde
  ret

jogo:
  call clear
  call primeira
  mov di, X
  call gets           
  call endl

  call clear
  call delay 
    
  mov cl,'a'
  call compare

  call delay

  call init_video
  
  call segunda                ;call segunda
  mov di, X
  call gets           
  call endl

  call clear
  call delay 
  
  mov cl,'c'
  call compare

  call delay

  call init_video

  call terceira               ;call terceira
  mov di, X
  call gets           
  call endl

  call clear
  call delay 
  
  mov cl,'d'
  call compare

  call delay

  call init_video   
  
  call quarta                ;call quarta
  mov di, X
  call gets           
  call endl

  call clear
  call delay 
  
  mov cl,'d'
  call compare

  call delay

  call init_video  

  call quinta               ;call quinta
  mov di, X
  call gets           
  call endl

  call clear
  call delay 
  
  mov cl,'b'
  call compare

  call delay

  
  call init_video
  
  mov ah, 02h  ;Setando o cursor
  mov bh, 0    ;Pagina 0
  mov dh, 5    ;Linha
  mov dl, 26   ;Coluna
  int 10h
  mov bl,14
  mov si, final


  call prints
  call delay
  call delay
  

  
menu:
  call clear 
  mov ah, 02h  ;Setando o cursor
  mov bh, 0    ;Pagina 0
  mov dh, 5    ;Linha
  mov dl, 20   ;Coluna
  mov bl, 11
  int 10h
  mov si, mensagem

  call prints         
  call delay

  mov si,opcoes
  mov ah, 02h  ;Setando o cursor
  mov bh, 0    ;Pagina 0
  mov dh, 10    ;Linha
  mov dl, 30   ;Coluna
  mov bl, 11
  int 10h
  mov si, opcao1
  call prints

  mov ah, 02h  ;Setando o cursor
  mov bh, 0    ;Pagina 0
  mov dh, 15    ;Linha
  mov dl, 30   ;Coluna
  mov bl, 11
  int 10h
  mov si,opcao2
  call prints

  call selecionar
  

  ret
selecionar:
  call getchar
  cmp al,49
  je jogo
  cmp al,50
  je creditos
  jne selecionar

creditos:
  call clear
  call init_video
  mov bl,11
  mov si,aviso
  call prints

  mov ah, 02h  ;Setando o cursor
  mov bh, 0    ;Pagina 0
  mov dh, 5    ;Linha
  mov dl, 36   ;Coluna
  int 10h
  mov si,alunos
  call prints


  mov si,nome1
  mov ah, 02h  ;Setando o cursor
  mov dh, 10    ;Linha
  mov dl, 30   ;Coluna
  
  int 10h
  call prints


  mov si,nome3
  mov ah, 02h  ;Setando o cursor
  mov dh, 14    ;Linha
  mov dl, 30   ;Coluna
  int 10h
  call prints

  mov si,nome2
  mov ah, 02h  ;Setando o cursor
  mov dh, 12    ;Linha
  mov dl, 30   ;Coluna
  int 10h
  call prints

  

  
  call getchar
  cmp al,27
  je menu
  jne creditos 

start:
  xor ax, ax
  mov ds, ax
  mov es, ax
  ;Código do projeto...

  call init_video       ;inciando o vídeo
  
  call menu

jmp $
