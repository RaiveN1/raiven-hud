const stresOn = false

var pusulaAlt = true
let ghizg = false
let stresValue = 100

tgiannHud = {}; 

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27: // ESC
            tgiannHud.CloseAyarMenu();
            break;
    }
});

tgiannHud.CloseAyarMenu = function() {
    $(".ayar-menu-ana").css({"display":"none"});
    $.post('https://tgiann-hud/close-ayar-menu');
};

tgiannHud.Open = function(data) {
    $(".money-cash").css("display", "block");
    $("#cash").html(data.cash);
};

tgiannHud.Show = function(data) {
    if(data.type == "cash") {
        $("#cash").html(data.cash);
        if (data.show) {
            $(".money-cash").fadeIn(150);
        } else {
            $(".money-cash").fadeOut(150);
        }
    }
};

tgiannHud.Update = function(data) {
    if(data.type == "cash") {
        $(".money-cash").css("display", "block");
        $("#cash").html(data.cash);
        if (data.minus) {
            $(".money-cash").append('<p class="moneyupdate minus">-<span id="cash-symbol">&dollar;&nbsp;</span><span><span id="minus-changeamount">' + data.amount + '</span></span></p>')
            $(".minus").css("display", "block");
            setTimeout(function() {
                $(".minus").fadeOut(750, function() {
                    $(".minus").remove();
                    $(".money-cash").fadeOut(750);
                });
            }, 3500)
        } else {
            $(".money-cash").append('<p class="moneyupdate plus">+<span id="cash-symbol">&dollar;&nbsp;</span><span><span id="plus-changeamount">' + data.amount + '</span></span></p>')
            $(".plus").css("display", "block");
            setTimeout(function() {
                $(".plus").fadeOut(750, function() {
                    $(".plus").remove();
                    $(".money-cash").fadeOut(750);
                });
            }, 3500)
        }
    }

};

tgiannHud.updateStatus = function(status){
    $('#yemek-ic').css('width', status.yemek/100 + '%')
    $('#su-ic').css('width', status.su/100 + '%')
    stresValue = status.stres/100
};

var imageWidth = 100 // leave this variable, related to pixel size of the directions
var containerWidth = 100 // width of the image container

// var width =  (imageWidth / containerWidth) * 100; // used to convert image width if changed
var width =  0;
var south = (-imageWidth) + width
var west = (-imageWidth * 2) + width
var north = (-imageWidth * 3) + width
var east = (-imageWidth * 4) + width
var south2 = (-imageWidth * 5) + width

function calcHeading(direction) {
    if (direction < 90) {
        return lerp(north, east, direction / 90)
    } else if (direction < 180) {
        return lerp(east, south2, rangePercent(90, 180, direction))
    } else if (direction < 270) {
        return lerp(south, west, rangePercent(180, 270, direction))
    } else if (direction <= 360) {
        return lerp(west, north, rangePercent(270, 360, direction))
    }
}
 
function rangePercent(min, max, amt) {
    return (((amt - min) * 100) / (max - min)) / 100
}

function lerp(min, max, amt) {
    return (1 - amt) * min + amt * max
}

