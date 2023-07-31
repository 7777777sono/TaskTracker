class User < ApplicationRecord
    # password_digestという属性に暗号化されたパスワードが格納される
    has_secure_password

    # 複数のtaskモデルのインスタンスを持つ
    has_many :tasks

    # 名前は存在しているか
    validates :name, presence: true

    # メールアドレスのフォーマットは適切か
    validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }

    # google idは存在しているか
    validates :google_id, presence: true

    # パスワードは、5から20文字まで
    validates :password, length: { in: 5..20 }
end
