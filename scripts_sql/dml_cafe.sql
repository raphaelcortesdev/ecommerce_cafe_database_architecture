/* DML - E-commerce Café */

USE ecomm_cafe;

-- tbl_usuarios

INSERT INTO tbl_usuarios (nome, cpf, ddd, telefone, email, senha, tipo_usuario) VALUES
('Ana Silva Oliveira', '11122233344', '11', '988887777', 'ana.silva@email.com', '$2b$12$K7vX6h...', 'cliente'),
('Bruno Santos Souza', '22233344455', '21', '977776666', 'bruno.santos@email.com', '$2b$12$R9zW1a...', 'cliente'),
('Carlos Eduardo Lima', '33344455566', '31', '966665555', 'carlos.lima@email.com', '$2b$12$P2qL9b...', 'cliente'),
('Diana Pinheiro Melo', '44455566677', '19', '955554444', 'diana.melo@email.com', '$2b$12$T4mN3c...', 'cliente'),
('Raphael Admin Cortes', '55566677788', '11', '911112222', 'admin.raphael@ecommcafe.com', '$2b$12$X8kI2o...', 'admin');

-- tbl_cafes
INSERT INTO tbl_cafes (nome, preco, estoque) VALUES
('Café Especial Bourbon Amarelo Premium', 48.90, 50),
('Café Especial Catuaí Vermelho Intenso', 42.50, 120),
('Café Raro Geisha Floral Extremo', 115.00, 15),
('Café Microlote Topázio Honey', 56.00, 0);

-- tbl_variedade_graos
INSERT INTO tbl_variedade_graos (nome) VALUES
('Bourbon Amarelo'),
('Catuaí Vermelho'),
('Geisha'),
('Topázio'),
('Acauã');

-- tbl_descricao_cafe
-- Relação 1:1 com tbl_cafes através das FKs 1, 2, 3 e 4
INSERT INTO tbl_descricao_cafe (tipo_torra, origem_pais, origem_regiao, descricao, peso_gramas, processamento, moagem, fk_tbl_cafes_id, fk_tbl_variedade_graos_id) VALUES
('media', 'Brasil', 'Sul de Minas', 'Um café adocicado com notas marcantes de caramelo.', 250, 'natural', 'graos', 1, 1),
('media_escura', 'Brasil', 'Cerrado Mineiro', 'Corpo denso, acidez baixa e finalização prolongada de chocolate.', 250, 'natural', 'filtro_papel', 2, 2),
('clara', 'Panamá', 'Boquete', 'Café exótico com altíssima acidez cítrica e aroma floral avassalador.', 150, 'lavado', 'graos', 3, 3),
('media_clara', 'Brasil', 'Mantiqueira de Minas', 'Processamento honey que realça a doçura frutada natural.', 250, 'honey', 'expresso', 4, 4);

-- tbl_entrega
INSERT INTO tbl_entrega (cep, logradouro, numero, complemento, bairro, cidade, estado, fk_tbl_usuarios_id) VALUES
('01310100', 'Avenida Paulista', '1000', 'Apto 42', 'Bela Vista', 'São Paulo', 'SP', 1),
('22041001', 'Rua Barata Ribeiro', '500', 'Bl B - Sl 302', 'Copacabana', 'Rio de Janeiro', 'RJ', 2),
('30140010', 'Avenida Cristóvão Colombo', '250', NULL, 'Savassi', 'Belo Horizonte', 'MG', 3),
('13024050', 'Rua Maria Monteiro', '1200', 'Casa', 'Cambuí', 'Campinas', 'SP', 1);

-- tbl_notas_sensoriais
INSERT INTO tbl_notas_sensoriais (nome, descricao) VALUES
('Caramelo', 'Doçura reconfortante que lembra açúcar queimado artesanal.'),
('Chocolate Meio Amargo', 'Sabor denso e amendoado típico de torras médias desenvolvidas.'),
('Floral Jasmine', 'Aroma perfumado e sutil que lembra flores brancas.'),
('Cítrico de Limão', 'Acidez viva e brilhante que traz frescor ao paladar.'),
('Frutas Vermelhas', 'Notas de morango e amora perceptíveis na pós-degustação.'),
('Nozes', 'Toque sutil de castanhas e amêndoas torradas.');

-- tbl_clube
-- Relação UNIQUE 1:1 - Apenas Ana e Bruno são assinantes
INSERT INTO tbl_clube (qtd_mensal_gramas, tipo_moagem, frequencia, preco, desconto, fk_tbl_usuarios_id) VALUES
(500, 'graos', 'Mensal', 89.90, 10.00, 1),
(1000, 'filtro_papel', 'Quinzenal', 165.00, 25.00, 2);

-- tbl_itens_carrinho_contem
-- Carrinhos ativos temporários que ainda não viraram pedidos
INSERT INTO tbl_itens_carrinho_contem (quantidade, fk_tbl_usuarios_id, fk_tbl_cafes_id) VALUES
(2, 2, 1), -- Bruno tem 2 pacotes do Bourbon no carrinho
(1, 2, 3), -- Bruno também tem 1 Geisha no carrinho
(3, 3, 2); -- Carlos tem 3 pacotes de Catuaí no carrinho

-- tbl_pedidos
INSERT INTO tbl_pedidos (data_hora, valor_total, status_pagamento, metodo_pagamento, id_transacao_api, link_pagamento, fk_tbl_usuarios_id, fk_tbl_entrega_id) VALUES
('2026-05-10 14:32:00', 140.30, 'Aprovado', 'PIX', 'tx_992384729384', NULL, 1, 1),
('2026-05-15 09:15:00', 42.50, 'Aprovado', 'Cartao_Credito', 'tx_112348572394', NULL, 2, 2),
('2026-06-01 19:40:00', 230.00, 'Cancelado', 'Boleto', 'tx_449284719284', 'https://gateway.com/boleto/1122', 3, 3),
('2026-06-09 21:05:00', 91.40, 'Pendente', 'PIX', 'tx_883749204823', 'https://gateway.com/pix/qrcode', 1, 4);

-- tbl_itens_pedidos_contem
-- Itemização histórica dos 4 pedidos acima
INSERT INTO tbl_itens_pedidos_contem (quantidade, preco_pago, fk_tbl_cafes_id, fk_tbl_pedidos_id) VALUES
(2, 48.90, 1, 1), -- No Pedido 1: 2x Bourbon (Preço histórico guardado)
(1, 42.50, 2, 1), -- No Pedido 1: 1x Catuaí
(1, 42.50, 2, 2), -- No Pedido 2: 1x Catuaí
(2, 115.00, 3, 3), -- No Pedido 3 (Cancelado): 2x Geisha
(1, 48.90, 1, 4), -- No Pedido 4 (Pendente): 1x Bourbon
(1, 42.50, 2, 4); -- No Pedido 4 (Pendente): 1x Catuaí

-- 11. POPULANDO: tbl_cafe_notas_possui
-- Relacionamento N:M mapeando as notas de cada caf
INSERT INTO tbl_cafe_notas_possui (fk_tbl_cafes_id, fk_tbl_notas_sensoriais_id) VALUES
(1, 1), -- Bourbon tem Caramelo
(1, 6), -- Bourbon tem Nozes
(2, 2), -- Catuaí tem Chocolate Meio Amargo
(2, 6), -- Catuaí tem Nozes
(3, 3), -- Geisha tem Floral Jasmine
(3, 4), -- Geisha tem Cítrico de Limão
(4, 5); -- Topázio tem Frutas Vermelhas