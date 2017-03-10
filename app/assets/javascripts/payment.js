$(function(){
  var stripe = Stripe('pk_test_EeQG1Jdk5GWdE5lUxAJBtZtm');
  var elements = stripe.elements();

  var card = elements.create('card', {
    style: {
      base: {
        iconColor: '#666EE8',
        color: '#31325F',
        lineHeight: '40px',
        fontWeight: 300,
        fontFamily: 'Helvetica Neue',
        fontSize: '14px',

        '::placeholder': {
          color: '#CFD7E0',
        },
      },
    }
  });
  card.mount('#card-number');

  function setOutcome(result) {
    var successElement = document.querySelector('.success');
    var errorElement = document.querySelector('.error');
    successElement.classList.remove('visible');
    errorElement.classList.remove('visible');

    if (result.token) {
      var $form = $('#payment-form');
      $form.append($("<input name='stripeToken' type='hidden'/>'").val(result.token.id))
      $form.off('submit').submit()
    } else if (result.error) {
      errorElement.textContent = result.error.message;
      errorElement.classList.add('visible');
    }
  }

  card.on('change', function(event) {
    setOutcome(event);
  });

  $('#payment-form').off('submit').on('submit', function(e){
      e.preventDefault();
      console.log('submitted');
      var form = this;
      var extraDetails = {
      };
      stripe.createToken(card).then(setOutcome);
  })

})
