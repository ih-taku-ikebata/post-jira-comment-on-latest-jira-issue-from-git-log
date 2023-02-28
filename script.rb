# REPOSITORY_PATH: git log を検索する対象のレポジトリのパス
# COMMENT        : Jira に投稿するコメント
# JIRA_SERVER_URL: Jira インスタンスのURL。例：`https://<yourdomain>.atlassian.net`
# JIRA_API_TOKEN : 認証のためのアクセストークン
# JIRA_EMAIL     : アクセストークンが作成されたユーザーのメールアドレス

require 'jira-ruby'

class LatestJiraIssueComment
  attr_reader :repository_path, :comment, :issue_key, :jira_server_url, :jira_api_token, :jira_email

  JIRA_ISSUE_REGEXP = Regexp.new('[A-Z]+-[0-9]+')

  def initialize
    @repository_path = ENV.fetch('REPOSITORY_PATH', nil)
    @comment = ENV.fetch('COMMENT', nil)
    @jira_server_url = ENV.fetch('JIRA_SERVER_URL', nil)
    @jira_api_token = ENV.fetch('JIRA_API_TOKEN', nil)
    @jira_email = ENV.fetch('JIRA_EMAIL', nil)

    set_issue_key
    validate!
  end

  def create
    jira_comment(@comment)
    puts @issue_key
  end

  private

  def set_issue_key
    @issue_key = latest_issue_key
  end

  def validate!
    errors = []
    invalid_env_keys = []
    invalid_env_keys << 'REPOSITORY_PATH' unless @repository_path
    invalid_env_keys << 'COMMENT' unless @comment
    invalid_env_keys << 'JIRA_SERVER_URL' unless @jira_server_url
    invalid_env_keys << 'JIRA_API_TOKEN' unless @jira_api_token
    invalid_env_keys << 'JIRA_EMAIL' unless @jira_email
    errors << "環境変数の #{invalid_env_keys.join(', ')} が設定されていません。" unless invalid_env_keys.empty?
    errors <<  '課題キーを取得できません。' unless @issue_key
    raise errors.join unless errors.empty?
  end

  def git_logs
    Dir.chdir(@repository_path) do
      `git log --oneline`.split("\n")
      # TODO: Open3 経由でコマンドを実行する
      # Open3 経由だとエラーになる
      # stdout, stderr = Open3.capture3( `git log --oneline`)
      # raise "コミットログを取得できません：#{stderr}" if stderr != ''
      # stdout.split("\n")
    end
  end

  def commits_with_issue_key
    git_logs.select { |log| log.match(JIRA_ISSUE_REGEXP) }
  end

  def latest_commit_with_issue_key
    commits_with_issue_key.first
  end

  def latest_issue_key
    latest_commit_with_issue_key.slice(JIRA_ISSUE_REGEXP)
  end

  def jira_client
    JIRA::Client.new(
      {
        site: @jira_server_url,
        context_path: '',
        username: @jira_email,
        password: @jira_api_token,
        auth_type: :basic,
      }
    )
  end

  def jira_issue
    begin
      jira_client.Issue.find(@issue_key)
    rescue
      raise "Jira の課題の取得に失敗しました。(#{@issue_key})"
    end
  end

  def jira_comment(body)
    jira_issue.comments.build.save!(body: body)
  end
end

LatestJiraIssueComment.new.create
