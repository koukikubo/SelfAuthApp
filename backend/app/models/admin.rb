class Admin < ApplicationRecord
  # パスワードのハッシュ化と認証機能を提供
  has_secure_password
  # アカウントロックの最大試行回数
  MAX_ATTEMPTS = 30
  # ユーザー名のバリデーション
  validates :name, presence: true
  # パスワードのバリデーション（新規作成時のみ）
  def active_for_login?
    # 論理削除されていたら不可
    return false if deleted?
    # アカウントがロックされていると不可
    return false if account_locked?
    # 適用期間開始日よりも前なら不可
    return false if effective_from > Date.current
    # 適用終了日よりも過去なら不可
    return false if effective_to.present? && effective_to < Date.current
    # 全てクリアしている場合はログイン可能とする
    true
  end

  # ログイン失敗時の処理
  def register_failed_attempt!
    # 失敗回数+1（DB更新）
    increment!(:failed_attempts)
    # 失敗回数が最大試行回数以上ならアカウントロックする
    update!(account_locked: true) if failed_attempts >= MAX_ATTEMPTS
  end
  # ログイン成功時に失敗回数をリセットする処理
  def reset_failed_attempts!
    update!(failed_attempts: 0)
  end
end
