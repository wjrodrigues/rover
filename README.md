# Rover

Aplicação que orienta o Rover em uma planície

## Iniciar aplicação

Inicia os containers

```bash
make start
```

Acompanhar status container

```bash
docker logs rover_app -f
```

Link da aplicação: http://localhost:3000

## Documentação
Atualiza documentação da aplicação

```bash
make update-doc
```

Link da documentação: http://localhost:3000/api-docs

## Teste manual

Ao acessar a documentação é possível realizar requisições para a API.

Arquivo que pode ser usado como exemple é o [loader_file](https://github.com/wjrodrigues/rover/blob/main/spec/fixtures/services/vehicle/loader_file.txt)

Para orientação de como usar a interface visite o site do [Swagger UI](https://swagger.io/tools/swagger-ui/)

## Estrutura

Aplicação foi desenvolvida utilizando [Ruby on Rails](https://rubyonrails.org/)

Estrutura de pastas segue o padrão MVC:

- **Models:** Estão os POROs responsáveis pela lógica de cada entidade (não foi utilizado ActiveRecord, pois os dados não tiveram persistência).

- **Controllers:** Responsável pela comunicação entre a interface e as ações (serviços).

- **Services:** Esta a lógica do negócio, validações das ações que podem ser realizadas com as entidades.
  - Foi criado um DTO nesta camada para facilitar a comunicação entre o controller e o service.

- **Presenters:** Responsável pela apresentação dos dados no formato desejado, JSON, Hash e outros.

- **Libs:** Código auxiliar da aplicação, podendo ser dependências de terceiros ou implementação de recursos nativos com camadas de abstrações, permitindo mudanças sem ocorrer grandes modificações.

## CI

Foi utilizado o github action para executar o CI sendo composto das seguintes ações:

- Inicialização dos containers.
- Analise estática do estilo do código - [rubocop](https://rubocop.org/)
- Testes unitários e de integração.
- Cobertura de código com alvo em 100%.

Exemplo da execução: https://github.com/wjrodrigues/rover/actions
