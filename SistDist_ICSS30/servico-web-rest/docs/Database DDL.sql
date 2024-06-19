CREATE TABLE public.livro (
    id_livro SERIAL NOT NULL,
    nome varchar NOT NULL,
    resumo varchar NOT NULL,
    qtd_paginas integer NOT NULL,
    data_publicacao date NOT NULL,
    genero varchar NOT NULL,
    autor varchar NOT NULL,
    PRIMARY KEY (id_livro)
);

