# 🎟️ Satisfaction Eventos

<div align="center">
  <img src="assets/imagens/logo_marca.png" alt="Logo Satisfaction Eventos" width="150"/>
  <br/>
  <p><strong>Plataforma moderna, segura e intuitiva para gestão completa de eventos.</strong></p>
  
  ![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
  ![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
  ![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
</div>

## 📌 Sobre o Projeto

O **Satisfaction Eventos** é uma solução completa para organização de eventos, permitindo gestão de convidados e controle de presença em tempo real. O sistema foi refatorado para oferecer alta performance, segurança avançada e customização visual, permitindo aos anfitriões gerir eventos com identidade visual própria (via integração ImgBB) e total controle sobre seus dados.

Este projeto foi desenvolvido como requisito avaliativo para o curso de **Análise e Desenvolvimento de Sistemas (ADS)**.

## ✨ Funcionalidades Principais

- **☁️ Gestão de Imagens em Nuvem:** Upload de banners customizáveis (ImgBB) com controle de alinhamento e preenchimento.
- **🔒 Segurança Avançada:** Senhas protegidas com `bcrypt` e fluxo de recuperação via API EmailJS.
- **⚡ Tempo Real:** Sincronização instantânea de dados via Firebase Realtime Database.
- **🌐 Suporte Multiplataforma:** Experiência nativa em Android, iOS e Web.
- **👥 Controle Total:** Gestão de convidados com exclusão em cascata e interface intuitiva.
- **🌗 Tema Dinâmico:** Suporte a Modo Claro e Modo Escuro com design *Glassmorphism*.

## 🛠️ Tecnologias e Arquitetura

* **Framework:** Flutter
* **Backend:** Firebase (Realtime Database & Authentication)
* **APIs de Terceiros:** ImgBB (Imagens), EmailJS (E-mails)
* **Arquitetura:** Padrão **MVC** (Model-View-Controller) com separação em camadas (`Controllers`, `Services`, `Models`).

## 🚀 Como Executar o Projeto

1. Clone este repositório:
   `git clone https://github.com/andreluiz05/satisfaction_eventos.git`
2. Acesse a pasta: `cd satisfaction_eventos`
3. Instale as dependências: `flutter pub get`
4. Execute: `flutter run`
