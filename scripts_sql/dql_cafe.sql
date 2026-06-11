/* DQL - e-Comerce Café */

/* 
1) CAFÉS EM ESTOQUE: Query que retorna apenas o nome e o preço de todos os cafés que possuem estoque disponível, 
ordenando do mais barato para o mais caro.
*/
SELECT nome, preco 
FROM tbl_cafes
WHERE estoque > 0
ORDER BY preco ASC;

-- ======================================================================================

/* 
2) INFORMAÇÕES ADMINs: Query que retorna nome, endereço e telefone de usuários cadastrados como "admin".
*/
SELECT nome, email, ddd, telefone
FROM tbl_usuarios
WHERE tipo_usuario = "admin";

-- ======================================================================================

/* 
3) DESCRIÇÃO CAFÉS DE TORRA MÉDIA OU MÉDIA ESCURA: Query que retorna a descrição de todos os cafés com torra média ou média escura
*/
SELECT 
	t1.nome AS nome_cafe,
	t2.tipo_torra,
	t2.origem_pais,
	t2.origem_regiao,
	t2.descricao,
	t2.peso_gramas,
	t2.processamento,
	t2.moagem
FROM tbl_cafes t1

INNER JOIN tbl_descricao_cafe t2
	ON t1.id = t2.fk_tbl_cafes_id

WHERE tipo_torra IN ("media", "media_escura");

-- ======================================================================================

/* 
4) FATURAMENTO POR PEDIDO: Query que retorna o faturamento por pedido.
contém id do pedido, a data, o nome do cliente que fez a compra e o valor total do pedido
*/
SELECT
    t2.id AS id_pedido,
    t2.data_hora AS datahora_pedido,
    t1.nome AS nome_cliente,
    t2.valor_total AS _valor_pedido
FROM tbl_usuarios t1

INNER JOIN tbl_pedidos t2
	ON t1.id = t2.fk_tbl_usuarios_id;
    
-- ======================================================================================

/* 
5) CARRINHO ABANDONADO: Query que retorna os clientes que tem itens no carrinho atualmente.
contém nome do usuário, o nome do café que está no carrinho e a quantidade solicitada
*/
SELECT 
	t1.nome AS nome_usuario,
    t2.nome AS nome_cafe,
    t3.quantidade AS quantidade_carrinho
FROM tbl_usuarios t1

INNER JOIN tbl_itens_carrinho_contem t3 -- tbl_itens_carrinho_contem serve como "ponte" entre usuarios e cafes, que não se relacionam.
	ON t1.id = t3.fk_tbl_usuarios_id

INNER JOIN tbl_cafes t2
	ON t3.fk_tbl_cafes_id = t2.id

ORDER BY nome_usuario;

-- ======================================================================================

/* 
6) SABORES DISPONÍVEIS: Query que lista o nome de todos os cafés 
e suas respectivas notas sensoriais
*/

SELECT
	t1.nome AS nome_cafe,
    t2.nome AS nome_nota,
    t2.descricao AS descricao_nota
FROM tbl_cafes t1

INNER JOIN tbl_cafe_notas_possui t3
	ON t1.id = t3.fk_tbl_cafes_id
    
INNER JOIN tbl_notas_sensoriais t2
	ON t3.fk_tbl_notas_sensoriais_id = t2.id
    
ORDER BY nome_cafe;

-- ======================================================================================

/* 
7) FICHA TECNICA COMPLETA: Query que lista o nome do café, o tipo de torra, o peso em gramas 
e o nome da sua variedade de grão
*/

SELECT 
	t2.nome AS nome_café,
    t1.tipo_torra,
    t1.peso_gramas,
    t3.nome AS variedade

FROM tbl_descricao_cafe t1

INNER JOIN tbl_cafes t2
	ON t2.id = t1.fk_tbl_cafes_id

INNER JOIN tbl_variedade_graos t3
	ON t3.id = fk_tbl_variedade_graos_id;
    
-- ======================================================================================

/* 
8) CAFÉ MAIS VENDIDO: Query que lista os cafés mais vendidos do catálogo. 
*/

SELECT
	t1.nome AS cafe_nome,
    SUM(t2.quantidade) AS total_qtd_vendido,
    SUM(t2.preco_pago * t2.quantidade) AS total_faturamento_vendido

FROM tbl_cafes t1

INNER JOIN tbl_itens_pedidos_contem t2
	ON t1.id = t2.fk_tbl_cafes_id
    
GROUP BY cafe_nome
ORDER BY total_qtd_vendido DESC;

-- ======================================================================================

/* 
9) ASSINANTES: Query que lista os clientes assinantes, junto com seus endereços de entrega e formas de contato
*/

select * from tbl_usuarios;
select * from tbl_clube;
select * from tbl_entrega;

SELECT
	t1.nome AS nome_cliente,
    t1.ddd,
	t1.telefone,
    t1.email,
    t2.cep,
    t2.logradouro,
    t2.numero,
    t2.complemento,
    t2.bairro,
    t2.cidade,
    t2.estado

FROM tbl_usuarios t1

INNER JOIN tbl_entrega t2
	ON t1.id = t2.fk_tbl_usuarios_id
INNER JOIN tbl_clube t3 
	ON t1.id = t3.fk_tbl_usuarios_id

WHERE tipo_usuario = "cliente"
ORDER BY estado;
    
-- ======================================================================================

/* 
10) AUDITORIA CONTÁBIL: Query que calcula a soma do preco_pago * quantidade de todos os itens de um pedido específico
e verifica se bate exatamente com o valor_total registrado na tabela de pedidos pai.
*/

SELECT 
	t1.id AS id_pedidos,
    t1.valor_total,
    SUM(t2.preco_pago * t2.quantidade) AS venda_bruta_itens,
	CASE
		WHEN t1.valor_total = SUM(t2.preco_pago * t2.quantidade) THEN true
        else false
	END AS confere

FROM tbl_pedidos t1

INNER JOIN tbl_itens_pedidos_contem t2
	ON t1.id = t2.fk_tbl_pedidos_id

GROUP BY t1.id;


    