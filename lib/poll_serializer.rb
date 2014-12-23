class PollSerializer 

  def self.count_per_month poll
    replies = poll.reply.group_by { |rep| rep.created_at.strftime("%m-%Y") }
    data = replies.map { |key, values| values.length }
    { 
      data: data,
      title: "Replies per month",
      x_axis: {
        legend: "Polls per month",
        series: replies.keys.map { |date| date }
      },
      y_axis: {
        legend: "No. polls",
        scale: [ 0, (data.max or 0) + 1 ]
      }
    }
  end

  def self.answers_per_question poll
    arr = []
    poll.question.each do |question| 
      answers_per_question = question.answer.group_by(&:possible_answer)
      data = answers_per_question.map { |possible_answer, answers| answers.length }
      series = answers_per_question.map { |possible_answer, answers| possible_answer.title }
      
      obj = { 
        data: data,
        title: question.title,
        x_axis: {
          legend: question.title,
          series: series
        },
        y_axis: {
          legend: "No. polls",
          scale: [ 0, (data.max or 0) + 1 ]
        }
      }

      arr.push(obj)

    end

  end

end