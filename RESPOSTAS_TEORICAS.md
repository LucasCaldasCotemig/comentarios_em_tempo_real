# Respostas teóricas

## 1. Como o Firebase identifica quem escreveu determinado comentário?

Pelo Firebase Authentication. Cada conta recebe um identificador único, o `uid`. No momento de comentar, o app lê `FirebaseAuth.instance.currentUser!.uid` e grava esse valor no campo `usuarioId` do comentário, junto com o nome (`nome`). Assim, cada comentário carrega a identificação de quem o escreveu.

No servidor, as regras do Firestore usam `request.auth.uid`, que é o uid de quem está fazendo a requisição e não pode ser falsificado pelo app. Comparando `request.auth.uid` com o `usuarioId` gravado, o Firebase sabe se quem está tentando criar ou excluir é mesmo o dono do comentário.

## 2. Como relacionar um comentário a uma publicação específica?

Cada comentário guarda o campo `publicacaoId`, que recebe o id do documento da publicação na collection `publicacoes`. Para mostrar apenas os comentários de uma publicação, a consulta filtra por esse campo:

```dart
_collection.where('publicacaoId', isEqualTo: publicacaoId).snapshots()
```

Por isso um comentário feito em uma publicação nunca aparece em outra.

## 3. Por que utilizamos StreamBuilder para mostrar os comentários?

O `snapshots()` do Firestore devolve um `Stream`, ou seja, uma sequência de listas de comentários que se atualiza sempre que algo muda no banco. O `StreamBuilder` escuta esse `Stream` e reconstrói a tela a cada novo valor recebido, sem precisar de botão de atualizar, de `setState` manual ou de buscar os dados de novo. Ele também trata os estados de carregando e de erro.

## 4. Como garantir que os comentários apareçam automaticamente em contas diferentes?

Todas as contas que estão com a mesma discussão aberta escutam a mesma consulta no Cloud Firestore (`comentarios` filtrado pelo `publicacaoId`). Quando uma conta grava um comentário novo, o Firestore avisa todos os ouvintes ativos dessa consulta, e cada app recebe a lista atualizada pelo `Stream`. O `StreamBuilder` redesenha a tela, então o comentário aparece na hora nas outras contas, sem atualizar a página.
