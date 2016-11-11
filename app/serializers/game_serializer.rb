class GameSerializer < ActiveModel::Serializer
  attributes :id, :total_score, :frames
end
