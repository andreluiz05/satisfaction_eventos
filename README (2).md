# 🎟️ Satisfaction Eventos

<div align="center">
  <img src="assets/imagens/logo_marca.png" alt="Logo Satisfaction Eventos" width="150"/>
  <br/>
  <p><strong>Plataforma moderna, segura e intuitiva para gestão completa de eventos.</strong></p>

  ![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
  ![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
  ![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
  ![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)
  ![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=apple&logoColor=white)
</div>

## 📌 Sobre o Projeto

O **Satisfaction Eventos** é uma solução robusta para organização de eventos, permitindo gestão de convidados e controle de presença em tempo real. O sistema foi projetado para oferecer alta performance e segurança, permitindo aos anfitriões gerir eventos com identidade visual própria (via integração com API ImgBB) e total controle sobre seus dados.

Este projeto foi desenvolvido como requisito avaliativo para o curso de **Análise e Desenvolvimento de Sistemas (ADS)** da Uninassau.

## ✨ Funcionalidades Principais

- **☁️ Gestão de Imagens em Nuvem:** Upload de banners customizáveis (ImgBB) com suporte a alinhamento vertical e exclusão automática.
- **🔒 Segurança Avançada:** Proteção de senhas com *hashing* (`bcrypt`) e fluxo de recuperação via API EmailJS.
- **⚡ Tempo Real:** Sincronização instantânea de dados via Firebase Realtime Database.
- **🌐 Suporte Multiplataforma:** Experiência otimizada para Android, iOS e Web.
- **👥 Controle Total:** Gestão de convidados com exclusão em cascata.
- **🌗 Tema Dinâmico:** Suporte a Modo Claro e Modo Escuro com design *Glassmorphism*.

## 🛠️ Tecnologias e Arquitetura

O sistema segue padrões rigorosos de engenharia de software:

* **Framework:** Flutter (Dart)
* **Backend:** Firebase (Realtime Database & Authentication)
* **APIs de Terceiros:** ImgBB, EmailJS
* **Arquitetura:** Padrão **MVC** (Model-View-Controller) com separação em camadas (`Controllers`, `Services`, `Models`).

## 📁 Estrutura de Pastas

```
satisfaction_eventos/
├── android/              # Configurações nativas Android
├── ios/                  # Configurações nativas iOS
├── lib/
│   ├── controllers/      # Lógica de negócio (MVC)
│   ├── models/           # Modelos de dados
│   ├── services/         # Integrações com APIs/Firebase
│   ├── views/            # Telas da aplicação
│   └── main.dart         # Ponto de entrada
├── assets/               # Imagens, fontes e recursos
└── pubspec.yaml          # Dependências do projeto
```

## 🚀 Passo a Passo para Executar o Projeto

### 1. Pré-requisitos

Certifique-se de ter instalado:

- [Git](https://git-scm.com/)
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (versão >= 3.8.1)
- IDE de sua preferência (VS Code ou Android Studio)

### 2. Clonando o Repositório

```bash
git clone https://github.com/andreluiz05/satisfaction_eventos.git
```

### 3. Acessando a Pasta do Projeto

```bash
cd satisfaction_eventos
```

### 4. Instalando Dependências

Execute o comando abaixo para baixar todos os pacotes e bibliotecas necessários:

```bash
flutter pub get
```

### 5. Configuração do Firebase

Certifique-se de que o arquivo `google-services.json` (Android) e `GoogleService-Info.plist` (iOS) estão configurados corretamente nas pastas nativas (`android/app/` e `ios/Runner/`).

### 6. Executando o Aplicativo

Para rodar em modo de depuração (debug):

```bash
flutter run
```

Para gerar o arquivo de instalação (.apk) para Android:

```bash
flutter build apk --release
```

## 📝 Documentação Técnica

Este projeto segue as normas de desenvolvimento de software, incluindo a documentação técnica completa conforme os padrões da ISO/IEC 12207 e ISO/IEC 25010.

## ⚠️ Status do Projeto

✅ **Concluído** — Projeto finalizado como requisito avaliativo do curso de ADS da Uninassau.

## 🤝 Como Contribuir

1. Faça um **fork** do projeto
2. Crie uma branch: `git checkout -b minha-feature`
3. Commit suas alterações: `git commit -m 'feat: minha nova feature'`
4. Push para a branch: `git push origin minha-feature`
5. Abra um **Pull Request**

## 👨‍💻 Autor

**André Luiz**

[![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/andreluiz05)

## 🙏 Agradecimentos

- Professores do curso de **Análise e Desenvolvimento de Sistemas** da **Uninassau**
- Comunidade **Flutter** pelos pacotes e recursos open source

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.
