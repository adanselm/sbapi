function formhash(form, password, email) {
  console.log("Hashing form");
  // Create a new element input, this will be our hashed password field.
  var p = document.createElement("input");
  p.name = "clienthash";
  p.type = "hidden"

  // Call sjcl HMAC-SHA256 with salt on the password
  var key = sjcl.codec.utf8String.toBits(email.value + "springbeats.com");
  var out = (new sjcl.misc.hmac(key, sjcl.hash.sha256)).mac(password.value);
  p.value = sjcl.codec.hex.fromBits(out)

  // NOW, add the new element to our form.
  // In this order for compatibility with IE9.
  // See http://stackoverflow.com/questions/20362851/hashing-a-password-before-form-submission-in-ie9
  form.appendChild(p);

  // Make sure the plaintext password doesn't get sent.
  password.value = "";
  // Finally submit the form.
  form.submit();
}

$(document).ready(function() {
    $('#loginForm').bootstrapValidator({
        feedbackIcons: {
            valid: 'glyphicon glyphicon-ok',
            invalid: 'glyphicon glyphicon-remove',
            validating: 'glyphicon glyphicon-refresh'
        },
        fields: {
            email: {
                validators: {
                    notEmpty: {
                        message: 'The email address is required'
                    },
                    emailAddress: {
                        message: 'The email address is not valid'
                    }
                }
            },
            password: {
                validators: {
                    notEmpty: {
                        message: 'The password is required'
                    }
                }
            }
        }
    });
});
