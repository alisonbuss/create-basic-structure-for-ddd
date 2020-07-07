
#### Translation for: **[English](https://github.com/alisonbuss/create-basic-structure-for-ddd/blob/master/README_LANG_EN.md)**.

# Script para criar estrutura básica para projetos DDD(Domain-Driven Design) em .Net Core.

<p align="center">
    <img src="https://github.com/alisonbuss/create-basic-structure-for-ddd/raw/master/files/print-01.png"/>
</p>

#### Status do Projeto: *(Em desenvolvimento)*.

### Projeto foi Inspirado:

  - *Post: [[ASP.NET Core - Começando um projeto novo](https://www.brunobrito.net.br/comecando-projeto-do-zero/)] por Bruno Brito.*
  - *Projeto Github [[Equinox Project](https://github.com/EduardoPires/EquinoxProject)] por Eduardo Pires.*
  - *YouTube [[Implementando o padrão CQRS em aplicações .NET](https://www.youtube.com/watch?v=AQcsfIXQj18)] no Canal dotNET.*
  - *YouTube [[REST API C# - Construindo um REST API com conceitos DDD + EF + Docker + IOC em .NET CORE 3.1](https://www.youtube.com/watch?v=plS-rf2UIPI)] no Canal Daniel Jesus.*
  - *YouTube [[(EM FIM SAIU DO FORNO) DDD Domain Driver Design 2020 .NET Core 3.1.1 C# usando (Async Task)](https://www.youtube.com/watch?v=MjnO2mcE-AQ)] no Canal DEV NET CORE Valdir Ferreira.*

### Dependências:

* **[[Estar em um sistema operacional Linux.](https://ubuntu.com/desktop)]**
* **[[Dotnet Core SDK](https://dotnet.microsoft.com/download/dotnet-core/3.1)]** 3.1.* ou superior...

> **Nota:**
> - *É necessário ter instalado as dependências citadas a cima, para que o projeto funcione.*
> - *A execução desse projeto foi feita através de um **Ubuntu 20.04 LTS (Focal Fossa)**.*

### Executando o projeto:

**Primeiro passo, baixar o projeto de um repositório do GitHub via CLI(Linux Command Line).**

Abra terminal no seu linux e execute os comandos abaixo: 

Terminal:

```bash
$ wget "https://github.com/alisonbuss/create-basic-structure-for-ddd/archive/master.zip" -O ~/Downloads/create-basic-structure-for-ddd-master.zip
$ unzip ~/Downloads/create-basic-structure-for-ddd-master.zip -d ~/Downloads/
$ cd ~/Downloads/create-basic-structure-for-ddd-master
$ ls -a
```

Pronto agora você pode executar o projeto:

Através do arquivo:

- **genesis.sh** em modo CLI.

**Executando em modo de CLI:**

> **Nota:**
> *Antes de executar o projeto, certifique-se de ter ajustado os parâmetros do arquivo **genesis.projects.json** para sua realidade.*

**Visualizar a documentação, passando o parâmetro **--help|-help|-h|help**.

Terminal:

```bash
$ bash genesis.sh --help
```

Resultado: 

```text
The genesis.sh is a simple Shell Script for creating .NET Core 
projects on a DDD(Domain-Driven Design) implementation model.

The proposed model is:
.
├── ExampleUsersDDD.sln --> (Solution file)
└── src
    ├── 1 - Presentation
    │   └── ExampleUsersDDD.UI.Web --> (ASP.NET Core Empty Web)
    ├── 2 - Services
    │   ├── ExampleUsersDDD.Service.API --> (ASP.NET Core Web API)
    │   └── ExampleUsersDDD.Service.gRPC --> (ASP.NET Core gRPC Service)
    ├── 3 - Business
    │   └── ExampleUsersDDD.Business --> (Class library)
    ├── 4 - Domain
    │   └── ExampleUsersDDD.Domain --> (Class library)
    └── 5 - Infra
        ├── ExampleUsersDDD.Infra.CrossCutting --> (Class library)
        └── ExampleUsersDDD.Infra.Data --> (Class library)


Usage:  bash genesis.sh [OPTIONS]

Options:
|                               | Descrição                               |
| ----------------------------- | --------------------------------------- |
| --json-file|-j                | - Set the json file to generate the     |
|                               |   DDD projects.                         |
|-------------------------------------------------------------------------|
| --help|-help|-h|help          | - Help                                  |
---------------------------------------------------------------------------

Examples:
| HELP------------------------------------------------------------------- |
| $ bash genesis.sh  --help                                               |
|                                                                         |
| RUN-------------------------------------------------------------------- |
| $ bash genesis.sh                                                       |
| ----------------------------------------------------------------------- |
| $ bash genesis.sh --json-file='./genesis.projects.json'                 |
---------------------------------------------------------------------------
```

Criando o projeto via terminal:

```shell

$ bash genesis.sh --json-file='./genesis.projects.json'

```

### Referências:

* Bruno Brito, Blog. ***ASP.NET Core - Começando um projeto novo*** <br/>
  Acessado: *Julho de 2020* <br/>
  Disponível: *[https://www.brunobrito.net.br/comecando-projeto-do-zero/](https://www.brunobrito.net.br/comecando-projeto-do-zero/)*

* Eduardo Pires, Github - ***Equinox Project*** <br/>
  Acessado: *Julho de 2020* <br/>
  Disponível: *[https://github.com/EduardoPires/EquinoxProject](https://github.com/EduardoPires/EquinoxProject)*

* YouTube - Canal dotNET - ***Implementando o padrão CQRS em aplicações .NET*** <br/>
  Acessado: *Julho de 2020* <br/>
  Disponível: *[https://www.youtube.com/watch?v=AQcsfIXQj18](https://www.youtube.com/watch?v=AQcsfIXQj18)*

* YouTube - Canal Daniel Jesus - ***REST API C# - Construindo um REST API com conceitos DDD + EF + Docker + IOC em .NET CORE 3.1*** <br/>
  Acessado: *Julho de 2020* <br/>
  Disponível: *[https://www.youtube.com/watch?v=plS-rf2UIPI](https://www.youtube.com/watch?v=plS-rf2UIPI)*

* YouTube - Canal DEV NET CORE Valdir Ferreira - ***(EM FIM SAIU DO FORNO) DDD Domain Driver Design 2020 .NET Core 3.1.1 C# usando (Async Task)*** <br/>
  Acessado: *Julho de 2020* <br/>
  Disponível: *[https://www.youtube.com/watch?v=MjnO2mcE-AQ](https://www.youtube.com/watch?v=MjnO2mcE-AQ)*

* YouTube - Canal Eduardo Pires - ***Tutorial ASP.NET MVC 5 + DDD + EF + AutoMapper + IoC + Dicas e Truques*** <br/>
  Acessado: *Julho de 2020* <br/>
  Disponível: *[https://www.youtube.com/watch?v=i9Il79a2uBU](https://www.youtube.com/watch?v=i9Il79a2uBU)*

* YouTube - Canal Douglas Mugnos - ***Qual a diferença entre aplicação stateless e stateful?*** <br/>
  Acessado: *Julho de 2020* <br/>
  Disponível: *[https://www.youtube.com/watch?v=IgP201jxFdc](https://www.youtube.com/watch?v=IgP201jxFdc)*

### Licença

[<img width="190" src="https://raw.githubusercontent.com/alisonbuss/my-licenses/master/files/logo-open-source-550x200px.png">](https://opensource.org/licenses)
[<img width="166" src="https://raw.githubusercontent.com/alisonbuss/my-licenses/master/files/icon-license-mit-500px.png">](https://github.com/alisonbuss/create-basic-structure-for-ddd/blob/master/LICENSE)
