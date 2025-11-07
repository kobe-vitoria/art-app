# art_app

Um app sobre arte, que integra com APIs e com serviços de CMS para postar e produzir conteúdo sobre obras artísticas hospedadas na API DO ARTIC (Art institute of Chicago) para os usuários.


## 🎨 Sobre o Projeto
Aplicativo mobile desenvolvido em Flutter que permite aos usuários explorar e descobrir obras de arte, combinando informações curatoriais do Contentful com imagens de alta resolução do Art Institute of Chicago.

## 🏗️ Arquitetura
O projeto segue uma arquitetura em camadas baseada no padrão MVVM (Model-View-ViewModel), promovendo separação de responsabilidades e facilidade de manutenção.
```
lib/
├── models/          # Entidades e modelos de dados
├── views/           # Camada de apresentação (UI)
├── viewmodels/      # Lógica de negócio e estado
├── services/        # Serviços de API e integração
├── repositories/    # Camada de acesso a dados
└── database/        # Configuração de persistência local
```

## Princípios Arquiteturais

Separação de Responsabilidades: Cada camada possui responsabilidades bem definidas
MVVM Pattern: ViewModel gerencia o estado e a lógica de negócio
Repository Pattern: Abstração da fonte de dados (API ou local)

## 🛠️ Tecnologias e Dependências
Dependências Principais
```
dependencies:
  flutter:
    sdk: flutter
  
  # HTTP & API
  http: ^1.1.0
  
  # Persistência Local
  sqflite: ^2.3.0
  path: ^1.8.3
  
  # Utilitários
  url_launcher: ^6.2.1
```

## Tecnologias

Flutter: Framework de desenvolvimento mobile
Dart: Linguagem de programação
SQLite: Banco de dados local para cache e offline
GraphQL: Consulta de dados do Contentful
REST API: Integração com Art Institute of Chicago

## 🔌 Integrações
1. Contentful (GraphQL)
Base URL: https://graphql.contentful.com/
Fornece o conteúdo editorial das obras de arte:

- Informações descritivas
- Temas e curiosidades
- Dados do autor

2. Art Institute of Chicago API (REST)
Base URL: https://api.artic.edu/
Fornece visualização de imagens de alta qualidade das obras de arte através de:

- API REST para metadados
- IIIF Image API para entrega otimizada de imagens

## Instalação

1. 2. Clone o repositório
```
- git clone <url-do-repositorio>
- cd <nome-do-projeto>
```

3. Instale as dependências
```
- flutter pub get
```

4. Configure o banco de dados local
```
- O SQLite será configurado automaticamente na primeira execução.
```

## 🚀 Build e Execução
# Modo Debug
```
flutter run
(escolher navegador web para rodar projeto)
```

# iOS (Coming soon)
```
flutter run -d ios
```

# Web
```
flutter run -d chrome
```

# Query
Query:
```
graphqlquery {
  arteCollection {
    items {
      id
      nome
      descricao
      temas
      curiosidades
      author {
        id
        authorBio
        authorName
        lastUpdatedAt
      }
    }
  }
}
```

# Resposta
```
{
  "data": {
    "arteCollection": {
      "items": [
        {
          "id": "123",
          "nome": "Título da Obra",
          "descricao": "Descrição detalhada...",
          "temas": ["Tema1", "Tema2"],
          "curiosidades": "Fatos interessantes...",
          "author": {
            "id": "author123",
            "authorName": "Nome do Autor",
            "authorBio": "Biografia...",
            "lastUpdatedAt": "2024-01-01T00:00:00Z"
          }
        }
      ]
    }
  }
}
```

### REST - Art Institute of Chicago API

#### Endpoint 1: Buscar metadados das obras

**Request**:
```
GET https://api.artic.edu/api/v1/artworks?ids={ids}&fields=id,image_id
```
## Parâmetros:
```
- ids: Lista de IDs separados por vírgula (ex: 123,456,789)
- fields: Campos desejados (ex: id,image_id)
```
## Resposta:
```
{
  "data": [
    {
      "id": 123,
      "image_id": "abc123-xyz789"
    }
  ]
}
```

#### Endpoint 2: URL de imagem (IIIF)
```
**Formato**:
https://www.artic.edu/iiif/2/{image_id}/full/843,/0/default.jpg
```

**Parâmetros**:
- `{image_id}`: ID da imagem obtido no endpoint anterior
- `843`: Largura da imagem em pixels
- Qualidade: `default.jpg`

**Exemplo**:
```
https://www.artic.edu/iiif/2/abc123-xyz789/full/843,/0/default.jpg
```