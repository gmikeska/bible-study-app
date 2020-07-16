class Quiz < ApplicationRecord
  belongs_to :lesson
  has_one :course, through: :lesson
  serialize :questions, Array

  def add_question(question, field_type,choices=nil,answer=nil)
    questions << {text:question, field_type:field_type,choices:choices, answer:answer}
    save
  end
  def self.question_types
    [["Short Answer","text_field"], ["Long Answer","text_area"], ["Multiple Choice","radio_button"], ["Attach File...", "file_field"]]
  end
  def check_answer(index,answer)
    results = []
    question = self.questions[index].symbolize_keys
    if(question[:field_type] == "radio_button")
      answer = answer.to_i
    end
    if(question[:answer].present? && question[:answer] == answer)
      result = :correct
    elsif(question[:answer].present? && question[:answer] != answer)
      result = :incorrect
    elsif(question[:answer].nil? || question[:answer] == "")
      result = :pending
    end
    return result
  end
  def check_results(answers)
    results = []
    self.questions.each_index do |index|; question = self.questions[index]
      if(question[:field_type] == "radio_button")
        answers[index] = answers[index].to_i

      end
      if(question[:answer].present? && question[:answer] == answers[index])
        results[index] = :correct
      elsif(question[:answer].present? && question[:answer] != answers[index])
        results[index] = :incorrect
      elsif(question[:answer].nil? || question[:answer] == "")
        results[index] = :pending
      end
    end
    return results
  end
  def check_score(results)
    number_correct = results.select{|e| e == :correct }.count
    puts "correct:#{number_correct}"
    number_incorrect = results.select{|e| e == :incorrect }.count
    puts "incorrect:#{number_incorrect}"
    total_scorable = number_correct + number_incorrect
    puts "total_scorable:#{total_scorable}"
    score = (number_correct.to_f/total_scorable.to_f)*100
    puts "score:#{score}"
    return score
  end
end
