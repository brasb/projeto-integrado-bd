-- Cria a tabela "conversas" e seus respectivos comentários.

CREATE TABLE conversas (
    conversa_id           NUMERIC(38)	  NOT NULL,
    nome_conversa         VARCHAR(512)    NOT NULL,
    descricao_conversa    VARCHAR(512),
    CONSTRAINT pk_conversa_id PRIMARY KEY (conversa_id)
);

COMMENT ON TABLE conversas IS 'Conversas existentes.';

COMMENT ON COLUMN conversas.conversa_id        IS 'ID da conversa';
COMMENT ON COLUMN conversas.nome_conversa      IS 'Nome da conversa.';
COMMENT ON COLUMN conversas.descricao_conversa IS 'Descricao da conversa';


-- Cria a tabela "habilidades" e seus respectivos comentários.

CREATE TABLE habilidades (
    nome_habilidade    VARCHAR(512)    NOT NULL,
    tipo               VARCHAR(512)    NOT NULL,
    CONSTRAINT pk_nome_habilidade PRIMARY KEY (nome_habilidade)
);

COMMENT ON TABLE habilidades IS 'Habilidades existentes.';

COMMENT ON COLUMN habilidades.nome_habilidade IS 'Nome da habilidade.';
COMMENT ON COLUMN habilidades.tipo            IS 'Tipo da habilidade.';


-- Cria a tabela "pessoas" e seus respectivos comentários.

CREATE TABLE pessoas (
    pessoa_id    NUMERIC(38)    NOT NULL,
    nome         VARCHAR(255)   NOT NULL,
    email        VARCHAR(255)   NOT NULL,
    cargo        VARCHAR(50)    NOT NULL,
    foto         BYTEA,
    descricao    VARCHAR(512),
    CONSTRAINT pk_pessoa_id PRIMARY KEY (pessoa_id)
);

COMMENT ON TABLE pessoas IS 'Pessoas cadastradas.';

COMMENT ON COLUMN pessoas.pessoa_id IS 'ID da pessoa.';
COMMENT ON COLUMN pessoas.nome      IS 'Nome da pessoa.';
COMMENT ON COLUMN pessoas.email     IS 'Email da pessoa.';
COMMENT ON COLUMN pessoas.cargo     IS 'Cargo da pessoa na empresa.';
COMMENT ON COLUMN pessoas.foto      IS 'Foto da pessoa.';
COMMENT ON COLUMN pessoas.descricao IS 'Descricao da pessoa.';


-- Cria a tabela "membros_conversas" e seus respectivos comentários.

CREATE TABLE membros_conversas (
    conversa_id       NUMERIC(38)    NOT NULL,
    pessoa_id         NUMERIC(38)    NOT NULL,
    cargo_conversa    VARCHAR(15)    NOT NULL,
    CONSTRAINT pk_conversa_id_pessoa_id PRIMARY KEY (conversa_id, pessoa_id)
);

COMMENT ON TABLE membros_conversas IS 'Pessoas da conversa.';

COMMENT ON COLUMN membros_conversas.conversa_id    IS 'ID da conversa.';
COMMENT ON COLUMN membros_conversas.pessoa_id      IS 'ID da pessoa.';
COMMENT ON COLUMN membros_conversas.cargo_conversa IS 'Cargo na conversa.';


-- Cria a tabela "mensagens" e seus respectivos comentários.

CREATE TABLE mensagens (
    conversa_id       NUMERIC(38)     NOT NULL,
    mensagem_id       NUMERIC(38)     NOT NULL,
    pessoa_id         NUMERIC(38)     NOT NULL,
    texto_mensagem    VARCHAR(512)    NOT NULL,
    anexo_mensagem    BYTEA,
    CONSTRAINT pk_mensagem_id PRIMARY KEY (conversa_id, mensagem_id, pessoa_id)
);

COMMENT ON TABLE mensagens IS 'mensagens da conversa';

