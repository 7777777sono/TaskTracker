class User < ApplicationRecord
    # 複数のtaskモデルのインスタンスを持つ
    has_many :tasks
end
