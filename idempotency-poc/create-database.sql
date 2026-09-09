-- -------------------------------------------------------------
-- Tabela de Status do Pagamento
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tb_status_pagamento (
    status_id TINYINT UNSIGNED NOT NULL,
    status_codigo VARCHAR(30) NOT NULL,
    status_descricao VARCHAR(100) NOT NULL,
    CONSTRAINT pk_status_pagamento PRIMARY KEY (status_id),
    CONSTRAINT uk_status_codigo UNIQUE (status_codigo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -------------------------------------------------------------
-- Dados iniciais de Status
-- -------------------------------------------------------------
INSERT INTO tb_status_pagamento (status_id, status_codigo, status_descricao) VALUES
    (1, 'CRIADO', 'Pagamento registrado no sistema'),
    (2, 'PROCESSADO', 'Pagamento processado com sucesso'),
    (3, 'FALHOU', 'Pagamento falhou ou rejeitado')
ON DUPLICATE KEY UPDATE 
    status_descricao = VALUES(status_descricao);

-- -------------------------------------------------------------
-- Tabela de Pagamentos
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tb_pagamentos (
    pagamento_id VARCHAR(36) NOT NULL,
    usuario_id VARCHAR(36) NOT NULL,
    idempotency_key VARCHAR(36) NOT NULL,
    valor DECIMAL(12,2) NOT NULL,
    status_id TINYINT UNSIGNED NOT NULL,
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_pagamentos PRIMARY KEY (pagamento_id),
    CONSTRAINT fk_pagamentos_status FOREIGN KEY (status_id) 
        REFERENCES tb_status_pagamento(status_id),
    CONSTRAINT uk_pagamento_usuario_chave UNIQUE (usuario_id, idempotency_key),
    INDEX idx_pagamentos_idempotency_key (idempotency_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;