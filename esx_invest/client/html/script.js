var inMenu = false
var activeSelected = null
var activeMenu = null

$(function() {
    window.addEventListener('message', function(event) {
        if(event.data.type == "open") {
            $('#waiting').show();
            $('body').addClass("active");
        } else if(event.data.type == "close"){
            close()
        } else if(event.data.type == "balance") {
            $('.name').html(event.data.player);
            $('.money').html(event.data.balance);
        } else if(event.data.type == "list") {
            $("#companies tbody").empty();

            var array = event.data.cache
            for (var e in array) {
                var obj = array[e];

                if(obj.rate == "up") {
                    var icon = "fa-arrow-up"
                } else if(obj.rate == "down") {
                    var icon = "fa-arrow-down"
                } else {
                    var icon = "fa-circle"
                }

                $('#companies tbody').append(`
                    <tr data-label='${obj.label}'>
                        <th>${obj.name}</th>
                        <th><i class='fas ${icon}'></i> ${obj.stock}</th>
                    </tr>`)
            }
        } else if(event.data.type == "all") {
            $("#all tbody").empty();
            var array = event.data.cache
            for (var e in array) {
                var obj = array[e];

                if(obj.active) {
                    var sold = "No"
                } else {
                    var sold = "Yes"
                }

                $('#all tbody').append(`
                    <tr>
                        <th>${obj.name}</th>
                        <th>${obj.rate}</th>
                        <th>${sold}</th>
                    </tr>`)
            }
        } else if(event.data.type == "sell") {
            $("#sell tbody").empty();

            var array = event.data.cache
            for (var e in array) {
                var obj = array[e];
                
                var intrest = obj.investRate - obj.rate
                intrest = parseFloat(intrest).toFixed(2)
                
                if(intrest > 0) {
                    var icon = "fa-arrow-up"
                } else if(intrest < 0) {
                    var icon = "fa-arrow-down"
                } else {
                    var icon = "fa-circle"
                }

                $('#sell tbody').append(`
                    <tr data-label='${obj.label}'>
                        <th>${obj.name}</th>
                        <th>${obj.amount}</th>
                        <th><i class='fas ${icon}'></i> ${intrest}</th>
                    </tr>`)
            }
        }
    });
});

$('#fingerprint-content').click(function(){
    $('.fingerprint-active, .fingerprint-bar').addClass("active")
    setTimeout(function(){
        $('#general').css('display', 'block')
        $('#topbar').css('display', 'flex')
        $('#waiting').css('display', 'none')
        $('.fingerprint-active, .fingerprint-bar').removeClass("active")
    }, 1400);
})

$('#close').click(function() {
    if(!inMenu) {
        close()
    } else {
        $('#close').html("Close <i class='fas fa-sign-out-alt'></i>");
        $('#buyUI, #allUI, #sellUI').hide();
        $('#general').show();
        inMenu = false
    }
})

// Input activate submit button
$('.input-cont input').on("input", function(e) {
    // console.log(e);
    var input = e.target.value
    var isnum = /^\d+$/.test(input)
    if(isnum) {
        var button = e.target.parentElement.parentElement.lastElementChild
        if($(button).css("opacity") < 1) {
            $(button).css("opacity", 1)
            $(button).css("pointer-events", "all")
        }
    }
})

// Process investments
$('form .btn').click(function (e) {
    e.preventDefault();
    var div = e.currentTarget.parentElement.parentElement
    var form = e.currentTarget.parentElement
    var inputValue = $(form).find("input[type='number']")[0] || null
    if(!inputValue || /^\d+$/.test(inputValue.value)) {
        if(inputValue != null) inputValue = inputValue.value
        var trActive = $(div).find('table > tbody > .active')[0]

        var label = $(trActive).data("label")
        var rate = $(trActive).children().last().text()
        rate = parseFloat(rate.slice(0, -1).substr(1))

        if (activeMenu == "sell") {
            $.post('http://esx_invest/sellInvestment', JSON.stringify({job: label, sellRate: rate}))
        } else if(activeMenu == "buy") {
            $.post('http://esx_invest/buyInvestment', JSON.stringify({job: label, amount: inputValue, boughtRate: rate}))
        }

        $('#buyUI, #allUI, #sellUI').hide();
        $('#general').show();
        $.post('http://esx_invest/balance', JSON.stringify({}))
    }
})

// On table click process activiation + submition
$('table').click(function(e) {
    var target = $(e.target)
    
    if(target.is("th")) {
        target = target[0].parentElement
    } else if(!target.is("tr")) {
        return;
        // wtf happend where did he press?
    }
    var currentForm = $(target).closest('div').children("form")[0];
    var selectedName = $(target).data("label");
    if(selectedName != null) {
        $(currentForm).data("label", selectedName)
        // console.log($(currentForm).data("name"));
        if(activeSelected != null) {
            $(activeSelected).removeClass("active")
        }
        $(target).addClass("active")
        activeSelected = target

        if(activeMenu == "sell") {
            var button = $('#sellUI').children().last().children().last()
            
            if($(button).css("opacity") < 1) {
                $(button).css("opacity", 1)
                $(button).css("pointer-events", "all")
            }
        }
    }
    
})

$('#new_bank').click(function() {
    $.post('http://esx_invest/newBanking', JSON.stringify({}))
})

// GENERAL
$('#buy').click(function() {
    $('#general').hide();
    $('#buyUI').show();
    $('#close').html("Back <i class='fas fa-sign-out-alt'></i>");
    $.post('http://esx_invest/list', JSON.stringify({}))
    inMenu = true
    activeMenu = "buy"
})

$('#all').click(function() {
    $('#general').hide();
    $('#allUI').show();
    $('#close').html("Back <i class='fas fa-sign-out-alt'></i>");
    $.post('http://esx_invest/all', JSON.stringify({}))
    inMenu = true
    activeMenu = "all"
})

$('#sell').click(function() {
    $('#general').hide();
    $('#sellUI').show();
    $('#close').html("Back <i class='fas fa-sign-out-alt'></i>");
    $.post('http://esx_invest/sell', JSON.stringify({}))
    inMenu = true
    activeMenu = "sell"
})

$('.back').click(function(){
    $('#buyUI, #allUI, #sellUI').hide();
    $('#general').show();
})

document.onkeyup = function(data){
    if (data.which == 27){
        close()
    }
}

function close() {
    $('#general, #waiting, #sellUI, #allUI, #buyUI, #topbar').hide();
    $('body').removeClass("active");
    $.post('http://esx_invest/close', JSON.stringify({}));
}