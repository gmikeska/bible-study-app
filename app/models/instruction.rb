class Instruction < ApplicationRecord
  belongs_to :course
  serialize :attending, Array
  serialize :messages, Array

end
