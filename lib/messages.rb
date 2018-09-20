require 'httparty'
require 'json'

module Messages
  include HTTParty
  base_uri "https://www.bloc.io/api/v1/"

  def get_messages(page = nil)
    page.nil? ? page_url = "" : page_url = "?page=#{page}"

    response = self.class.get("/message_threads" + page_url, headers: { "authorization" =>  @auth_token })
    JSON.parse(response.body)
  end

  def create_messages(sender, recipient_id, token, subject, stripped_text)
    response = self.class.post("/messages", headers: { "authorization" => @auth_token },
    body: { sender: sender, recipient_id: recipient_id, token: token, subject: subject, stripped_text: stripped_text })

    response.success? ? "Message was successfully sent!" : "Your message did not send, please try again."
  end
end
