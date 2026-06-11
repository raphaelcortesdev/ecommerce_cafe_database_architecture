/* DDL - E-Commerce  Café */

CREATE DATABASE ecomm_cafe;
USE ecomm_cafe;

CREATE TABLE tbl_usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(200) NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE, -- UNIQUE protege contra CPF duplicado
    ddd CHAR(2) NOT NULL,					
    telefone VARCHAR(11) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE, -- UNIQUE protege contra e-mails duplicados
    senha VARCHAR(200) NOT NULL,
    tipo_usuario ENUM('cliente', 'admin') NOT NULL
);

CREATE TABLE tbl_cafes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(200) NOT NULL,
    preco DECIMAL(10, 2) NOT NULL,
    estoque INT NOT NULL DEFAULT 0
);

CREATE TABLE tbl_variedade_graos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL UNIQUE -- UNIQUE garante que não haja variedade repetida
);

CREATE TABLE tbl_descricao_cafe (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tipo_torra ENUM('clara', 'media_clara', 'media', 'media_escura', 'escura') NOT NULL,
    origem_pais VARCHAR(20) NOT NULL,
    origem_regiao VARCHAR(50),
    descricao TEXT,
    peso_gramas INT NOT NULL,
    processamento ENUM('natural', 'lavado', 'natural_anaerobico', 'honey') NOT NULL,
    moagem ENUM('graos', 'filtro_papel', 'prensa_francesa', 'expresso') NOT NULL,
    fk_tbl_cafes_id INT NOT NULL UNIQUE, -- UNIQUE garante a relação 1:1 com tbl_cafes 
    fk_tbl_variedade_graos_id INT NOT NULL 
);

CREATE TABLE tbl_entrega (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cep VARCHAR(8) NOT NULL,
    logradouro VARCHAR(200) NOT NULL,
    numero VARCHAR(10) NOT NULL,
    complemento VARCHAR(100),
    bairro VARCHAR(60) NOT NULL,
    cidade VARCHAR(40) NOT NULL,
    estado CHAR(2) NOT NULL,
    fk_tbl_usuarios_id INT NOT NULL
);

CREATE TABLE tbl_notas_sensoriais (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    descricao TEXT
);

CREATE TABLE tbl_clube (
    id INT AUTO_INCREMENT PRIMARY KEY,
    qtd_mensal_gramas INT NOT NULL,
    tipo_moagem VARCHAR(200) NOT NULL,
    frequencia VARCHAR(50) NOT NULL,
    preco DECIMAL(10, 2) NOT NULL,
    desconto DECIMAL(10, 2) DEFAULT 0.00,
    fk_tbl_usuarios_id INT NOT NULL UNIQUE       -- UNIQUE garante relacionamento 1:1 com tbl_usuarios
);

CREATE TABLE tbl_itens_carrinho_contem (
    quantidade INT NOT NULL DEFAULT 1,
    fk_tbl_usuarios_id INT NOT NULL,
    fk_tbl_cafes_id INT NOT NULL,
    PRIMARY KEY (fk_tbl_usuarios_id, fk_tbl_cafes_id) -- PK composta
);

CREATE TABLE tbl_pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data_hora DATETIME NOT NULL,
    valor_total DECIMAL(10, 2) NOT NULL,
    status_pagamento VARCHAR(50) NOT NULL,
    metodo_pagamento VARCHAR(20) NOT NULL,
    id_transacao_api VARCHAR(100),
    link_pagamento TEXT,
    fk_tbl_usuarios_id INT NOT NULL,
    fk_tbl_entrega_id INT NOT NULL
);

CREATE TABLE tbl_itens_pedidos_contem (
    quantidade INT NOT NULL,
    preco_pago DECIMAL(10, 2) NOT NULL,
    fk_tbl_cafes_id INT NOT NULL,
    fk_tbl_pedidos_id INT NOT NULL,
    PRIMARY KEY (fk_tbl_cafes_id, fk_tbl_pedidos_id) -- PK composta
);

CREATE TABLE tbl_cafe_notas_possui (
    fk_tbl_cafes_id INT NOT NULL,
    fk_tbl_notas_sensoriais_id INT NOT NULL,
    PRIMARY KEY (fk_tbl_cafes_id, fk_tbl_notas_sensoriais_id) -- PK composta
);

-- CONSTRAINTS --

