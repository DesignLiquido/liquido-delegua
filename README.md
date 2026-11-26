# Líquido em Delégua

Reimplementação do [Líquido](https://github.com/DesignLiquido/liquido) — conjunto de ferramentas para aplicações para a internet 100% em português — escrita em Delégua e distribuída como pacote Pacoteca (`liquido`).

O Líquido original roda sobre Express, Handlebars e xml2js. Esta versão não depende de bibliotecas de Node.js: o servidor HTTP é escrito sobre o módulo `rede` (soquetes TCP), e o pacote agrega outros projetos escritos em Delégua pela Pacoteca: [`delegua`](../delegua-delegua), [`delprops`](../delprops-delegua), [`foles`](../foles-delegua) e [`lmht`](../lmht-delegua).

## O que funciona

- Rotas por convenção em `rotas/`: `inicial.delegua` → `/`, `clientes/[id].delegua` → `/clientes/:id`, escritas exatamente como no Líquido original (`liquido.rotaGet(funcao(requisicao, resposta) { ... })`);
- Todos os métodos de rota (`rotaGet`, `rotaPost`, `rotaPut`, `rotaDelete`, `rotaPatch`, `rotaCopy`, `rotaHead`, `rotaOptions`, `rotaPurge`, `rotaLock`, `rotaUnlock`, `rotaPropfind`, `rotaLink`, `rotaUnlink`, `rotaView`) e middlewares (`liquido.rotaGet(middleware1, middleware2, tratador)`);
- `requisicao`: `metodo`, `caminho`, `url`, `cabecalhos`, `cabecalho(nome)`, `corpo` (JSON ou formulário), `corpoTexto`, `parametros`, `parametrosPesquisa`, `parametrosCaminho`, `cookies`, `usuario`, `autenticado`, `rota`;
- `resposta`: `enviar`, `status`, `json`, `redirecionar`, `lmht()`/`lmht(valores)`/`lmht("visao", valores)`, `cabecalho`, `tipoConteudo`, `cookie`, `limparCookie`;
- Visões LMHT (`visoes/`), leiaute `base.lmht` com `<conteudo/>`, parciais `<parcial nome="x"/>` (`visoes/parciais/`), modelos no estilo Handlebars (`{{x}}`, `{{{x}}}`, `{{#cada}}`/`{{#each}}`, `{{#se}}`/`{{#if}}`, `{{senao}}`, `{{#with}}`, `{{@indice}}`, `{{../x}}`) e `<estilo>` em FolEs;
- Conversão de `estilos/*.foles` para `publico/css/` e arquivos estáticos (texto e binários);
- `configuracao.delprops` com as mesmas chaves do original (mais `liquido.roteador.endereco` e `liquido.roteador.tempoLimite`);
- Cabeçalhos de segurança equivalentes ao Helmet, CORS (com lista de origens e pré-verificação), cookies, registro de acessos no estilo Morgan;
- Respostas 404 (JSON ou HTML), 405 com `Allow`, 500 com códigos `LIQxxxxx` (JSON em `rest`, página HTML em `mvc`);
- Autenticação JWT (HS256, compatível com outras bibliotecas): `POST /token` com usuários de `usuarios.json`, `requisicao.usuario` e o middleware `liquido.exigirAutenticacao()`; a chave vem de `chaveSecreta` (variável de ambiente ou `.ambiente`);
- Documentação OpenAPI automática em `/docs/openapi.json` e `/docs` (ReDoc), com os decoradores `@rest.documentacao(...)` e `@rest.resposta(...)`.

## Como funciona

Em Delégua, `importar` resolve caminhos literais durante a análise sintática, então os arquivos de rota não podem ser descobertos em tempo de execução. O comando `liquido` percorre `rotas/` e gera `.liquido/aplicacao.delegua`, que coloca cada arquivo de rota dentro de `funcao rotaN(liquido) { ... }` e o registra no caminho correspondente. Esse programa é então executado.

## Uso

```sh
liquido novo meu-projeto --arquetipo mvc   # ou rest
cd meu-projeto
liquido servir                             # http://localhost:3000
```

Outros comandos: `gerar-aplicacao`, `simular requisicoes.json` (atende requisições descritas em JSON sem abrir porta), `documentar [--saida openapi.json]`, `estilos`, `gerar rota clientes/[id] --metodos get,post`, `gerar visao clientes/[id]`.

`bin/liquido` e `bin/liquido.cmd` chamam `fontes/ilc.delegua`. O interpretador usado é o da variável `LIQUIDO_DELEGUA` (para a ILC) e `LIQUIDO_INTERPRETADOR` (para executar o programa gerado; um caminho `.js` é executado com `node`). Sem elas, o Líquido usa o `deldel` (o interpretador de Delégua escrito em Delégua, do [delegua-delegua](../delegua-delegua)) se ele estiver no `PATH`, e senão o `delegua`. Com o `deldel`, nem a ILC nem a aplicação dependem de Node.js.

## Ainda não portado

- Pituguês (`liquido.linguagem = 'pituguês'`): o gerador reconhece `.pitu`, mas o programa gerado é Delégua;
- Banco de dados LinConEs (`liquido.dados`, `liquido banco iniciar`): falta um pacote LinConEs para Delégua;
- Recarga automática ao alterar arquivos;
- Realizações `llvm`/`cgd`: o código usa apenas módulos com a mesma interface nas duas realizações, mas `rede.escreverArquivo` (arquivos estáticos binários) ainda só existe no delegua-node.

O plano de modularização e compilação com o delegua-llvm, com o estado de cada fase, está em [planos/modularizacao.md](planos/modularizacao.md).

## Requisitos de execução (realização node)

Este pacote depende de correções feitas nesta mesma leva de trabalho em outros repositórios:

- `delegua` (núcleo) ≥ 1.28.6 com as correções de `pegue` para erros internos e de `nulo` em variáveis tipadas;
- `delegua-node` com isolamento de escopo de módulos e `rede.escreverArquivo`;
- `delegua-arquivos` com as operações da realização LLVM (`listarDiretorio`, `lerTexto`, `escreverTexto`, `criarDiretorio` etc.).

## Testes

```sh
node D:\Delegua\delegua-node\dist\execucao.js testar
```

Para o desenvolvimento local, os diretórios em `pacotes/node/` e `pacotes/llvm/` podem usar junções para os repositórios irmãos (`delegua-delegua`, `delprops-delegua`, `foles-delegua`, `lmht-delegua`), ou ser instalados pelo `pacote` (que registra as versões travadas em `pacoteca.trava`).
