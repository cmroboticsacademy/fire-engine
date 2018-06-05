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

// =========== Enable Tooltips ============= //

$(function () {
  $('[data-toggle="tooltip"]').tooltip()
})

// ============ Quiz Form: Toggle Scripts ============ //
// ============ Quiz Form: Toggle Scripts ============ //

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

// ============ Quiz Form: Creating Questions and Answers ============ //
// ============ Quiz Form: Creating Questions and Answers ============ //

function createQuestion() {
  var questionListContainer = $('.question-list');

  var questionIndex = getQuestionCount();
  var alreadyExist = checkExistingQuestionIndex(questionIndex);

  // Check if question index already exist..
  if (alreadyExist) {
    questionIndex = getNextQuestionIndex(questionIndex);
  };

  var newQuestionId = 'question_' + questionIndex;
  var newQuestionText = 'Question ' + questionIndex;
  var newQuestionCardContainer = '<div class="question-card card border-primary" id="' + newQuestionId + '"></div>';

  var cardHeaderContainer = '<div class="card-header"></div>';
  var cardHeaderText = '<b class="float-left">' + newQuestionText + '</b>';
  var removeBtnContainer = '<div class="text-right"></div>';
  var removeButton = '<button type="button" class="btn btn-danger remove-question-btn" questionId="' + questionIndex + '"><i class="fas fa-times"></i> Remove Question</button>';
  var questionEditor = '<textarea class="form-control" id="editorquiz_questions_' + questionIndex + '" name="quiz[questions][' + questionIndex + '][content]" placeholder="Enter Question"></textarea>';

  var cardBodyContainer = '<div class="question-options card-body"></div>';
  var cardBodyText = '<b>Question Weight / Type</b>';
  var rowContainer = '<div class="row"></div>';
  var columnContainer = '<div class="col-4"></div>';
  var questionWeightInput = '<input class="form-control" id="quiz_questions_' + questionIndex + '_points" name="quiz[questions][' + questionIndex + '][points]" placeholder="Enter Point Value" type="number" value="1.0">';
  var questionTypeInput = '<input class="form-control" id="quiz_questions_' + questionIndex + '_type" name="quiz[questions][' + questionIndex + '][type]" placeholder="Enter Question Type (optional)" type="text">';
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

function getNextQuestionIndex(questionIndex) {
  var nextIndex = questionIndex + 1;
  // Recursively get the next index, what?
  if (checkExistingQuestionIndex(nextIndex)) {
    return getNextQuestionIndex(nextIndex);
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
  var alreadyExist = checkExistingAnswerIndex(questionId, answerIndex);

  // Check if question index already exist..
  if (alreadyExist) {
    answerIndex = getNextAnswerIndex(questionId, answerIndex);
  };

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
  var answerWeightInput = '<input id="' + weightInputId + '" max="1.0" min="-1.0" name="' + weightInputName + '" placeholder="Enter Value" step="0.25" type="number" value="1.0" class="form-control">';

  var removeAnswerBtn = '<button type="button" class="btn btn-outline-danger btn-block remove-answer-btn" questionId="' + questionId + '" answerId="' + answerIndex + '"><i class="fas fa-times-circle"></i></button>';

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

function checkExistingAnswerIndex(questionIndex, answerIndex) {
  var selector = '#question_' + questionIndex + '_answer_' + answerIndex;
  var found = $(selector);

  // console.log(found);
  if (found.length > 0) {
    return true;
  } else {
    return false;
  };
};

function getNextAnswerIndex(questionIndex, answerIndex) {
  var nextIndex = answerIndex + 1;

  // Recursively get the next index, what?
  if (checkExistingAnswerIndex(questionIndex, nextIndex)) {
    return getNextAnswerIndex(questionIndex, nextIndex);
  } else {
    return nextIndex;
  };
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
  var selector = '#question_' + questionId + '_answer_' + answerId;
  var answerContainer = $(selector);
  var inputSelector = answerContainer.prev('input');

  // console.log(answerContainer);
  // console.log(inputSelector);

  answerContainer.remove();
  inputSelector.remove();
};

// ============ Quiz Form: Creating Answers ============ //
// ============ Quiz Form: Creating Answers  ============ //

// Answer simple are for question forms only...
function createAnswerSimple() {
  var answerListContainer = $('.answer-list');
  var answerIndex = getAnswerSimpleCount();
  var alreadyExist = checkExistingAnswerSimpleIndex(answerIndex);

  if (alreadyExist) {
    answerIndex = getNextAnswerSimpleIndex(answerIndex);
  };

  var newAnswerElemId = 'answer_' + answerIndex;
  var newAnswerId = 'question_answers_' + answerIndex + '_answer';
  var newAnswerName = 'question[answers][' + answerIndex + '][answer]';
  var newWeightId = 'question_answers_' + answerIndex + '_weight';
  var newWeightName = 'question[answers][' + answerIndex + '][weight]';

  var answerContainer = '<div id="' + newAnswerElemId + '" class="row mb-2"></div>';
  var largeColumnContainer = '<div class="col-9 pr-0"></div>';
  var smallColumnContainer = '<div class="col-2 pr-0"></div>';
  var tinyColumnContainer = '<div class="col-1"></div>';

  var answerTextInput = '<input class="form-control" name="' + newAnswerName + '" id="' + newAnswerId + '" placeholder="Enter Answer" type="text">';
  var answerWeightInput = '<input class="form-control" name="' + newWeightName + '" id="' + newWeightId + '" max="1.0" min="-1.0" step="0.25" placeholder="Enter Value">';
  var removeAnswerSimpleBtn = '<button type="button" class="btn btn-outline-danger btn-block remove-answer-simple-btn" answerId="' + answerIndex + '"><i class="fas fa-times-circle"></i></button>';

  // Appends
  answerListContainer.append(answerContainer);
  $('.row').last().append(largeColumnContainer);
  $('.col-9').last().append(answerTextInput);
  $('.row').last().append(smallColumnContainer);
  $('.col-2').last().append(answerWeightInput);
  $('.row').last().append(tinyColumnContainer);
  $('.col-1').last().append(removeAnswerSimpleBtn);
};

function getAnswerSimpleCount() {
  var answerList = $('[id^=answer_]')
  var answerCount = answerList.length;

  console.log(answerCount);
  return answerCount;
};

function checkExistingAnswerSimpleIndex(answerIndex) {
  var selector = '#answer_' + answerIndex;
  var found = $(selector);

  // console.log(found);
  if (found.length > 0) {
    return true;
  } else {
    return false;
  };
};

function getNextAnswerSimpleIndex(index) {
  var nextIndex = index + 1;

  // Recursively get the next index, what?
  if (checkExistingAnswerSimpleIndex(nextIndex)) {
    return getNextAnswerSimpleIndex(nextIndex);
  } else {
    return nextIndex;
  };
};

function removeAnswerSimple(answerId) {
  console.log('removing answer ' + answerId);

  var selector = '#answer_' + answerId;
  var answerContainer = $(selector);
  var inputSelector = answerContainer.prev('input');

  // console.log(answerContainer);
  // console.log(inputSelector);

  answerContainer.remove();
  inputSelector.remove();
};

function selectionToggleImportQuestion(questionId) {
  var selector = '#checkbox_' + questionId;
  var checkbox = $(selector);
  var importBtn = $('.import-btn');
  var count = parseInt(importBtn.attr('count'));

  if (checkbox.is(':checked')) {
    checkbox.prop('checked', false);
    count -= 1;
  } else {
    checkbox.prop('checked', true);
    count += 1;
  };

  importBtn.attr('count', count);
  updateSelectedCount();
};

function updateSelectedCount() {
  var importBtn = $('.import-btn');
  var count = importBtn.attr('count');

  // console.log(count);

  if (count < 1) {
    importBtn.text('Select Questions');
    importBtn.attr('disabled', true);

    if (importBtn.hasClass('btn-primary')) {
      importBtn.removeClass('btn-primary').addClass('btn-outline-primary');
    };
  } else {
    var text = 'Import ' + count + ' Question(s)'
    importBtn.text(text);
    importBtn.attr('disabled', false);

    if (importBtn.hasClass('btn-outline-primary')) {
      importBtn.removeClass('btn-outline-primary').addClass('btn-primary');
    };
  };
};

// ============ Main Init ============ //
// ============ Main Init ============ //

$(document).ready(function() {
  var isQuizForm = $('.quiz-form').length;
  var isQuestionForm = $('.question-form').length;
  var isQuestionImportForm = $('.question-import-form').length;

  if (isQuizForm) {
    toggleTimeLimit();
    toggleTimeWindow();
  } else if (isQuestionForm) {
    console.log('Question Form');
  } else if (isQuestionImportForm) {
    updateSelectedCount();
  };
});

// ============ Quiz Form: Click Events ============ //
// ============ Quiz Form: Click Events ============ //

$(document).on('click', '#quiz_time_limit', function() {
  toggleTimeLimit();
});

$(document).on('click', '#quiz_time_window', function() {
  toggleTimeWindow()
});

$(document).on('click', '.add-question-btn', function() {
  event.preventDefault();
  createQuestion();
});

$(document).on('click', '.add-answer-btn', function() {
  event.preventDefault();
  var questionId = $(this).attr('questionId');

  createAnswers(questionId);
});

$(document).on('click', '.remove-question-btn', function() {
  event.preventDefault();
    var questionId = $(this).attr('questionId');

    removeQuestion(questionId);
});

$(document).on('click', '.remove-answer-btn', function() {
  event.preventDefault();
  var questionId = $(this).attr('questionId');
  var answerId = $(this).attr('answerId');

  removeAnswer(questionId, answerId);
});

// ============ Quiz Form / Import Question: Click Events ============ //
// ============ Quiz Form / Import Question: Click Events ============ //

$(document).on('click', '[id^="question_"]', function() {
  event.preventDefault();
  var questionId = $(this).attr('questionId');

  $(this).toggleClass('active');

  selectionToggleImportQuestion(questionId);
});

// ============ Question Form: Click Events ============ //
// ============ Question Form: Click Events ============ //

$(document).on('click', '.add-answer-simple-btn', function() {
  event.preventDefault();
  createAnswerSimple();
})

$(document).on('click', '.remove-answer-simple-btn', function() {
  event.preventDefault();
  var answerId = $(this).attr('answerId');

  removeAnswerSimple(answerId);
})
