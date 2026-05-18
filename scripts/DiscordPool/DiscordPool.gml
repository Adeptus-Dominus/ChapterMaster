/*
    []=============================================[]
    ||  Webhook Integration System for GameMaker   ||
    ||  https://github.com/Kruger0/GMHook          ||
    ||                                             ||
    ||                                 --KrugDev   ||
    []=============================================[]
*/

///@desc Creates a Discord poll object for interactive voting.
///@arg {String} text The poll question text.
///@arg {Real} duration The poll duration in hours (1-768). Defaults to 24.
///@arg {Bool} multiselect Whether users can select multiple answers. Defaults to false.
///@return {DiscordPoll} A new poll instance.
function DiscordPoll(text, duration = 24, multiselect = false) constructor {
	
    #region Private
    question            = {text};
    self.duration       = clamp(duration, 1, 768);
    allow_multiselect   = multiselect;
    answers             = [];
    #endregion

    ///@desc Adds an answer option to the poll.
    ///@arg {String} text The answer text.
    ///@arg {String|Real} emoji The emoji for the answer (name string or ID number).
    ///@return {Struct.DiscordPoll} Returns self for method chaining.
    static AddAnswer = function(text, emoji = undefined) {
        var _answer = {
            poll_media : {text},
        }
        if (emoji != undefined) {
            _answer.poll_media.emoji = {};

            if (is_numeric(emoji)) {
                _answer.poll_media.emoji.id = string(emoji);
            } else {
                _answer.poll_media.emoji.name = emoji;
            }
        }
        array_push(answers, _answer);
        return self;
    }
}