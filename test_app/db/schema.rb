ActiveRecord::Schema.define do
  create_table :articles, :force => true do |t|
    t.string :title
    t.string :password
  end
end

