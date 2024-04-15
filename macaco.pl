:- dynamic posicao/2.
:- dynamic altura/2.
:- dynamic pegou/2.

posicoes([porta, janela, centro]).
alturas([chao, em_cima_da_caixa, teto]).

posicao(macaco, porta).
posicao(caixa, janela).
posicao(banana, centro).

altura(macaco, chao).
altura(caixa, chao).
altura(banana, teto).

pegou(macaco, nada).

imprimir_posicao_altura(Entidade) :-
    posicao(Entidade, Posicao),
    altura(Entidade, Altura),
    format("Posição do ~w: ~w/~w~n", [Entidade, Posicao, Altura]).

imprimir_acao_macaco :-
    write("Escolha a ação do macaco: "),
    %Quero adicionar um if
   % Se a posição do macaco for a mesma da caixa
    (   altura(macaco, chao) ->
        write('1. Mover macaco'), nl
    ;   true
    ),
    (   posicao(macaco, Posicao),
        posicao(caixa, Posicao),
        altura(macaco, chao)->
        write('2. Subir na caixa'), nl,
        write('3. Mover caixa'), nl
    ;   true
    ),
    (   posicao(macaco, Posicao),
        posicao(banana, Posicao),
        altura(macaco, em_cima_da_caixa)->
        write('4. Pegar Banana'), nl
    ;   true
    ),
    (   altura(macaco, em_cima_da_caixa) ->  
    	write("5. Descer da caixa"), nl
    ;   true
    ).

posicao_inicial(Entidade) :-
    % trocar "macaco" por Entidade
    write("Digite a posição inicial de "), write(Entidade), write(" (porta, janela, centro): "),
    read(PosicaoInicial),
    posicoes(Posicoes),
    (
    	member(PosicaoInicial, Posicoes) ->  
    	retractall(posicao(Entidade, _)),
        assertz(posicao(Entidade, PosicaoInicial))
    ;   write("A posição inicial é inválida!"), nl,
        write("Escolha: porta, centro ou janela"), nl,
        posicao_inicial(Entidade)
    ).


iniciar(1) :-
    escolher_acao.

iniciar(2) :-
    posicao_inicial(macaco),
    posicao_inicial(caixa),
    posicao_inicial(banana),
    escolher_acao.

iniciar(_) :-
    start.

start :-
    write("Boas vindas ao jogo do macaco!"),nl,
    write("Neste jogo você escolhe as ações de um macaco que deseja pegar uma banana"), nl,
    write("O macaco está no chão, a banana está no teto e ele tem uma caixa na qual ele pode subir para pegar a banana"), nl,
    write("Seu objetivo é fazer o macaco pegar a caixa, levar até a banana, subir na caixa e pegar a banana."), nl,
    write("--------------------------"),nl,
    write("1. Jogar jogo"), nl,
    write("2. Editar as posições inicias do macaco, caixa e banana"),nl,
    write("Escolha o que você deseja fazer: "),
    read(EscolhaInicial),
    iniciar(EscolhaInicial).
%    escolher_acao.




escolher_acao :-
    imprimir_posicao_altura(macaco),
    imprimir_posicao_altura(caixa),
    imprimir_posicao_altura(banana),
    imprimir_acao_macaco,
    read(Acao),
    realizar_acao(Acao),
    verificar.

realizar_acao(1) :-
    altura(macaco, chao),
    write("Digite para onde você quer mover o macaco (porta, centro ou janela): "),
    read(NovoLocal),
    mover_macaco_para(NovoLocal).

realizar_acao(2) :-
    (	posicao(macaco, Posicao),
        posicao(caixa, Posicao) ->  
    	retractall(altura(macaco, _)),
    	assertz(altura(macaco, em_cima_da_caixa))
    ;   true
    ).
    
realizar_acao(3) :-
    altura(macaco, chao),
    (	posicao(macaco, Posicao),
        posicao(caixa, Posicao) ->  
    	write("Digite para onde você deseja mover a caixa: (porta, centro, janela): "),
        read(NovoLocalCaixa),
        mover_caixa_para(NovoLocalCaixa)
    ;   true
    ).

realizar_acao(4) :-
    altura(macaco, em_cima_da_caixa),
    (
    	posicao(macaco, Posicao),
        posicao(banana, Posicao) ->  
    	retractall(pegou(macaco, _)),
        assertz(pegou(macaco, banana))
    ;   true
   	).

realizar_acao(5) :-
    altura(macaco, em_cima_da_caixa),
    retractall(altura(macaco, _)),
    assertz(altura(macaco, chao)),
    !.
    

realizar_acao(_) :-
    write("Ação inválida"), nl.

mover_caixa_para(Local) :-
    posicoes(Posicoes),
    member(Local, Posicoes),
    retractall(posicao(caixa, _)),
    assertz(posicao(caixa, Local)),
    mover_macaco_para(Local).

mover_macaco_para(porta) :-
    altura(macaco, chao),
    retractall(posicao(macaco, _)),
    assertz(posicao(macaco, porta)),
    !.

mover_macaco_para(centro) :-
    altura(macaco, chao),
    retractall(posicao(macaco, _)),
    assertz(posicao(macaco, centro)),
    !.


mover_macaco_para(janela) :-
    altura(macaco, chao),
    retractall(posicao(macaco, _)),
    assertz(posicao(macaco, janela)),
    !.

mover_macaco_para(_) :-
    write("Posição inválida"),nl.

verificar :-
    pegou(macaco, banana),
    write("Fim, o macaco pegou a banana"), nl.

verificar :-
    pegou(macaco, nada),
    escolher_acao.
