innermenu = false
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
            console.log(event.data.cache);
            for (let i = 0; i < event.data.cache.length; i++) {
                const e = event.data.cache[i];
                
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

$('#new_bank').click(function() {
    $.post('http://esx_invest/newBanking', JSON.stringify({}))
})

// GENERAL
$('#buy').click(function() {
    $('#general').hide();
    $('#buyUI').show();
    $('#close').html("Back <i class='fas fa-sign-out-alt'></i>");
    innermenu = true
})

$('#all').click(function() {
    $('#general').hide();
    $('#allUI').show();
    $('#close').html("Back <i class='fas fa-sign-out-alt'></i>");
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