window.addEventListener('message', function(event) {
    switch(event.data.action) {
        case "disSes":
            if (event.data.disSes)  {
                $(".orta-hud-sag").fadeIn(25);
            } else {
                $(".orta-hud-sag").fadeOut(25);
            }
        case "one":
            $(".full-screen").fadeIn(100);
            break;
        case "two": // Araçta İken
            if (event.data.direction) {
                $(".carStats").css("display", "flex")
                $(".saat").addClass("saat-car")

                var direction = calcHeading(event.data.direction)
                if (pusulaAlt) {
                    $(".direction").find(".image").attr('style', 'transform: translate3d(' + direction + 'px, 0px, 0px)');
                    $(".street-txt-tip1").css("display", "flex")
                } else {
                    $(".direction-tip2").find(".image-2").attr('style', 'transform: translate3d(' + direction + 'px, 0px, 0px)');
                    $(".street-sol").css("display", "flex");
                    $(".street-sag").css("display", "flex");
                    $(".direction-tip2").css("width", "100px");
                }
                return;
            }

            if (event.data.engine == false ) {
                setProgressSpeed(0)
                setProgressMini(0,'.progress-fuel')
            } else {
                setProgressMini(event.data.fuel,'.progress-fuel')
                if (event.data.fuel < 21) {
                    $('#fuel').css('stroke', '#d5993d'); //Turuncu
                } else if (event.data.fuel < 16) {
                        $('#fuel').css('stroke', '#800'); // Kırmızı
                } else {
                    $('#fuel').css('stroke', '#31a372'); //  Yeşil
                }
            }
            
            if (pusulaAlt) { 
                $(".street-txt-tip1").html(event.data.street);
            } else {
                $(".street-sol").html(event.data.streetSag);
                $(".street-sag").html(event.data.streetSol);
            }
            
            $(".time").html(event.data.time); 
        
            if (event.data.belt == "close") {
                $('#seatbelt').css('display','none');
            } else if (event.data.belt) {
                $('#seatbelt').css('display','block');
                if (event.data.seatbeltmod) {
                    $('#seatbelt').css('color','#d5993d');
                } else {
                    $('#seatbelt').css('color','#31a372');
                }
            } else {
                $('#seatbelt').css('display','none');
            }

            if (event.data.engineHealth < 500) {
                $('#engineHealth').css('display','block');
            } else {
                $('#engineHealth').css('display','none');
            }

            if (event.data.cruise) {
                $('#cruise').css('display','block');
            } else {
                $('#cruise').css('display','none');
            }

            if (event.data.yukseklik) {
                $('#yukseklik').css('display','block');
                $('#yukseklik').html(Math.round(event.data.yukseklik*3.5)+" Fit");
            } else {
                $('#yukseklik').css('display','none');
            }

            break;
        case "four": // Araçta Değilken
            $(".carStats").css("display", "none");
            $(".saat").removeClass("saat-car")
            $(".street-txt-tip1").css("display", "none");
            $(".time").html(event.data.time); 
            var direction = calcHeading(event.data.direction)
            if (pusulaAlt) {
                $(".direction").find(".image").attr('style', 'transform: translate3d(' + direction + 'px, 0px, 0px)');
            } else {
                $(".street-sol").css("display", "none");
                $(".street-sag").css("display", "none");
                $(".direction-tip2").find(".image-2").attr('style', 'transform: translate3d(' + (direction  + 100) + 'px, 0px, 0px)');
                $(".direction-tip2").css("width", "300px");
            }
            break;
        case "timeSet": // Araçta Değilken
            $(".time").html(event.data.time); 
            break;
        case "open":
            tgiannHud.Open(event.data);
            break;
        case "update":
            tgiannHud.Update(event.data);
            break;
        case "show":
            tgiannHud.Show(event.data);
            break;
        case 'vehSpeed':
            setProgressSpeed(Math.round(event.data.speed))
            break
        case 'tick':
            $(".container").css("display", event.data.show ? "none" : "block");
            $("#can-ic").css("width", event.data.health + "%");
            $("#zirh-ic").css("width", event.data.armor + "%");
            if (event.data.armor <= 35) {
                $("#zirh-ic").css("background", "#c62828");
            } else {
                $("#zirh-ic").css("background", "#3989ff");
            }
            $("#stamina-ic").css("width", event.data.stamina + "%");
            var oxyValue = event.data.oxy * 2.5
            if (oxyValue > 100 ) { oxyValue = 100 }

            if (stresOn) {
                if (oxyValue < 100) {
                    $(".stres-oxy").html(`
                        <i class="fas fa-lungs"></i>
                        <div id="stres-oxy-ic"></div>
                    `);
                    $('#stres-oxy-ic').css('width', oxyValue + '%')
                } else {
                    $(".stres-oxy").html(`
                        <i class="fas fa-virus"></i>
                        <div id="stres-oxy-ic"></div>
                    `);
                    $('#stres-oxy-ic').css('width', stresValue + '%')
                }
            } else {
                if (oxyValue < 100) {
                    $(".stres-oxy").css("display", "flex")
                    $(".stres-oxy").html(`
                        <i class="fas fa-lungs"></i>
                        <div id="stres-oxy-ic"></div>
                    `);
                    $('#stres-oxy-ic').css('width', oxyValue + '%')
                } else {
                    $(".stres-oxy").css("display", "none")
                }
            }

            break;
        case 'updateStatus':
            tgiannHud.updateStatus(event.data.st);
            break;
        case 'showui':
            $('body').show();
            break;
        case 'hideui':
            $('body').hide();
            break;
        case 'ses-0':
            $('#dot-0').css("opacity", 1);
            $('#dot-1').css("opacity", 0);
            $('#dot-2').css("opacity", 0);
            break;
        case 'ses-1':
            $('#dot-0').css("opacity", 1);
            $('#dot-1').css("opacity", 1);
            $('#dot-2').css("opacity", 0);
            break;
        case 'ses-2':
            $('#dot-0').css("opacity", 1);
            $('#dot-1').css("opacity", 1);
            $('#dot-2').css("opacity", 1);
            break;
        case 'ses-aktif':
            $("#dot-0").css("background", "#418aff");
            $("#dot-1").css("background", "#418aff");
            $("#dot-2").css("background", "#418aff");
            break;
        case 'ses-aktif-telsiz':
            $("#dot-0").css("background", "#3caf73");
            $("#dot-1").css("background", "#3caf73");
            $("#dot-2").css("background", "#3caf73");
            break;
        case 'ses-pasif':
            $("#dot-0").css("background", "#fff");
            $("#dot-1").css("background", "#fff");
            $("#dot-2").css("background", "#fff");
            break;   
        case 'showMenu':
            $(".ayar-menu-ana").css({"display":"flex"});
            break
    }
})