COMMENT ON COLUMN mensagens.conversa_id    IS 'ID da conversa.';
COMMENT ON COLUMN mensagens.mensagem_id    IS 'ID da mensagem.';
COMMENT ON COLUMN mensagens.pessoa_id      IS 'ID da pessoa.';
COMMENT ON COLUMN mensagens.texto_mensagem IS 'Texto da mensagem.';
COMMENT ON COLUMN mensagens.anexo_mensagem IS 'Anexo da mensagem.';


-- Cria a tabela "postagens" e seus respectivos comentários.

CREATE TABLE postagens (
    postagem_id       NUMERIC(38)    NOT NULL,
    pessoa_id         NUMERIC(38)    NOT NULL,
    anexo_postagem    BYTEA,
    texto_postagem    VARCHAR(512),
    CONSTRAINT pk_postagem_id PRIMARY KEY (postagem_id, pessoa_id)
);


COMMENT ON TABLE postagens IS 'Postagens existentes.';

COMMENT ON COLUMN postagens.postagem_id    IS 'ID da postagem.';
COMMENT ON COLUMN postagens.pessoa_id      IS 'ID da pessoa.';
COMMENT ON COLUMN postagens.anexo_postagem IS 'Anexo da postagem.';
COMMENT ON COLUMN postagens.texto_postagem IS 'Texto da postagem.';


-- Cria a tabela "habilidades_pessoas" e seus respectivos comentários.

CREATE TABLE habilidades_pessoas (
    nome_habilidade    VARCHAR(512)    NOT NULL,
    pessoa_id          NUMERIC(38)     NOT NULL,
    CONSTRAINT pk_nome_habilidade_pessoa_id PRIMARY KEY (nome_habilidade, pessoa_id)
);

COMMENT ON TABLE habilidades_pessoas IS 'Habilidades das pessoas.';

COMMENT ON COLUMN habilidades_pessoas.nome_habilidade IS   'Nome da habilidade';
COMMENT ON COLUMN habilidades_pessoas.pessoa_id       IS   'ID da pessoa.';


-- Adiciona as FKs.

ALTER TABLE membros_conversas ADD CONSTRAINT conversas_membros_conversas_fk
FOREIGN KEY (conversa_id)
REFERENCES conversas (conversa_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE mensagens ADD CONSTRAINT conversas_mensagens_fk
FOREIGN KEY (conversa_id)
REFERENCES conversas (conversa_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE habilidades_pessoas ADD CONSTRAINT habilidades_habilidades_pessoas_fk
FOREIGN KEY (nome_habilidade)
REFERENCES habilidades (nome_habilidade)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE habilidades_pessoas ADD CONSTRAINT pessoas_habilidades_pessoas_fk
FOREIGN KEY (pessoa_id)
REFERENCES pessoas (pessoa_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE postagens ADD CONSTRAINT pessoas_postagens_fk
FOREIGN KEY (pessoa_id)
REFERENCES pessoas (pessoa_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE mensagens ADD CONSTRAINT pessoas_mensagens_fk
FOREIGN KEY (pessoa_id)
REFERENCES pessoas (pessoa_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE membros_conversas ADD CONSTRAINT pessoas_membros_conversas_fk
FOREIGN KEY (pessoa_id)
REFERENCES pessoas (pessoa_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


-- Cria as checagens.

ALTER TABLE habilidades
ADD CONSTRAINT nome_habilidade_check
CHECK (nome_habilidade ~* '{a-z}');

ALTER TABLE pessoas
ADD CONSTRAINT nome_pessoa_check
CHECK (nome ~* '{a-z}');

ALTER TABLE habilidades
ADD CONSTRAINT tipo_check
CHECK (tipo IN ('Soft', 'Hard'));

ALTER TABLE postagens
ADD CONSTRAINT post_check
CHECK (NOT (texto_postagem IS NULL AND anexo_postagem IS NULL));

ALTER TABLE membros_conversas
ADD CONSTRAINT cargo_conversa_check
CHECK (cargo_conversa IN ('Administrador', 'Membro'));

