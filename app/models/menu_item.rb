class MenuItem < ActiveRecord::Base
   belongs_to :menu_sections
   has_many :menu_additions
   has_many :menu_choices
end
