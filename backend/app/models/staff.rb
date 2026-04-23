class Staff < ApplicationRecord
  has_secure_password
  # ログイン失敗回数
  MAX_ATTEMPTS = 30

  # 権限の定義
  enum role: {
    viewer: 0,
    operator: 1,
    owner: 2
  }

  validates :name, uniqueness: true

  def active_for_login?
    # 論理削除されていたら不可
    return false if deleted?
    # アカウントがロックされていると不可
    return false if account_locked?
    # 適用期間開始日よりも前なら不可
    return false if effective_from > Date.current
    # 適用終了日よりも過去なら不可
    return false if effective_to.present? && effective_to < Date.current

    true
  end

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