$('#yemek-on').on('change',function(){
    if(this.checked){
        $(".yemek").css({"display":"flex"});
    }
    else{
        $(".yemek").css({"display":"none"});
    }
});

$('#su-on').on('change',function(){
    if(this.checked){
        $(".su").css({"display":"flex"});
    }
    else{
        $(".su").css({"display":"none"});
    }
});

$('#stamina-on').on('change',function(){
    if(this.checked){
        $(".stamina").css({"display":"flex"});
    }
    else{
        $(".stamina").css({"display":"none"});
    }
});

$('#stress-on').on('change',function(){
    if(this.checked){
        $(".stres").css({"display":"flex"});
    }
    else{
        $(".stres").css({"display":"none"});
    }
});

$('#saat-on').on('change',function(){
    if(this.checked){
        $(".saat").css({"display":"flex"});
    }
    else{
        $(".saat").css({"display":"none"});
    }
});

$('#emote-on').on('change',function(){
    $.post('https://tgiann-hud/set-emotechat', JSON.stringify({status: this.checked}));
});

$('#siyahbar-on').on('change',function(){
    if (this.checked) {
        $(".siyah-bar").css({"display":"flex"});
    } else {
        $(".siyah-bar").css({"display":"none"});
    }
});

$('#ghizg-on').on('change',function(){
    $.post('https://tgiann-hud/fh4speed', JSON.stringify({status: this.checked}));
    if (this.checked) {
        $(".speedamount").css("display", "none");
        $(".kmhText").css("display", "none");
    } else {
        $(".speedamount").css("display", "flex");
        $(".kmhText").css("display", "flex");
    }
});

$('#pusula-on').on('change',function(){
    if(this.checked){
        if (pusulaAlt) {
            $(".street-tip1").css({"display":"flex"});
        } else {
            $(".tepe-hud").css({"display":"flex"});
        }
        $("input[name^='chkBox_pusula']").attr("disabled",false);
        $.post('https://tgiann-hud/set-compass', JSON.stringify({compassOn: true}));
    }
    else{
        if (pusulaAlt) {
            $(".street-tip1").css({"display":"none"});
        } else {
            $(".tepe-hud").css({"display":"none"});
        }

        $("input[name^='chkBox_pusula']").attr("disabled",true);
        $.post('https://tgiann-hud/set-compass', JSON.stringify({compassOn: false}));
    }
});

$(document).on('click', '.close-ayar-menu', function(e){
    tgiannHud.CloseAyarMenu()
});

function pusulaKonum(id) {
    for (var i = 1;i <= 2; i++) {
        document.getElementById(i).checked = false;
    }
    document.getElementById(id).checked = true;

    if ($('#1').is(":checked")) {
        $(".street-tip1").css({"display":"flex"});
        $(".tepe-hud").css({"display":"none"});
        pusulaAlt = true
    } else {
        $(".street-tip1").css({"display":"none"});
        $(".tepe-hud").css({"display":"flex"});
        pusulaAlt = false
    }
}

function setProgressSpeed(value){
    var circle = document.querySelector('.progress-speed');
    var radius = circle.r.baseVal.value;
    var circumference = radius * 2 * Math.PI;
    var html = $('.progress-speed').parent().parent().find('span');
    var predkosc = Math.floor(value * 1.3)
    if (value > 200) { value = 200 }
    var percent = value*100/220;

    circle.style.strokeDasharray = `${circumference} ${circumference}`;
    circle.style.strokeDashoffset = `${circumference}`;

    const offset = circumference - ((-percent*73)/100) / 100 * circumference;
    circle.style.strokeDashoffset = -offset;

    html.text(predkosc);
}

function setProgressMini(percent, element){
    var circle = document.querySelector(element);
    var radius = circle.r.baseVal.value;
    var circumference = radius * 2 * Math.PI;
    var html = $(element).parent().parent().find('span');

    circle.style.strokeDasharray = `${circumference} ${circumference}`;
    circle.style.strokeDashoffset = `${circumference}`;

    const offset = circumference - ((-percent*73)/100) / 100 * circumference;
    circle.style.strokeDashoffset = -offset;

    html.text(Math.round(percent));
}