## Post Jira Comment on Latest Jira Issue From Git Log

git log のタイトルから Jira の直近の課題キー（抽出条件：[A-Z]+-[0-9]+）を取得して、その課題にコメントを投稿します。

## 入力パラメータ

`github_repository` と `github_sha` と `github_token` を除き全て必須です。

| 入力              | 説明                                                        | デフォルト                 |
|-------------------|-------------------------------------------------------------|----------------------------|
| comment           | Jira に投稿するコメント                                     |                            |
| jira_server_url   | Jira インスタンスのURL                                      |                            |
| jira_api_token    | Jira の認証のためのアクセストークン                         |                            |
| jira_email        | Jira のアクセストークンが作成されたユーザーのメールアドレス |                            |
| github_repository | Git のレポジトリ                                            | `${{ github.repository }}` |
| github_sha        | Git のコミットハッシュ                                      | `${{ github.sha }}`        |
| github_token      | Github のアクセストークン                                   | `${{ github.token }}`      |

## 出力パラメータ

| 出力           | 説明                               |
|----------------|------------------------------------|
| jira_issue_key | コメント投稿対象の Jira の課題キー |