ALTER TABLE tbl_descricao_cafe ADD CONSTRAINT FK_tbl_descricao_cafe_2
    FOREIGN KEY (fk_tbl_cafes_id)
    REFERENCES tbl_cafes (id)
    ON DELETE CASCADE; -- CASCADE: se um café for excluído da base, sua descrição também é
    
ALTER TABLE tbl_descricao_cafe ADD CONSTRAINT FK_tbl_descricao_variedade
    FOREIGN KEY (fk_tbl_variedade_graos_id)
    REFERENCES tbl_variedade_graos (id)
    ON DELETE RESTRICT; -- RESTRICT: impede o sistema de deixar a descrição com dados de variedade orfãos
 
ALTER TABLE tbl_entrega ADD CONSTRAINT FK_tbl_entrega_2
    FOREIGN KEY (fk_tbl_usuarios_id)
    REFERENCES tbl_usuarios (id)
    ON DELETE CASCADE; -- CASCADE: se apagar um usuário, seu endereço de entrega também é deletado
 
ALTER TABLE tbl_clube ADD CONSTRAINT FK_tbl_clube_2
    FOREIGN KEY (fk_tbl_usuarios_id)
    REFERENCES tbl_usuarios (id)
    ON DELETE CASCADE; -- CASCADE: se a conta do usuario for deletada, sua assinatura também é
 
ALTER TABLE tbl_itens_carrinho_contem ADD CONSTRAINT FK_tbl_itens_carrinho_contem_1
    FOREIGN KEY (fk_tbl_usuarios_id)
    REFERENCES tbl_usuarios (id)
    ON DELETE CASCADE; -- CASCADE: se deletar o usuário, limpa o carrinho temporário dele

ALTER TABLE tbl_itens_carrinho_contem ADD CONSTRAINT FK_tbl_itens_carrinho_contem_2
    FOREIGN KEY (fk_tbl_cafes_id)
    REFERENCES tbl_cafes (id)
    ON DELETE CASCADE; -- CASCADE: se o café deixar de existir, sai do carrinho automaticamente
 
ALTER TABLE tbl_pedidos ADD CONSTRAINT FK_tbl_pedidos_2
    FOREIGN KEY (fk_tbl_usuarios_id)
    REFERENCES tbl_usuarios (id)
    ON DELETE RESTRICT; -- RESTRICT: se a conta do cliente for deletada, seu histórico de pedidos permanece na db

ALTER TABLE tbl_pedidos ADD CONSTRAINT FK_tbl_pedidos_3
    FOREIGN KEY (fk_tbl_entrega_id)
    REFERENCES tbl_entrega (id)
    ON DELETE RESTRICT; -- Se o endereço de entrega do usuario for deletada, mantém seu histórico de pedidos intacto
 
ALTER TABLE tbl_itens_pedidos_contem ADD CONSTRAINT FK_tbl_itens_pedidos_contem_1
    FOREIGN KEY (fk_tbl_cafes_id)
    REFERENCES tbl_cafes (id)
    ON DELETE RESTRICT; -- RESTRICT: se um café for retirado do catalogo, o histórico de vendas dele permanece intacto
 
ALTER TABLE tbl_itens_pedidos_contem ADD CONSTRAINT FK_tbl_itens_pedidos_contem_2
    FOREIGN KEY (fk_tbl_pedidos_id)
    REFERENCES tbl_pedidos (id)
    ON DELETE CASCADE; -- CASCADE: se o pedido principal for deletado por algum motivo, limpa os itens dele
 
ALTER TABLE tbl_cafe_notas_possui ADD CONSTRAINT FK_tbl_cafe_notas_possui_1
    FOREIGN KEY (fk_tbl_cafes_id)
    REFERENCES tbl_cafes (id)
    ON DELETE CASCADE; -- CASCADE: se um café for retirado do catálogo, suas notas também são excluída da entidade associativa que associaa relação N:N cafés e notas
 
ALTER TABLE tbl_cafe_notas_possui ADD CONSTRAINT FK_tbl_cafe_notas_possui_2
    FOREIGN KEY (fk_tbl_notas_sensoriais_id)
    REFERENCES tbl_notas_sensoriais (id)
    ON DELETE CASCADE; -- CASCADE: se uma nota sensorial for excluída, os cafés associados a essa nota também são excluídos da entidade associativa que associaa relação N:N cafés e notas