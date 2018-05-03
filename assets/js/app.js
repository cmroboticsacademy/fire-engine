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


  questionListGroup.append(`
    <li class="list-group-item question_${questionIndex}">
      <div id="question_${questionIndex}">
        <div class="row">
          <div col="1"  style="padding-top:5px;">
            <a href="javascript:void(0);" onclick="deleteQuestion(this, ${questionIndex})">
              <i class="fas fa-trash"></i>
            </a>
          </div>

          <div class="col 5">
            <input class="form-control" id="quiz_questions_${questionIndex}_content" name="quiz[questions][${questionIndex}][content]" placeholder="Question" type="text">
          </div>

          <div class="col 6">
            <input class="form-control" id="quiz_questions_${questionIndex}_type" name="quiz[questions][${questionIndex}][type]" placeholder="Type" type="text">
          </div>
        </div>

        <ul class="list-group answers">
          <li class="list-group-item answer_0">

            <div id="question_${questionIndex}_answer_0" class="row">
              <div col="1"  style="padding-top:5px;">
                <a href="javascript:void(0);" onclick="deleteAnswer(this, ${questionIndex}, 0)">
                  <i class="fas fa-times-circle"></i>
                </a>
              </div>

              <div class="col 9">
                <input class="form-control" id="quiz_questions_${questionIndex}_answers_0_answer" name="quiz[questions][${questionIndex}][answers][0][answer]" placeholder="Answer" type="text">
              </div>

              <div class="form-check col 2">
                <label for="quiz_questions_${questionIndex}_answers_0_weight">Weight</label>

                <input name="quiz[questions][${questionIndex}][answers][0][weight]" value="false" type="hidden">

                <input id="quiz_questions_${questionIndex}_answers_0_weight" name="quiz[questions][${questionIndex}][answers][0][weight]" type="number" step="0.25" value="0" max="1.0" min="-1.0">
              </div>
            </div>
          </li>
        </ul>
      </div>

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

window.deleteQuestion = (obj, index) => {
  console.log(index)
  $(obj).closest("#question_"+index).prev().remove()
  $(obj).closest("#question_"+index).remove()
}

window.deleteAnswer = (obj, q, a) => {
  $(obj).closest("#question_"+q+"_answer_"+a).prev("input").remove()
  $(obj).closest("#question_"+q+"_answer_"+a).remove()
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


function removeQuestion(questionId) {

};

// ============ Main Creating Questions ============ //
// ============ Main Creating Questions ============ //

function createQuestion() {
  var questionListContainer = $('.question-list');

  var questionIndex = getQuestionCount();
  var alreadyExist = checkExistingQuestionIndex(questionIndex);

  // ========= check if question index already exist..
  if (alreadyExist) {
    questionIndex = getNextIndex(questionIndex);
  };

  var newQuestionId = 'question_' + questionIndex;
  var newQuestionText = 'Question ' + questionIndex;
  var newQuestionCardContainer = '<div class="question-card card border-primary" id="' + newQuestionId + '"></div>';

  var cardHeaderContainer = '<div class="card-header"></div>';
  var cardHeaderText = '<b class="float-left">' + newQuestionText + '</b>';
  var removeBtnContainer = '<div class="text-right"></div>';
  var removeButton = '<button class="btn btn-danger remove-question-btn" questionId="' + questionIndex + '"><i class="fas fa-times"></i> Remove Question</button>';
  var questionEditor = '<textarea class="form-control" id="editorquiz_questions_' + questionIndex + '" name="quiz[questions][' + questionIndex + '][content]" placeholder="Enter Question Here"></textarea>';

  var cardBodyContainer = '<div class="question-options card-body"></div>';
  var cardBodyText = '<b>Question Weight / Type</b>';
  var rowContainer = '<div class="row"></div>';
  var columnContainer = '<div class="col-4"></div>';
  var questionWeightInput = '<input class="form-control" id="quiz_questions_' + questionIndex + '_points" name="quiz[questions][' + questionIndex + '][points]" placeholder="Points" type="number" value="1.0">';
  var questionTypeInput = '<input class="form-control" id="quiz_questions_' + questionIndex + '_type" name="quiz[questions][' + questionIndex + '][type]" placeholder="Question Type" type="text">';
  var addAnswerButton = '<button class="btn btn-outline-primary btn-block add-answer-btn" questionId="' + questionIndex + '"><i class="fas fa-plus"></i> Add Answer</button>';

  var cardFooterContainer = '<div class="question-answer-list card-footer"><div>';
  var cardFooterText = '<b>Answer Text / Weight</b>';

  // Create New Navigation Item
  createQuestionNavItem(questionIndex, newQuestionId, newQuestionText);

  // Appends
  questionListContainer.append(newQuestionCardContainer);
  $('.question-card').last().append(cardHeaderContainer);
  $('.card-header').last().append(cardHeaderText);
  $('.card-header').last().append(removeBtnContainer);
  $('.text-right').last().append(removeButton);
  $('.card-header').last().append(questionEditor);

  $('.question-card').last().append(cardBodyContainer);
  $('.card-body').last().append(cardBodyText);
  $('.card-body').last().append(rowContainer);
  $('.row').last().append(columnContainer);
  $('.col-4').last().append(questionWeightInput);
  $('.row').last().append(columnContainer);
  $('.col-4').last().append(questionTypeInput);
  $('.row').last().append(columnContainer);
  $('.col-4').last().append(addAnswerButton);

  $('.question-card').last().append(cardFooterContainer);
  $('.card-footer').last().append(cardFooterText);

  // Create an intial answer choice
  createAnswers(questionIndex);
};

function getQuestionCount() {
  var questionListContainer = $('.question-list').children();
  var questionCount = questionListContainer.filter('div').length;

  return questionCount;
};

function checkExistingQuestionIndex(questionIndex) {
  var selector = '#question_' + questionIndex;
  var found = $(selector);

  if (found.length > 0) {
    return true;
  } else {
    return false;
  };
};

function getNextIndex(questionIndex) {
  var nextIndex = questionIndex + 1;
  // Recursively get the next index, what?
  if (checkExistingQuestionIndex(nextIndex)) {
    return getNextIndex(nextIndex);
  } else {
    return nextIndex;
  };
};

function createQuestionNavItem(questionIndex, questionId, questionText) {
  var navContainer = $('#question-scrollspy-nav');
  var navItem = '<a href="#' + questionId + '" class="list-group-item list-group-item-action" questionId="' + questionIndex + '">' + questionText + '</a>';

  navContainer.append(navItem);
};

function createAnswers(questionId) {
  var selector = '#question_' + questionId;
  var answerListContainer = $(selector).find('.question-answer-list');
  var answerIndex = getAnswerCount(questionId);
  var newAnswerId = 'question_' + questionId + '_answer_' + answerIndex;
  var newAnswerSelector = '#' + newAnswerId;

  // console.log(answerIndex);

  var newAnswerContainer = '<div id="' + newAnswerId + '" class="row"></div>';
  var rowContainer = '<div class="row"></div>';
  var largeColumnContainer = '<div class="col-8"></div>';
  var smallColumnContainer = '<div class="col-3"></div>';
  var tinyColumnContainer = '<div class="col-1"></div>';

  var textInputId = 'quiz_questions_' + questionId + '_answers_' + answerIndex + '_answer';
  var textInputName = 'quiz[questions][' + questionId + '][answers][' + answerIndex + '][answer]';
  var weightInputId = 'quiz_questions_' + questionId + '_answers_' + answerIndex + '_weight';
  var weightInputName = 'quiz[questions][' + questionId + '][answers][' + answerIndex + '][weight]';
  var answerTextInput = '<input class="form-control" id="' + textInputId + '" name="' + textInputName + '" placeholder="Enter Answer" type="text">';
  var answerWeightInput = '<input id="' + weightInputId + '" max="1.0" min="-1.0" name="' + weightInputName + '" placeholder="0" step="0.25" type="number" value="1.0" class="form-control">';

  var removeAnswerBtn = '<button class="btn btn-outline-danger btn-block remove-answer-btn" questionId="' + questionId + '" answerId="' + answerIndex + '"><i class="fas fa-times-circle"></i></button>';

  // Appends
  answerListContainer.last().append(newAnswerContainer);
  $(newAnswerSelector).last().append(largeColumnContainer);
  $(newAnswerSelector).find('.col-8').last().append(answerTextInput);
  $(newAnswerSelector).last().append(smallColumnContainer);
  $(newAnswerSelector).find('.col-3').last().append(answerWeightInput);
  $(newAnswerSelector).last().append(tinyColumnContainer);
  $(newAnswerSelector).find('.col-1').last().append(removeAnswerBtn);
};

function getAnswerCount(questionId) {
  var selector = '#question_' + questionId;
  var answerSelector = 'question_' + questionId + '_answer';
  var answerListContainer = $(selector).find('.question-answer-list').children();
  var answerCount = answerListContainer.filter('div').length;

  // console.log(answerCount);
  return answerCount;
};

function removeQuestion(questionId) {
  var selector = '#question_' + questionId;
  var navSelector = '[questionid="' + questionId + '"]'
  var questionContainer = $(selector);
  var questionInputItem = $(questionContainer).prev('input');
  var questionNavItem = $('#question-scrollspy-nav').find(navSelector);
  var questionNavInputItem = $(questionNavItem).prev('input');

  questionContainer.remove();
  questionInputItem.remove();
  questionNavItem.remove();
  questionNavInputItem.remove();
};

function removeAnswer(questionId, answerId) {

};

// ============ Main Init ============ //
// ============ Main Init ============ //

$(document).ready(function() {
  var isQuizForm = $('.quiz-form').length;

  if (isQuizForm) {
    toggleTimeLimit();
    toggleTimeWindow();
  };
});

// ============ Click Events ============ //
// ============ Click Events ============ //

$(document).on('click', '#quiz_time_limit', function() {
  toggleTimeLimit();
});

$(document).on('click', '#quiz_time_window', function() {
  toggleTimeWindow()
});

$(document).on('click', '.add-question-btn', function() {
  createQuestion();
});

$(document).on('click', '.add-answer-btn', function() {
  var questionId = $(this).attr('questionId');
  createAnswers(questionId);
});

$(document).on('click', '.remove-question-btn', function() {
    var questionId = $(this).attr('questionId');
    removeQuestion(questionId);
});
