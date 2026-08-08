function SectorHandler() constructor {
    millenium = 41;
    year_fraction = 0;
    year = 735;
    check_number = 5;

    static date = function() {
        var yf = "";
        if (year_fraction < 10) {
            yf = "00" + string(year_fraction);
        }
        if ((year_fraction >= 10) && (year_fraction < 100)) {
            yf = "0" + string(year_fraction);
        }
        if (year_fraction >= 100) {
            yf = string(year_fraction);
        }
        return $"{check_number} {yf} {year}.M{millenium}";
    };

    static game_year = function() {
        return (millenium * 1000) + year;
    };

    static increment_date = function() {
        year_fraction += 84;
        if (year_fraction > 999) {
            year += 1;
            year_fraction = 0;
        }
        if (year >= 1000) {
            millenium += 1;
            year -= 1000;
        }
    };

    static get_time_from_current_year = function(age_from_year) {
        return game_year() - age_from_year;
    };

    static get_creation_year = function(age) {
        return game_year() - age;
    };

    LOGGER.info("SectorHandler successfully initialised");
}
