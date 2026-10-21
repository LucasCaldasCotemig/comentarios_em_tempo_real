# Comentários em Tempo Real

Atividade de Framework — Flutter + Firebase Authentication + Cloud Firestore.

Aplicativo de publicações com cadastro, login e perfil. Cada publicação tem um botão de comentários que abre uma tela com a publicação e a discussão. Os comentários ficam no Cloud Firestore e aparecem automaticamente para todos que estão com a discussão aberta.

## Como rodar

1. Gere as pastas de plataforma e instale as dependências:

```
flutter create . --platforms=web,android
flutter pub get
```

2. Configure o Firebase do seu próprio projeto (gera o `lib/firebase_options.dart` real, substituindo o placeholder incluído aqui):

```
dart pub global activate flutterfire_cli
flutterfire configure
```

3. No Console do Firebase:
   - **Authentication > Sign-in method:** ative **E-mail/senha**.
   - **Firestore Database:** crie o banco e publique as regras do arquivo `firestore.rules`.

4. Rode o app:

```
flutter run -d chrome --web-port 8080
```

## Regras do Firestore

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    match /publicacoes/{publicacao} {
      allow read: if request.auth != null;
      allow create: if request.auth != null
                    && request.resource.data.autorUid == request.auth.uid;
    }

    match /comentarios/{comentario} {
      allow read: if request.auth != null;
      allow create: if request.auth != null
                    && request.resource.data.usuarioId == request.auth.uid;
      allow delete: if request.auth != null
                    && resource.data.usuarioId == request.auth.uid;
    }
  }
}
```

Só o dono do comentário (`usuarioId == request.auth.uid`) consegue excluí-lo, e isso é garantido no servidor.

## Dados no Firestore

`publicacoes`: `texto`, `autorNome`, `autorUid`, `criadoEm`

`comentarios`: `texto`, `nome`, `usuarioId` (uid de quem comentou), `publicacaoId`, `criadoEm`

## Teste obrigatório

1. Abra o app em duas janelas, uma delas anônima (ou em dois navegadores), e crie duas contas.
2. Na primeira conta, crie uma publicação.
3. Na segunda conta, abra a publicação pelo botão de comentários e comente.
4. Com a discussão aberta na primeira conta, confira que o comentário aparece sozinho.
5. Faça outros comentários em outras publicações e confirme que cada um aparece só na publicação correta.
6. Exclua um comentário próprio. A lixeira só aparece nos comentários da própria conta.

## Estrutura

```
lib/
├── main.dart
├── firebase_options.dart
├── models/
│   ├── publicacao.dart
│   └── comentario.dart
├── services/
│   ├── auth_service.dart
│   ├── publicacao_service.dart
│   └── comentario_service.dart
├── providers/
│   ├── auth_provider.dart
│   ├── publicacao_provider.dart
│   └── comentario_provider.dart
└── pages/
    ├── login_page.dart
    ├── cadastro_page.dart
    ├── home_page.dart
    ├── perfil_page.dart
    └── comentarios_page.dart
```

## Observação

O app da aula de 19/10 não foi encontrado no computador, então esta versão recria as funcionalidades pedidas como base (cadastro, login, perfil e publicações) e acrescenta os comentários. As respostas das questões estão em `RESPOSTAS_TEORICAS.md`.
