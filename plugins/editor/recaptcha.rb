description 'reCAPTCHA support to avoid spamming'
require 'net/http'

RECAPTCHA_PUBLIC = Config['recaptcha.public']
RECAPTCHA_PRIVATE = Config['recaptcha.private']

class ::Olelo::Application
  hook :head do
    %{<script type="text/javascript" src="http://www.google.com/recaptcha/api/js/recaptcha_ajax.js"/>
<script type="text/javascript">
  $(function() {
    Recaptcha.create('#{RECAPTCHA_PUBLIC}',
      'recaptcha', {
        theme: 'clean',
        callback: Recaptcha.focus_response_field
    });
  });
</script>} if flash[:show_captcha]
  end

  %w(edit attributes upload).each do |action|
    before "#{action}_buttons" do
      if flash[:show_captcha] && action?(action)
        %{<br/><div id="recaptcha"></div><br/>}
      end
    end

    redefine_method "post_#{action}" do
      if captcha_valid?
        super()
      else
        flash.info! :enter_captcha.t
        flash.now[:show_captcha] = true
        halt render(:edit)
      end
    end
  end

  private

  def captcha_valid?
    if Time.now.to_i < session[:olelo_recaptcha_timeout].to_i
      true
    elsif params[:recaptcha_challenge_field] && params[:recaptcha_response_field]
      response = Net::HTTP.post_form(URI.parse('http://api-verify.recaptcha.net/verify'),
                                     'privatekey' => RECAPTCHA_PRIVATE,
                                     'remoteip'   => request.ip,
                                     'challenge'  => params[:recaptcha_challenge_field],
                                     'response'   => params[:recaptcha_response_field])
      if response.body.split("\n").first == 'true'
        session[:olelo_recaptcha_timeout] = Time.now.to_i + 3600
        flash.info! :captcha_valid.t
        true
      else
        flash.error! :captcha_invalid.t
        false
      end
    end
  end
end
