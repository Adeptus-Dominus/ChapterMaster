/*
    []=============================================[]
    ||  Webhook Integration System for GameMaker   ||
    ||  https://github.com/Kruger0/GMHook          ||
    ||                                             ||
    ||                                 --KrugDev   ||
    []=============================================[]
*/

///@desc Creates a Discord embed object for rich message formatting.
///@return {DiscordEmbed} A new embed instance.
function DiscordEmbed() constructor {

    ///@desc Adds a field to the embed.
    ///@arg {String} name The field name/title.
    ///@arg {String} value The field content.
    ///@arg {Bool} inline Whether the field should be displayed inline. Defaults to false.
    ///@return {Struct.DiscordEmbed} Returns self for method chaining.
    static AddField = function(name, value, inline = false) {
        self[$ "fields"] ??= [];
        array_push(fields, {name, value, inline});
        return self;
    }
    
    ///@desc Sets multiple fields at once.
    ///@arg {Array} fields Array of field objects {name, value, inline}.
    ///@return {Struct.DiscordEmbed} Returns self for method chaining.
    static SetFields = function(fields) {
        self.fields = variable_clone(fields);
        return self;
    }
    
    ///@desc Sets the embed title.
    ///@arg {String} title The embed title text.
    ///@return {Struct.DiscordEmbed} Returns self for method chaining.
    static SetTitle = function(title) {
        self.title = title;
        return self;
    }
    
    ///@desc Sets the embed description.
    ///@arg {String} description The embed description text.
    ///@return {Struct.DiscordEmbed} Returns self for method chaining.
    static SetDescription = function(description) {
        self.description = description;
        return self;
    }
    
    ///@desc Sets the embed color (left border color).
    ///@arg {Real} color The color value (BGR format will be converted to RGB).
    ///@return {Struct.DiscordEmbed} Returns self for method chaining.
    static SetColor = function(color) {
        self.color = ((color & 0xFF) << 16) | (color & 0xFF00) | ((color & 0xFF0000) >> 16);
        return self;
    }
    
    ///@desc Sets the embed author information.
    ///@arg {String} name The author name.
    ///@arg {String} url The author URL (makes name clickable).
    ///@arg {String} icon_url The author icon URL.
    ///@return {Struct.DiscordEmbed} Returns self for method chaining.
    static SetAuthor = function(name, url = "", icon_url = "") {
        author = {name, url, icon_url};
        return self;
    }
    
    ///@desc Sets the embed URL (makes title clickable).
    ///@arg {String} url The URL to link to.
    ///@return {Struct.DiscordEmbed} Returns self for method chaining.
    static SetURL = function(url) {
        self.url = url;
        return self;
    }
    
    ///@desc Sets the embed image from a URL.
    ///@arg {String} url The image URL.
    ///@return {Struct.DiscordEmbed} Returns self for method chaining.
    static SetImageURL = function(url) {
        image = {url};
        return self;
    }
    
    ///@desc Sets the embed image from an attached file.
    ///@arg {String} filename The filename of the attached file.
    ///@return {Struct.DiscordEmbed} Returns self for method chaining.
    static SetImageFile = function(filename) {
        image = {url : "attachment://"+filename};
        return self;
    }
    
    ///@desc Sets the embed thumbnail image.
    ///@arg {String} url The thumbnail image URL.
    ///@return {Struct.DiscordEmbed} Returns self for method chaining.
    static SetThumbnail = function(url) {
        thumbnail = {url};
        return self;
    }
    
    ///@desc Sets the embed footer information.
    ///@arg {String} text The footer text.
    ///@arg {String} icon_url The footer icon URL.
    ///@return {Struct.DiscordEmbed} Returns self for method chaining.
    static SetFooter = function(text, icon_url = "") {
        footer = {text, icon_url};
        return self;
    }
    
    ///@desc Sets the embed timestamp.
    ///@arg {String} timestamp The timestamp in ISO 8601 format.
    ///@return {Struct.DiscordEmbed} Returns self for method chaining.
    static SetTimestamp = function(timestamp) {
        self.timestamp = timestamp;
        return self;
    }
}