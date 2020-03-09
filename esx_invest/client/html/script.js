var innermenu = false
var activeSelected = null

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
        } else if(event.data.type == "jobs") {
            $("#jobs tbody").empty();
            // console.log(event.data.cache);
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
                $('#jobs tbody').append(`
                    <tr data-name='${obj.name}'>
                        <th>${obj.label}</th>
                        <th><i class='fas ${icon}'></i> ${obj.stock}</th>
                    </tr>`)
            }
        } else if(event.data.type == "all") {
            $("#all tbody").empty();
            var array = event.data.cache
            for (var e in array) {
                var obj = array[e];
                console.log(obj.created);
                if(obj.active) {
                    var sold = "-"
                } else {
                    var time = new Date(obj.created-obj.sold)
                    var sold = "yas"
                }
                $('#all tbody').append(`
                    <tr>
                        <th>${obj.label}</th>
                        <th>${obj.amount}</th>
                        <th>${sold}</th>
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
    if(!innermenu) close()
    else {
        $('#close').html("Close <i class='fas fa-sign-out-alt'></i>");
        $('#buyUI, #allUI, #sellUI').hide();
        $('#general').show();
        innermenu = false
    }
})

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

$('form .btn').click(function (e) {
    e.preventDefault();
    var div = e.currentTarget.parentElement.parentElement
    var form = e.currentTarget.parentElement
    var inputValue = $(form).find("input[type='number']")[0].value
    if(/^\d+$/.test(inputValue)) {
        var trActive = $(div).find('table > tbody > .active')[0]
        var name = $(trActive).data("name")
        console.log(name);
        console.log(inputValue);
    }
})

$('table').click(function(e) {
    var target = $(e.target)
    
    if(target.is("th")) {
        target = target[0].parentElement
    } else if(!target.is("tr")) {
        return;
        // wtf happend where did he press?
    }
    var currentForm = $(target).closest('div').children("form")[0];
    var selectedName = $(target).data("name");
    if(selectedName != null) {
        $(currentForm).data("name", selectedName)
        // console.log($(currentForm).data("name"));
        if(activeSelected != null) {
            $(activeSelected).removeClass("active")
        }
        $(target).addClass("active")
        activeSelected = target
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
    $.post('http://esx_invest/jobs', JSON.stringify({}))
    innermenu = true
})

$('#all').click(function() {
    $('#general').hide();
    $('#allUI').show();
    $('#close').html("Back <i class='fas fa-sign-out-alt'></i>");
    $.post('http://esx_invest/all', JSON.stringify({}))
    innermenu = true
})

$('#sell').click(function() {
    $('#general').hide();
    $('#sellUI').show();
    $('#close').html("Back <i class='fas fa-sign-out-alt'></i>");
    innermenu = true
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