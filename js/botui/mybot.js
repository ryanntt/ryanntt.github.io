var innerHeight = window.innerHeight;
var screenWidth = screen.width;

var botui = new BotUI('my-pa');
var chatSection = $('#chat');

var accessToken = "565f08f95fe147bf84d78b10ba53d7f7",
baseUrl = "https://api.dialogflow.com/v1/",
messageInternalError = "Oh no, there has been an internal server error",
messageSorry = "I'm sorry, I don't ahve the answer to that";

function startChat() {
    $('html, body').animate({
        scrollTop: $("#chat").offset().top
    }, 1000); // smooth scrolling

    $("#chat").toggleClass('open');
    $("#avatar").toggleClass('open');
    $('#chat').css('min-height', innerHeight);
    send("Hello");
    $('#start-chat').css('visibility', 'hidden');
    $('#chat').css('max-height', 'none');
};

function send(val) {
    var text = val;
    $.ajax({
    type: "POST",
    url: baseUrl + "query" + "?v=20150910",
    contentType: "application/json; charset=utf-8",
    headers: {
        "Authorization": "Bearer " + accessToken
    },
    data: JSON.stringify({query: text, lang:"en", sessionId:"yaydevdiner"}),

    success: function(data) {
        prepareResponse(data);
    },
    error: function() {
        respond(messageInternalError);
    }
    });
}

function prepareResponse(val) {
    var debugJSON = JSON.stringify(val, undefined, 2);
    var spokenResponse = val.result.fulfillment.messages;
    var delay = 0;

    for (let entry of spokenResponse) {
    // console.log(delay);
    setTimeout(function() {
        respond(entry);
        scrollSmooth();
    }, delay);
    delay += typingTime(messageExtract(entry))+500;
    }
    scrollSmooth();
    // console.log(debugJSON);
}

function respond(val) {
    if (val == "") {
    return messageSorry;
    }
    
    // Categorise response type to determine whethere this has text only, or buttons
    switch (val.type) {
    case 0: // Text
        var message = messageExtract(val);
        // console.log("typing:"+ typingTime(message));
        if (message != "") {
        botui.message.add({
            delay: typingTime(message),
            loading: true,
            content: message
        })
        }
        scrollSmooth();
        break;
    case 2: // Buttons
        var message = messageExtract(val);
        // console.log("typing:"+ typingTime(message));
        botui.message.add({
        delay: typingTime(message),
        loading: true,
        content: message
        });
        delay = typingTime(message)+500; // delay and setTimeout are used to display buttons after title text
        setTimeout(function() { 
        addButton(val.replies);
        }, delay);
        scrollSmooth();
        break;
    default:
        return messageSorry;
    }
}

function addButton(val) {
    var buttons = [];
    for (let entry of val) { // Build the array of buttons before passing to botui
    buttons.push( {
        text: entry,
        value: entry
    });
    }
    scrollSmooth();
    botui.action.button({
    action: buttons
    }).then(function(res) {
    // console.log(res.value);
    send(res.value);
    });
}

function typingTime(message) { // Function to calculate typing time provided human typing speed on mobile is 400 characters per minute
    var typingTime = message.length*60/(Math.ceil(Math.random()*3)+5);
    return typingTime;
};

function messageExtract(val) { // Function to extract message from object of response array
    if (val == "") {
    return messageSorry;
    }

    switch (val.type) {
    case 0:
        return val.speech;
    case 2:
        return val.title;
        break;
    default:
        return messageSorry;
    }
}

function scrollSmooth () {
    var shouldScroll = chatSection.offset().top + chatSection.height()- $(window).height() + 50 >= $('html, body').scrollTop();
    if (shouldScroll) {
        var scrollPos = chatSection.offset().top + chatSection.height()- $(window).height()+ 120;
        $('html, body').animate({
            scrollTop: scrollPos
        }, 1000);
    }
 }