class User < ApplicationRecord
    # 複数のtaskモデルのインスタンスを持つ
    has_many :tasks

    # 名前は存在しているか
    validates :name, presence: true

    # google idは存在しているか
    validates :google_id, presence: true

    # パスワードは、5から20文字まで
    validates :password, length: { in: 5..20 }
end
