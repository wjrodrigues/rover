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

