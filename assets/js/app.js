// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".


import "phoenix_html"

$(".alert").alert()

window.addQuestion = () => {
  var questionListGroup = $(".list-group.questions")
  var questionIndex = questionListGroup.children().length


  questionListGroup.append(`<li class="list-group-item question_${questionIndex}">
  <div id="question_${questionIndex}">
    <div class="row">
      <div col="1"  style="padding-top:5px;"><a href="javascript:void(0);" onclick="deleteQuestion(this, ${questionIndex})"><i class="fas fa-trash"></a></i></div>
    <div class="col 5">
      <input class="form-control" id="quiz_questions_${questionIndex}_content" name="quiz[questions][${questionIndex}][content]" placeholder="Question" type="text">        </div>
      <div class="col 6">
        <input class="form-control" id="quiz_questions_${questionIndex}_type" name="quiz[questions][${questionIndex}][type]" placeholder="Type" type="text">        </div>
      </div>

      <ul class="list-group answers">
        <li class="list-group-item answer_0">
          <div id="question_${questionIndex}_answer_0" class="row">
            <div col="1"  style="padding-top:5px;"><a href="javascript:void(0);" onclick="deleteAnswer(this, ${questionIndex}, 0)"><i class="fas fa-times-circle"></a></i></div>
            <div class="col 9">
              <input class="form-control" id="quiz_questions_${questionIndex}_answers_0_answer" name="quiz[questions][${questionIndex}][answers][0][answer]" placeholder="Answer" type="text">              </div>
              <div class="form-check col 2">
                <label for="quiz_questions_${questionIndex}_answers_0_weight">Weight</label>              <input name="quiz[questions][${questionIndex}][answers][0][weight]" value="false" type="hidden"><input id="quiz_questions_${questionIndex}_answers_0_weight" name="quiz[questions][${questionIndex}][answers][0][weight]" type="number" step="0.25" value="0" max="1.0" min="-1.0">
                </div>
              </div>
            </li>

            </ul>

            <a href="javascript:void(0);" class="btn btn-default btn-circle addAnswer" onclick="addAnswer(this)"><svg class="svg-inline--fa fa-plus fa-w-14" aria-hidden="true" data-prefix="fa" data-icon="plus" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" data-fa-i2svg=""><path fill="currentColor" d="M448 294.2v-76.4c0-13.3-10.7-24-24-24H286.2V56c0-13.3-10.7-24-24-24h-76.4c-13.3 0-24 10.7-24 24v137.8H24c-13.3 0-24 10.7-24 24v76.4c0 13.3 10.7 24 24 24h137.8V456c0 13.3 10.7 24 24 24h76.4c13.3 0 24-10.7 24-24V318.2H424c13.3 0 24-10.7 24-24z"></path></svg><!-- <i class="fa fa-plus"></i> --> Add Answer</a></div>

        </li>`)

}

window.addAnswer = (obj) => {
  var questionIndex = obj.parentElement.parentElement.className.split(" ")[1].split("_")[1]
  var question = $(`.list-group-item.question_${questionIndex}`)
  var questionAnswers = question.find('.list-group-item')
  var questionAnswersIndex = questionAnswers.children().length

  console.log("questionAnswers", questionAnswers)


  questionAnswers.append(`
    <div id="question_${questionIndex}_answer_${questionAnswersIndex}" class="row">
      <div col="1"  style="padding-top:5px;"><a href="javascript:void(0);" onclick="deleteAnswer(this, ${questionIndex}, ${questionAnswersIndex})"><i class="fas fa-times-circle"></a></i></div>
      <div class="col 9">
        <input class="form-control" id="quiz_questions_${questionIndex}_answers_${questionAnswersIndex}_answer" name="quiz[questions][${questionIndex}][answers][${questionAnswersIndex}][answer]" placeholder="Answer" type="text">              </div>
        <div class="form-check col 2">
          <label for="quiz_questions_${questionIndex}_answers_${questionAnswersIndex}_weight">Weight</label>              <input name="quiz[questions][${questionIndex}][answers][${questionAnswersIndex}][weight]" value="false" type="hidden"><input id="quiz_questions_${questionIndex}_answers_0_weight" name="quiz[questions][${questionIndex}][answers][${questionAnswersIndex}][weight]" value="0" type="number" step="0.25" value="0" max="1.0" min="-1.0">
          </div>
        </div>
      </li>

    </ul>
    `)

}

