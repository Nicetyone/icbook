$(function () {
    function display(bool) {
        if (bool) {
            $("#phone").show(200);
            strona = history.length
        } else {
            $("#phone").hide(200);
        }
    }

    display(false)

    window.addEventListener('message', function(event) {
        var item = event.data;
    
        if (item.type === "ui") {
            if (item.status == true) {
                display(true)
            } else {
                display(false)
            }
        }
    })

   
    document.onkeyup = function (data) {
        if (data.which == 27) {
            $.post('http://icbook/exit', JSON.stringify({})); 
            return
        }

        if (data.which == 117) {
            $.post('http://icbook/exit', JSON.stringify({})); 
            return
        }

        if (data.which == 8) {
            $.post('http://icbook/exit', JSON.stringify({})); 
            return
        }
    };


    
})






function goBack() {
    if (strona !== history.length){
    window.history.back();
  } else {
    $.notify("Brak wczesniejszych stron", "error");
    return;
  }
}

function goHome() {
    $.post('http://icbook/exit', JSON.stringify({})); 
    return
}

  
function goForward() {
    if (strona !== history.length){
    window.history.forward();
  } else {
    $.notify("Brak stron", "error");
    return;
  }
}

function goRotate() {
    if (  $(phone).css( "transform" ) === 'rotate(0deg)' || $(phone).css( "transform" ) == 'none' || stan === 1){
        $(phone).css("transition-property","left");
        $(phone).css("transition-duration","1s");    
        $(phone).css("left","40%");
        
        setTimeout(function(){
            $(phone).css("transition-duration","1s");
            $(phone).css("transition-property","transform");
            $(phone).css("transform","rotate(-90deg)");
            document.getElementById("bg-icbook").setAttribute("id", "bg-icbook2");
        }, 1000);
        setTimeout(function(){
            $(phone).css("transition-property","transform");
            $(phone).css("transition-duration","1s");    
            $(phone).css("transform","rotate(-90deg) scale(2,2)");
       }, 2000);
       setTimeout(function(){
        $(phone).css("transition-property","bottom");
        $(phone).css("transition-duration","1s");    
        $(phone).css("bottom","20%");
   }, 3000);
             setTimeout(function(){ 
                document.getElementById("przyciskback").setAttribute("id", "przyciskback2");
                document.getElementById("przyciskforward").setAttribute("id", "przyciskforward2");
             }, 2000);
        stan = 0;

    } else if (stan === 0) {
        stan = 1;
        $(phone).css("transition-duration","1s");
        $(phone).css("transition-property","transform");
        $(phone).css("transform","rotate(0deg)");
        setTimeout(function(){
            $(phone).css("transition-property","left");
            $(phone).css("transition-duration","1s");    
            $(phone).css("left","20px");
       }, 1000);
       setTimeout(function(){
        $(phone).css("transition-property","bottom");
        $(phone).css("transition-duration","1s");    
        $(phone).css("bottom","20px");
   }, 2000);
       document.getElementById("bg-icbook2").setAttribute("id", "bg-icbook");
       document.getElementById("przyciskback2").setAttribute("id", "przyciskback");
       document.getElementById("przyciskforward2").setAttribute("id", "przyciskforward");
    }
}









