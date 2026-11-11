# Instalação na Hostinger — Central de Matrículas

Este pacote é uma aplicação **Node.js 22 + MySQL**, com o painel React já compilado. Não depende de Cloudflare, ChatGPT, D1, R2 ou login. Matrículas e anexos são gravados no MySQL. O painel abre diretamente pelo endereço.

## 1. Criar o banco

No hPanel, abra **Bancos de dados → Gerenciamento**. Crie um banco MySQL e um usuário com permissão nesse banco. Guarde o nome completo do banco, o usuário e a senha. Não envie esses dados pelo chat.

O aplicativo cria as tabelas `cm_settings`, `cm_consultants`, `cm_enrollments` e `cm_attachments` automaticamente na primeira consulta. Também é possível importar o arquivo `schema.sql` pelo phpMyAdmin. Ele não apaga tabelas existentes nem cria usuários ou alunos fictícios; inicia somente os três consultores originais.

## 2. Enviar o ZIP

É necessário um plano Hostinger com suporte a **Node.js Web Apps** (Business ou Cloud). No hPanel:

1. **Sites → Criar site → Web App → Enviar os arquivos do seu site**.
2. Envie **Recife_Matriculas_Hostinger.zip**, sem descompactar.
3. Confirme os parâmetros abaixo. O `package.json` já fica na raiz do ZIP.

| Configuração | Valor |
| --- | --- |
| Tipo / framework | Other / Outro (aplicação Node.js de servidor) |
| Node.js | 22.x |
| Comando de instalação, se solicitado | `npm install` |
| Comando de build | `npm run build` |
| Arquivo de entrada | `server.js` |
| Comando de inicialização | `npm start` |
| Diretório da aplicação / saída | `.` (raiz do pacote) |

O build somente verifica os arquivos: o painel e o servidor já foram compilados. Não selecione implantação de site estático, pois os cadastros precisam do servidor Node.js. Enviar apenas `index.html` para `public_html` não instala esta aplicação.

## 3. Configurar as variáveis

Na etapa **Environment variables / Variáveis de ambiente**, informe:

| Variável | Valor |
| --- | --- |
| `DB_HOST` | `127.0.0.1` para o MySQL da mesma hospedagem, conforme orientação da Hostinger |
| `DB_PORT` | `3306` |
| `DB_NAME` | Nome completo do banco no hPanel |
| `DB_USER` | Nome completo do usuário do banco |
| `DB_PASSWORD` | Senha desse usuário |
| `APP_ORIGIN` | Endereço final do site, por exemplo `https://matriculas.seudominio.com.br` |

O `PORT` é fornecido pela Hostinger. A aplicação usa essa variável automaticamente. Para banco externo que exige TLS, configure também `DB_SSL=true` e o host/porta correspondentes. Senhas do banco ficam somente no servidor; não são incluídas no painel nem no ZIP.

Publique e reinicie a aplicação após mudar as variáveis. O endpoint `/api/health` retorna `{"ok":true,"database":"mysql"}` quando a conexão funciona. Se o domínio mudar, atualize `APP_ORIGIN`.

## Dados, arquivos e planilhas

- O formulário exige RA numérico, uma ou mais fotos/prints e um comprovante PDF ou imagem. RA e CPF são armazenados como texto para manter zeros iniciais.
- Limites: até 5 fotos de 5 MB e um comprovante de até 10 MB; envio total de até 40 MB. O MySQL precisa aceitar pacotes de pelo menos 16 MB para os anexos maiores (`max_allowed_packet`). Arquivos ficam no banco, junto dos metadados, sem depender do disco da implantação.
- Consulte os anexos nos detalhes do aluno. A exportação Excel contém RA e resumo diário por consultor; pode ser aberta no Excel ou importada no Google Planilhas.
- A conexão automática do Google usada na outra hospedagem não integra este pacote. Nesta versão, use o Excel para levar os dados ao Google Planilhas.
- O ZIP contém o aplicativo, sem uma cópia dos alunos ou anexos da hospedagem anterior. A instalação na Hostinger usa o novo banco. A migração de registros existentes deve ser feita separadamente, com backup e conferência dos anexos.
- O acesso ao painel é direto e compartilhado: não existe tela de e-mail/senha ou separação entre administrador e operador.

## Alterar no VS Code

O pacote pronto serve para publicação. Para alterar componentes, use **Recife_Matriculas_Codigo_VSCode.zip**, abra a pasta no VS Code e execute:

```powershell
npm.cmd ci
npm.cmd run build:hostinger
```

O novo arquivo será gerado em `outputs/Recife_Matriculas_Hostinger.zip`. Envie-o novamente à Hostinger, mantendo as mesmas variáveis e o mesmo banco. Nenhum comando de build apaga matrículas.

Referências oficiais:

- https://www.hostinger.com/support/how-to-deploy-a-nodejs-website-in-hostinger/
- https://www.hostinger.com/support/connecting-a-hostinger-mysql-database-to-a-node-js-application/
- https://www.hostinger.com/support/how-to-add-environment-variables-during-node-js-application-deployment/

## Verificação desta entrega

Servidor compilado e testes executados com uma instância isolada do MySQL Community 8.4. Foram conferidos: criação do esquema, RA/CPF com zeros iniciais, anexos BLOB, validações obrigatórias, repetição de cadastro, remoção e reativação de consultores, reinicialização sem recriar consultores removidos, exportação Excel e rotas HTTP do pacote. A publicação na sua conta Hostinger e a conexão com o banco dessa conta dependem das configurações acima.
