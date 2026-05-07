# 🎟️ Satisfaction Eventos

<div align="center">
  <img src="assets/imagens/logo.png" alt="Logo Satisfaction Eventos" width="150"/>
  <br/>
  <p><strong>Plataforma moderna e intuitiva para gestão de eventos e controle de convidados.</strong></p>
  
  ![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
  ![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
  ![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)
</div>

## 📌 Sobre o Projeto

O **Satisfaction Eventos** é um aplicativo móvel (MVP) desenvolvido para simplificar o gerenciamento de eventos. Focado na experiência do anfitrião, o app permite a criação rápida de eventos, cadastro de convidados e controle de presença (check-in) em tempo real, utilizando uma interface premium com elementos de *Glassmorphism*.

Este projeto foi desenvolvido como requisito avaliativo (AV2) para o curso de **Análise e Desenvolvimento de Sistemas (ADS)** da Uninassau.

## ✨ Funcionalidades Principais

- **🔒 Autenticação de Interface:** Tela de login dividida para "Anfitrião" e "Convidado".
- **📅 Gestão de Eventos:** Criação e exclusão de eventos detalhados (Nome, Local, Data e Horário).
- **👥 Controle de Convidados:** Adição de convidados e marcação de presença com barra de progresso de check-in dinâmica.
- **💾 Persistência de Dados (Oline-first):** Utilização de cache JSON para garantir que nenhum dado seja perdido ao fechar o aplicativo.
- **🌗 Tema Dinâmico:** Suporte completo para Modo Claro (Light) e Modo Escuro (Dark).
- **👤 Painel de Perfil:** Área do usuário com opções de configurações e Logout.

## 🛠️ Tecnologias e Arquitetura

O projeto foi construído utilizando as melhores práticas de Engenharia de Software:

* **Framework:** Flutter (SDK `>=3.8.1 <4.0.0`)
* **Linguagem:** Dart
* **Armazenamento Nuvem:** `FireBase - NoSQL (JSON)
* **Arquitetura:** Padrão **MVC** (Model-View-Controller) modificado, com separação clara entre a camada de apresentação (`Widgets`), regras de negócio e controle de estado (`ChangeNotifier`).

## 🚀 Como Executar o Projeto

Para clonar e rodar este aplicativo localmente, você precisará do [Git](https://git-scm.com), [Flutter](https://flutter.dev/docs/get-started/install) e do Android SDK instalados em sua máquina.

No seu terminal:

```bash
# Clone este repositório
$ git clone [https://github.com/andreluiz05/satisfaction_eventos.git](https://github.com/andreluiz05/satisfaction_eventos.git)

# Acesse a pasta do projeto
$ cd satisfaction_eventos

# Instale as dependências
$ flutter pub get

# Execute o aplicativo em modo de depuração
$ flutter run

Ênio Enrique
Emerson
