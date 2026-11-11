-- Central de Matrículas Recife — banco MySQL separado
-- Compatível com Recife_Matriculas_Hostinger.zip.
-- Selecione o banco criado na Hostinger e importe este arquivo.
-- Cria a estrutura para matrículas, RA, consultores, fotos e comprovantes.
-- Não inclui dados de alunos nem anexos da hospedagem anterior.
-- Os consultores iniciais são preparados pelo aplicativo ao conectar ao banco.

-- MySQL 8 / MariaDB. Use the existing database created in hPanel; no CREATE DATABASE permission needed.
CREATE TABLE IF NOT EXISTS cm_settings (
 setting_key VARCHAR(80) PRIMARY KEY,
 setting_value VARCHAR(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS cm_consultants (
 id CHAR(36) PRIMARY KEY,
 name VARCHAR(80) NOT NULL,
 name_key VARCHAR(160) NOT NULL,
 active TINYINT NOT NULL DEFAULT 1,
 created_at VARCHAR(30) NOT NULL,
 removed_at VARCHAR(30) NULL,
 UNIQUE KEY cm_consultant_name (name_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS cm_enrollments (
 id CHAR(36) PRIMARY KEY,
 enrollment_date DATE NOT NULL,
 consultant VARCHAR(80) NOT NULL,
 whatsapp VARCHAR(25) NOT NULL,
 polo VARCHAR(30) NOT NULL,
 enrollment_type VARCHAR(80) NOT NULL,
 student VARCHAR(150) NOT NULL,
 ra VARCHAR(30) NOT NULL,
 document VARCHAR(11) NOT NULL,
 product VARCHAR(20) NOT NULL,
 course VARCHAR(180) NOT NULL,
 created_at VARCHAR(30) NOT NULL,
 KEY cm_enrollment_date (enrollment_date),
 KEY cm_enrollment_ra (ra),
 KEY cm_enrollment_consultant (consultant)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS cm_attachments (
 id CHAR(36) PRIMARY KEY,
 enrollment_id CHAR(36) NOT NULL,
 kind VARCHAR(20) NOT NULL,
 name VARCHAR(180) NOT NULL,
 mime VARCHAR(100) NOT NULL,
 size INT UNSIGNED NOT NULL,
 data LONGBLOB NOT NULL,
 KEY cm_attachment_enrollment (enrollment_id),
 CONSTRAINT cm_attachment_enrollment_fk FOREIGN KEY (enrollment_id) REFERENCES cm_enrollments(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