window.addAnswerQuestionForm = (obj) => {
  var questionAnswers = $('.list-group-item.answer_0')
  var questionAnswersIndex = questionAnswers.children().length

  questionAnswers.append(`
    <div id="question_0_answer_${questionAnswersIndex}" class="row">
      <div col="1"  style="padding-top:5px;"><a href="javascript:void(0);" onclick="deleteAnswer(this, 0, ${questionAnswersIndex})"><i class="fas fa-times-circle"></a></i></div>
      <div class="col 9">
        <input class="form-control" id="question_answers_${questionAnswersIndex}_answer" name="question[answers][${questionAnswersIndex}][answer]" placeholder="Answer" type="text">              </div>
        <div class="form-check col 2">
          <label for="question_answers_${questionAnswersIndex}_weight">Weight</label>              <input name="question[answers][${questionAnswersIndex}][weight]" value="false" type="hidden"><input id="question_answers_[${questionAnswersIndex}]_weight" name="question[answers][${questionAnswersIndex}][weight]" value="0" type="number" step="0.25" value="0" max="1.0" min="-1.0">
          </div>
        </div>
      </li>

    </ul
    `)

}

window.addTagQuestionForm = (obj) => {
  var questionTags = $('.list-group-item.tag_0')
  var questionTagsIndex = questionTags.children().length

  questionTags.append(`
    <div id="question_0_tag_${questionTagsIndex}" class="row">
      <div col="1"  style="padding-top:5px;"><a href="javascript:void(0);" onclick="deleteTag(this, 0, ${questionTagsIndex})"><i class="fas fa-times-circle"></a></i></div>
      <div class="col 9">
        <input class="form-control" id="question_tags_${questionTagsIndex}_name" name="question[tags][${questionTagsIndex}][name]" placeholder="Tag" type="text">          </div>
      </li>

    </ul
    `)

}



window.deleteQuestion = (obj, index) => {
  console.log(index)
  $(obj).closest("#question_"+index).prev().remove()
  $(obj).closest("#question_"+index).remove()
}

window.deleteTag = (obj, q, a) => {
  $(obj).closest("#question_"+q+"_tag_"+a).prev("input").remove()
  $(obj).closest("#question_"+q+"_tag_"+a).remove()
}

// ============ Quiz Forms Scripts ============ //
// ============ Quiz Forms Scripts ============ //

function toggleTimeLimit() {
  var timeLimitCheck = $('#quiz_time_limit');
  var timeLimitInput = $('#quiz_time_limit_minutes');

  if (timeLimitCheck.is(':checked')) {
    timeLimitInput.prop('disabled', false);
  } else {
    timeLimitInput.prop('disabled', true);
  };
};

function toggleTimeWindow() {
  var timeWindowCheck = $('#quiz_time_window');
  var timeOpenSelectors = $('[id^=quiz_time_open]');
  var timeClosedSelectors = $('[id^=quiz_time_closed]');

  if (timeWindowCheck.is(':checked')) {
    timeOpenSelectors.each(function() {
      $(this).prop('disabled', false);
    });

    timeClosedSelectors.each(function() {
      $(this).prop('disabled', false);
    });

  } else {
    timeOpenSelectors.each(function() {
      $(this).prop('disabled', true);
    });

    timeClosedSelectors.each(function() {
      $(this).prop('disabled', true);
    });
  };
};


$(document).ready(function() {
  var isQuizForm = $('.quiz-form').length;

  if (isQuizForm) {
    toggleTimeLimit();
    toggleTimeWindow();
  };
});

$(document).on('click', '#quiz_time_limit', function() {
  toggleTimeLimit();
});

$(document).on('click', '#quiz_time_window', function() {
  toggleTimeWindow()
});
