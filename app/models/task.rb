class Task < ApplicationRecord
    # userのモデルインスタンスに属する
    belongs_to :user
end
